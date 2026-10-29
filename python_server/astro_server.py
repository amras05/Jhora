#!/usr/bin/env python3
"""
Vedic Astrology Calculation Server using Swiss Ephemeris.
Provides high-precision planetary positions, divisional charts (D1, D9, D10, etc.),
and Vimshottari Dashas matching Jagannatha Hora.
"""

import json
import math
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime, timedelta
from urllib.parse import urlparse, parse_qs

import swisseph as swe

# ══════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════
PORT = 8399
swe.set_sid_mode(swe.SIDM_LAHIRI)

PLANET_IDS = [swe.SUN, swe.MOON, swe.MARS, swe.MERCURY, swe.JUPITER, swe.VENUS, swe.SATURN]
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
# Core Calculation Functions
# ══════════════════════════════════════════════════════════════════

def add_years_exact(dt: datetime, years_float: float) -> datetime:
    """Add years using solar year (365.2425 days)."""
    return dt + timedelta(days=years_float * 365.2425)


def get_navamsa_rashi(longitude: float) -> int:
    """Calculate Navamsha (D9) sign index (0-11)."""
    total_pada = int((longitude % 360.0) / PADA_SPAN)
    return total_pada % 12


def get_dasamsa_rashi(longitude: float) -> int:
    """Calculate Dasamsa (D10) sign index (0-11)."""
    lon = longitude % 360.0
    rashi_idx = int(lon / 30.0) % 12
    deg_in_rashi = lon % 30.0
    part = int(deg_in_rashi / 3.0)  # 10 parts of 3 degrees each
    # Odd sign starts from the same sign, Even sign starts from the 9th sign
    if rashi_idx % 2 == 0:  # Odd sign (Aries is 0, Gemini 2, Leo 4, etc.)
        return (rashi_idx + part) % 12
    else:  # Even sign (Taurus is 1, Cancer 3, etc.)
        return ((rashi_idx + 8) + part) % 12


def get_saptamsa_rashi(longitude: float) -> int:
    """Calculate Saptamsa (D7) sign index (0-11)."""
    lon = longitude % 360.0
    rashi_idx = int(lon / 30.0) % 12
    deg_in_rashi = lon % 30.0
    part = int(deg_in_rashi / (30.0 / 7.0))
    if rashi_idx % 2 == 0:  # Odd sign starts from the sign itself
        return (rashi_idx + part) % 12
    else:  # Even sign starts from the 7th sign
        return ((rashi_idx + 6) + part) % 12


def get_drekkana_rashi(longitude: float) -> int:
    """Calculate Drekkana (D3) sign index (0-11)."""
    lon = longitude % 360.0
    rashi_idx = int(lon / 30.0) % 12
    deg_in_rashi = lon % 30.0
    part = int(deg_in_rashi / 10.0)  # 3 parts: 0-10 (1st), 10-20 (5th), 20-30 (9th)
    if part == 0:
        return rashi_idx
    elif part == 1:
        return (rashi_idx + 4) % 12
    else:
        return (rashi_idx + 8) % 12


def get_dvadasamsa_rashi(longitude: float) -> int:
    """Calculate Dvadasamsa (D12) sign index (0-11)."""
    lon = longitude % 360.0
    rashi_idx = int(lon / 30.0) % 12
    deg_in_rashi = lon % 30.0
    part = int(deg_in_rashi / 2.5)  # 12 parts of 2.5 deg each starting from same sign
    return (rashi_idx + part) % 12


def _planet_data(name: str, longitude: float, latitude: float, speed: float, is_retro: bool):
    """Build planet position dictionary with full astronomical & astrological details."""
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

    navamsa_idx = get_navamsa_rashi(longitude)
    dasamsa_idx = get_dasamsa_rashi(longitude)
    saptamsa_idx = get_saptamsa_rashi(longitude)
    drekkana_idx = get_drekkana_rashi(longitude)
    dvadasamsa_idx = get_dvadasamsa_rashi(longitude)

    return {
        'name': name,
        'longitude': round(longitude, 6),
        'latitude': round(latitude, 6),
        'speed': round(speed, 6),
        'isRetrograde': is_retro,
        'rashiIndex': rashi_idx,
        'rashi': RASHIS[rashi_idx],
        'rashiSanskrit': RASHIS_SANSKRIT[rashi_idx],
        'degreesInRashi': round(deg_in_rashi, 4),
        'dms': f"{d}°{m:02d}'{s:02d}\"",
        'nakshatraIndex': nak_idx,
        'nakshatra': NAKSHATRAS[nak_idx],
        'nakshatraLord': NAKSHATRA_LORDS[nak_idx],
        'pada': pada,
        'navamsaRashiIndex': navamsa_idx,
        'navamsaRashi': RASHIS[navamsa_idx],
        'dasamsaRashiIndex': dasamsa_idx,
        'saptamsaRashiIndex': saptamsa_idx,
        'drekkanaRashiIndex': drekkana_idx,
        'dvadasamsaRashiIndex': dvadasamsa_idx,
    }


def compute_chart(year: int, month: int, day: int, hour: int, minute: int, lat: float, lon: float, tz_offset: float):
    """Compute full Vedic chart using Swiss Ephemeris."""
    local_decimal_hours = hour + minute / 60.0
    ut_decimal_hours = local_decimal_hours - tz_offset

    adj_day = day
    adj_month = month
    adj_year = year
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

    # Planet positions (sidereal)
    planets = []
    for pid, name in zip(PLANET_IDS, PLANET_NAMES):
        pos = swe.calc_ut(jd, pid, swe.FLG_SIDEREAL | swe.FLG_SPEED)
        lon_sid = pos[0][0] % 360.0
        lat_ecl = pos[0][1]
        speed = pos[0][3]
        is_retro = speed < 0
        planets.append(_planet_data(name, lon_sid, lat_ecl, speed, is_retro))

    # Rahu (Mean Node) & Ketu
    rahu_pos = swe.calc_ut(jd, swe.MEAN_NODE, swe.FLG_SIDEREAL | swe.FLG_SPEED)
    rahu_lon = rahu_pos[0][0] % 360.0
    ketu_lon = (rahu_lon + 180.0) % 360.0
    planets.append(_planet_data('Rahu', rahu_lon, 0, rahu_pos[0][3], True))
    planets.append(_planet_data('Ketu', ketu_lon, 0, -rahu_pos[0][3], True))

    # Ascendant (Lagna) in Sidereal
    cusps, ascmc = swe.houses_ex(jd, lat, lon, b'P', swe.FLG_SIDEREAL)
    asc_sid = ascmc[0] % 360.0
    ascendant = _planet_data('Ascendant', asc_sid, 0, 0, False)

    # Vimshottari Dashas
    moon_lon = planets[1]['longitude']
    birth_dt = datetime(year, month, day, hour, minute)
    dashas = compute_vimshottari_dashas(moon_lon, birth_dt)

    return {
        'jd': jd,
        'ayanamsa': round(ayanamsa, 6),
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

    # First Maha Dasha
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

    # Remaining 8 Maha Dashas
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
            self._send_json({'status': 'ok', 'engine': 'Swiss Ephemeris with Lahiri Ayanamsa'})
        else:
            self._send_json({'error': 'Not found'}, 404)

    def do_POST(self):
        if self.path == '/calculate':
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length)
            try:
                data = json.loads(body)
                self._handle_calculate_json(data)
            except json.JSONDecodeError:
                self._send_json({'error': 'Invalid JSON'}, 400)
        else:
            self._send_json({'error': 'Not found'}, 404)

    def _handle_calculate(self, params):
        try:
            year = int(params.get('year', [2000])[0])
            month = int(params.get('month', [1])[0])
            day = int(params.get('day', [1])[0])
            hour = int(params.get('hour', [12])[0])
            minute = int(params.get('minute', [0])[0])
            lat = float(params.get('lat', [0.0])[0])
            lon = float(params.get('lon', [0.0])[0])
            tz = float(params.get('tz', [5.5])[0])

            result = compute_chart(year, month, day, hour, minute, lat, lon, tz)
            self._send_json(result)
        except Exception as e:
            self._send_json({'error': str(e)}, 500)

    def _handle_calculate_json(self, data):
        try:
            year = int(data.get('year', 2000))
            month = int(data.get('month', 1))
            day = int(data.get('day', 1))
            hour = int(data.get('hour', 12))
            minute = int(data.get('minute', 0))
            lat = float(data.get('lat', 0.0))
            lon = float(data.get('lon', 0.0))
            tz = float(data.get('tz', 5.5))

            result = compute_chart(year, month, day, hour, minute, lat, lon, tz)
            self._send_json(result)
        except Exception as e:
            self._send_json({'error': str(e)}, 500)

    def _send_json(self, data, status=200):
        self.send_response(status)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        self.wfile.write(json.dumps(data, indent=2).encode('utf-8'))

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def log_message(self, format, *args):
        pass


def main():
    server = HTTPServer(('0.0.0.0', PORT), AstroHandler)
    print(f"Vedic Astrology Server running on http://0.0.0.0:{PORT}")
    print(f"Swiss Ephemeris with Lahiri Ayanamsa active.")
    server.serve_forever()


if __name__ == '__main__':
    main()
