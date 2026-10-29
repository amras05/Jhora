import '../../core/constants/astro_constants.dart';

/// Represents a planet's position in a Vedic horoscope.
class PlanetPosition {
  final String name;
  final double longitude;      // Sidereal longitude (0-360)
  final double latitude;       // Celestial latitude
  final double speed;          // Daily motion in degrees
  final bool isRetrograde;

  // Optional pre-computed divisional chart indexes
  final int? precomputedNavamsa;
  final int? precomputedDasamsa;
  final int? precomputedSaptamsa;
  final int? precomputedDrekkana;
  final int? precomputedDvadasamsa;

  const PlanetPosition({
    required this.name,
    required this.longitude,
    this.latitude = 0,
    this.speed = 0,
    this.isRetrograde = false,
    this.precomputedNavamsa,
    this.precomputedDasamsa,
    this.precomputedSaptamsa,
    this.precomputedDrekkana,
    this.precomputedDvadasamsa,
  });

  /// Rashi index (0-11, where 0=Aries/Mesha, 1=Taurus/Vrishabha, ... 11=Pisces/Meena)
  int get rashiIndex => ((longitude % 360.0) / 30.0).floor().clamp(0, 11);

  /// Rashi name (English)
  String get rashi => AstroConstants.rashis[rashiIndex];

  /// Rashi Sanskrit name
  String get rashiSanskrit => AstroConstants.rashisSanskrit[rashiIndex];

  /// Degrees within the rashi (0-30)
  double get degreesInRashi => longitude % 30.0;

  /// DMS string (degrees, minutes, seconds) within the rashi
  String get dmsInRashi {
    double deg = degreesInRashi;
    int d = deg.floor();
    double minTotal = (deg - d) * 60.0;
    int m = minTotal.floor();
    int s = ((minTotal - m) * 60.0).round();
    if (s >= 60) {
      s = 0;
      m += 1;
    }
    if (m >= 60) {
      m = 0;
      d += 1;
    }
    return '$d°${m.toString().padLeft(2, '0')}\'${s.toString().padLeft(2, '0')}"';
  }

  /// Short degree format e.g. "12°48'"
  String get shortDegInRashi {
    double deg = degreesInRashi;
    int d = deg.floor();
    int m = ((deg - d) * 60.0).round();
    if (m >= 60) {
      m = 0;
      d += 1;
    }
    return '$d°${m.toString().padLeft(2, '0')}\'';
  }

  /// Full position string like "15°23'45" Aries"
  String get fullPosition => '$dmsInRashi $rashi';

  /// Nakshatra index (0-26)
  int get nakshatraIndex => ((longitude % 360.0) / AstroConstants.nakshatraSpan).floor().clamp(0, 26);

  /// Nakshatra name
  String get nakshatra => AstroConstants.nakshatras[nakshatraIndex];

  /// Nakshatra lord
  String get nakshatraLord => AstroConstants.nakshatraLords[nakshatraIndex];

  /// Pada (1-4) within the nakshatra
  int get pada {
    double posInNak = (longitude % 360.0) % AstroConstants.nakshatraSpan;
    return (posInNak / AstroConstants.padaSpan).floor().clamp(0, 3) + 1;
  }

  /// Navamsa (D9) rashi index (0-11)
  int get navamsaRashiIndex {
    if (precomputedNavamsa != null) return precomputedNavamsa!;
    int totalPada = (((longitude % 360.0) / AstroConstants.padaSpan).floor()) % 108;
    return totalPada % 12;
  }

  /// Navamsa rashi name
  String get navamsaRashi => AstroConstants.rashis[navamsaRashiIndex];

  /// Dasamsa (D10) rashi index (0-11)
  int get dasamsaRashiIndex {
    if (precomputedDasamsa != null) return precomputedDasamsa!;
    int r = rashiIndex;
    int part = (degreesInRashi / 3.0).floor().clamp(0, 9);
    if (r % 2 == 0) {
      return (r + part) % 12;
    } else {
      return ((r + 8) + part) % 12;
    }
  }

  /// Saptamsa (D7) rashi index (0-11)
  int get saptamsaRashiIndex {
    if (precomputedSaptamsa != null) return precomputedSaptamsa!;
    int r = rashiIndex;
    int part = (degreesInRashi / (30.0 / 7.0)).floor().clamp(0, 6);
    if (r % 2 == 0) {
      return (r + part) % 12;
    } else {
      return ((r + 6) + part) % 12;
    }
  }

  /// Drekkana (D3) rashi index (0-11)
  int get drekkanaRashiIndex {
    if (precomputedDrekkana != null) return precomputedDrekkana!;
    int r = rashiIndex;
    int part = (degreesInRashi / 10.0).floor().clamp(0, 2);
    if (part == 0) return r;
    if (part == 1) return (r + 4) % 12;
    return (r + 8) % 12;
  }

  /// Dvadasamsa (D12) rashi index (0-11)
  int get dvadasamsaRashiIndex {
    if (precomputedDvadasamsa != null) return precomputedDvadasamsa!;
    int r = rashiIndex;
    int part = (degreesInRashi / 2.5).floor().clamp(0, 11);
    return (r + part) % 12;
  }

  /// Get English abbreviation for chart display
  String get abbreviation => AstroConstants.planetAbbr[name] ?? name.substring(0, 2);

  /// Display string with retrograde marker
  String get displayAbbr => isRetrograde ? '$abbreviation(R)' : abbreviation;

  /// Planet dignity in current rashi
  String get dignity {
    if (AstroConstants.exaltation[name] == rashiIndex) return 'Exalted';
    if (AstroConstants.debilitation[name] == rashiIndex) return 'Debilitated';
    if (AstroConstants.ownSigns[name]?.contains(rashiIndex) ?? false) return 'Own Sign';

    String rashiLord = AstroConstants.rashiLords[rashiIndex];
    if (rashiLord == name) return 'Own Sign';
    if (AstroConstants.friends[name]?.contains(rashiLord) ?? false) return 'Friendly';
    if (AstroConstants.enemies[name]?.contains(rashiLord) ?? false) return 'Enemy';

    return 'Neutral';
  }

  factory PlanetPosition.fromJson(Map<String, dynamic> json) => PlanetPosition(
    name: json['name'] as String,
    longitude: (json['longitude'] as num).toDouble(),
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    isRetrograde: json['isRetrograde'] as bool? ?? false,
    precomputedNavamsa: json['navamsaRashiIndex'] as int?,
    precomputedDasamsa: json['dasamsaRashiIndex'] as int?,
    precomputedSaptamsa: json['saptamsaRashiIndex'] as int?,
    precomputedDrekkana: json['drekkanaRashiIndex'] as int?,
    precomputedDvadasamsa: json['dvadasamsaRashiIndex'] as int?,
  );

  @override
  String toString() => '$name: $fullPosition (Nak: $nakshatra P$pada) ${isRetrograde ? "(R)" : ""}';
}
