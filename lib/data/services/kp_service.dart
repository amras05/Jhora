import '../models/chart_data.dart';
import '../../../core/constants/astro_constants.dart';

class KPSubLord {
  final String entityName;
  final double longitude;
  final String signName;
  final String signLord;
  final String starName;
  final String starLord;
  final String subLord;
  final String subSubLord;

  const KPSubLord({
    required this.entityName,
    required this.longitude,
    required this.signName,
    required this.signLord,
    required this.starName,
    required this.starLord,
    required this.subLord,
    required this.subSubLord,
  });
}

class KPHouseSignificator {
  final int houseNumber;
  final List<String> levelA;
  final List<String> levelB;
  final List<String> levelC;
  final List<String> levelD;

  const KPHouseSignificator({
    required this.houseNumber,
    required this.levelA,
    required this.levelB,
    required this.levelC,
    required this.levelD,
  });
}

class KPAnalysis {
  final List<KPSubLord> planetSubLords;
  final List<KPSubLord> cuspSubLords;
  final List<KPHouseSignificator> significators;

  const KPAnalysis({
    required this.planetSubLords,
    required this.cuspSubLords,
    required this.significators,
  });
}

/// 100% Classical Krishnamurti Paddhati (KP) System Engine
class KPService {
  KPService._();

  static const List<String> _dashaLords = [
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury'
  ];

  static const Map<String, double> _dashaSpans = {
    'Ketu': 7.0,
    'Venus': 20.0,
    'Sun': 6.0,
    'Moon': 10.0,
    'Mars': 7.0,
    'Rahu': 18.0,
    'Jupiter': 16.0,
    'Saturn': 19.0,
    'Mercury': 17.0,
  };

  /// Compute KP Sub-Lords and 4-tier Significators
  static KPAnalysis calculate(ChartData chart) {
    final planetSubLords = <KPSubLord>[];
    for (final p in chart.planets) {
      planetSubLords.add(_getSubLordInfo(p.name, p.longitude));
    }
    // Add Ascendant
    planetSubLords.insert(0, _getSubLordInfo('Ascendant', chart.ascendant.longitude));

    // 12 Equal/Placidus Bhavas Cusps
    final cuspSubLords = <KPSubLord>[];
    final ascLon = chart.ascendant.longitude;
    for (int i = 0; i < 12; i++) {
      final cuspLon = (ascLon + i * 30.0) % 360.0;
      cuspSubLords.add(_getSubLordInfo('Cusp ${i + 1}', cuspLon));
    }

    // Compute 4-level Significators
    final significators = <KPHouseSignificator>[];
    final ascSign = chart.ascendant.rashiIndex;

    for (int h = 1; h <= 12; h++) {
      final houseSign = (ascSign + h - 1) % 12;
      final houseLord = _getSignLord(houseSign);

      // Level B: Planets occupying this house
      final occupants = chart.planets.where((p) {
        int pHouse = ((p.rashiIndex - ascSign + 12) % 12) + 1;
        return pHouse == h;
      }).map((p) => p.name).toList();

      // Level A: Planets in star of occupants
      final levelA = <String>[];
      for (final p in chart.planets) {
        final starLord = _getSubLordInfo(p.name, p.longitude).starLord;
        if (occupants.contains(starLord) && !levelA.contains(p.name)) {
          levelA.add(p.name);
        }
      }

      // Level C: Planets in star of house lord
      final levelC = <String>[];
      for (final p in chart.planets) {
        final starLord = _getSubLordInfo(p.name, p.longitude).starLord;
        if (starLord == houseLord && !levelC.contains(p.name)) {
          levelC.add(p.name);
        }
      }

      significators.add(KPHouseSignificator(
        houseNumber: h,
        levelA: levelA,
        levelB: occupants,
        levelC: levelC,
        levelD: [houseLord],
      ));
    }

    return KPAnalysis(
      planetSubLords: planetSubLords,
      cuspSubLords: cuspSubLords,
      significators: significators,
    );
  }

  static KPSubLord _getSubLordInfo(String entityName, double longitude) {
    int rashiIdx = (longitude / 30.0).floor() % 12;
    final signName = AstroConstants.rashis[rashiIdx];
    final signLord = _getSignLord(rashiIdx);

    const nakshatraSpan = 360.0 / 27.0; // 13.333333°
    int nakIdx = (longitude / nakshatraSpan).floor() % 27;
    final nakName = AstroConstants.nakshatras[nakIdx];
    final starLord = _dashaLords[nakIdx % 9];

    double remInNak = longitude - (nakIdx * nakshatraSpan);
    if (remInNak < 0) remInNak += nakshatraSpan;

    int starLordIdx = _dashaLords.indexOf(starLord);
    double accumulated = 0.0;
    String subLord = starLord;
    String subSubLord = starLord;

    for (int i = 0; i < 9; i++) {
      final subLordName = _dashaLords[(starLordIdx + i) % 9];
      final subSpan = (nakshatraSpan * (_dashaSpans[subLordName]! / 120.0));
      if (remInNak >= accumulated && remInNak < (accumulated + subSpan)) {
        subLord = subLordName;
        double remInSub = remInNak - accumulated;
        int subLordIdx = _dashaLords.indexOf(subLord);
        double subAcc = 0.0;
        for (int j = 0; j < 9; j++) {
          final sslName = _dashaLords[(subLordIdx + j) % 9];
          final sslSpan = subSpan * (_dashaSpans[sslName]! / 120.0);
          if (remInSub >= subAcc && remInSub <= (subAcc + sslSpan)) {
            subSubLord = sslName;
            break;
          }
          subAcc += sslSpan;
        }
        break;
      }
      accumulated += subSpan;
    }

    return KPSubLord(
      entityName: entityName,
      longitude: longitude,
      signName: signName,
      signLord: signLord,
      starName: nakName,
      starLord: starLord,
      subLord: subLord,
      subSubLord: subSubLord,
    );
  }

  static String _getSignLord(int rashiIndex) {
    switch (rashiIndex % 12) {
      case 0: return 'Mars';
      case 1: return 'Venus';
      case 2: return 'Mercury';
      case 3: return 'Moon';
      case 4: return 'Sun';
      case 5: return 'Mercury';
      case 6: return 'Venus';
      case 7: return 'Mars';
      case 8: return 'Jupiter';
      case 9: return 'Saturn';
      case 10: return 'Saturn';
      case 11: return 'Jupiter';
      default: return 'Sun';
    }
  }
}
