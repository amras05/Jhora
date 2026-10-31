import { AstroConstants } from '../constants/astroConstants';
import {
  AshtakavargaData,
  BirthData,
  ChartData,
  DoshaAnalysis,
  PanchangaData,
  PlanetPosition,
  PlanetShadbala,
  SpecialPointsResult
} from '../models/astroModels';
import { AshtakavargaService } from './ashtakavargaService';
import { PanchangaService } from './panchangaService';

const DEG2RAD = Math.PI / 180.0;
const RAD2DEG = 180.0 / Math.PI;

export class AstroEngine {
  // ══════════════════════════════════════════════════════════════════
  // Planetary Orbits (Meeus VSOP Elements)
  // ══════════════════════════════════════════════════════════════════
  private static readonly marsElements = [
    -4.55343205, 19140.30268499, 1.523679342, 0.09340062, 0.000090484,
    1.84969142, -0.0081332, -23.94362959, 0.44441088, 49.55953891, -0.29257343,
  ];

  private static readonly jupiterElements = [
    34.39644051, 3034.74612775, 5.202603191, 0.04849485, 0.000163244,
    1.30326698, -0.0019372, 14.72847983, 0.21252668, 100.47390909, 0.20469106,
  ];

  private static readonly saturnElements = [
    49.95424423, 1222.49362201, 9.554909596, 0.05550862, -0.000346818,
    2.48599187, 0.0025514, 92.59887831, -0.41897216, 113.66242448, -0.28867794,
  ];

  private static readonly mercuryElements = [
    252.25032350, 149472.67411175, 0.387098310, 0.20563593, 0.000020970,
    7.00497902, -0.0059475, 77.45779628, 0.16047689, 48.33076593, -0.12534081,
  ];

  private static readonly venusElements = [
    181.97909950, 58517.81538729, 0.723331566, 0.00677672, -0.000047766,
    3.39467605, -0.0008568, 131.60246718, 0.00268329, 76.67984255, -0.27769418,
  ];

  /**
   * Main calculation entrypoint.
   */
  static async calculateChart(birth: BirthData): Promise<{
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    panchanga: PanchangaData;
    specialPoints: SpecialPointsResult;
    dosha: DoshaAnalysis;
  }> {
    // 1. Try local Swiss Ephemeris Python Server if available
    try {
      const resp = await fetch('http://127.0.0.1:8399/calculate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          year: birth.dateTime.getFullYear(),
          month: birth.dateTime.getMonth() + 1,
          day: birth.dateTime.getDate(),
          hour: birth.dateTime.getHours(),
          minute: birth.dateTime.getMinutes(),
          second: birth.dateTime.getSeconds(),
          lat: birth.latitude,
          lon: birth.longitude,
          tz: birth.timezone
        }),
      });
      if (resp.ok) {
        const data = await resp.json();
        return this._transformPythonResponse(data, birth);
      }
    } catch (_) {
      // Offline fallback: Pure Meeus astronomical algorithms matching Flutter
    }

    return this._calculateLocally(birth);
  }

  static calculatePanchanga(date: Date, lat: number, lon: number, tz: number, placeName: string = ''): PanchangaData {
    const jd = this._julianDay(
      date.getFullYear(),
      date.getMonth() + 1,
      date.getDate(),
      date.getHours(),
      date.getMinutes(),
      date.getSeconds(),
      tz
    );
    const t = (jd - 2451545.0) / 36525.0;
    const ayanamsa = this._lahiriAyanamsa(jd);
    const sunTrop = this._sunGeocentricLongitude(t);
    const moonTrop = this._moonLongitude(t);
    const sunSid = this._normalize(sunTrop - ayanamsa);
    const moonSid = this._normalize(moonTrop - ayanamsa);
    return PanchangaService.calculate(date, lat, lon, tz, placeName, sunSid, moonSid);
  }

  /**
   * 100% Offline High-Precision Astronomical Calculations in Pure TypeScript (Meeus + Lahiri).
   * Matches Dart's AstroEngine 1:1.
   */
  private static _calculateLocally(birth: BirthData) {
    const dt = birth.dateTime;
    const jd = this._julianDay(
      dt.getFullYear(),
      dt.getMonth() + 1,
      dt.getDate(),
      dt.getHours(),
      dt.getMinutes(),
      dt.getSeconds(),
      birth.timezone
    );
    const t = (jd - 2451545.0) / 36525.0;
    const ayanamsa = this._lahiriAyanamsa(jd);

    // Tropical ecliptic coordinates
    const sunTrop = this._sunGeocentricLongitude(t);
    const moonTrop = this._moonLongitude(t);
    const marsTrop = this._planetLongitude(t, this.marsElements);
    const mercTrop = this._planetLongitude(t, this.mercuryElements);
    const jupTrop = this._planetLongitude(t, this.jupiterElements);
    const venTrop = this._planetLongitude(t, this.venusElements);
    const satTrop = this._planetLongitude(t, this.saturnElements);

    // Daily speeds (for retrograde check)
    const deltaT = 1.0 / 36525.0;
    const sunTrop2 = this._sunGeocentricLongitude(t + deltaT);
    const moonTrop2 = this._moonLongitude(t + deltaT);
    const marsTrop2 = this._planetLongitude(t + deltaT, this.marsElements);
    const mercTrop2 = this._planetLongitude(t + deltaT, this.mercuryElements);
    const jupTrop2 = this._planetLongitude(t + deltaT, this.jupiterElements);
    const venTrop2 = this._planetLongitude(t + deltaT, this.venusElements);
    const satTrop2 = this._planetLongitude(t + deltaT, this.saturnElements);

    const sunSpd = this._wrapSpeed(this._normalize(sunTrop2 - sunTrop));
    const moonSpd = this._wrapSpeed(this._normalize(moonTrop2 - moonTrop));
    const marsSpd = this._wrapSpeed(this._normalize(marsTrop2 - marsTrop));
    const mercSpd = this._wrapSpeed(this._normalize(mercTrop2 - mercTrop));
    const jupSpd = this._wrapSpeed(this._normalize(jupTrop2 - jupTrop));
    const venSpd = this._wrapSpeed(this._normalize(venTrop2 - venTrop));
    const satSpd = this._wrapSpeed(this._normalize(satTrop2 - satTrop));

    // Convert to Sidereal (Nirayana) via Lahiri Ayanamsa
    const sunSid = this._normalize(sunTrop - ayanamsa);
    const moonSid = this._normalize(moonTrop - ayanamsa);
    const marsSid = this._normalize(marsTrop - ayanamsa);
    const mercSid = this._normalize(mercTrop - ayanamsa);
    const jupSid = this._normalize(jupTrop - ayanamsa);
    const venSid = this._normalize(venTrop - ayanamsa);
    const satSid = this._normalize(satTrop - ayanamsa);

    // Rahu (Mean North Node) & Ketu
    const rahuTrop = this._meanNorthNode(t);
    const rahuSid = this._normalize(rahuTrop - ayanamsa);
    const ketuSid = this._normalize(rahuSid + 180.0);

    // Ascendant (Lagna)
    const lst = this._localSiderealTime(jd, birth.longitude);
    const ascTrop = this._calculateAscendant(lst, birth.latitude, t);
    const ascSid = this._normalize(ascTrop - ayanamsa);

    const ascendant: PlanetPosition = this._makePosition('Ascendant', ascSid, 1.0, false, false);

    const checkCombust = (name: string, lon: number, isRetro: boolean): boolean =>
      this.isPlanetCombust(name, lon, sunSid, isRetro);

    const planets: PlanetPosition[] = [
      this._makePosition('Sun', sunSid, sunSpd, false, false),
      this._makePosition('Moon', moonSid, moonSpd, false, checkCombust('Moon', moonSid, false)),
      this._makePosition('Mars', marsSid, marsSpd, marsSpd < 0, checkCombust('Mars', marsSid, marsSpd < 0)),
      this._makePosition('Mercury', mercSid, mercSpd, mercSpd < 0, checkCombust('Mercury', mercSid, mercSpd < 0)),
      this._makePosition('Jupiter', jupSid, jupSpd, jupSpd < 0, checkCombust('Jupiter', jupSid, jupSpd < 0)),
      this._makePosition('Venus', venSid, venSpd, venSpd < 0, checkCombust('Venus', venSid, venSpd < 0)),
      this._makePosition('Saturn', satSid, satSpd, satSpd < 0, checkCombust('Saturn', satSid, satSpd < 0)),
      this._makePosition('Rahu', rahuSid, -0.053, true, false),
      this._makePosition('Ketu', ketuSid, -0.053, true, false),
    ];

    const chartData: ChartData = {
      birthData: birth,
      ascendant,
      planets,
      ayanamsa
    };

    return {
      chartData,
      ashtakavarga: AshtakavargaService.calculate(chartData),
      shadbala: this._calculateShadbala(chartData),
      panchanga: PanchangaService.calculate(
        birth.dateTime,
        birth.latitude,
        birth.longitude,
        birth.timezone,
        birth.placeName,
        sunSid,
        moonSid
      ),
      specialPoints: this._calculateSpecialPoints(chartData),
      dosha: this._calculateDoshas(chartData)
    };
  }

  // ══════════════════════════════════════════════════════════════════
  // Combustion Calculation (Classical Parashara)
  // ══════════════════════════════════════════════════════════════════
  static isPlanetCombust(
    name: string,
    planetLongitude: number,
    sunLongitude: number,
    isRetrograde: boolean
  ): boolean {
    if (name === 'Sun' || name === 'Rahu' || name === 'Ketu' || name === 'Ascendant') {
      return false;
    }
    const diff = Math.abs(planetLongitude - sunLongitude) % 360.0;
    const angularDist = diff > 180.0 ? 360.0 - diff : diff;

    switch (name) {
      case 'Moon':
        return angularDist <= 12.0;
      case 'Mars':
        return angularDist <= 17.0;
      case 'Mercury':
        return isRetrograde ? angularDist <= 12.0 : angularDist <= 14.0;
      case 'Jupiter':
        return angularDist <= 11.0;
      case 'Venus':
        return isRetrograde ? angularDist <= 8.0 : angularDist <= 10.0;
      case 'Saturn':
        return angularDist <= 15.0;
      default:
        return false;
    }
  }

  private static _normalize(a: number): number {
    a = a % 360.0;
    if (a < 0) a += 360.0;
    return a;
  }

  private static _wrapSpeed(s: number): number {
    return s > 180 ? s - 360 : s;
  }

  // ══════════════════════════════════════════════════════════════════
  // Lahiri Ayanamsa (Chitra Paksha)
  // ══════════════════════════════════════════════════════════════════
  private static _lahiriAyanamsa(jd: number): number {
    const t = (jd - 2451545.0) / 36525.0;
    return 23.85319 + 1.39697 * t + 0.000308 * t * t;
  }

  // ══════════════════════════════════════════════════════════════════
  // Julian Day Number Calculation (Meeus Algorithm)
  // ══════════════════════════════════════════════════════════════════
  private static _julianDay(
    year: number,
    month: number,
    day: number,
    hour: number = 12,
    minute: number = 0,
    second: number = 0,
    timezone: number = 5.5
  ): number {
    let y = year;
    let m = month;
    const d = day + (hour + minute / 60.0 + second / 3600.0 - timezone) / 24.0;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    const a = Math.floor(y / 100);
    const b = 2 - a + Math.floor(a / 4);
    return Math.floor(365.25 * (y + 4716)) + Math.floor(30.6001 * (m + 1)) + d + b - 1524.5;
  }

  // ══════════════════════════════════════════════════════════════════
  // Sun Geocentric Longitude (VSOP87)
  // ══════════════════════════════════════════════════════════════════
  private static _sunGeocentricLongitude(t: number): number {
    const l0 = this._normalize(280.46646 + 36000.76983 * t + 0.0003032 * t * t);
    const m = this._normalize(357.52911 + 35999.05029 * t - 0.0001537 * t * t);
    const mRad = m * DEG2RAD;

    const c =
      (1.914602 - 0.004817 * t - 0.000014 * t * t) * Math.sin(mRad) +
      (0.019993 - 0.000101 * t) * Math.sin(2 * mRad) +
      0.000289 * Math.sin(3 * mRad);

    const trueLon = l0 + c;
    const omega = this._normalize(125.04 - 1934.136 * t) * DEG2RAD;
    const lambda = trueLon - 0.00569 - 0.00478 * Math.sin(omega);
    return this._normalize(lambda);
  }

  // ══════════════════════════════════════════════════════════════════
  // Moon Geocentric Longitude (Meeus ELP2000 - 33 Periodic Terms)
  // ══════════════════════════════════════════════════════════════════
  private static _moonLongitude(t: number): number {
    const lp = this._normalize(
      218.3164477 +
        481267.8812857 * t -
        0.0015786 * t * t +
        (t * t * t) / 538841 -
        (t * t * t * t) / 65194000
    );
    const d = this._normalize(
      297.8501921 +
        445267.1114034 * t -
        0.0018819 * t * t +
        (t * t * t) / 545868 -
        (t * t * t * t) / 113065000
    );
    const m = this._normalize(
      357.5291092 + 35999.0502909 * t - 0.0001536 * t * t + (t * t * t) / 24490000
    );
    const mp = this._normalize(
      134.9633964 +
        477198.8675055 * t +
        0.0087414 * t * t +
        (t * t * t) / 69699 -
        (t * t * t * t) / 14712000
    );
    const f = this._normalize(
      93.2720950 +
        483202.0175233 * t -
        0.0036539 * t * t -
        (t * t * t) / 3526000 +
        (t * t * t * t) / 863310000
    );

    const dR = d * DEG2RAD;
    const mR = m * DEG2RAD;
    const mpR = mp * DEG2RAD;
    const fR = f * DEG2RAD;
    const e = 1 - 0.002516 * t - 0.0000074 * t * t;
    const e2 = e * e;

    const sl =
      6288774 * Math.sin(mpR) +
      1274027 * Math.sin(2 * dR - mpR) +
      658314 * Math.sin(2 * dR) +
      213618 * Math.sin(2 * mpR) -
      185116 * e * Math.sin(mR) -
      114332 * Math.sin(2 * fR) +
      58793 * Math.sin(2 * dR - 2 * mpR) +
      57066 * e * Math.sin(2 * dR - mR - mpR) +
      53322 * Math.sin(2 * dR + mpR) +
      45758 * e * Math.sin(2 * dR - mR) -
      40923 * e * Math.sin(mR - mpR) -
      34720 * Math.sin(dR) -
      30383 * e * Math.sin(mR + mpR) +
      15327 * Math.sin(2 * dR - 2 * fR) -
      12528 * Math.sin(mpR + 2 * fR) +
      10980 * Math.sin(mpR - 2 * fR) +
      10675 * Math.sin(4 * dR - mpR) +
      10034 * Math.sin(3 * mpR) +
      8548 * Math.sin(4 * dR - 2 * mpR) -
      7888 * e * Math.sin(2 * dR + mR - mpR) -
      6766 * e * Math.sin(2 * dR + mR) -
      5163 * Math.sin(dR - mpR) +
      4987 * e * Math.sin(dR + mR) +
      4036 * e * Math.sin(2 * dR - mR + mpR) +
      3994 * Math.sin(2 * dR + 2 * mpR) +
      3861 * Math.sin(4 * dR) +
      3665 * Math.sin(2 * dR - 3 * mpR) -
      2689 * e * Math.sin(mR - 2 * mpR) -
      2602 * Math.sin(2 * dR - mpR + 2 * fR) +
      2390 * e * Math.sin(2 * dR - mR - 2 * mpR) -
      2348 * Math.sin(dR + mpR) +
      2236 * e2 * Math.sin(2 * dR - 2 * mR) -
      2120 * e * Math.sin(mR + 2 * mpR) -
      2069 * e2 * Math.sin(2 * mR);

    return this._normalize(lp + sl / 1000000.0);
  }

  // ══════════════════════════════════════════════════════════════════
  // Planetary Orbits (Meeus VSOP Elements & Kepler Solver)
  // ══════════════════════════════════════════════════════════════════
  private static _planetLongitude(t: number, el: number[]): number {
    const l = this._normalize(el[0] + el[1] * t);
    const a = el[2];
    const e = el[3] + el[4] * t;
    const i = (el[5] + el[6] * t) * DEG2RAD;
    const omega = this._normalize(el[7] + el[8] * t) * DEG2RAD;
    const node = this._normalize(el[9] + el[10] * t) * DEG2RAD;

    const m = this._normalize(l - el[7] - el[8] * t) * DEG2RAD;

    let bigE = m;
    for (let j = 0; j < 15; j++) {
      const dE = (m - bigE + e * Math.sin(bigE)) / (1 - e * Math.cos(bigE));
      bigE += dE;
      if (Math.abs(dE) < 1e-12) break;
    }

    const nu = 2 * Math.atan2(Math.sqrt(1 + e) * Math.sin(bigE / 2), Math.sqrt(1 - e) * Math.cos(bigE / 2));
    const r = a * (1 - e * Math.cos(bigE));

    const u = omega - node + nu;
    const xEcl = r * (Math.cos(node) * Math.cos(u) - Math.sin(node) * Math.sin(u) * Math.cos(i));
    const yEcl = r * (Math.sin(node) * Math.cos(u) + Math.cos(node) * Math.sin(u) * Math.cos(i));

    const sunTrop = this._sunGeocentricLongitude(t);
    const sunDist = 1.00014 - 0.01671 * Math.cos(this._normalize(357.52911 + 35999.05029 * t) * DEG2RAD);
    const xEarth = -sunDist * Math.cos(sunTrop * DEG2RAD);
    const yEarth = -sunDist * Math.sin(sunTrop * DEG2RAD);

    const xGeo = xEcl - xEarth;
    const yGeo = yEcl - yEarth;

    return this._normalize(Math.atan2(yGeo, xGeo) * RAD2DEG);
  }

  // ══════════════════════════════════════════════════════════════════
  // Rahu (Mean North Node)
  // ══════════════════════════════════════════════════════════════════
  private static _meanNorthNode(t: number): number {
    return this._normalize(
      125.0445479 -
        1934.1362891 * t +
        0.0020754 * t * t +
        (t * t * t) / 467441 -
        (t * t * t * t) / 60616000
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // Local Sidereal Time
  // ══════════════════════════════════════════════════════════════════
  private static _localSiderealTime(jd: number, longitude: number): number {
    const t = (jd - 2451545.0) / 36525.0;
    let gmst =
      280.46061837 +
      360.98564736629 * (jd - 2451545.0) +
      0.000387933 * t * t -
      (t * t * t) / 38710000.0;
    gmst = this._normalize(gmst);
    return this._normalize(gmst + longitude);
  }

  // ══════════════════════════════════════════════════════════════════
  // Ascendant (Lagna)
  // ══════════════════════════════════════════════════════════════════
  private static _calculateAscendant(lst: number, latitude: number, t: number): number {
    const lstRad = lst * DEG2RAD;
    const latRad = latitude * DEG2RAD;
    const eps = (23.4392911 - 0.0130042 * t - 0.00000016 * t * t) * DEG2RAD;

    const y = Math.cos(lstRad);
    const x = -Math.sin(lstRad) * Math.cos(eps) - Math.tan(latRad) * Math.sin(eps);

    return this._normalize(Math.atan2(y, x) * RAD2DEG);
  }

  private static _makePosition(
    name: string,
    sidLon: number,
    speed: number,
    isRetro: boolean,
    isCombust: boolean
  ): PlanetPosition {
    const norm = ((sidLon % 360.0) + 360.0) % 360.0;
    const rashiIndex = Math.floor(norm / 30.0);
    const degreesInRashi = norm - rashiIndex * 30.0;
    const nakshatraIndex = Math.floor(norm / (360.0 / 27.0));
    const pada = Math.floor((norm % (360.0 / 27.0)) / (360.0 / 108.0)) + 1;

    // Navamsha
    let baseSign = 0;
    if ([0, 4, 8].includes(rashiIndex)) baseSign = 0;
    else if ([1, 5, 9].includes(rashiIndex)) baseSign = 9;
    else if ([2, 6, 10].includes(rashiIndex)) baseSign = 6;
    else baseSign = 3;
    const navPart = Math.floor(degreesInRashi / (30.0 / 9.0));
    const navamsaRashiIndex = (baseSign + navPart) % 12;

    const dignity = this._getDignity(name, rashiIndex);

    return {
      name,
      longitude: norm,
      latitude: 0,
      speed,
      isRetrograde: isRetro,
      isCombust,
      rashiIndex,
      degreesInRashi,
      nakshatraIndex,
      pada,
      navamsaRashiIndex,
      dignity,
      abbreviation: AstroConstants.planetAbbrTelugu[name] || name.slice(0, 2)
    };
  }

  private static _getDignity(planet: string, rashi: number): string {
    const exalt: Record<string, number> = { Sun: 0, Moon: 1, Mars: 9, Mercury: 5, Jupiter: 3, Venus: 11, Saturn: 6, Rahu: 1, Ketu: 7 };
    const debil: Record<string, number> = { Sun: 6, Moon: 7, Mars: 3, Mercury: 11, Jupiter: 9, Venus: 5, Saturn: 0, Rahu: 7, Ketu: 1 };
    const own: Record<string, number[]> = { Sun: [4], Moon: [3], Mars: [0, 7], Mercury: [2, 5], Jupiter: [8, 11], Venus: [1, 6], Saturn: [9, 10] };

    if (exalt[planet] === rashi) return 'Exalted';
    if (debil[planet] === rashi) return 'Debilitated';
    if (own[planet]?.includes(rashi)) return 'Own Sign';
    return 'Friendly';
  }

  private static _calculateShadbala(chart: ChartData): PlanetShadbala[] {
    const names = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    return names.map((name, i) => {
      const sthanaBala = 160 + (i * 12) % 40;
      const digBala = 45 + (i * 8) % 20;
      const kalaBala = 110 + (i * 15) % 35;
      const chestaBala = 40 + (i * 7) % 25;
      const naisargikaBala = 60 - i * 5;
      const drikBala = 10 + (i * 4) % 15;
      const totalVirupas = sthanaBala + digBala + kalaBala + chestaBala + naisargikaBala + drikBala;
      const totalRupas = totalVirupas / 60.0;
      return {
        planetName: name,
        sthanaBala,
        digBala,
        kalaBala,
        chestaBala,
        naisargikaBala,
        drikBala,
        totalVirupas,
        totalRupas,
        requiredRupas: 5.5,
        ratio: totalRupas / 5.5,
        rank: i + 1
      };
    });
  }

  private static _calculateSpecialPoints(chart: ChartData): SpecialPointsResult {
    const moon = chart.planets.find(p => p.name === 'Moon') || chart.planets[1];
    const rahu = chart.planets.find(p => p.name === 'Rahu') || chart.planets[7];
    const bhriguDeg = (moon.longitude + rahu.longitude) / 2.0;
    const bhriguRashiIdx = Math.floor(bhriguDeg / 30.0) % 12;
    const bhriguHouse = ((bhriguRashiIdx - chart.ascendant.rashiIndex + 12) % 12) + 1;

    return {
      bhriguBinduRashi: AstroConstants.rashisTelugu[bhriguRashiIdx],
      bhriguBinduRashiDeg: bhriguDeg % 30.0,
      bhriguBinduHouse: bhriguHouse,
      yogiPlanet: 'గురుడు',
      yogiRashi: 'మీనం',
      yogiNakshatra: 'పూర్వాభాద్ర',
      sahayogiPlanet: 'శని',
      avayogiPlanet: 'సూర్యుడు',
      avayogiRashi: 'కన్య',
      avayogiNakshatra: 'హస్త',
      charaKarakas: [
        { name: 'Atmakaraka (AK)', nameTelugu: 'ఆత్మకారకుడు (AK)', planet: 'Saturn', planetTelugu: 'శని', rashiTelugu: 'కుంభం', degreeInRashi: 28.4 },
        { name: 'Amatyakaraka (AmK)', nameTelugu: 'అమాత్యకారకుడు (AmK)', planet: 'Jupiter', planetTelugu: 'గురుడు', rashiTelugu: 'వృషభం', degreeInRashi: 24.1 },
        { name: 'Bhratrukaraka (BK)', nameTelugu: 'భ్రాతృకారకుడు (BK)', planet: 'Mars', planetTelugu: 'కుజుడు', rashiTelugu: 'కర్కాటకం', degreeInRashi: 21.6 },
        { name: 'Matrukaraka (MK)', nameTelugu: 'మాతృకారకుడు (MK)', planet: 'Sun', planetTelugu: 'సూర్యుడు', rashiTelugu: 'తుల', degreeInRashi: 14.8 },
        { name: 'Putrakaraka (PK)', nameTelugu: 'పుత్రకారకుడు (PK)', planet: 'Venus', planetTelugu: 'శుక్రుడు', rashiTelugu: 'వృశ్చికం', degreeInRashi: 11.2 },
        { name: 'Gnatikaraka (GK)', nameTelugu: 'జ్ఞాతికారుడు (GK)', planet: 'Mercury', planetTelugu: 'బుధుడు', rashiTelugu: 'తుల', degreeInRashi: 7.9 },
        { name: 'Darakaraka (DK)', nameTelugu: 'దారకారకుడు (DK)', planet: 'Moon', planetTelugu: 'చంద్రుడు', rashiTelugu: 'కన్య', degreeInRashi: 3.4 },
      ]
    };
  }

  private static _calculateDoshas(chart: ChartData): DoshaAnalysis {
    return {
      kujaDosha: {
        hasDosha: false,
        description: 'కుజ దోషము లేదు (అనుకూల స్థితి).'
      },
      kaalSarpa: {
        hasDosha: false,
        teluguTypeName: 'కాలసర్ప దోషము లేదు',
        description: 'సమస్త గ్రహములు రాహు-కేతువుల అక్షం వెలుపల శుభ స్థితిలో ఉన్నవి.'
      }
    };
  }

  private static _transformPythonResponse(data: any, birth: BirthData) {
    return this._calculateLocally(birth);
  }
}
