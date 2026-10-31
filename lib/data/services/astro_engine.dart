import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/birth_data.dart';
import '../models/chart_data.dart';
import '../models/planet_position.dart';
import 'dasha_service.dart';

/// 100% Offline-Capable High-Precision Vedic Astrology Calculation Engine.
/// Operates completely offline with pure Dart Meeus astronomical algorithms,
/// with optional local Swiss Ephemeris microservice bridge when available.
class AstroEngine {
  AstroEngine._();

  static const String _apiBaseUrl = 'http://127.0.0.1:8399';
  static const double _deg2rad = pi / 180.0;
  static const double _rad2deg = 180.0 / pi;

  /// Calculate chart (tries local Swiss Ephemeris microservice with 300ms timeout, instantly falls back to 100% offline Dart engine)
  static Future<ChartData> calculateChartAsync(BirthData birth) async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/calculate').replace(queryParameters: {
        'year': birth.dateTime.year.toString(),
        'month': birth.dateTime.month.toString(),
        'day': birth.dateTime.day.toString(),
        'hour': birth.dateTime.hour.toString(),
        'minute': birth.dateTime.minute.toString(),
        'lat': birth.latitude.toString(),
        'lon': birth.longitude.toString(),
        'tz': birth.timezone.toString(),
      });

      final response = await http.get(uri).timeout(const Duration(milliseconds: 300));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return _fromSwissEphemerisJson(data, birth);
      }
    } catch (_) {
      // 100% Offline fallback
    }

    return calculateChart(birth);
  }

  /// Classical Parashara combustion check against the Sun.
  /// Standard combustion limits from Sun in degrees:
  /// - Moon: 12°
  /// - Mars: 17°
  /// - Mercury: 14° (direct), 12° (retrograde)
  /// - Jupiter: 11°
  /// - Venus: 10° (direct), 8° (retrograde)
  /// - Saturn: 15°
  /// - Sun, Rahu, Ketu, Ascendant: Never combust
  static bool isPlanetCombust({
    required String name,
    required double planetLongitude,
    required double sunLongitude,
    required bool isRetrograde,
  }) {
    if (name == 'Sun' || name == 'Rahu' || name == 'Ketu' || name == 'Ascendant') {
      return false;
    }

    double diff = (planetLongitude - sunLongitude).abs() % 360.0;
    double angularDist = diff > 180.0 ? 360.0 - diff : diff;

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

  static ChartData _fromSwissEphemerisJson(Map<String, dynamic> data, BirthData birth) {
    final ascJson = data['ascendant'] as Map<String, dynamic>;
    final ascendant = PlanetPosition.fromJson(ascJson);

    final planetsJson = data['planets'] as List<dynamic>;
    List<PlanetPosition> planets = planetsJson.map((p) => PlanetPosition.fromJson(p as Map<String, dynamic>)).toList();

    // Verify combustion against Sun
    final sunPos = planets.firstWhere((p) => p.name == 'Sun', orElse: () => planets.first);
    planets = planets.map((p) {
      if (p.name == 'Sun' || p.name == 'Rahu' || p.name == 'Ketu' || p.name == 'Ascendant') {
        return p;
      }
      final combust = p.isCombust || isPlanetCombust(
        name: p.name,
        planetLongitude: p.longitude,
        sunLongitude: sunPos.longitude,
        isRetrograde: p.isRetrograde,
      );
      return p.copyWith(isCombust: combust);
    }).toList();

    final ayanamsa = (data['ayanamsa'] as num).toDouble();

    List<DashaPeriod>? dashas;
    if (data['dashas'] != null) {
      final dList = data['dashas'] as List<dynamic>;
      dashas = dList.map((d) => DashaPeriod.fromJson(d as Map<String, dynamic>)).toList();
    }

    return ChartData(
      birthData: birth,
      ascendant: ascendant,
      planets: planets,
      ayanamsa: ayanamsa,
      precomputedDashas: dashas,
    );
  }

  /// 100% Standalone Offline Astronomical calculations in pure Dart (Meeus + Lahiri)
  static ChartData calculateChart(BirthData birth) {
    double jd = birth.julianDay;
    double t = (jd - 2451545.0) / 36525.0;

    double ayanamsa = _lahiriAyanamsa(jd);

    // Tropical ecliptic coordinates
    double sunTrop = _sunGeocentricLongitude(t);
    double moonTrop = _moonLongitude(t);
    double marsTrop = _planetLongitude(t, _marsElements);
    double mercTrop = _planetLongitude(t, _mercuryElements);
    double jupTrop = _planetLongitude(t, _jupiterElements);
    double venTrop = _planetLongitude(t, _venusElements);
    double satTrop = _planetLongitude(t, _saturnElements);

    // Daily speeds (for retrograde check)
    double dt = 1.0 / 36525.0;
    double sunTrop2 = _sunGeocentricLongitude(t + dt);
    double moonTrop2 = _moonLongitude(t + dt);
    double marsTrop2 = _planetLongitude(t + dt, _marsElements);
    double mercTrop2 = _planetLongitude(t + dt, _mercuryElements);
    double jupTrop2 = _planetLongitude(t + dt, _jupiterElements);
    double venTrop2 = _planetLongitude(t + dt, _venusElements);
    double satTrop2 = _planetLongitude(t + dt, _saturnElements);

    double sunSpd = _wrapSpeed(_normalize(sunTrop2 - sunTrop));
    double moonSpd = _wrapSpeed(_normalize(moonTrop2 - moonTrop));
    double marsSpd = _wrapSpeed(_normalize(marsTrop2 - marsTrop));
    double mercSpd = _wrapSpeed(_normalize(mercTrop2 - mercTrop));
    double jupSpd = _wrapSpeed(_normalize(jupTrop2 - jupTrop));
    double venSpd = _wrapSpeed(_normalize(venTrop2 - venTrop));
    double satSpd = _wrapSpeed(_normalize(satTrop2 - satTrop));

    // Convert to Sidereal (Nirayana) via Lahiri Ayanamsa
    double sunSid = _normalize(sunTrop - ayanamsa);
    double moonSid = _normalize(moonTrop - ayanamsa);
    double marsSid = _normalize(marsTrop - ayanamsa);
    double mercSid = _normalize(mercTrop - ayanamsa);
    double jupSid = _normalize(jupTrop - ayanamsa);
    double venSid = _normalize(venTrop - ayanamsa);
    double satSid = _normalize(satTrop - ayanamsa);

    // Rahu (Mean Node) & Ketu
    double rahuTrop = _meanNorthNode(t);
    double rahuSid = _normalize(rahuTrop - ayanamsa);
    double ketuSid = _normalize(rahuSid + 180.0);

    // Ascendant (Lagna)
    double lst = birth.localSiderealTime;
    double ascTrop = _calculateAscendant(lst, birth.latitude, t);
    double ascSid = _normalize(ascTrop - ayanamsa);

    PlanetPosition ascendant = PlanetPosition(name: 'Ascendant', longitude: ascSid);

    bool checkCombust(String name, double lon, bool isRetro) =>
        isPlanetCombust(name: name, planetLongitude: lon, sunLongitude: sunSid, isRetrograde: isRetro);

    List<PlanetPosition> planets = [
      PlanetPosition(name: 'Sun', longitude: sunSid, speed: sunSpd),
      PlanetPosition(name: 'Moon', longitude: moonSid, speed: moonSpd, isCombust: checkCombust('Moon', moonSid, false)),
      PlanetPosition(name: 'Mars', longitude: marsSid, speed: marsSpd, isRetrograde: marsSpd < 0, isCombust: checkCombust('Mars', marsSid, marsSpd < 0)),
      PlanetPosition(name: 'Mercury', longitude: mercSid, speed: mercSpd, isRetrograde: mercSpd < 0, isCombust: checkCombust('Mercury', mercSid, mercSpd < 0)),
      PlanetPosition(name: 'Jupiter', longitude: jupSid, speed: jupSpd, isRetrograde: jupSpd < 0, isCombust: checkCombust('Jupiter', jupSid, jupSpd < 0)),
      PlanetPosition(name: 'Venus', longitude: venSid, speed: venSpd, isRetrograde: venSpd < 0, isCombust: checkCombust('Venus', venSid, venSpd < 0)),
      PlanetPosition(name: 'Saturn', longitude: satSid, speed: satSpd, isRetrograde: satSpd < 0, isCombust: checkCombust('Saturn', satSid, satSpd < 0)),
      PlanetPosition(name: 'Rahu', longitude: rahuSid, isRetrograde: true),
      PlanetPosition(name: 'Ketu', longitude: ketuSid, isRetrograde: true),
    ];

    return ChartData(
      birthData: birth,
      ascendant: ascendant,
      planets: planets,
      ayanamsa: ayanamsa,
    );
  }

  static double _normalize(double a) {
    a = a % 360.0;
    if (a < 0) a += 360.0;
    return a;
  }

  static double _wrapSpeed(double s) => s > 180 ? s - 360 : s;

  // ══════════════════════════════════════════════════════════════════
  // LAHIRI AYANAMSA (Chitra Paksha)
  // ══════════════════════════════════════════════════════════════════
  static double _lahiriAyanamsa(double jd) {
    double t = (jd - 2451545.0) / 36525.0;
    return 23.85319 + 1.39697 * t + 0.000308 * t * t;
  }

  // ══════════════════════════════════════════════════════════════════
  // SUN (VSOP87)
  // ══════════════════════════════════════════════════════════════════
  static double _sunGeocentricLongitude(double t) {
    double l0 = _normalize(280.46646 + 36000.76983 * t + 0.0003032 * t * t);
    double m = _normalize(357.52911 + 35999.05029 * t - 0.0001537 * t * t);
    double mRad = m * _deg2rad;

    double c = (1.914602 - 0.004817 * t - 0.000014 * t * t) * sin(mRad)
        + (0.019993 - 0.000101 * t) * sin(2 * mRad)
        + 0.000289 * sin(3 * mRad);

    double trueLon = l0 + c;
    double omega = _normalize(125.04 - 1934.136 * t) * _deg2rad;
    double lambda = trueLon - 0.00569 - 0.00478 * sin(omega);
    return _normalize(lambda);
  }

  // ══════════════════════════════════════════════════════════════════
  // MOON (Meeus ELP2000)
  // ══════════════════════════════════════════════════════════════════
  static double _moonLongitude(double t) {
    double lp = _normalize(218.3164477 + 481267.8812857 * t
        - 0.0015786 * t * t + t * t * t / 538841 - t * t * t * t / 65194000);
    double d = _normalize(297.8501921 + 445267.1114034 * t
        - 0.0018819 * t * t + t * t * t / 545868 - t * t * t * t / 113065000);
    double m = _normalize(357.5291092 + 35999.0502909 * t
        - 0.0001536 * t * t + t * t * t / 24490000);
    double mp = _normalize(134.9633964 + 477198.8675055 * t
        + 0.0087414 * t * t + t * t * t / 69699 - t * t * t * t / 14712000);
    double f = _normalize(93.2720950 + 483202.0175233 * t
        - 0.0036539 * t * t - t * t * t / 3526000 + t * t * t * t / 863310000);

    double dR = d * _deg2rad, mR = m * _deg2rad, mpR = mp * _deg2rad, fR = f * _deg2rad;
    double e = 1 - 0.002516 * t - 0.0000074 * t * t;
    double e2 = e * e;

    double sl = 6288774 * sin(mpR)
        + 1274027 * sin(2 * dR - mpR)
        + 658314 * sin(2 * dR)
        + 213618 * sin(2 * mpR)
        - 185116 * e * sin(mR)
        - 114332 * sin(2 * fR)
        + 58793 * sin(2 * dR - 2 * mpR)
        + 57066 * e * sin(2 * dR - mR - mpR)
        + 53322 * sin(2 * dR + mpR)
        + 45758 * e * sin(2 * dR - mR)
        - 40923 * e * sin(mR - mpR)
        - 34720 * sin(dR)
        - 30383 * e * sin(mR + mpR)
        + 15327 * sin(2 * dR - 2 * fR)
        - 12528 * sin(mpR + 2 * fR)
        + 10980 * sin(mpR - 2 * fR)
        + 10675 * sin(4 * dR - mpR)
        + 10034 * sin(3 * mpR)
        + 8548 * sin(4 * dR - 2 * mpR)
        - 7888 * e * sin(2 * dR + mR - mpR)
        - 6766 * e * sin(2 * dR + mR)
        - 5163 * sin(dR - mpR)
        + 4987 * e * sin(dR + mR)
        + 4036 * e * sin(2 * dR - mR + mpR)
        + 3994 * sin(2 * dR + 2 * mpR)
        + 3861 * sin(4 * dR)
        + 3665 * sin(2 * dR - 3 * mpR)
        - 2689 * e * sin(mR - 2 * mpR)
        - 2602 * sin(2 * dR - mpR + 2 * fR)
        + 2390 * e * sin(2 * dR - mR - 2 * mpR)
        - 2348 * sin(dR + mpR)
        + 2236 * e2 * sin(2 * dR - 2 * mR)
        - 2120 * e * sin(mR + 2 * mpR)
        - 2069 * e2 * sin(2 * mR);

    return _normalize(lp + sl / 1000000.0);
  }

  // ══════════════════════════════════════════════════════════════════
  // PLANETARY ORBITS (Meeus VSOP)
  // ══════════════════════════════════════════════════════════════════
  static const List<double> _marsElements = [
    -4.55343205, 19140.30268499, 1.523679342, 0.09340062, 0.000090484,
    1.84969142, -0.0081332, -23.94362959, 0.44441088, 49.55953891, -0.29257343,
  ];

  static const List<double> _jupiterElements = [
    34.39644051, 3034.74612775, 5.202603191, 0.04849485, 0.000163244,
    1.30326698, -0.0019372, 14.72847983, 0.21252668, 100.47390909, 0.20469106,
  ];

  static const List<double> _saturnElements = [
    49.95424423, 1222.49362201, 9.554909596, 0.05550862, -0.000346818,
    2.48599187, 0.0025514, 92.59887831, -0.41897216, 113.66242448, -0.28867794,
  ];

  static const List<double> _mercuryElements = [
    252.25032350, 149472.67411175, 0.387098310, 0.20563593, 0.000020970,
    7.00497902, -0.0059475, 77.45779628, 0.16047689, 48.33076593, -0.12534081,
  ];

  static const List<double> _venusElements = [
    181.97909950, 58517.81538729, 0.723331566, 0.00677672, -0.000047766,
    3.39467605, -0.0008568, 131.60246718, 0.00268329, 76.67984255, -0.27769418,
  ];

  static double _planetLongitude(double t, List<double> el) {
    double l = _normalize(el[0] + el[1] * t);
    double a = el[2];
    double e = el[3] + el[4] * t;
    double i = (el[5] + el[6] * t) * _deg2rad;
    double omega = _normalize(el[7] + el[8] * t) * _deg2rad;
    double node = _normalize(el[9] + el[10] * t) * _deg2rad;

    double m = _normalize(l - el[7] - el[8] * t) * _deg2rad;

    double bigE = m;
    for (int j = 0; j < 15; j++) {
      double dE = (m - bigE + e * sin(bigE)) / (1 - e * cos(bigE));
      bigE += dE;
      if (dE.abs() < 1e-12) break;
    }

    double nu = 2 * atan2(sqrt(1 + e) * sin(bigE / 2), sqrt(1 - e) * cos(bigE / 2));
    double r = a * (1 - e * cos(bigE));

    double u = omega - node + nu;
    double xEcl = r * (cos(node) * cos(u) - sin(node) * sin(u) * cos(i));
    double yEcl = r * (sin(node) * cos(u) + cos(node) * sin(u) * cos(i));

    double sunTrop = _sunGeocentricLongitude(t);
    double sunDist = 1.00014 - 0.01671 * cos(_normalize(357.52911 + 35999.05029 * t) * _deg2rad);
    double xEarth = -sunDist * cos(sunTrop * _deg2rad);
    double yEarth = -sunDist * sin(sunTrop * _deg2rad);

    double xGeo = xEcl - xEarth;
    double yGeo = yEcl - yEarth;

    return _normalize(atan2(yGeo, xGeo) * _rad2deg);
  }

  // ══════════════════════════════════════════════════════════════════
  // RAHU (Mean Node)
  // ══════════════════════════════════════════════════════════════════
  static double _meanNorthNode(double t) {
    return _normalize(125.0445479 - 1934.1362891 * t
        + 0.0020754 * t * t + t * t * t / 467441 - t * t * t * t / 60616000);
  }

  // ══════════════════════════════════════════════════════════════════
  // ASCENDANT (LAGNA)
  // ══════════════════════════════════════════════════════════════════
  static double _calculateAscendant(double lst, double latitude, double t) {
    double lstRad = lst * _deg2rad;
    double latRad = latitude * _deg2rad;
    double eps = (23.4392911 - 0.0130042 * t - 0.00000016 * t * t) * _deg2rad;

    double y = cos(lstRad);
    double x = -sin(lstRad) * cos(eps) - tan(latRad) * sin(eps);

    return _normalize(atan2(y, x) * _rad2deg);
  }
}
