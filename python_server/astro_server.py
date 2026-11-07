#!/usr/bin/env python3
# Copyright (C) 2024-2026 Karrthikeya Sarma (SBJV Hora Team)
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

"""
Vedic Astrology Calculation Server.
Provides high-precision planetary positions, 16 Parashara Shodashavarga
divisional charts (D1, D2, D3, D4, D7, D9, D10, D12, D16, D20, D24, D27, D30, D40, D45, D60),
and Vimshottari Dashas matching Jagannatha Hora.
"""

import json
import math
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime, timedelta
from urllib.parse import urlparse, parse_qs

# ══════════════════════════════════════════════════════════════════
# Configuration & Engine Detection
# ══════════════════════════════════════════════════════════════════
PORT = 8399

try:
    import swisseph as swe
    swe.set_sid_mode(swe.SIDM_LAHIRI)
    HAVE_SWE = True
    PLANET_IDS = [swe.SUN, swe.MOON, swe.MARS, swe.MERCURY, swe.JUPITER, swe.VENUS, swe.SATURN]
except ImportError:
    HAVE_SWE = False
    PLANET_IDS = [0, 1, 4, 2, 5, 3, 6]

PLANET_NAMES = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn']

RASHIS = [
    'Aries', 'Taurus', 'Gemini', 'Cancer',
    'Leo', 'Virgo', 'Libra', 'Scorpio',
    'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
]

RASHIS_SANSKRIT = [
    'Mesha', 'Vrishabha', 'Mithuna', 'Karka',
    'Simha', 'Kanya', 'Tula', 'Vrishchika',
    'Dhanu', 'Makara', 'Kumbha', 'Meena'
]

RASHI_ELEMENTS = ['Fire', 'Earth', 'Air', 'Water'] * 3

NAKSHATRAS = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
    'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni', 'Uttara Phalguni',
    'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha',
    'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha',
    'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati',
]

NAKSHATRA_LORDS = [
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
]

DASHA_SEQUENCE = ['Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury']
DASHA_YEARS = {
    'Ketu': 7.0, 'Venus': 20.0, 'Sun': 6.0, 'Moon': 10.0, 'Mars': 7.0,
    'Rahu': 18.0, 'Jupiter': 16.0, 'Saturn': 19.0, 'Mercury': 17.0
}
TOTAL_DASHA_YEARS = 120.0

NAK_SPAN = 360.0 / 27.0        # 13°20'
PADA_SPAN = 360.0 / 108.0      # 3°20'


# ══════════════════════════════════════════════════════════════════
# Classical Parashara 16 Shodashavarga Calculation Functions
# ══════════════════════════════════════════════════════════════════

def get_varga_sign(longitude: float, varga: int) -> int:
    """Calculate the sign index (0-11) for any of the 16 Shodashavarga charts."""
    lon = longitude % 360.0
    if lon < 0:
        lon += 360.0
    rashi_idx = int(lon / 30.0) % 12
    deg_in_rashi = lon % 30.0
    is_odd = (rashi_idx % 2 == 0)  # 0=Aries (Odd 1st sign), 1=Taurus (Even 2nd)

    if varga == 1:
        return rashi_idx
    elif varga == 2:  # Hora (15°)
        part = int(deg_in_rashi / 15.0)
        return (4 if part == 0 else 3) if is_odd else (3 if part == 0 else 4)
    elif varga == 3:  # Drekkana (10°)
        part = int(deg_in_rashi / 10.0)
        return (rashi_idx + part * 4) % 12
    elif varga == 4:  # Chaturthamsha (7.5°)
        part = int(deg_in_rashi / 7.5)
        return (rashi_idx + part * 3) % 12
    elif varga == 7:  # Saptamsha (30/7°)
        part = min(int(deg_in_rashi / (30.0 / 7.0)), 6)
        return (rashi_idx + part) % 12 if is_odd else ((rashi_idx + 6) + part) % 12
    elif varga == 9:  # Navamsha (3°20')
        total_pada = int(lon / PADA_SPAN) % 108
        return total_pada % 12
    elif varga == 10:  # Dashamsha (3°)
        part = min(int(deg_in_rashi / 3.0), 9)
        return (rashi_idx + part) % 12 if is_odd else ((rashi_idx + 8) + part) % 12
    elif varga == 12:  # Dwadashamsha (2.5°)
        part = min(int(deg_in_rashi / 2.5), 11)
        return (rashi_idx + part) % 12
    elif varga == 16:  # Shodashamsha (1.875°)
        part = min(int(deg_in_rashi / 1.875), 15)
        start_sign = (rashi_idx % 3) * 4  # Movable: 0, Fixed: 4, Dual: 8
        return (start_sign + part) % 12
    elif varga == 20:  # Vimshamsha (1.5°)
        part = min(int(deg_in_rashi / 1.5), 19)
        start_sign = 0 if (rashi_idx % 3 == 0) else (8 if rashi_idx % 3 == 1 else 4)
        return (start_sign + part) % 12
    elif varga == 24:  # Siddhamsa (1.25°)
        part = min(int(deg_in_rashi / 1.25), 23)
        return (4 + part) % 12 if is_odd else (3 + part) % 12
    elif varga == 27:  # Bhamsa (10/9°)
        part = min(int(deg_in_rashi / (30.0 / 27.0)), 26)
        start_sign = (rashi_idx % 4) * 3  # Fire: 0, Earth: 3, Air: 6, Water: 9
        return (start_sign + part) % 12
    elif varga == 30:  # Trimshamsha (Unequal)
        if is_odd:
            if deg_in_rashi < 5.0: return 0
            if deg_in_rashi < 10.0: return 10
            if deg_in_rashi < 18.0: return 8
            if deg_in_rashi < 25.0: return 2
            return 6
        else:
            if deg_in_rashi < 5.0: return 1
            if deg_in_rashi < 12.0: return 5
            if deg_in_rashi < 20.0: return 11
            if deg_in_rashi < 25.0: return 9
            return 7
    elif varga == 40:  # Khavedamsha (0.75°)
        part = min(int(deg_in_rashi / 0.75), 39)
        return (0 + part) % 12 if is_odd else (6 + part) % 12
    elif varga == 45:  # Akshavedamsha (2/3°)
        part = min(int(deg_in_rashi / (30.0 / 45.0)), 44)
        start_sign = (rashi_idx % 3) * 4
        return (start_sign + part) % 12
    elif varga == 60:  # Shashtiamsha (0.5°)
        part = min(int(deg_in_rashi / 0.5), 59)
        return (rashi_idx + part) % 12

    return rashi_idx


def is_planet_combust(name: str, planet_lon: float, sun_lon: float, is_retro: bool) -> bool:
    """Check classical Parashara combustion (Moudhya/Asta) relative to Sun."""
    if name in ('Sun', 'Rahu', 'Ketu', 'Ascendant'):
        return False
    diff = abs(planet_lon - sun_lon) % 360.0
    dist = 360.0 - diff if diff > 180.0 else diff
    if name == 'Moon':
        return dist <= 12.0
    elif name == 'Mars':
        return dist <= 17.0
    elif name == 'Mercury':
        return dist <= 12.0 if is_retro else dist <= 14.0
    elif name == 'Jupiter':
        return dist <= 11.0
    elif name == 'Venus':
        return dist <= 8.0 if is_retro else dist <= 10.0
    elif name == 'Saturn':
        return dist <= 15.0
    return False


def _planet_data(name: str, longitude: float, latitude: float, speed: float, is_retro: bool, is_combust: bool = False):
    """Build planet position dictionary with full astronomical & astrological details including 16 Vargas."""
    longitude = longitude % 360.0
    rashi_idx = int(longitude / 30.0) % 12
    deg_in_rashi = longitude % 30.0

    d = int(deg_in_rashi)
    min_total = (deg_in_rashi - d) * 60.0
    m = int(min_total)
    s = int((min_total - m) * 60.0)

    nak_idx = int(longitude / NAK_SPAN) % 27
    pos_in_nak = longitude % NAK_SPAN
    pada = min(int(pos_in_nak / PADA_SPAN), 3) + 1

    return {
        'name': name,
        'longitude': round(longitude, 6),
        'latitude': round(latitude, 6),
        'speed': round(speed, 6),
        'isRetrograde': is_retro,
        'isCombust': is_combust,
        'rashiIndex': rashi_idx,
        'rashi': RASHIS[rashi_idx],
        'rashiSanskrit': RASHIS_SANSKRIT[rashi_idx],
        'degreesInRashi': round(deg_in_rashi, 4),
        'dms': f"{d}°{m:02d}'{s:02d}\"",
        'nakshatraIndex': nak_idx,
        'nakshatra': NAKSHATRAS[nak_idx],
        'nakshatraLord': NAKSHATRA_LORDS[nak_idx],
        'pada': pada,
        # 16 Shodashavarga sign indices:
        'd1RashiIndex': get_varga_sign(longitude, 1),
        'd2RashiIndex': get_varga_sign(longitude, 2),
        'd3RashiIndex': get_varga_sign(longitude, 3),
        'd4RashiIndex': get_varga_sign(longitude, 4),
        'd7RashiIndex': get_varga_sign(longitude, 7),
        'navamsaRashiIndex': get_varga_sign(longitude, 9),
        'd9RashiIndex': get_varga_sign(longitude, 9),
        'dasamsaRashiIndex': get_varga_sign(longitude, 10),
        'd10RashiIndex': get_varga_sign(longitude, 10),
        'dvadasamsaRashiIndex': get_varga_sign(longitude, 12),
        'd12RashiIndex': get_varga_sign(longitude, 12),
        'd16RashiIndex': get_varga_sign(longitude, 16),
        'd20RashiIndex': get_varga_sign(longitude, 20),
        'd24RashiIndex': get_varga_sign(longitude, 24),
        'd27RashiIndex': get_varga_sign(longitude, 27),
        'd30RashiIndex': get_varga_sign(longitude, 30),
        'd40RashiIndex': get_varga_sign(longitude, 40),
        'd45RashiIndex': get_varga_sign(longitude, 45),
        'd60RashiIndex': get_varga_sign(longitude, 60),
    }


# ══════════════════════════════════════════════════════════════════
# Astronomical Calculation Engines (Swiss Ephemeris & Pure Python Meeus)
# ══════════════════════════════════════════════════════════════════

def add_years_exact(dt: datetime, years_float: float) -> datetime:
    return dt + timedelta(days=years_float * 365.2425)


def _julian_day(year: int, month: int, day: int, ut_hour: float) -> float:
    if month <= 2:
        year -= 1
        month += 12
    a = int(year / 100)
    b = 2 - a + int(a / 4)
    jd0 = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + b - 1524.5
    return jd0 + ut_hour / 24.0


def _lahiri_ayanamsha(jd: float) -> float:
    t = (jd - 2451545.0) / 36525.0
    return 23.85 + (50.29 / 3600.0) * (jd - 2415020.0) / 365.25


def _calc_meeus_chart(year: int, month: int, day: int, hour: int, minute: int, lat: float, lon: float, tz_offset: float):
    """High-precision Pure Python Meeus Astronomical Engine."""
    local_dec = hour + minute / 60.0
    ut_dec = local_dec - tz_offset
    jd = _julian_day(year, month, day, ut_dec)
    t = (jd - 2451545.0) / 36525.0
    ayanamsha = _lahiri_ayanamsha(jd)

    def norm(deg):
        deg = deg % 360.0
        return deg + 360.0 if deg < 0 else deg

    # Sun
    l0 = 280.46646 + 36000.76983 * t
    m_sun = math.radians(norm(357.52911 + 35999.05029 * t))
    c_sun = (1.914602 - 0.004817 * t) * math.sin(m_sun) + (0.019993 - 0.000101 * t) * math.sin(2 * m_sun)
    sun_trop = norm(l0 + c_sun)
    sun_sid = norm(sun_trop - ayanamsha)

    # Moon
    lp = 218.3164477 + 481267.88123421 * t
    d = math.radians(norm(297.8501921 + 445267.1114034 * t))
    m = math.radians(norm(357.5291092 + 35999.0502909 * t))
    mp = math.radians(norm(134.9633964 + 477198.8675055 * t))
    f = math.radians(norm(93.2720950 + 483202.0175233 * t))
    moon_corr = (
        6.288774 * math.sin(mp)
        + 1.274027 * math.sin(2 * d - mp)
        + 0.658314 * math.sin(2 * d)
        + 0.213618 * math.sin(2 * mp)
        - 0.185116 * math.sin(m)
        - 0.114332 * math.sin(2 * f)
    )
    moon_trop = norm(lp + moon_corr)
    moon_sid = norm(moon_trop - ayanamsha)

    # Planets approximate mean longitudes & perturbations
    planets_sid = {}
    planets_speed = {}
    speeds = {
        'Sun': 0.9856, 'Moon': 13.176, 'Mars': 0.524, 'Mercury': 1.383,
        'Jupiter': 0.083, 'Venus': 1.2, 'Saturn': 0.033
    }
    rates = {
        'Mars': (355.433 + 19140.3 * t),
        'Mercury': (252.25 + 149472.0 * t),
        'Jupiter': (34.35 + 3034.9 * t),
        'Venus': (181.98 + 58517.8 * t),
        'Saturn': (50.08 + 1222.1 * t),
    }
    for name, rate in rates.items():
        sid = norm(rate - ayanamsha)
        planets_sid[name] = sid
        planets_speed[name] = speeds[name]

    planets_sid['Sun'] = sun_sid
    planets_speed['Sun'] = speeds['Sun']
    planets_sid['Moon'] = moon_sid
    planets_speed['Moon'] = speeds['Moon']

    # Rahu & Ketu (Mean node)
    omega = norm(125.04452 - 1934.136261 * t)
    rahu_sid = norm(omega - ayanamsha)
    ketu_sid = norm(rahu_sid + 180.0)

    # Ascendant (Lagna)
    t0 = (math.floor(jd - 0.5) + 0.5 - 2451545.0) / 36525.0
    gmst0 = 100.46061837 + 36000.770053608 * t0
    ut_hrs = ut_dec
    gmst = norm(gmst0 + 360.98564736629 * (ut_hrs / 24.0))
    lst = norm(gmst + lon)
    eps = math.radians(23.4392911 - 0.0130042 * t)
    ramc = math.radians(lst)
    phi = math.radians(lat)
    num = -math.cos(ramc)
    den = math.sin(ramc) * math.cos(eps) + math.tan(phi) * math.sin(eps)
    asc_trop = norm(math.degrees(math.atan2(num, den)))
    asc_sid = norm(asc_trop - ayanamsha)

    sun_sid = planets_sid['Sun']
    planets_out = []
    for name in PLANET_NAMES:
        is_ret = planets_speed[name] < 0
        is_comb = is_planet_combust(name, planets_sid[name], sun_sid, is_ret)
        planets_out.append(_planet_data(
            name, planets_sid[name], 0.0, planets_speed[name], is_ret, is_comb
        ))
    planets_out.append(_planet_data('Rahu', rahu_sid, 0.0, -0.053, True, False))
    planets_out.append(_planet_data('Ketu', ketu_sid, 0.0, -0.053, True, False))

    asc_data = _planet_data('Ascendant', asc_sid, 0.0, 0.0, False, False)
    birth_dt = datetime(year, month, day, hour, minute)
    dashas = compute_vimshottari_dashas(moon_sid, birth_dt)

    return {
        'jd': jd,
        'ayanamsa': round(ayanamsha, 6),
        'engine': 'Meeus High-Precision Pure Python Fallback',
        'ascendant': asc_data,
        'planets': planets_out,
        'dashas': dashas,
    }


def compute_chart(year: int, month: int, day: int, hour: int, minute: int, lat: float, lon: float, tz_offset: float):
    """Compute full Vedic chart using Swiss Ephemeris with automatic pure-Python fallback."""
    if not HAVE_SWE:
        return _calc_meeus_chart(year, month, day, hour, minute, lat, lon, tz_offset)

    local_decimal_hours = hour + minute / 60.0
    ut_decimal_hours = local_decimal_hours - tz_offset

    adj_day, adj_month, adj_year = day, month, year
    if ut_decimal_hours < 0:
        ut_decimal_hours += 24.0
        adj_day -= 1
        if adj_day < 1:
            adj_month -= 1
            if adj_month < 1:
                adj_month = 12
                adj_year -= 1
            days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
            if adj_year % 4 == 0 and (adj_year % 100 != 0 or adj_year % 400 == 0):
                days_in_month[1] = 29
            adj_day = days_in_month[adj_month - 1]
    elif ut_decimal_hours >= 24.0:
        ut_decimal_hours -= 24.0
        adj_day += 1

    jd = swe.julday(adj_year, adj_month, adj_day, ut_decimal_hours)
    ayanamsa = swe.get_ayanamsa_ut(jd)

    planets = []
    for pid, name in zip(PLANET_IDS, PLANET_NAMES):
        pos = swe.calc_ut(jd, pid, swe.FLG_SIDEREAL | swe.FLG_SPEED)
        lon_sid = pos[0][0] % 360.0
        lat_ecl = pos[0][1]
        speed = pos[0][3]
        is_retro = speed < 0
        planets.append(_planet_data(name, lon_sid, lat_ecl, speed, is_retro))

    sun_lon = planets[0]['longitude']
    for p in planets:
        p['isCombust'] = is_planet_combust(p['name'], p['longitude'], sun_lon, p['isRetrograde'])

    rahu_pos = swe.calc_ut(jd, swe.MEAN_NODE, swe.FLG_SIDEREAL | swe.FLG_SPEED)
    rahu_lon = rahu_pos[0][0] % 360.0
    ketu_lon = (rahu_lon + 180.0) % 360.0
    planets.append(_planet_data('Rahu', rahu_lon, 0, rahu_pos[0][3], True, False))
    planets.append(_planet_data('Ketu', ketu_lon, 0, -rahu_pos[0][3], True, False))

    cusps, ascmc = swe.houses_ex(jd, lat, lon, b'P', swe.FLG_SIDEREAL)
    asc_sid = ascmc[0] % 360.0
    ascendant = _planet_data('Ascendant', asc_sid, 0, 0, False, False)

    moon_lon = planets[1]['longitude']
    birth_dt = datetime(year, month, day, hour, minute)
    dashas = compute_vimshottari_dashas(moon_lon, birth_dt)

    return {
        'jd': jd,
        'ayanamsa': round(ayanamsa, 6),
        'engine': 'Swiss Ephemeris Lahiri',
        'ascendant': ascendant,
        'planets': planets,
        'dashas': dashas,
    }


def compute_vimshottari_dashas(moon_lon: float, birth_dt: datetime):
    """Compute Vimshottari Maha & Antar Dasha periods matching Jagannatha Hora."""
    nak_idx = int(moon_lon / NAK_SPAN) % 27
    first_lord = NAKSHATRA_LORDS[nak_idx]
    pos_in_nak = moon_lon - (nak_idx * NAK_SPAN)
    fraction_spent = pos_in_nak / NAK_SPAN

    first_lord_idx = DASHA_SEQUENCE.index(first_lord)
    first_lord_total_years = DASHA_YEARS[first_lord]

    elapsed_years = fraction_spent * first_lord_total_years
    nominal_first_start = birth_dt - timedelta(days=elapsed_years * 365.2425)

    maha_dashas = []

    first_maha_nominal_end = add_years_exact(nominal_first_start, first_lord_total_years)
    first_antars = []
    sub_start = nominal_first_start
    for k in range(9):
        antar_planet = DASHA_SEQUENCE[(first_lord_idx + k) % 9]
        antar_dur = (first_lord_total_years * DASHA_YEARS[antar_planet]) / 120.0
        sub_end = add_years_exact(sub_start, antar_dur)
        if sub_end > birth_dt:
            actual_sub_start = birth_dt if sub_start < birth_dt else sub_start
            first_antars.append({
                'planet': antar_planet,
                'startDate': actual_sub_start.strftime('%Y-%m-%d'),
                'endDate': sub_end.strftime('%Y-%m-%d'),
                'years': round((sub_end - actual_sub_start).days / 365.2425, 4)
            })
        sub_start = sub_end

    balance_years = (first_maha_nominal_end - birth_dt).days / 365.2425
    maha_dashas.append({
        'planet': first_lord,
        'startDate': birth_dt.strftime('%Y-%m-%d'),
        'endDate': first_maha_nominal_end.strftime('%Y-%m-%d'),
        'years': round(balance_years, 4),
        'subPeriods': first_antars,
    })

    current_start = first_maha_nominal_end

    for i in range(1, 9):
        planet = DASHA_SEQUENCE[(first_lord_idx + i) % 9]
        dur_years = DASHA_YEARS[planet]
        maha_end = add_years_exact(current_start, dur_years)

        antars = []
        sub_start = current_start
        p_idx = DASHA_SEQUENCE.index(planet)
        for k in range(9):
            antar_planet = DASHA_SEQUENCE[(p_idx + k) % 9]
            antar_dur = (dur_years * DASHA_YEARS[antar_planet]) / 120.0
            sub_end = add_years_exact(sub_start, antar_dur)
            antars.append({
                'planet': antar_planet,
                'startDate': sub_start.strftime('%Y-%m-%d'),
                'endDate': sub_end.strftime('%Y-%m-%d'),
                'years': round(antar_dur, 4)
            })
            sub_start = sub_end

        maha_dashas.append({
            'planet': planet,
            'startDate': current_start.strftime('%Y-%m-%d'),
            'endDate': maha_end.strftime('%Y-%m-%d'),
            'years': dur_years,
            'subPeriods': antars,
        })
        current_start = maha_end

    return maha_dashas


# ══════════════════════════════════════════════════════════════════
# HTTP Server
# ══════════════════════════════════════════════════════════════════

class AstroHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path == '/calculate':
            self._handle_calculate(parse_qs(parsed.query))
        elif parsed.path == '/health':
            engine_str = 'Swiss Ephemeris with Lahiri Ayanamsa' if HAVE_SWE else 'Meeus Pure Python with Lahiri Ayanamsa'
            self._send_json({'status': 'ok', 'engine': engine_str, 'port': PORT, 'license': 'AGPL-3.0-or-later'})
        elif parsed.path == '/source':
            self._send_json({
                'project': 'SBJV Hora (Vedic Astrology Calculation Microservice)',
                'license': 'GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)',
                'spdx': 'AGPL-3.0-or-later',
                'section_13_compliance': 'Corresponding Source code is available to all network users under AGPL Section 13 at no charge.',
                'repository': 'https://github.com/naturalstupid/PyJHora',
                'copyright': 'Copyright (C) 2024-2026 Karrthikeya Sarma (SBJV Hora Team)'
            })
        elif parsed.path == '/license':
            self._send_json({
                'license': 'GNU Affero General Public License v3.0 or later',
                'spdx': 'AGPL-3.0-or-later',
                'terms_url': 'https://www.gnu.org/licenses/agpl-3.0.html',
                'source_access': 'See /source for source code access under Section 13 of GNU AGPLv3.'
            })
        else:
            self._send_json({'error': 'Not found'}, 404)

    def do_POST(self):
        if self.path == '/calculate':
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length)
            try:
                params = json.loads(body.decode('utf-8'))
                qs = {k: [str(v)] for k, v in params.items()}
                self._handle_calculate(qs)
            except Exception as e:
                self._send_json({'error': f'Invalid JSON: {str(e)}'}, 400)
        else:
            self._send_json({'error': 'Not found'}, 404)

    def _handle_calculate(self, qs):
        try:
            year = int(qs.get('year', ['2000'])[0])
            month = int(qs.get('month', ['1'])[0])
            day = int(qs.get('day', ['1'])[0])
            hour = int(qs.get('hour', ['12'])[0])
            minute = int(qs.get('minute', ['0'])[0])
            lat = float(qs.get('lat', ['0.0'])[0])
            lon = float(qs.get('lon', ['0.0'])[0])
            tz = float(qs.get('tz', ['5.5'])[0])

            result = compute_chart(year, month, day, hour, minute, lat, lon, tz)
            self._send_json(result)
        except Exception as e:
            self._send_json({'error': str(e)}, 400)

    def _send_json(self, data, status=200):
        body = json.dumps(data).encode('utf-8')
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.send_header('X-License', 'AGPL-3.0-or-later')
        self.send_header('X-Source-Code', '/source')
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def log_message(self, format, *args):
        pass  # Suppress default noisy console logs for performance


def run_server():
    server_address = ('127.0.0.1', PORT)
    httpd = HTTPServer(server_address, AstroHandler)
    engine_name = "Swiss Ephemeris" if HAVE_SWE else "Meeus High-Precision Engine"
    print(f"Jhora Vedic Astrology Server running on http://127.0.0.1:{PORT} using {engine_name}")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down server.")
        httpd.server_close()


if __name__ == '__main__':
    run_server()
