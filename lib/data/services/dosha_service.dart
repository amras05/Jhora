import '../models/chart_data.dart';

class KujaDoshaResult {
  final bool hasDosha;
  final bool isCancelled;
  final String cancellationReason;
  final String teluguReason;
  final List<String> referencePoints;
  final List<int> affectedHouses;
  final String severity;

  const KujaDoshaResult({
    required this.hasDosha,
    required this.isCancelled,
    this.cancellationReason = '',
    this.teluguReason = '',
    required this.referencePoints,
    required this.affectedHouses,
    required this.severity,
  });
}

class KaalSarpaResult {
  final bool hasDosha;
  final bool isPartial;
  final String typeName;
  final String teluguTypeName;
  final String description;
  final String teluguDescription;
  final int rahuHouse;
  final int ketuHouse;

  const KaalSarpaResult({
    required this.hasDosha,
    this.isPartial = false,
    this.typeName = '',
    this.teluguTypeName = '',
    this.description = '',
    this.teluguDescription = '',
    this.rahuHouse = 0,
    this.ketuHouse = 0,
  });
}

class DoshaAnalysis {
  final KujaDoshaResult kujaDosha;
  final KaalSarpaResult kaalSarpa;
  final bool hasPitruDosha;
  final String pitruDoshaReason;
  final bool hasGuruChandal;
  final String guruChandalReason;

  const DoshaAnalysis({
    required this.kujaDosha,
    required this.kaalSarpa,
    required this.hasPitruDosha,
    required this.pitruDoshaReason,
    required this.hasGuruChandal,
    required this.guruChandalReason,
  });
}

/// 100% Classical Parashari Dosha Analysis Service
class DoshaService {
  DoshaService._();

  static DoshaAnalysis analyze(ChartData chart) {
    return DoshaAnalysis(
      kujaDosha: _checkKujaDosha(chart),
      kaalSarpa: _checkKaalSarpa(chart),
      hasPitruDosha: _checkPitruDosha(chart).$1,
      pitruDoshaReason: _checkPitruDosha(chart).$2,
      hasGuruChandal: _checkGuruChandal(chart).$1,
      guruChandalReason: _checkGuruChandal(chart).$2,
    );
  }

  static KujaDoshaResult _checkKujaDosha(ChartData chart) {
    final mars = chart.getPlanet('Mars');
    if (mars == null) {
      return const KujaDoshaResult(
        hasDosha: false,
        isCancelled: false,
        referencePoints: [],
        affectedHouses: [],
        severity: 'None',
      );
    }

    final ascSign = chart.ascendant.rashiIndex;
    final moon = chart.getPlanet('Moon');
    final venus = chart.getPlanet('Venus');
    final jupiter = chart.getPlanet('Jupiter');

    final refPoints = <String>[];
    final houses = <int>[];

    int hFromAsc = ((mars.rashiIndex - ascSign + 12) % 12) + 1;
    if ([1, 2, 4, 7, 8, 12].contains(hFromAsc)) {
      refPoints.add('Lagna');
      houses.add(hFromAsc);
    }

    if (moon != null) {
      int hFromMoon = ((mars.rashiIndex - moon.rashiIndex + 12) % 12) + 1;
      if ([1, 2, 4, 7, 8, 12].contains(hFromMoon)) {
        refPoints.add('Moon');
        houses.add(hFromMoon);
      }
    }

    if (venus != null) {
      int hFromVenus = ((mars.rashiIndex - venus.rashiIndex + 12) % 12) + 1;
      if ([1, 2, 4, 7, 8, 12].contains(hFromVenus)) {
        refPoints.add('Venus');
        houses.add(hFromVenus);
      }
    }

    if (refPoints.isEmpty) {
      return const KujaDoshaResult(
        hasDosha: false,
        isCancelled: false,
        referencePoints: [],
        affectedHouses: [],
        severity: 'None',
      );
    }

    bool isCancelled = false;
    String reason = '';
    String teluguReason = '';

    if (hFromAsc == 1 && mars.rashiIndex == 0) {
      isCancelled = true;
      reason = 'Mars is in Aries in 1st house (Own sign cancellation).';
      teluguReason = 'కుజుడు మేష లగ్నంలో స్వక్షేత్రంలో ఉండటం వల్ల కుజదోషం నివృత్తి.';
    } else if (hFromAsc == 4 && mars.rashiIndex == 3) {
      isCancelled = true;
      reason = 'Mars in Cancer in 4th house (Neecha cancellation).';
      teluguReason = 'కుజుడు కర్కాటకంలో 4వ స్థానంలో ఉండటం వల్ల దోష నివృత్తి.';
    } else if (hFromAsc == 7 && (mars.rashiIndex == 9 || mars.rashiIndex == 2)) {
      isCancelled = true;
      reason = 'Mars in 7th in Capricorn (Exalted) or Gemini.';
      teluguReason = 'కుజుడు మకరం లేదా మిథునంలో 7వ స్థానంలో ఉండటం వల్ల దోష నివృత్తి.';
    } else if (hFromAsc == 8 && (mars.rashiIndex == 8 || mars.rashiIndex == 11)) {
      isCancelled = true;
      reason = 'Mars in 8th in Sagittarius or Pisces (Jupiter signs).';
      teluguReason = 'కుజుడు ధనుస్సు లేదా మీనంలో 8వ స్థానంలో ఉండటం వల్ల నివృత్తి.';
    } else if (hFromAsc == 12 && (mars.rashiIndex == 1 || mars.rashiIndex == 6)) {
      isCancelled = true;
      reason = 'Mars in 12th in Taurus or Libra (Venus signs).';
      teluguReason = 'కుజుడు వృషభం లేదా తులారాశిలో 12వ స్థానంలో ఉండటం వల్ల నివృత్తి.';
    } else if (jupiter != null && (jupiter.rashiIndex == mars.rashiIndex || ((jupiter.rashiIndex - mars.rashiIndex + 12) % 12 == 6))) {
      isCancelled = true;
      reason = 'Mars is conjunct or aspected by benefic Jupiter (Guru Drishti).';
      teluguReason = 'కుజుడిపై గురు దృష్టి లేదా గురు సంయోగం వల్ల కుజదోషం సంపూర్ణ నివృత్తి.';
    } else if (moon != null && moon.rashiIndex == mars.rashiIndex) {
      isCancelled = true;
      reason = 'Moon and Mars conjunction forms Chandra-Mangala Yoga nullifying affliction.';
      teluguReason = 'చంద్ర-కుజుల సంయోగం వల్ల కుజదోష భంగం.';
    }

    String severity = 'Mild';
    if (!isCancelled) {
      if (refPoints.length == 3) {
        severity = 'High';
      } else if (refPoints.length == 2) {
        severity = 'Moderate';
      } else {
        severity = 'Low';
      }
    }

    return KujaDoshaResult(
      hasDosha: true,
      isCancelled: isCancelled,
      cancellationReason: reason,
      teluguReason: teluguReason,
      referencePoints: refPoints,
      affectedHouses: houses,
      severity: severity,
    );
  }

  static KaalSarpaResult _checkKaalSarpa(ChartData chart) {
    final rahu = chart.getPlanet('Rahu');
    final ketu = chart.getPlanet('Ketu');
    if (rahu == null || ketu == null) return const KaalSarpaResult(hasDosha: false);

    final ascSign = chart.ascendant.rashiIndex;
    final rahuHouse = ((rahu.rashiIndex - ascSign + 12) % 12) + 1;
    final ketuHouse = ((ketu.rashiIndex - ascSign + 12) % 12) + 1;

    final planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    int directCount = 0;
    int indirectCount = 0;

    for (final name in planets) {
      final p = chart.getPlanet(name);
      if (p == null) continue;

      double diffRahu = (p.longitude - rahu.longitude + 360.0) % 360.0;
      if (diffRahu > 0 && diffRahu < 180.0) {
        directCount++;
      } else {
        indirectCount++;
      }
    }

    bool hasFullDosha = (directCount == 7 || indirectCount == 7);
    bool hasPartialDosha = (directCount == 6 || indirectCount == 6);

    if (!hasFullDosha && !hasPartialDosha) {
      return const KaalSarpaResult(hasDosha: false);
    }

    final types = {
      1: ('Ananta Kaal Sarpa', 'అనంత కాలసర్ప యోగం', 'Rahu in 1st, Ketu in 7th. Challenges in self-identity and relationships, solved with perseverance.'),
      2: ('Kulika Kaal Sarpa', 'కుళిక కాలసర్ప యోగం', 'Rahu in 2nd, Ketu in 8th. Financial flux and family communication dynamics.'),
      3: ('Vasuki Kaal Sarpa', 'వాసుకి కాలసర్ప యోగం', 'Rahu in 3rd, Ketu in 9th. High courage and sibling efforts with divine grace.'),
      4: ('Shankhapala Kaal Sarpa', 'శంఖపాల కాలసర్ప యోగం', 'Rahu in 4th, Ketu in 10th. Maternal care, domestic shifts, and career expansion.'),
      5: ('Padma Kaal Sarpa', 'పద్మ కాలసర్ప యోగం', 'Rahu in 5th, Ketu in 11th. Creative genius, higher education, and progeny blessings.'),
      6: ('Mahapadma Kaal Sarpa', 'మహా పద్మ కాలసర్ప యోగం', 'Rahu in 6th, Ketu in 12th. Triumph over rivals, legal victories, and health recovery.'),
      7: ('Takshaka Kaal Sarpa', 'తక్షక కాలసర్ప యోగం', 'Rahu in 7th, Ketu in 1st. Business partnerships and marital growth through patience.'),
      8: ('Karkotaka Kaal Sarpa', 'కర్కోటక కాలసర్ప యోగం', 'Rahu in 8th, Ketu in 2nd. Research abilities, ancestral assets, and spiritual depth.'),
      9: ('Shankhachooda Kaal Sarpa', 'శంఖచూడ కాలసర్ప యోగం', 'Rahu in 9th, Ketu in 3rd. Philosophical quest and fortune earned through righteous deeds.'),
      10: ('Ghataka Kaal Sarpa', 'ఘాతక కాలసర్ప యోగం', 'Rahu in 10th, Ketu in 4th. Dynamic professional authority and public distinction.'),
      11: ('Vishadhara Kaal Sarpa', 'విషధర కాలసర్ప యోగం', 'Rahu in 11th, Ketu in 5th. Vast networks, foreign connections, and multiple income sources.'),
      12: ('Sheshanaga Kaal Sarpa', 'శేషనాగ కాలసర్ప యోగం', 'Rahu in 12th, Ketu in 6th. Foreign residency, spiritual liberation, and visionary dreams.'),
    };

    final typeInfo = types[rahuHouse] ?? ('Kaal Sarpa Yoga', 'కాలసర్ప యోగం', 'Planets hemmed between Rahu and Ketu.');

    return KaalSarpaResult(
      hasDosha: true,
      isPartial: hasPartialDosha,
      typeName: typeInfo.$1,
      teluguTypeName: typeInfo.$2,
      description: typeInfo.$3,
      teluguDescription: hasPartialDosha ? '${typeInfo.$2} (పాక్షిక / Partial - ఒక గ్రహం బయట ఉంది)' : typeInfo.$2,
      rahuHouse: rahuHouse,
      ketuHouse: ketuHouse,
    );
  }

  static (bool, String) _checkPitruDosha(ChartData chart) {
    final sun = chart.getPlanet('Sun');
    final rahu = chart.getPlanet('Rahu');
    final ketu = chart.getPlanet('Ketu');
    final saturn = chart.getPlanet('Saturn');

    if (sun != null) {
      if (rahu != null && sun.rashiIndex == rahu.rashiIndex) {
        return (true, 'Sun conjunct Rahu (Surya Grahan combination in chart)');
      }
      if (ketu != null && sun.rashiIndex == ketu.rashiIndex) {
        return (true, 'Sun conjunct Ketu (Solar eclipse axis affliction)');
      }
      if (saturn != null && sun.rashiIndex == saturn.rashiIndex) {
        return (true, 'Sun conjunct Saturn (Father-Son planetary opposition in same house)');
      }
    }
    return (false, 'No Pitru Dosha identified');
  }

  static (bool, String) _checkGuruChandal(ChartData chart) {
    final jup = chart.getPlanet('Jupiter');
    final rahu = chart.getPlanet('Rahu');
    final ketu = chart.getPlanet('Ketu');

    if (jup != null) {
      if (rahu != null && jup.rashiIndex == rahu.rashiIndex) {
        return (true, 'Jupiter conjunct Rahu forms Guru Chandal Yoga in house ${(jup.rashiIndex - chart.ascendant.rashiIndex + 12) % 12 + 1}.');
      }
      if (ketu != null && jup.rashiIndex == ketu.rashiIndex) {
        return (true, 'Jupiter conjunct Ketu forms Ganesha Yoga (Spiritual Chandal combination).');
      }
    }
    return (false, 'No Guru Chandal Yoga identified');
  }
}
