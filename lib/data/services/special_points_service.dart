import '../../../core/constants/astro_constants.dart';
import '../models/chart_data.dart';

/// Models and calculation service for Vedic Special Points:
/// - Yogi, Duplicate Yogi (Sahayogi), Avayogi Points & Planets
/// - Bhrigu Bindu (Destiny Point)
/// - Jaimini 7 Chara Karakas
/// - Arudha Padas (P1 to P12)
class SpecialPointsResult {
  // Yogi & Avayogi
  final double yogiLongitude;
  final String yogiRashi;
  final String yogiNakshatra;
  final int yogiPada;
  final String yogiPlanet;
  final String sahayogiPlanet;
  final double avayogiLongitude;
  final String avayogiRashi;
  final String avayogiNakshatra;
  final int avayogiPada;
  final String avayogiPlanet;

  // Bhrigu Bindu
  final double bhriguBinduLongitude;
  final String bhriguBinduRashi;
  final double bhriguBinduRashiDeg;
  final String bhriguBinduNakshatra;
  final int bhriguBinduPada;
  final int bhriguBinduHouse;

  // Jaimini Chara Karakas
  final List<JaiminiKaraka> charaKarakas;

  // Arudha Padas
  final List<ArudhaPada> arudhaPadas;

  const SpecialPointsResult({
    required this.yogiLongitude,
    required this.yogiRashi,
    required this.yogiNakshatra,
    required this.yogiPada,
    required this.yogiPlanet,
    required this.sahayogiPlanet,
    required this.avayogiLongitude,
    required this.avayogiRashi,
    required this.avayogiNakshatra,
    required this.avayogiPada,
    required this.avayogiPlanet,
    required this.bhriguBinduLongitude,
    required this.bhriguBinduRashi,
    required this.bhriguBinduRashiDeg,
    required this.bhriguBinduNakshatra,
    required this.bhriguBinduPada,
    required this.bhriguBinduHouse,
    required this.charaKarakas,
    required this.arudhaPadas,
  });
}

class JaiminiKaraka {
  final String nameTelugu;
  final String nameEnglish;
  final String abbreviation;
  final String planetTelugu;
  final String planetEnglish;
  final double degreeInRashi;
  final String rashiTelugu;

  const JaiminiKaraka({
    required this.nameTelugu,
    required this.nameEnglish,
    required this.abbreviation,
    required this.planetTelugu,
    required this.planetEnglish,
    required this.degreeInRashi,
    required this.rashiTelugu,
  });
}

class ArudhaPada {
  final int houseNumber;
  final String code; // P1..P12 / AL, A2..A12
  final String teluguName;
  final String rashiTelugu;
  final int rashiIndex;

  const ArudhaPada({
    required this.houseNumber,
    required this.code,
    required this.teluguName,
    required this.rashiTelugu,
    required this.rashiIndex,
  });
}

class SpecialPointsService {
  SpecialPointsService._();

  static const List<String> _nakshatraLords = [
    'కేతువు', 'శుక్రుడు', 'రవి', 'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురువు', 'శని', 'బుధుడు',
    'కేతువు', 'శుక్రుడు', 'రవి', 'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురువు', 'శని', 'బుధుడు',
    'కేతువు', 'శుక్రుడు', 'రవి', 'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురువు', 'శని', 'బుధుడు',
  ];

  static const List<String> _rashiLords = [
    'కుజుడు', 'శుక్రుడు', 'బుధుడు', 'చంద్రుడు', 'రవి', 'బుధుడు',
    'శుక్రుడు', 'కుజుడు', 'గురువు', 'శని', 'శని', 'గురువు',
  ];

  static SpecialPointsResult calculate(ChartData chart) {
    final sun = chart.getPlanet('Sun');
    final moon = chart.getPlanet('Moon');
    final rahu = chart.getPlanet('Rahu');
    final lagnaLon = chart.ascendant.longitude;

    final sunLon = sun?.longitude ?? 0.0;
    final moonLon = moon?.longitude ?? 0.0;
    final rahuLon = rahu?.longitude ?? 0.0;

    // 1. Yogi Point = (Sun Longitude + Moon Longitude + 93° 20') mod 360°
    // 93° 20' = 93.33333333333333° (Start of Pushya Nakshatra)
    final yogiLon = (sunLon + moonLon + 93.33333333333333) % 360.0;
    final yogiRashiIdx = (yogiLon / 30.0).floor() % 12;
    final yogiNakIdx = (yogiLon / (360.0 / 27.0)).floor() % 27;
    final yogiPada = (((yogiLon % (360.0 / 27.0)) / (360.0 / 108.0)).floor() % 4) + 1;
    final yogiPlanet = _nakshatraLords[yogiNakIdx];
    final sahayogiPlanet = _rashiLords[yogiRashiIdx];

    // 2. Avayogi Point = 6th Nakshatra from Yogi Nakshatra
    // Avayogi Lon = (Yogi Lon + 186° 40') mod 360°
    final avayogiLon = (yogiLon + 186.66666666666666) % 360.0;
    final avayogiRashiIdx = (avayogiLon / 30.0).floor() % 12;
    final avayogiNakIdx = (yogiNakIdx + 5) % 27; // 6th counting inclusive
    final avayogiPada = (((avayogiLon % (360.0 / 27.0)) / (360.0 / 108.0)).floor() % 4) + 1;
    final avayogiPlanet = _nakshatraLords[avayogiNakIdx];

    // 3. Bhrigu Bindu (Destiny Point) = Rahu to Moon Midpoint
    final forwardArc = (moonLon - rahuLon + 360.0) % 360.0;
    final bbLon = (rahuLon + forwardArc / 2.0) % 360.0;
    final bbRashiIdx = (bbLon / 30.0).floor() % 12;
    final bbRashiDeg = bbLon % 30.0;
    final bbNakIdx = (bbLon / (360.0 / 27.0)).floor() % 27;
    final bbPada = (((bbLon % (360.0 / 27.0)) / (360.0 / 108.0)).floor() % 4) + 1;
    final lagnaRashiIdx = (lagnaLon / 30.0).floor() % 12;
    final bbHouse = ((bbRashiIdx - lagnaRashiIdx + 12) % 12) + 1;

    // 4. Jaimini 7 Chara Karakas (7 physical planets sorted by deg in rashi descending)
    final candidatePlanets = chart.planets.where((p) =>
      ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'].contains(p.name)
    ).toList();

    candidatePlanets.sort((a, b) => (b.longitude % 30.0).compareTo(a.longitude % 30.0));

    final karakaNames = [
      ('ఆత్మ కారకము (ఆత్మ)', 'Atma Karaka', 'AK'),
      ('అమాత్య కారకము (తెలివైన)', 'Amatya Karaka', 'AmK'),
      ('భ్రాతృ కారకము (తోడబుట్టిన)', 'Bhratri Karaka', 'BK'),
      ('మాతృ కారకము (తల్లి)', 'Matri Karaka', 'MK'),
      ('పుత్ర కారకము (సంతానము)', 'Putra Karaka', 'PK'),
      ('జ్ఞాతి కారకము (దగ్గర బంధువులు)', 'Gnati Karaka', 'GK'),
      ('దార కారకము (జీవిత భాగస్వామి)', 'Dara Karaka', 'DK'),
    ];

    final charaKarakas = <JaiminiKaraka>[];
    for (int i = 0; i < candidatePlanets.length && i < karakaNames.length; i++) {
      final p = candidatePlanets[i];
      final rIdx = (p.longitude / 30.0).floor() % 12;
      charaKarakas.add(JaiminiKaraka(
        nameTelugu: karakaNames[i].$1,
        nameEnglish: karakaNames[i].$2,
        abbreviation: karakaNames[i].$3,
        planetTelugu: AstroConstants.planetNamesTelugu[p.name] ?? p.name,
        planetEnglish: p.name,
        degreeInRashi: p.longitude % 30.0,
        rashiTelugu: AstroConstants.rashisTelugu[rIdx],
      ));
    }

    // 5. Arudha Padas (P1 to P12)
    final padaTitles = [
      'లగ్న పాదము (ఆరూఢ లగ్నము - AL)',
      'ధనారూఢ పాదము (కోశారూఢ - A2)',
      'విక్రమ / భ్రాతృ పాదము (A3)',
      'మాతృ పాదము (సుఖారూఢ - A4)',
      'మంత్ర / పుత్ర పాదము (A5)',
      'రోగ / శత్రు పాదము (A6)',
      'దార / కళత్ర పాదము (దారారూఢ - A7)',
      'మృత్యు / ఆయువు పాదము (A8)',
      'పితృ / భాగ్య పాదము (భాగ్యారూఢ - A9)',
      'కర్మ / రాజ్య పాదము (రాజ్యారూఢ - A10)',
      'లాభ / అయ పాదము (లాభారూఢ - A11)',
      'వ్యయ / ఉప పాదము (ఉపపదము - UL / A12)',
    ];

    final arudhaPadas = <ArudhaPada>[];
    for (int h = 1; h <= 12; h++) {
      final houseSignIdx = (lagnaRashiIdx + h - 1) % 12;
      final lordName = _rashiLords[houseSignIdx];
      final lordEnglish = _englishPlanetName(lordName);
      final lordPlanet = chart.planets.firstWhere(
        (p) => p.name.toLowerCase() == lordEnglish.toLowerCase(),
        orElse: () => chart.planets.first,
      );
      final lordSignIdx = (lordPlanet.longitude / 30.0).floor() % 12;
      final dist = (lordSignIdx - houseSignIdx + 12) % 12;
      int padaSignIdx = (lordSignIdx + dist) % 12;

      // Jaimini exception rules for Arudha:
      // If pada falls in same house, jump 10 houses (+9)
      if (padaSignIdx == houseSignIdx) {
        padaSignIdx = (houseSignIdx + 9) % 12;
      } else if (padaSignIdx == (houseSignIdx + 6) % 12) {
        // If falls in 7th house, jump 10 houses (+9)
        padaSignIdx = (houseSignIdx + 6 + 9) % 12;
      }

      arudhaPadas.add(ArudhaPada(
        houseNumber: h,
        code: 'P$h',
        teluguName: padaTitles[h - 1],
        rashiTelugu: AstroConstants.rashisTelugu[padaSignIdx],
        rashiIndex: padaSignIdx,
      ));
    }

    return SpecialPointsResult(
      yogiLongitude: yogiLon,
      yogiRashi: AstroConstants.rashisTelugu[yogiRashiIdx],
      yogiNakshatra: AstroConstants.nakshatrasTelugu[yogiNakIdx],
      yogiPada: yogiPada,
      yogiPlanet: yogiPlanet,
      sahayogiPlanet: sahayogiPlanet,
      avayogiLongitude: avayogiLon,
      avayogiRashi: AstroConstants.rashisTelugu[avayogiRashiIdx],
      avayogiNakshatra: AstroConstants.nakshatrasTelugu[avayogiNakIdx],
      avayogiPada: avayogiPada,
      avayogiPlanet: avayogiPlanet,
      bhriguBinduLongitude: bbLon,
      bhriguBinduRashi: AstroConstants.rashisTelugu[bbRashiIdx],
      bhriguBinduRashiDeg: bbRashiDeg,
      bhriguBinduNakshatra: AstroConstants.nakshatrasTelugu[bbNakIdx],
      bhriguBinduPada: bbPada,
      bhriguBinduHouse: bbHouse,
      charaKarakas: charaKarakas,
      arudhaPadas: arudhaPadas,
    );
  }

  static String _englishPlanetName(String telugu) {
    switch (telugu) {
      case 'రవి': return 'Sun';
      case 'చంద్రుడు': return 'Moon';
      case 'కుజుడు': return 'Mars';
      case 'బుధుడు': return 'Mercury';
      case 'గురువు': return 'Jupiter';
      case 'శుక్రుడు': return 'Venus';
      case 'శని': return 'Saturn';
      case 'రాహువు': return 'Rahu';
      case 'కేతువు': return 'Ketu';
      default: return 'Sun';
    }
  }
}
