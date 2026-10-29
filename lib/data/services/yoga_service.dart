import '../models/planet_position.dart';
import '../models/chart_data.dart';

enum YogaCategory {
  mahapurusha,
  raja,
  dhana,
  auspicious,
  special,
}

class VedicYoga {
  final String name;
  final String teluguName;
  final YogaCategory category;
  final String description;
  final String teluguDescription;
  final List<String> planets;
  final List<int> houses;
  final double strengthScore;

  const VedicYoga({
    required this.name,
    required this.teluguName,
    required this.category,
    required this.description,
    required this.teluguDescription,
    required this.planets,
    required this.houses,
    this.strengthScore = 0.85,
  });
}

/// 100% Classical Vedic Yogas Detection Engine (Parashari & Jaimini)
class YogaService {
  YogaService._();

  static List<VedicYoga> detectYogas(ChartData chart) {
    final yogas = <VedicYoga>[];
    final asc = chart.ascendant;
    final ascSign = asc.rashiIndex;

    int houseOf(PlanetPosition p) => ((p.rashiIndex - ascSign + 12) % 12) + 1;

    final sun = chart.getPlanet('Sun');
    final moon = chart.getPlanet('Moon');
    final mars = chart.getPlanet('Mars');
    final mercury = chart.getPlanet('Mercury');
    final jupiter = chart.getPlanet('Jupiter');
    final venus = chart.getPlanet('Venus');
    final saturn = chart.getPlanet('Saturn');

    // 1. PANCHA MAHAPURUSHA YOGAS
    if (mars != null) {
      final h = houseOf(mars);
      if ([1, 4, 7, 10].contains(h) && (mars.dignity.contains('Own') || mars.dignity.contains('Exalted'))) {
        yogas.add(VedicYoga(
          name: 'Ruchaka Mahapurusha Yoga',
          teluguName: 'రుచక మహాపురుష యోగం',
          category: YogaCategory.mahapurusha,
          description: 'Mars in Kendra in Own or Exaltation sign. Bestows courage, leadership, victory over adversaries, and military/executive power.',
          teluguDescription: 'కుజుడు కేంద్రంలో స్వక్షేత్ర లేదా ఉచ్ఛస్థితిలో ఉండటం వలన ధైర్యం, నాయకత్వ గుణం, స్థిరాస్తి లాభాలు కలుగుతాయి.',
          planets: ['Mars'],
          houses: [h],
        ));
      }
    }

    if (mercury != null) {
      final h = houseOf(mercury);
      if ([1, 4, 7, 10].contains(h) && (mercury.dignity.contains('Own') || mercury.dignity.contains('Exalted'))) {
        yogas.add(VedicYoga(
          name: 'Bhadra Mahapurusha Yoga',
          teluguName: 'భద్ర మహాపురుష యోగం',
          category: YogaCategory.mahapurusha,
          description: 'Mercury in Kendra in Gemini or Virgo. Confers supreme intellect, sharp analytical prowess, eloquence, and commercial success.',
          teluguDescription: 'బుధుడు కేంద్రంలో స్వక్షేత్ర/ఉచ్ఛ స్థితిలో ఉండటం వల్ల అద్భుతమైన విద్యాబుద్ధులు, వాక్చాతుర్యం, వ్యాపార విజయం లభిస్తాయి.',
          planets: ['Mercury'],
          houses: [h],
        ));
      }
    }

    if (jupiter != null) {
      final h = houseOf(jupiter);
      if ([1, 4, 7, 10].contains(h) && (jupiter.dignity.contains('Own') || jupiter.dignity.contains('Exalted'))) {
        yogas.add(VedicYoga(
          name: 'Hamsa Mahapurusha Yoga',
          teluguName: 'హంస మహాపురుష యోగం',
          category: YogaCategory.mahapurusha,
          description: 'Jupiter in Kendra in Cancer, Sagittarius, or Pisces. Bestows noble wisdom, righteous character, universal respect, and spiritual elevation.',
          teluguDescription: 'గురుడు కేంద్రంలో ఉచ్ఛ/స్వక్షేత్ర స్థితిలో ఉండటం వలన ఉన్నత విజ్ఞానం, ఆధ్యాత్మిక ఔన్నత్యం, గౌరవ మన్ననలు లభిస్తాయి.',
          planets: ['Jupiter'],
          houses: [h],
        ));
      }
    }

    if (venus != null) {
      final h = houseOf(venus);
      if ([1, 4, 7, 10].contains(h) && (venus.dignity.contains('Own') || venus.dignity.contains('Exalted'))) {
        yogas.add(VedicYoga(
          name: 'Malavya Mahapurusha Yoga',
          teluguName: 'మాళవ్య మహాపురుష యోగం',
          category: YogaCategory.mahapurusha,
          description: 'Venus in Kendra in Taurus, Libra, or Pisces. Confers opulent wealth, artistic mastery, marital joy, and refined vehicles.',
          teluguDescription: 'శుక్రుడు కేంద్రంలో స్వక్షేత్ర/ఉచ్ఛ స్థితిలో ఉండటం వల్ల భోగభాగ్యాలు, వాహన యోగం, కళా నైపుణ్యం ప్రాప్తిస్తాయి.',
          planets: ['Venus'],
          houses: [h],
        ));
      }
    }

    if (saturn != null) {
      final h = houseOf(saturn);
      if ([1, 4, 7, 10].contains(h) && (saturn.dignity.contains('Own') || saturn.dignity.contains('Exalted'))) {
        yogas.add(VedicYoga(
          name: 'Sasa Mahapurusha Yoga',
          teluguName: 'శశ మహాపురుష యోగం',
          category: YogaCategory.mahapurusha,
          description: 'Saturn in Kendra in Libra, Capricorn, or Aquarius. Gives mass leadership, endurance, political influence, and lasting authority.',
          teluguDescription: 'శని కేంద్రంలో ఉచ్ఛ/స్వక్షేత్ర స్థితిలో ఉండటం వల్ల ప్రజా నాయకత్వం, దీర్ఘాయుష్షు, స్థిరమైన అధికారం చేకూరుతాయి.',
          planets: ['Saturn'],
          houses: [h],
        ));
      }
    }

    // 2. GAJAKESARI, BUDHADITYA, CHANDRA-MANGALA
    if (jupiter != null && moon != null) {
      final diff = (jupiter.rashiIndex - moon.rashiIndex + 12) % 12;
      if ([0, 3, 6, 9].contains(diff)) {
        yogas.add(VedicYoga(
          name: 'Gajakesari Yoga',
          teluguName: 'గజకేసరి యోగం',
          category: YogaCategory.auspicious,
          description: 'Jupiter is in a Kendra (1, 4, 7, 10) from the Moon. Conveys eminent status, lasting fame, prosperity, and fearlessness like a lion.',
          teluguDescription: 'చంద్రుడి నుండి గురుడు కేంద్రంలో ఉండటం వల్ల సమాజంలో విశేష కీర్తి ప్రతిష్టలు, సంపద, ధైర్యం కలుగుతాయి.',
          planets: ['Jupiter', 'Moon'],
          houses: [houseOf(moon), houseOf(jupiter)],
        ));
      }
    }

    if (sun != null && mercury != null) {
      if (sun.rashiIndex == mercury.rashiIndex) {
        final dist = (sun.longitude - mercury.longitude).abs();
        yogas.add(VedicYoga(
          name: 'Budhaditya Yoga',
          teluguName: 'బుధాదిత్య యోగం',
          category: YogaCategory.auspicious,
          description: 'Sun and Mercury conjunction in the same sign. Enhances brilliance, sharp memory, communicative genius, and administrative acumen.',
          teluguDescription: 'రవి, బుధుల సంయోగం వలన తీక్షణమైన మేధస్సు, గణిత/శాస్త్ర ప్రావీణ్యం, సమాజంలో ఉన్నత గౌరవం లభిస్తాయి.',
          planets: ['Sun', 'Mercury'],
          houses: [houseOf(sun)],
          strengthScore: dist > 3.0 ? 0.95 : 0.75,
        ));
      }
    }

    if (moon != null && mars != null) {
      if (moon.rashiIndex == mars.rashiIndex) {
        yogas.add(VedicYoga(
          name: 'Chandra-Mangala Yoga',
          teluguName: 'చంద్ర-మంగళ యోగం',
          category: YogaCategory.dhana,
          description: 'Moon and Mars conjunction. Generates enormous financial drive, real-estate gains, enterprise, and material abundance.',
          teluguDescription: 'చంద్ర, కుజుల కలయిక వల్ల విపరీతమైన ధనార్జనా శక్తి, స్థిరాస్తి వృద్ధి, పట్టుదల కలుగుతాయి.',
          planets: ['Moon', 'Mars'],
          houses: [houseOf(moon)],
        ));
      }
    }

    if (jupiter != null || venus != null || mercury != null) {
      final b10Lagna = [jupiter, venus, mercury].where((p) => p != null && houseOf(p) == 10).toList();
      if (b10Lagna.isNotEmpty) {
        yogas.add(VedicYoga(
          name: 'Amala Yoga',
          teluguName: 'అమల యోగం',
          category: YogaCategory.raja,
          description: 'Natural benefic in the 10th house from Ascendant. Guarantees spotless reputation, high professional achievements, and philanthropic deeds.',
          teluguDescription: 'లగ్నం నుండి 10వ స్థానంలో శుభగ్రహం ఉండటం వలన నిర్మలమైన కీర్తి, వృత్తిపరమైన ఉన్నత విజయం సిద్ధిస్తాయి.',
          planets: b10Lagna.map((p) => p!.name).toList(),
          houses: [10],
        ));
      }
    }

    if (venus != null || jupiter != null) {
      final h9 = ((ascSign + 8) % 12);
      final l9Lord = _getRashiLord(h9);
      final l9Planet = chart.getPlanet(l9Lord);
      if (l9Planet != null && (l9Planet.dignity.contains('Own') || l9Planet.dignity.contains('Exalted'))) {
        final h = houseOf(l9Planet);
        if ([1, 4, 7, 9, 10].contains(h)) {
          yogas.add(VedicYoga(
            name: 'Lakshmi Yoga',
            teluguName: 'లక్ష్మీ యోగం',
            category: YogaCategory.dhana,
            description: '9th house lord in Kendra or Trikona in exalted/own sign. Blesses the native with constant fortune, virtue, and abundant riches.',
            teluguDescription: 'భాగ్యాధిపతి కేంద్ర, కోణాలలో స్వ/ఉచ్ఛ క్షేత్రంలో ఉండటం వల్ల నిరంతర ధనధాన్యాలు, సద్గుణాలు ప్రాప్తిస్తాయి.',
            planets: [l9Planet.name],
            houses: [h],
          ));
        }
      }
    }

    if (jupiter != null && venus != null && mercury != null) {
      final hj = houseOf(jupiter);
      final hv = houseOf(venus);
      final hm = houseOf(mercury);
      final validHouses = [1, 2, 4, 5, 7, 9, 10];
      if (validHouses.contains(hj) && validHouses.contains(hv) && validHouses.contains(hm)) {
        yogas.add(VedicYoga(
          name: 'Saraswati Yoga',
          teluguName: 'సరస్వతీ యోగం',
          category: YogaCategory.auspicious,
          description: 'Jupiter, Venus, and Mercury occupy Kendras, Trikonas, or 2nd house. Blesses with mastery of arts, literature, music, and deep scholarship.',
          teluguDescription: 'గురు, శుక్ర, బుధులు కేంద్ర, కోణ, ద్వితీయ స్థానాలలో ఉండటం వల్ల పాండిత్యం, సంగీతం, సాహిత్యాలలో నిపుణత లభిస్తుంది.',
          planets: ['Jupiter', 'Venus', 'Mercury'],
          houses: [hj, hv, hm],
        ));
      }
    }

    final h6Sign = (ascSign + 5) % 12;
    final h8Sign = (ascSign + 7) % 12;
    final h12Sign = (ascSign + 11) % 12;
    final l6 = chart.getPlanet(_getRashiLord(h6Sign));
    final l8 = chart.getPlanet(_getRashiLord(h8Sign));
    final l12 = chart.getPlanet(_getRashiLord(h12Sign));

    if (l6 != null && [6, 8, 12].contains(houseOf(l6))) {
      yogas.add(VedicYoga(
        name: 'Harsha Vipareeta Raja Yoga',
        teluguName: 'హర్ష విపరీత రాజయోగం',
        category: YogaCategory.raja,
        description: '6th lord placed in 6th, 8th, or 12th house. Gives immunity to enemies, physical stamina, and unexpected rise through challenges.',
        teluguDescription: '6వ అధిపతి దుస్థానాలలో ఉండటం వలన శత్రుజయం, ఆకస్మిక ధనలాభం, కష్టాల నుండి బయటపడే శక్తి లభిస్తాయి.',
        planets: [l6.name],
        houses: [houseOf(l6)],
      ));
    }
    if (l8 != null && [6, 8, 12].contains(houseOf(l8))) {
      yogas.add(VedicYoga(
        name: 'Sarala Vipareeta Raja Yoga',
        teluguName: 'సరళ విపరీత రాజయోగం',
        category: YogaCategory.raja,
        description: '8th lord in 6th, 8th, or 12th house. Grants fearlessness, long life, victory in court battles, and profound resilience.',
        teluguDescription: '8వ అధిపతి దుస్థానాలలో ఉండటం వలన దీర్ఘాయుష్షు, ఆపదల నుండి రక్షణ, శత్రువులపై విజయం చేకూరుతాయి.',
        planets: [l8.name],
        houses: [houseOf(l8)],
      ));
    }
    if (l12 != null && [6, 8, 12].contains(houseOf(l12))) {
      yogas.add(VedicYoga(
        name: 'Vimala Vipareeta Raja Yoga',
        teluguName: 'విమల విపరీత రాజయోగం',
        category: YogaCategory.raja,
        description: '12th lord in 6th, 8th, or 12th house. Bestows noble spending habits, independent wealth, and peace of mind.',
        teluguDescription: '12వ అధిపతి దుస్థానాలలో ఉండటం వలన సద్వినియోగ సంపద, మనశ్శాంతి, స్వతంత్ర జీవనం లభిస్తాయి.',
        planets: [l12.name],
        houses: [houseOf(l12)],
      ));
    }

    return yogas;
  }

  static String _getRashiLord(int rashiIndex) {
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
