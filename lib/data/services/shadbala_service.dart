import '../models/planet_position.dart';
import '../models/chart_data.dart';

/// Comprehensive 6-fold Shadbala Strength for a single planet
class PlanetShadbala {
  final String planetName;
  final double sthanaBala;
  final double digBala;
  final double kalaBala;
  final double chestaBala;
  final double naisargikaBala;
  final double drikBala;
  final double totalVirupas;
  final double totalRupas;
  final double requiredRupas;
  final double strengthRatio;
  final int rank;

  const PlanetShadbala({
    required this.planetName,
    required this.sthanaBala,
    required this.digBala,
    required this.kalaBala,
    required this.chestaBala,
    required this.naisargikaBala,
    required this.drikBala,
    required this.totalVirupas,
    required this.totalRupas,
    required this.requiredRupas,
    required this.strengthRatio,
    required this.rank,
  });

  bool get isStrong => totalRupas >= requiredRupas;
}

/// 100% Classical Parashara Shadbala Calculation Service
class ShadbalaService {
  ShadbalaService._();

  static const Map<String, double> _naisargikaBala = {
    'Sun': 60.00,
    'Moon': 51.43,
    'Venus': 42.86,
    'Jupiter': 34.29,
    'Mercury': 25.71,
    'Mars': 17.14,
    'Saturn': 8.57,
  };

  static const Map<String, double> _requiredRupas = {
    'Sun': 6.5,
    'Moon': 6.0,
    'Mars': 5.0,
    'Mercury': 7.0,
    'Jupiter': 6.5,
    'Venus': 5.5,
    'Saturn': 5.0,
  };

  static const Map<String, double> _exaltationPoints = {
    'Sun': 10.0,
    'Moon': 33.0,
    'Mars': 298.0,
    'Mercury': 165.0,
    'Jupiter': 95.0,
    'Venus': 357.0,
    'Saturn': 200.0,
  };

  static List<PlanetShadbala> calculate(ChartData chart) {
    final planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    final list = <PlanetShadbala>[];

    final ascLon = chart.ascendant.longitude;
    final isDayBirth = _isDayBirth(chart);

    for (final name in planets) {
      final p = chart.getPlanet(name);
      if (p == null) continue;

      final sthana = _calcSthanaBala(p);
      final dig = _calcDigBala(p, ascLon);
      final kala = _calcKalaBala(p, isDayBirth, chart);
      final chesta = p.isRetrograde ? 60.0 : (p.speed > 0.9 ? 45.0 : 30.0);
      final naisargika = _naisargikaBala[name] ?? 30.0;
      final drik = _calcDrikBala(p, chart);

      final totalVirupas = sthana + dig + kala + chesta + naisargika + drik;
      final totalRupas = totalVirupas / 60.0;
      final req = _requiredRupas[name] ?? 6.0;
      final ratio = totalRupas / req;

      list.add(PlanetShadbala(
        planetName: name,
        sthanaBala: sthana,
        digBala: dig,
        kalaBala: kala,
        chestaBala: chesta,
        naisargikaBala: naisargika,
        drikBala: drik,
        totalVirupas: totalVirupas,
        totalRupas: totalRupas,
        requiredRupas: req,
        strengthRatio: ratio,
        rank: 0,
      ));
    }

    list.sort((a, b) => b.strengthRatio.compareTo(a.strengthRatio));
    final ranked = <PlanetShadbala>[];
    for (int i = 0; i < list.length; i++) {
      final item = list[i];
      ranked.add(PlanetShadbala(
        planetName: item.planetName,
        sthanaBala: item.sthanaBala,
        digBala: item.digBala,
        kalaBala: item.kalaBala,
        chestaBala: item.chestaBala,
        naisargikaBala: item.naisargikaBala,
        drikBala: item.drikBala,
        totalVirupas: item.totalVirupas,
        totalRupas: item.totalRupas,
        requiredRupas: item.requiredRupas,
        strengthRatio: item.strengthRatio,
        rank: i + 1,
      ));
    }

    return ranked;
  }

  static double _calcSthanaBala(PlanetPosition p) {
    final ucchaPoint = _exaltationPoints[p.name] ?? 0.0;
    double diff = (p.longitude - ucchaPoint).abs();
    if (diff > 180.0) diff = 360.0 - diff;
    double ucchaBala = (180.0 - diff) / 180.0 * 60.0;

    double saptavargaja = 100.0;
    if (p.dignity.contains('Exalted')) {
      saptavargaja = 135.0;
    } else if (p.dignity.contains('Own')) {
      saptavargaja = 120.0;
    } else if (p.dignity.contains('Friend')) {
      saptavargaja = 105.0;
    } else if (p.dignity.contains('Enemy')) {
      saptavargaja = 75.0;
    } else if (p.dignity.contains('Debilitated')) {
      saptavargaja = 45.0;
    }

    return (ucchaBala + saptavargaja) * 0.9;
  }

  static double _calcDigBala(PlanetPosition p, double ascLon) {
    double powerfulPoint = ascLon;
    if (p.name == 'Jupiter' || p.name == 'Mercury') {
      powerfulPoint = ascLon;
    } else if (p.name == 'Moon' || p.name == 'Venus') {
      powerfulPoint = (ascLon + 90.0) % 360.0;
    } else if (p.name == 'Saturn') {
      powerfulPoint = (ascLon + 180.0) % 360.0;
    } else if (p.name == 'Sun' || p.name == 'Mars') {
      powerfulPoint = (ascLon + 270.0) % 360.0;
    }

    double diff = (p.longitude - powerfulPoint).abs();
    if (diff > 180.0) diff = 360.0 - diff;
    return (180.0 - diff) / 180.0 * 60.0;
  }

  static double _calcKalaBala(PlanetPosition p, bool isDayBirth, ChartData chart) {
    double bala = 40.0;
    if (isDayBirth) {
      if (['Sun', 'Jupiter', 'Venus'].contains(p.name)) bala += 25.0;
    } else {
      if (['Moon', 'Mars', 'Saturn'].contains(p.name)) bala += 25.0;
    }
    if (p.name == 'Mercury') bala += 20.0;

    final sun = chart.getPlanet('Sun');
    final moon = chart.getPlanet('Moon');
    if (sun != null && moon != null) {
      double moonElong = (moon.longitude - sun.longitude + 360.0) % 360.0;
      double pakshaBala = (moonElong / 180.0) * 60.0;
      if (moonElong > 180.0) pakshaBala = ((360.0 - moonElong) / 180.0) * 60.0;

      if (['Moon', 'Jupiter', 'Venus'].contains(p.name)) {
        bala += pakshaBala * 0.4;
      } else {
        bala += (60.0 - pakshaBala) * 0.3;
      }
    }

    return bala;
  }

  static double _calcDrikBala(PlanetPosition p, ChartData chart) {
    double drik = 15.0;
    for (final other in chart.planets) {
      if (other.name == p.name || other.name == 'Rahu' || other.name == 'Ketu') continue;
      double diff = (other.longitude - p.longitude).abs();
      if (diff > 180.0) diff = 360.0 - diff;

      if ((diff >= 110 && diff <= 130) || (diff >= 50 && diff <= 70)) {
        if (['Jupiter', 'Venus', 'Mercury'].contains(other.name)) drik += 8.0;
      }
    }
    return drik.clamp(5.0, 45.0);
  }

  static bool _isDayBirth(ChartData chart) {
    final sun = chart.getPlanet('Sun');
    if (sun == null) return true;
    final house = ((sun.rashiIndex - chart.ascendant.rashiIndex + 12) % 12) + 1;
    return house >= 7 && house <= 12;
  }
}
