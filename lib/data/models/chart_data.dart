import 'birth_data.dart';
import 'planet_position.dart';
import '../services/dasha_service.dart';

/// Complete horoscope chart data with all planetary positions and divisional charts.
class ChartData {
  final BirthData birthData;
  final PlanetPosition ascendant;
  final List<PlanetPosition> planets;
  final double ayanamsa;
  final List<DashaPeriod>? precomputedDashas;

  const ChartData({
    required this.birthData,
    required this.ascendant,
    required this.planets,
    required this.ayanamsa,
    this.precomputedDashas,
  });

  /// Ascendant (Lagna) rashi index (D1)
  int get lagnaRashi => ascendant.rashiIndex;

  /// Get planet by name
  PlanetPosition? getPlanet(String name) {
    try {
      return planets.firstWhere((p) => p.name == name);
    } catch (_) {
      return null;
    }
  }

  /// Get all bodies (Ascendant + planets) in a specific D1 rashi (by index 0-11)
  List<PlanetPosition> planetsInRashi(int rashiIndex) {
    List<PlanetPosition> result = planets.where((p) => p.rashiIndex == rashiIndex).toList();
    if (ascendant.rashiIndex == rashiIndex) {
      result.insert(0, ascendant);
    }
    return result;
  }

  /// Rasi (D1) chart — planets grouped by rashi index 0-11
  Map<int, List<PlanetPosition>> get planetsByRashi {
    Map<int, List<PlanetPosition>> map = {};
    for (int i = 0; i < 12; i++) {
      map[i] = planetsInRashi(i);
    }
    return map;
  }

  /// Navamsa (D9) chart — planets placed by their navamsa rashi
  Map<int, List<PlanetPosition>> get navamsaPlanetsByRashi {
    Map<int, List<PlanetPosition>> map = {};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }
    map[ascendant.navamsaRashiIndex]!.add(ascendant);
    for (var p in planets) {
      map[p.navamsaRashiIndex]!.add(p);
    }
    return map;
  }

  /// Dasamsa (D10) chart — Career / Profession
  Map<int, List<PlanetPosition>> get dasamsaPlanetsByRashi {
    Map<int, List<PlanetPosition>> map = {};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }
    map[ascendant.dasamsaRashiIndex]!.add(ascendant);
    for (var p in planets) {
      map[p.dasamsaRashiIndex]!.add(p);
    }
    return map;
  }

  /// Saptamsa (D7) chart — Children / Legacy
  Map<int, List<PlanetPosition>> get saptamsaPlanetsByRashi {
    Map<int, List<PlanetPosition>> map = {};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }
    map[ascendant.saptamsaRashiIndex]!.add(ascendant);
    for (var p in planets) {
      map[p.saptamsaRashiIndex]!.add(p);
    }
    return map;
  }

  /// Drekkana (D3) chart — Siblings / Courage
  Map<int, List<PlanetPosition>> get drekkanaPlanetsByRashi {
    Map<int, List<PlanetPosition>> map = {};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }
    map[ascendant.drekkanaRashiIndex]!.add(ascendant);
    for (var p in planets) {
      map[p.drekkanaRashiIndex]!.add(p);
    }
    return map;
  }

  /// Dvadasamsa (D12) chart — Parents / Ancestry
  Map<int, List<PlanetPosition>> get dvadasamsaPlanetsByRashi {
    Map<int, List<PlanetPosition>> map = {};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }
    map[ascendant.dvadasamsaRashiIndex]!.add(ascendant);
    for (var p in planets) {
      map[p.dvadasamsaRashiIndex]!.add(p);
    }
    return map;
  }
}
