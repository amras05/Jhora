import '../../../core/constants/astro_constants.dart';
import '../models/chart_data.dart';
import '../models/planet_position.dart';

/// Complete Classical Parashara 16 Shodashavarga Divisional Charts
enum DivisionalChartType {
  d1,
  d2,
  d3,
  d4,
  d7,
  d9,
  d10,
  d12,
  d16,
  d20,
  d24,
  d27,
  d30,
  d40,
  d45,
  d60,
}

/// Service providing calculation and metadata for all 16 Parashara Shodashavarga charts.
class DivisionalChartService {
  DivisionalChartService._();

  /// User-facing Telugu title with significance description.
  static String getDivisionalTitle(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1:
        return 'D1 రాశి చక్రము (Rasi - Body & General Life)';
      case DivisionalChartType.d2:
        return 'D2 హోరా చక్రము (Hora - Wealth & Prosperity)';
      case DivisionalChartType.d3:
        return 'D3 ద్రేక్కాణ చక్రము (Drekkana - Siblings & Courage)';
      case DivisionalChartType.d4:
        return 'D4 చతుర్థాంశ చక్రము (Chaturthamsha - Assets & Fortune)';
      case DivisionalChartType.d7:
        return 'D7 సప్తాంశ చక్రము (Saptamsha - Progeny & Children)';
      case DivisionalChartType.d9:
        return 'D9 నవాంశ చక్రము (Navamsha - Dharma, Spouse & Destiny)';
      case DivisionalChartType.d10:
        return 'D10 దశాంశ చక్రము (Dashamsha - Career, Honors & Status)';
      case DivisionalChartType.d12:
        return 'D12 ద్వాదశాంశ చక్రము (Dwadashamsha - Parents & Ancestry)';
      case DivisionalChartType.d16:
        return 'D16 షోడశాంశ చక్రము (Shodashamsha - Vehicles & Luxuries)';
      case DivisionalChartType.d20:
        return 'D20 వింశాంశ చక్రము (Vimshamsha - Spiritual Progress & Upasana)';
      case DivisionalChartType.d24:
        return 'D24 చతుర్వింశాంశ చక్రము (Siddhamsa - Learning & Higher Knowledge)';
      case DivisionalChartType.d27:
        return 'D27 సప్తవింశాంశ చక్రము (Bhamsa - Vital Strength & Weaknesses)';
      case DivisionalChartType.d30:
        return 'D30 త్రింశాంశ చక్రము (Trimshamsha - Arishta, Evils & Health)';
      case DivisionalChartType.d40:
        return 'D40 ఖవేదాంశ చక్రము (Khavedamsha - Auspicious & Inauspicious Results)';
      case DivisionalChartType.d45:
        return 'D45 అక్షవేదాంశ చక్రము (Akshavedamsha - Character & Integrity)';
      case DivisionalChartType.d60:
        return 'D60 షష్ట్యంశ చక్రము (Shashtiamsha - Past Karma & Fine Destiny)';
    }
  }

  /// Compact center title for South Indian chart box.
  static String getDivisionalCenterName(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1:
        return 'D1 • రాశి చక్రము';
      case DivisionalChartType.d2:
        return 'D2 • హోరా చక్రము';
      case DivisionalChartType.d3:
        return 'D3 • ద్రేక్కాణ చక్రము';
      case DivisionalChartType.d4:
        return 'D4 • చతుర్థాంశ చక్రము';
      case DivisionalChartType.d7:
        return 'D7 • సప్తాంశ చక్రము';
      case DivisionalChartType.d9:
        return 'D9 • నవాంశ చక్రము';
      case DivisionalChartType.d10:
        return 'D10 • దశాంశ చక్రము';
      case DivisionalChartType.d12:
        return 'D12 • ద్వాదశాంశ చక్రము';
      case DivisionalChartType.d16:
        return 'D16 • షోడశాంశ చక్రము';
      case DivisionalChartType.d20:
        return 'D20 • వింశాంశ చక్రము';
      case DivisionalChartType.d24:
        return 'D24 • సిద్ధాంశ చక్రము';
      case DivisionalChartType.d27:
        return 'D27 • భంశ చక్రము';
      case DivisionalChartType.d30:
        return 'D30 • త్రింశాంశ చక్రము';
      case DivisionalChartType.d40:
        return 'D40 • ఖవేదాంశ చక్రము';
      case DivisionalChartType.d45:
        return 'D45 • అక్షవేదాంశ చక్రము';
      case DivisionalChartType.d60:
        return 'D60 • షష్ట్యంశ చక్రము';
    }
  }

  /// Compact significance description for South Indian chart center.
  static String getDivisionalSignificance(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1:
        return 'Body & General Life';
      case DivisionalChartType.d2:
        return 'Wealth & Prosperity';
      case DivisionalChartType.d3:
        return 'Siblings & Courage';
      case DivisionalChartType.d4:
        return 'Assets & Fortune';
      case DivisionalChartType.d7:
        return 'Progeny & Children';
      case DivisionalChartType.d9:
        return 'Dharma & Spouse';
      case DivisionalChartType.d10:
        return 'Career & Status';
      case DivisionalChartType.d12:
        return 'Parents & Ancestry';
      case DivisionalChartType.d16:
        return 'Vehicles & Comforts';
      case DivisionalChartType.d20:
        return 'Spiritual Upasana';
      case DivisionalChartType.d24:
        return 'Learning & Knowledge';
      case DivisionalChartType.d27:
        return 'Vital Strength';
      case DivisionalChartType.d30:
        return 'Arishta & Health';
      case DivisionalChartType.d40:
        return 'Auspicious Fortune';
      case DivisionalChartType.d45:
        return 'Character & Conduct';
      case DivisionalChartType.d60:
        return 'Past Karma & Destiny';
    }
  }

  /// Compact chip label for horizontal selector bar.
  static String getDivisionalChipLabel(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1:
        return 'D1 రాశి (Rasi)';
      case DivisionalChartType.d2:
        return 'D2 హోరా (Wealth)';
      case DivisionalChartType.d3:
        return 'D3 ద్రేక్కాణ (Siblings)';
      case DivisionalChartType.d4:
        return 'D4 చతుర్థాంశ (Assets)';
      case DivisionalChartType.d7:
        return 'D7 సప్తాంశ (Children)';
      case DivisionalChartType.d9:
        return 'D9 నవాంశ (Navamsa)';
      case DivisionalChartType.d10:
        return 'D10 దశాంశ (Career)';
      case DivisionalChartType.d12:
        return 'D12 ద్వాదశాంశ (Parents)';
      case DivisionalChartType.d16:
        return 'D16 షోడశాంశ (Vehicles)';
      case DivisionalChartType.d20:
        return 'D20 వింశాంశ (Upasana)';
      case DivisionalChartType.d24:
        return 'D24 సిద్ధాంశ (Learning)';
      case DivisionalChartType.d27:
        return 'D27 భంశ (Strength)';
      case DivisionalChartType.d30:
        return 'D30 త్రింశాంశ (Arishta)';
      case DivisionalChartType.d40:
        return 'D40 ఖవేదాంశ (Fortune)';
      case DivisionalChartType.d45:
        return 'D45 అక్షవేదాంశ (Character)';
      case DivisionalChartType.d60:
        return 'D60 షష్ట్యంశ (Karma)';
    }
  }

  /// Pure mathematical Parashara calculation for any longitude into its Varga sign (0-11).
  static int getSignForLongitude(double longitude, DivisionalChartType type) {
    double lon = longitude % 360.0;
    if (lon < 0) lon += 360.0;

    int rashiIndex = (lon / 30.0).floor() % 12;
    double degInRashi = lon % 30.0;
    bool isOddSign = (rashiIndex % 2 == 0); // 0=Mesha (Odd 1st sign), 1=Vrishabha (Even 2nd)

    switch (type) {
      case DivisionalChartType.d1:
        return rashiIndex;

      case DivisionalChartType.d2:
        // D2 Hora (15°): Odd -> 1st half Leo(4), 2nd half Cancer(3); Even -> Cancer(3), Leo(4)
        int part = (degInRashi / 15.0).floor().clamp(0, 1);
        return isOddSign ? (part == 0 ? 4 : 3) : (part == 0 ? 3 : 4);

      case DivisionalChartType.d3:
        // D3 Drekkana (10°): 1st, 5th, 9th
        int part = (degInRashi / 10.0).floor().clamp(0, 2);
        return (rashiIndex + part * 4) % 12;

      case DivisionalChartType.d4:
        // D4 Chaturthamsha (7.5°): Kendras (1st, 4th, 7th, 10th)
        int part = (degInRashi / 7.5).floor().clamp(0, 3);
        return (rashiIndex + part * 3) % 12;

      case DivisionalChartType.d7:
        // D7 Saptamsha (30/7°): Odd from same, Even from 7th
        int part = (degInRashi / (30.0 / 7.0)).floor().clamp(0, 6);
        return isOddSign ? (rashiIndex + part) % 12 : ((rashiIndex + 6) + part) % 12;

      case DivisionalChartType.d9:
        // D9 Navamsha (3°20'): 108 padas across zodiac
        int totalPada = ((lon / AstroConstants.padaSpan).floor()) % 108;
        return totalPada % 12;

      case DivisionalChartType.d10:
        // D10 Dashamsha (3°): Odd from same, Even from 9th
        int part = (degInRashi / 3.0).floor().clamp(0, 9);
        return isOddSign ? (rashiIndex + part) % 12 : ((rashiIndex + 8) + part) % 12;

      case DivisionalChartType.d12:
        // D12 Dwadashamsha (2.5°): from same sign
        int part = (degInRashi / 2.5).floor().clamp(0, 11);
        return (rashiIndex + part) % 12;

      case DivisionalChartType.d16:
        // D16 Shodashamsha (1.875°): Movable Aries(0), Fixed Leo(4), Dual Sag(8)
        int part = (degInRashi / 1.875).floor().clamp(0, 15);
        int startSign = (rashiIndex % 3) * 4;
        return (startSign + part) % 12;

      case DivisionalChartType.d20:
        // D20 Vimshamsha (1.5°): Movable Aries(0), Fixed Sag(8), Dual Leo(4)
        int part = (degInRashi / 1.5).floor().clamp(0, 19);
        int startSign = (rashiIndex % 3 == 0) ? 0 : (rashiIndex % 3 == 1 ? 8 : 4);
        return (startSign + part) % 12;

      case DivisionalChartType.d24:
        // D24 Siddhamsa (1.25°): Odd from Leo(4), Even from Cancer(3)
        int part = (degInRashi / 1.25).floor().clamp(0, 23);
        return isOddSign ? (4 + part) % 12 : (3 + part) % 12;

      case DivisionalChartType.d27:
        // D27 Bhamsa (10/9°): Fire Aries(0), Earth Cancer(3), Air Libra(6), Water Cap(9)
        int part = (degInRashi / (30.0 / 27.0)).floor().clamp(0, 26);
        int startSign = (rashiIndex % 4) * 3;
        return (startSign + part) % 12;

      case DivisionalChartType.d30:
        // D30 Trimshamsha: classical 5 unequal divisions by planetary rulers
        if (isOddSign) {
          if (degInRashi < 5.0) return 0;   // Mars (Aries)
          if (degInRashi < 10.0) return 10; // Saturn (Aquarius)
          if (degInRashi < 18.0) return 8;  // Jupiter (Sagittarius)
          if (degInRashi < 25.0) return 2;  // Mercury (Gemini)
          return 6;                         // Venus (Libra)
        } else {
          if (degInRashi < 5.0) return 1;   // Venus (Taurus)
          if (degInRashi < 12.0) return 5;  // Mercury (Virgo)
          if (degInRashi < 20.0) return 11; // Jupiter (Pisces)
          if (degInRashi < 25.0) return 9;  // Saturn (Capricorn)
          return 7;                         // Mars (Scorpio)
        }

      case DivisionalChartType.d40:
        // D40 Khavedamsha (0.75°): Odd from Aries(0), Even from Libra(6)
        int part = (degInRashi / 0.75).floor().clamp(0, 39);
        return isOddSign ? (0 + part) % 12 : (6 + part) % 12;

      case DivisionalChartType.d45:
        // D45 Akshavedamsha (2/3°): Movable Aries(0), Fixed Leo(4), Dual Sag(8)
        int part = (degInRashi / (30.0 / 45.0)).floor().clamp(0, 44);
        int startSign = (rashiIndex % 3) * 4;
        return (startSign + part) % 12;

      case DivisionalChartType.d60:
        // D60 Shashtiamsha (0.5°): starts from same sign
        int part = (degInRashi / 0.5).floor().clamp(0, 59);
        return (rashiIndex + part) % 12;
    }
  }

  /// Calculates the Ascendant (Lagna) sign index (0-11) for the given divisional chart.
  static int getLagnaForType(ChartData chartData, DivisionalChartType type) {
    return getSignForLongitude(chartData.ascendant.longitude, type);
  }

  /// Maps planets into their respective sign positions (0-11) for the given divisional chart.
  static Map<int, List<PlanetPosition>> getPlacementsForType(
    ChartData chartData,
    DivisionalChartType type,
  ) {
    final map = <int, List<PlanetPosition>>{};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }

    for (final p in chartData.planets) {
      int targetSign = getSignForLongitude(p.longitude, type);
      map[targetSign]?.add(p);
    }
    return map;
  }
}
