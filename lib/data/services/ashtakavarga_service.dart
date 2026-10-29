import '../models/chart_data.dart';

/// Represents a single planet's Bhinnashtakavarga (BAV) or Sarvashtakavarga (SAV)
class AshtakavargaData {
  /// 8 Bhinnashtakavargas (Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn, Lagna)
  /// Map of PlanetName to List of 12 signs (Aries=0 to Pisces=11)
  final Map<String, List<int>> bav;

  /// Sarvashtakavarga: Sum of all 7 planets' BAV for each of the 12 signs (Total = 337)
  final List<int> sav;

  const AshtakavargaData({
    required this.bav,
    required this.sav,
  });

  int get totalSAV => sav.fold(0, (sum, val) => sum + val);

  bool isSignAuspicious(int signIndex) => sav[signIndex % 12] >= 28;
}

/// 100% Classical Parashara Ashtakavarga Calculation Engine
class AshtakavargaService {
  AshtakavargaService._();

  static const Map<String, List<int>> _sunRules = {
    'Sun': [1, 2, 4, 7, 8, 9, 10, 11],
    'Moon': [3, 6, 10, 11],
    'Mars': [1, 2, 4, 7, 8, 9, 10, 11],
    'Mercury': [3, 5, 6, 9, 10, 11, 12],
    'Jupiter': [5, 6, 9, 11],
    'Venus': [6, 7, 12],
    'Saturn': [1, 2, 4, 7, 8, 9, 10, 11],
    'Ascendant': [3, 4, 6, 10, 11, 12],
  };

  static const Map<String, List<int>> _moonRules = {
    'Sun': [3, 6, 7, 8, 10, 11],
    'Moon': [1, 3, 6, 7, 10, 11],
    'Mars': [2, 3, 5, 6, 9, 10, 11],
    'Mercury': [1, 3, 4, 5, 7, 8, 10, 11],
    'Jupiter': [1, 4, 7, 8, 10, 11, 12],
    'Venus': [3, 4, 5, 7, 9, 10, 11],
    'Saturn': [3, 5, 6, 11],
    'Ascendant': [3, 6, 10, 11],
  };

  static const Map<String, List<int>> _marsRules = {
    'Sun': [3, 5, 6, 10, 11],
    'Moon': [3, 6, 11],
    'Mars': [1, 2, 4, 7, 8, 10, 11],
    'Mercury': [3, 5, 6, 11],
    'Jupiter': [6, 10, 11, 12],
    'Venus': [6, 8, 11, 12],
    'Saturn': [1, 4, 7, 8, 9, 10, 11],
    'Ascendant': [1, 3, 6, 10, 11],
  };

  static const Map<String, List<int>> _mercuryRules = {
    'Sun': [5, 6, 9, 11, 12],
    'Moon': [2, 4, 6, 8, 10, 11],
    'Mars': [1, 2, 4, 7, 8, 9, 10, 11],
    'Mercury': [1, 3, 5, 6, 9, 10, 11, 12],
    'Jupiter': [6, 8, 11, 12],
    'Venus': [1, 2, 3, 4, 5, 8, 9, 11],
    'Saturn': [1, 2, 4, 7, 8, 9, 10, 11],
    'Ascendant': [1, 2, 4, 6, 8, 10, 11],
  };

  static const Map<String, List<int>> _jupiterRules = {
    'Sun': [1, 2, 3, 4, 7, 8, 9, 10, 11],
    'Moon': [2, 5, 7, 9, 11],
    'Mars': [1, 2, 4, 7, 8, 10, 11],
    'Mercury': [1, 2, 4, 5, 6, 9, 10, 11],
    'Jupiter': [1, 2, 3, 4, 7, 8, 10, 11],
    'Venus': [2, 5, 6, 9, 10, 11],
    'Saturn': [3, 5, 6, 12],
    'Ascendant': [1, 2, 4, 5, 6, 7, 9, 10, 11],
  };

  static const Map<String, List<int>> _venusRules = {
    'Sun': [8, 11, 12],
    'Moon': [1, 2, 3, 4, 5, 8, 9, 11, 12],
    'Mars': [3, 5, 6, 9, 11, 12],
    'Mercury': [3, 5, 6, 9, 11],
    'Jupiter': [5, 8, 9, 10, 11],
    'Venus': [1, 2, 3, 4, 5, 8, 9, 10, 11],
    'Saturn': [3, 4, 5, 8, 9, 10, 11],
    'Ascendant': [1, 2, 3, 4, 5, 8, 9, 11],
  };

  static const Map<String, List<int>> _saturnRules = {
    'Sun': [1, 2, 4, 7, 8, 10, 11],
    'Moon': [3, 6, 11],
    'Mars': [3, 5, 6, 10, 11, 12],
    'Mercury': [6, 8, 9, 10, 11, 12],
    'Jupiter': [5, 6, 11, 12],
    'Venus': [6, 11, 12],
    'Saturn': [3, 5, 6, 11],
    'Ascendant': [1, 3, 4, 6, 10, 11],
  };

  static AshtakavargaData calculate(ChartData chart) {
    final planetSigns = <String, int>{};
    for (final p in chart.planets) {
      planetSigns[p.name] = p.rashiIndex;
    }
    planetSigns['Ascendant'] = chart.ascendant.rashiIndex;

    final bav = <String, List<int>>{};

    bav['Sun'] = _computeBAV(_sunRules, planetSigns);
    bav['Moon'] = _computeBAV(_moonRules, planetSigns);
    bav['Mars'] = _computeBAV(_marsRules, planetSigns);
    bav['Mercury'] = _computeBAV(_mercuryRules, planetSigns);
    bav['Jupiter'] = _computeBAV(_jupiterRules, planetSigns);
    bav['Venus'] = _computeBAV(_venusRules, planetSigns);
    bav['Saturn'] = _computeBAV(_saturnRules, planetSigns);

    final sav = List<int>.filled(12, 0);
    for (int sign = 0; sign < 12; sign++) {
      int sum = 0;
      for (final planet in ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn']) {
        sum += bav[planet]![sign];
      }
      sav[sign] = sum;
    }

    return AshtakavargaData(bav: bav, sav: sav);
  }

  static List<int> _computeBAV(Map<String, List<int>> rules, Map<String, int> planetSigns) {
    final result = List<int>.filled(12, 0);

    rules.forEach((contributor, houses) {
      final baseSign = planetSigns[contributor];
      if (baseSign != null) {
        for (final house in houses) {
          final targetSign = (baseSign + (house - 1)) % 12;
          result[targetSign] += 1;
        }
      }
    });

    return result;
  }
}
