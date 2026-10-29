import 'dart:math';
import '../../core/constants/astro_constants.dart';
import '../models/birth_data.dart';
import '../models/panchanga_data.dart';
import 'astro_engine.dart';

/// Calculates complete Vedic Panchanga (5 limbs) + Muhurthas with high-precision solar algorithms.
class PanchangaService {
  PanchangaService._();

  static const List<String> tithis = [
    'Pratipada', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami',
    'Shashthi', 'Saptami', 'Ashtami', 'Navami', 'Dashami',
    'Ekadashi', 'Dwadashi', 'Trayodashi', 'Chaturdashi', 'Purnima',
    'Pratipada', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami',
    'Shashthi', 'Saptami', 'Ashtami', 'Navami', 'Dashami',
    'Ekadashi', 'Dwadashi', 'Trayodashi', 'Chaturdashi', 'Amavasya',
  ];

  static const List<String> yogas = [
    'Vishkambha', 'Priti', 'Ayushman', 'Saubhagya', 'Shobhana',
    'Atiganda', 'Sukarma', 'Dhriti', 'Shoola', 'Ganda',
    'Vriddhi', 'Dhruva', 'Vyaghata', 'Harshana', 'Vajra',
    'Siddhi', 'Vyatipata', 'Variyan', 'Parigha', 'Shiva',
    'Siddha', 'Sadhya', 'Shubha', 'Shukla', 'Brahma',
    'Indra', 'Vaidhriti'
  ];

  static const List<String> weekdays = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  // 1-based part of day (1 to 8) for Rahu, Yama, Gulika [Sunday=0 ... Saturday=6]
  static const List<int> _rahuParts = [8, 2, 7, 5, 6, 4, 3];
  static const List<int> _yamaParts = [5, 4, 3, 2, 1, 7, 6];
  static const List<int> _gulikaParts = [7, 6, 5, 4, 3, 2, 1];

  /// Calculate full daily Panchanga for the specified date and place coordinates.
  static PanchangaData calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    required double timezone,
    required String placeName,
  }) {
    // Calculate chart at midday for planetary longitudes
    final chart = AstroEngine.calculateChart(BirthData(
      name: 'Panchanga',
      dateTime: DateTime(date.year, date.month, date.day, 12, 0),
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
      placeName: placeName,
    ));

    final sun = chart.getPlanet('Sun')!;
    final moon = chart.getPlanet('Moon')!;

    final sunLon = sun.longitude % 360.0;
    final moonLon = moon.longitude % 360.0;

    // 1. Tithi (Difference between Moon and Sun in 12° increments)
    final diff = _normalize(moonLon - sunLon);
    final tithiIdx = (diff / 12.0).floor().clamp(0, 29);
    final tithiProgress = ((diff % 12.0) / 12.0) * 100.0;
    final paksha = tithiIdx < 15 ? 'Shukla Paksha' : 'Krishna Paksha';

    // 2. Vara (Weekday)
    final weekdayIdx = date.weekday % 7; // DateTime weekday is 1=Mon..7=Sun -> 0=Sun..6=Sat
    final varaName = weekdays[weekdayIdx];

    // 3. Nakshatra & Pada
    final nakIdx = moon.nakshatraIndex;
    final nakPada = moon.pada;

    // 4. Yoga (Sum of Sun and Moon in 13°20' increments)
    final sum = _normalize(sunLon + moonLon);
    final yogaIdx = (sum / (360.0 / 27.0)).floor().clamp(0, 26);

    // 5. Karana (Half of a Tithi = 6° increments)
    final karanaIdx = (diff / 6.0).floor().clamp(0, 59);

    // 6. Solar Times (Sunrise & Sunset)
    final (sunrise, sunset) = _calculateSunriseSunset(date, latitude, longitude, timezone);

    // 7. Muhurthams & Kaala
    final rahuKalam = _getOctantPeriod(sunrise, sunset, _rahuParts[weekdayIdx]);
    final yamagandam = _getOctantPeriod(sunrise, sunset, _yamaParts[weekdayIdx]);
    final gulikaKalam = _getOctantPeriod(sunrise, sunset, _gulikaParts[weekdayIdx]);

    // Abhijit Muhurtha (8th of 15 muhurthas in daytime)
    final dayDuration = sunset.difference(sunrise);
    final muhurthaDur = Duration(microseconds: (dayDuration.inMicroseconds / 15).round());
    final abhijitStart = sunrise.add(muhurthaDur * 7);
    final abhijitEnd = sunrise.add(muhurthaDur * 8);

    // Brahma Muhurtha (96 min to 48 min before sunrise)
    final brahmaStart = sunrise.subtract(const Duration(minutes: 96));
    final brahmaEnd = sunrise.subtract(const Duration(minutes: 48));

    return PanchangaData(
      date: date,
      placeName: placeName,
      vara: varaName,
      varaIndex: weekdayIdx,
      tithi: tithis[tithiIdx],
      tithiIndex: tithiIdx,
      paksha: paksha,
      tithiProgress: tithiProgress,
      nakshatra: AstroConstants.nakshatras[nakIdx],
      nakshatraIndex: nakIdx,
      nakshatraPada: nakPada,
      yoga: yogas[yogaIdx],
      yogaIndex: yogaIdx,
      karana: _getKaranaName(karanaIdx),
      karanaIndex: karanaIdx,
      sunSign: sun.rashi,
      moonSign: moon.rashi,
      sunrise: sunrise,
      sunset: sunset,
      rahuKalam: rahuKalam,
      yamagandam: yamagandam,
      gulikaKalam: gulikaKalam,
      abhijitMuhurtham: (abhijitStart, abhijitEnd),
      brahmaMuhurtham: (brahmaStart, brahmaEnd),
    );
  }

  static (DateTime, DateTime) _getOctantPeriod(DateTime sunrise, DateTime sunset, int part1Based) {
    final dayDuration = sunset.difference(sunrise);
    final octant = Duration(microseconds: (dayDuration.inMicroseconds / 8).round());
    final start = sunrise.add(octant * (part1Based - 1));
    final end = start.add(octant);
    return (start, end);
  }

  static (DateTime, DateTime) _calculateSunriseSunset(
    DateTime date,
    double latitude,
    double longitude,
    double timezone,
  ) {
    int y = date.year;
    int m = date.month;
    int d = date.day;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    double a = (y / 100).floorToDouble();
    double b = 2 - a + (a / 4).floorToDouble();
    double jd = (365.25 * (y + 4716)).floorToDouble() +
        (30.6001 * (m + 1)).floorToDouble() +
        d +
        b -
        1524.5;

    double t = (jd - 2451545.0) / 36525.0;

    // Geometric Mean Longitude of Sun (degrees)
    double l0 = (280.46646 + t * (36000.76983 + 0.0003032 * t)) % 360.0;
    if (l0 < 0) l0 += 360.0;

    // Geometric Mean Anomaly of Sun (degrees)
    double mSun = (357.52911 + t * (35999.05029 - 0.0001537 * t)) % 360.0;
    if (mSun < 0) mSun += 360.0;
    double mRad = mSun * pi / 180.0;

    // Eccentricity of Earth's orbit
    double e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);

    // Sun Equation of the Center
    double c = sin(mRad) * (1.914602 - t * (0.004817 + 0.000014 * t)) +
        sin(2.0 * mRad) * (0.019993 - 0.000101 * t) +
        sin(3.0 * mRad) * 0.000289;

    double sunTrueLon = l0 + c;

    // Sun Apparent Longitude (degrees)
    double omega = 125.04 - 1934.136 * t;
    double lambdaSun = sunTrueLon - 0.00569 - 0.00478 * sin(omega * pi / 180.0);

    // Mean Obliquity of the Ecliptic (degrees)
    double obliq0 = 23.0 +
        (26.0 +
                (21.448 -
                        t *
                            (46.815 +
                                t * (0.00059 - t * 0.001813))) /
                    60.0) /
            60.0;
    double obliq = obliq0 + 0.00256 * cos(omega * pi / 180.0);

    // Sun Declination (degrees)
    double sinDec = sin(obliq * pi / 180.0) * sin(lambdaSun * pi / 180.0);
    double declination = asin(sinDec) * 180.0 / pi;

    // Equation of Time (minutes)
    double yVar = tan((obliq / 2.0) * pi / 180.0);
    yVar = yVar * yVar;

    double l0Rad = l0 * pi / 180.0;
    double eot = 4.0 *
        (180.0 / pi) *
        (yVar * sin(2.0 * l0Rad) -
            2.0 * e * sin(mRad) +
            4.0 * e * yVar * sin(mRad) * cos(2.0 * l0Rad) -
            0.5 * (yVar * yVar) * sin(4.0 * l0Rad) -
            1.25 * (e * e) * sin(2.0 * mRad));

    // Zenith angle for sunrise/sunset: 90°50' = 90.8333°
    // Standard astronomical atmospheric refraction (34') + solar semi-diameter (16')
    const double zenith = 90.8333;
    double latRad = latitude * pi / 180.0;
    double decRad = declination * pi / 180.0;

    double cosHa = (cos(zenith * pi / 180.0) - sin(latRad) * sin(decRad)) /
        (cos(latRad) * cos(decRad));

    // Clamp for extreme latitudes
    cosHa = cosHa.clamp(-1.0, 1.0);
    double haDeg = acos(cosHa) * 180.0 / pi;

    // Local apparent solar noon in minutes from midnight local time
    double solarNoonMin = 720.0 - (4.0 * longitude) - eot + (timezone * 60.0);
    double haMin = haDeg * 4.0;

    double sunriseMin = solarNoonMin - haMin;
    double sunsetMin = solarNoonMin + haMin;

    DateTime minToDateTime(double totalMinutes) {
      while (totalMinutes < 0) {
        totalMinutes += 1440;
      }
      while (totalMinutes >= 1440) {
        totalMinutes -= 1440;
      }

      int hour = (totalMinutes / 60).floor();
      int minute = (totalMinutes % 60).round();
      if (minute >= 60) {
        hour += 1;
        minute = 0;
      }
      hour = hour % 24;
      return DateTime(date.year, date.month, date.day, hour, minute);
    }

    return (
      minToDateTime(sunriseMin),
      minToDateTime(sunsetMin),
    );
  }

  static String _getKaranaName(int index) {
    const repeating = [
      'Bava', 'Balava', 'Kaulava', 'Taitila', 'Gara', 'Vanija', 'Vishti'
    ];
    if (index == 0) return 'Kimstughna';
    if (index >= 57) {
      return const ['Shakuni', 'Chatushpada', 'Naga'][index - 57];
    }
    return repeating[(index - 1) % repeating.length];
  }

  static double _normalize(double value) => (value % 360.0 + 360.0) % 360.0;
}
