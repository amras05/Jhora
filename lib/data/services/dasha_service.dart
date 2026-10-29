import '../../core/constants/astro_constants.dart';
import '../models/planet_position.dart';

/// Represents a single Dasha period across all 5 classical Vedic levels:
/// Level 1: Maha Dasha (MD)
/// Level 2: Antar Dasha (AD / Bhukti)
/// Level 3: Pratyantar Dasha (PD)
/// Level 4: Sookshma Dasha (SD)
/// Level 5: Prana Dasha (PrD)
class DashaPeriod {
  final String planet;
  final DateTime startDate;
  final DateTime endDate;
  final double? years;
  final int level;
  List<DashaPeriod>? _subPeriods;

  DashaPeriod({
    required this.planet,
    required this.startDate,
    required this.endDate,
    this.years,
    this.level = 1,
    List<DashaPeriod>? subPeriods,
  }) : _subPeriods = subPeriods;

  /// Sub-periods for this period. Lazily generated up to Level 5 (Prana Dasha).
  List<DashaPeriod>? get subPeriods {
    if (_subPeriods != null) return _subPeriods!;
    if (level < 5) {
      _subPeriods = DashaService.generateSubPeriodsFor(this);
      return _subPeriods!;
    }
    return null;
  }

  Duration get duration => endDate.difference(startDate);

  String get durationString {
    int totalDays = duration.inDays;
    if (totalDays == 0) {
      int h = duration.inHours;
      int m = duration.inMinutes % 60;
      if (h > 0) return '${h}h ${m}m';
      int s = duration.inSeconds % 60;
      return '${m}m ${s}s';
    }
    int y = (totalDays / 365.2425).floor();
    int m = (((totalDays - y * 365.2425) / 30.4375).floor()).clamp(0, 11);
    int d = ((totalDays - y * 365.2425 - m * 30.4375).round()).clamp(0, 30);

    String result = '';
    if (y > 0) result += '${y}Y ';
    if (m > 0 || y > 0) result += '${m}M ';
    result += '${d}D';
    return result.trim();
  }

  String get levelName {
    switch (level) {
      case 1:
        return 'మహాదశ (Maha Dasha)';
      case 2:
        return 'అంతర్దశ (Antar Dasha)';
      case 3:
        return 'ప్రత్యంతర దశ (Pratyantar Dasha)';
      case 4:
        return 'సూక్ష్మ దశ (Sookshma Dasha)';
      case 5:
        return 'ప్రాణ దశ (Prana Dasha)';
      default:
        return 'దశ';
    }
  }

  String get levelAbbr {
    switch (level) {
      case 1:
        return 'MD';
      case 2:
        return 'AD';
      case 3:
        return 'PD';
      case 4:
        return 'SD';
      case 5:
        return 'PrD';
      default:
        return 'D';
    }
  }

  /// Whether a given date falls within this dasha period
  bool containsDate(DateTime date) =>
      (date.isAfter(startDate) && date.isBefore(endDate)) ||
      date.isAtSameMomentAs(startDate);

  factory DashaPeriod.fromJson(Map<String, dynamic> json) => DashaPeriod(
        planet: json['planet'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        years: (json['years'] as num?)?.toDouble(),
        level: (json['level'] as num?)?.toInt() ?? 1,
        subPeriods: (json['subPeriods'] as List<dynamic>?)
            ?.map((e) => DashaPeriod.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'planet': planet,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'years': years,
        'level': level,
        if (_subPeriods != null)
          'subPeriods': _subPeriods!.map((e) => e.toJson()).toList(),
      };
}

/// Service for computing high-precision Vimshottari Dasha system
/// down to Level 5 (Prana Dasha) matching Jagannatha Hora.
class DashaService {
  DashaService._();

  static DateTime _addYears(DateTime dt, double years) {
    return dt.add(Duration(microseconds: (years * 365.2425 * 86400 * 1000000).round()));
  }

  /// Calculate Vimshottari Maha Dashas from Moon's sidereal position.
  /// Sub-periods down to Level 5 (Prana Dasha) are accessible via [DashaPeriod.subPeriods].
  static List<DashaPeriod> calculateMahaDasha(
    PlanetPosition moon,
    DateTime birthDateTime,
  ) {
    double moonLon = moon.longitude % 360.0;
    int nakIdx = (moonLon / AstroConstants.nakshatraSpan).floor().clamp(0, 26);
    String firstLord = AstroConstants.nakshatraLords[nakIdx];

    double posInNak = moonLon - (nakIdx * AstroConstants.nakshatraSpan);
    double fractionSpent = posInNak / AstroConstants.nakshatraSpan;

    int firstLordIdx = AstroConstants.dashaSequence.indexOf(firstLord);
    double firstLordTotalYears = AstroConstants.dashaYears[firstLord]!;

    // Elapsed time before birth
    double elapsedYears = fractionSpent * firstLordTotalYears;
    DateTime nominalFirstStart = birthDateTime.subtract(
      Duration(microseconds: (elapsedYears * 365.2425 * 86400 * 1000000).round()),
    );

    List<DashaPeriod> mahaDashas = [];

    // ─── 1. First Maha Dasha (Partially elapsed at birth) ───
    DateTime firstMahaNominalEnd = _addYears(nominalFirstStart, firstLordTotalYears);
    List<DashaPeriod> firstAntars = [];
    DateTime subStart = nominalFirstStart;

    for (int k = 0; k < 9; k++) {
      String antarPlanet = AstroConstants.dashaSequence[(firstLordIdx + k) % 9];
      double antarDur = (firstLordTotalYears * AstroConstants.dashaYears[antarPlanet]!) / 120.0;
      DateTime subEnd = (k == 8) ? firstMahaNominalEnd : _addYears(subStart, antarDur);

      if (subEnd.isAfter(birthDateTime)) {
        DateTime actualSubStart = subStart.isBefore(birthDateTime) ? birthDateTime : subStart;
        double actualYears = (subEnd.difference(actualSubStart).inMicroseconds) / (365.2425 * 86400 * 1000000);

        firstAntars.add(DashaPeriod(
          planet: antarPlanet,
          startDate: actualSubStart,
          endDate: subEnd,
          years: actualYears,
          level: 2,
        ));
      }
      subStart = subEnd;
    }

    double balanceYears = firstMahaNominalEnd.difference(birthDateTime).inMicroseconds /
        (365.2425 * 86400 * 1000000);

    mahaDashas.add(DashaPeriod(
      planet: firstLord,
      startDate: birthDateTime,
      endDate: firstMahaNominalEnd,
      years: balanceYears,
      level: 1,
      subPeriods: firstAntars,
    ));

    DateTime currentStart = firstMahaNominalEnd;

    // ─── 2. Remaining 8 Maha Dashas (Full cycles) ───
    for (int i = 1; i < 9; i++) {
      String planet = AstroConstants.dashaSequence[(firstLordIdx + i) % 9];
      double durYears = AstroConstants.dashaYears[planet]!;
      DateTime mahaEnd = _addYears(currentStart, durYears);

      List<DashaPeriod> antars = [];
      DateTime subCurrent = currentStart;
      int pIdx = AstroConstants.dashaSequence.indexOf(planet);

      for (int k = 0; k < 9; k++) {
        String antarPlanet = AstroConstants.dashaSequence[(pIdx + k) % 9];
        double antarDur = (durYears * AstroConstants.dashaYears[antarPlanet]!) / 120.0;
        DateTime subEnd = (k == 8) ? mahaEnd : _addYears(subCurrent, antarDur);

        antars.add(DashaPeriod(
          planet: antarPlanet,
          startDate: subCurrent,
          endDate: subEnd,
          years: antarDur,
          level: 2,
        ));
        subCurrent = subEnd;
      }

      mahaDashas.add(DashaPeriod(
        planet: planet,
        startDate: currentStart,
        endDate: mahaEnd,
        years: durYears,
        level: 1,
        subPeriods: antars,
      ));

      currentStart = mahaEnd;
    }

    return mahaDashas;
  }

  /// Generate 9 sub-periods for any given parent DashaPeriod (up to Level 5 Prana Dasha).
  /// Sub-periods begin with the parent's ruling planet and cycle through the 9 Vimshottari planets.
  static List<DashaPeriod> generateSubPeriodsFor(DashaPeriod parent) {
    if (parent.level >= 5) return const [];
    final start = parent.startDate;
    final end = parent.endDate;
    final totalMicros = end.difference(start).inMicroseconds;
    if (totalMicros <= 0) return const [];

    final pIdx = AstroConstants.dashaSequence.indexOf(parent.planet);
    if (pIdx == -1) return const [];

    final nextLevel = parent.level + 1;
    final subs = <DashaPeriod>[];
    DateTime currStart = start;

    for (int k = 0; k < 9; k++) {
      final subPlanet = AstroConstants.dashaSequence[(pIdx + k) % 9];
      final frac = AstroConstants.dashaYears[subPlanet]! / 120.0;
      DateTime currEnd;
      if (k == 8) {
        currEnd = end;
      } else {
        final subMicros = (totalMicros * frac).round();
        currEnd = currStart.add(Duration(microseconds: subMicros));
      }

      double subYears = (parent.years != null)
          ? (parent.years! * frac)
          : (currEnd.difference(currStart).inMicroseconds / (365.2425 * 86400 * 1000000));

      subs.add(DashaPeriod(
        planet: subPlanet,
        startDate: currStart,
        endDate: currEnd,
        years: subYears,
        level: nextLevel,
      ));
      currStart = currEnd;
    }
    return subs;
  }

  /// Find the current running Maha Dasha (Level 1) for a given date.
  static DashaPeriod? findCurrentMahaDasha(
    List<DashaPeriod> dashas,
    DateTime date,
  ) {
    for (var dasha in dashas) {
      if (dasha.containsDate(date)) return dasha;
    }
    return null;
  }

  /// Find the current running Antar Dasha (Level 2).
  static DashaPeriod? findCurrentAntarDasha(
    List<DashaPeriod> dashas,
    DateTime date,
  ) {
    DashaPeriod? maha = findCurrentMahaDasha(dashas, date);
    if (maha?.subPeriods == null) return null;
    for (var antar in maha!.subPeriods!) {
      if (antar.containsDate(date)) return antar;
    }
    return null;
  }

  /// Find the current running Pratyantar Dasha (Level 3).
  static DashaPeriod? findCurrentPratyantarDasha(
    List<DashaPeriod> dashas,
    DateTime date,
  ) {
    DashaPeriod? antar = findCurrentAntarDasha(dashas, date);
    if (antar?.subPeriods == null) return null;
    for (var pratyantar in antar!.subPeriods!) {
      if (pratyantar.containsDate(date)) return pratyantar;
    }
    return null;
  }

  /// Find the current running Sookshma Dasha (Level 4).
  static DashaPeriod? findCurrentSookshmaDasha(
    List<DashaPeriod> dashas,
    DateTime date,
  ) {
    DashaPeriod? pratyantar = findCurrentPratyantarDasha(dashas, date);
    if (pratyantar?.subPeriods == null) return null;
    for (var sookshma in pratyantar!.subPeriods!) {
      if (sookshma.containsDate(date)) return sookshma;
    }
    return null;
  }

  /// Find the current running Prana Dasha (Level 5).
  static DashaPeriod? findCurrentPranaDasha(
    List<DashaPeriod> dashas,
    DateTime date,
  ) {
    DashaPeriod? sookshma = findCurrentSookshmaDasha(dashas, date);
    if (sookshma?.subPeriods == null) return null;
    for (var prana in sookshma!.subPeriods!) {
      if (prana.containsDate(date)) return prana;
    }
    return null;
  }

  /// Returns the complete 5-level active dasha period chain for a given moment:
  /// (Maha, Antar, Pratyantar, Sookshma, Prana)
  static ({
    DashaPeriod? maha,
    DashaPeriod? antar,
    DashaPeriod? pratyantar,
    DashaPeriod? sookshma,
    DashaPeriod? prana,
  }) findCurrentHierarchy(
    List<DashaPeriod> dashas,
    DateTime date,
  ) {
    final maha = findCurrentMahaDasha(dashas, date);
    final antar = findCurrentAntarDasha(dashas, date);
    final pratyantar = findCurrentPratyantarDasha(dashas, date);
    final sookshma = findCurrentSookshmaDasha(dashas, date);
    final prana = findCurrentPranaDasha(dashas, date);

    return (
      maha: maha,
      antar: antar,
      pratyantar: pratyantar,
      sookshma: sookshma,
      prana: prana,
    );
  }
}
