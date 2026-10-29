import '../models/chart_data.dart';
import '../models/birth_data.dart';
import 'astro_engine.dart';
import 'ashtakavarga_service.dart';

class SinglePlanetTransit {
  final String planetName;
  final int natalRashi;
  final int transitRashi;
  final double transitLongitude;
  final int houseFromMoon;
  final int houseFromLagna;
  final bool isFavorable;
  final int savPoints;
  final String effect;
  final String teluguEffect;

  const SinglePlanetTransit({
    required this.planetName,
    required this.natalRashi,
    required this.transitRashi,
    required this.transitLongitude,
    required this.houseFromMoon,
    required this.houseFromLagna,
    required this.isFavorable,
    required this.savPoints,
    required this.effect,
    required this.teluguEffect,
  });
}

class SadeSatiStatus {
  final bool isActive;
  final String phase;
  final String teluguPhase;
  final int saturnHouseFromMoon;
  final String description;
  final String teluguDescription;

  const SadeSatiStatus({
    required this.isActive,
    required this.phase,
    required this.teluguPhase,
    required this.saturnHouseFromMoon,
    required this.description,
    required this.teluguDescription,
  });
}

class GocharAnalysis {
  final DateTime transitDate;
  final List<SinglePlanetTransit> transits;
  final SadeSatiStatus sadeSati;
  final bool isKantakaShani;
  final bool isAshtamaShani;
  final int overallFavorableCount;

  const GocharAnalysis({
    required this.transitDate,
    required this.transits,
    required this.sadeSati,
    required this.isKantakaShani,
    required this.isAshtamaShani,
    required this.overallFavorableCount,
  });
}

/// 100% Classical Vedic Gochar (Transit) Analysis Service
class TransitService {
  TransitService._();

  static const Map<String, List<int>> _beneficTransitHouses = {
    'Sun': [3, 6, 10, 11],
    'Moon': [1, 3, 6, 7, 10, 11],
    'Mars': [3, 6, 11],
    'Mercury': [2, 4, 6, 8, 10, 11],
    'Jupiter': [2, 5, 7, 9, 11],
    'Venus': [1, 2, 3, 4, 5, 8, 9, 11, 12],
    'Saturn': [3, 6, 11],
    'Rahu': [3, 6, 10, 11],
    'Ketu': [3, 6, 11],
  };

  static GocharAnalysis calculateGochar({
    required ChartData natalChart,
    required DateTime transitDate,
    required AshtakavargaData ashtakavarga,
  }) {
    final transitBirthData = BirthData(
      name: 'Transit',
      dateTime: transitDate,
      latitude: natalChart.birthData.latitude,
      longitude: natalChart.birthData.longitude,
      timezone: natalChart.birthData.timezone,
      placeName: natalChart.birthData.placeName,
    );

    final transitChart = AstroEngine.calculateChart(transitBirthData);

    final moon = natalChart.getPlanet('Moon');
    final natalMoonSign = moon?.rashiIndex ?? 0;
    final natalLagnaSign = natalChart.ascendant.rashiIndex;

    final transits = <SinglePlanetTransit>[];
    int favorableCount = 0;

    for (final tp in transitChart.planets) {
      final np = natalChart.getPlanet(tp.name);
      final natalSign = np?.rashiIndex ?? 0;

      final hFromMoon = ((tp.rashiIndex - natalMoonSign + 12) % 12) + 1;
      final hFromLagna = ((tp.rashiIndex - natalLagnaSign + 12) % 12) + 1;

      final benefics = _beneficTransitHouses[tp.name] ?? [3, 6, 11];
      final isFav = benefics.contains(hFromMoon);
      if (isFav) favorableCount++;

      final savPts = ashtakavarga.sav[tp.rashiIndex % 12];

      transits.add(SinglePlanetTransit(
        planetName: tp.name,
        natalRashi: natalSign,
        transitRashi: tp.rashiIndex,
        transitLongitude: tp.longitude,
        houseFromMoon: hFromMoon,
        houseFromLagna: hFromLagna,
        isFavorable: isFav,
        savPoints: savPts,
        effect: isFav ? 'Favorable transit in house $hFromMoon from Moon' : 'Challenging transit in house $hFromMoon from Moon',
        teluguEffect: isFav ? 'చంద్రుడి నుండి $hFromMoonవ స్థానంలో అనుకూల గోచారం' : 'చంద్రుడి నుండి $hFromMoonవ స్థానంలో ప్రతికూల గోచారం',
      ));
    }

    final transitSaturn = transitChart.getPlanet('Saturn');
    final saturnSign = transitSaturn?.rashiIndex ?? 0;
    final saturnHouseFromMoon = ((saturnSign - natalMoonSign + 12) % 12) + 1;

    SadeSatiStatus sadeSati;
    if (saturnHouseFromMoon == 12) {
      sadeSati = const SadeSatiStatus(
        isActive: true,
        phase: '1st Phase (Rising / 12th House)',
        teluguPhase: 'మొదటి దశ (ఆరంభ ఏలినాటి శని - 12వ స్థానం)',
        saturnHouseFromMoon: 12,
        description: 'Saturn in 12th from Moon. Increased expenditure, mental shifts, and new restructuring.',
        teluguDescription: 'వ్యయ శని: ఖర్చులు పెరుగుట, దూర ప్రయాణాలు, ఆలోచనలలో మార్పులు.',
      );
    } else if (saturnHouseFromMoon == 1) {
      sadeSati = const SadeSatiStatus(
        isActive: true,
        phase: '2nd Phase (Peak / Janma Shani)',
        teluguPhase: 'రెండవ దశ (జన్మ శని - శిఖరాగ్ర దశ)',
        saturnHouseFromMoon: 1,
        description: 'Saturn conjunct Natal Moon. High discipline required, profound inner maturity, and life foundation work.',
        teluguDescription: 'జన్మ శని: శరీర శ్రమ, మానసిక ఒత్తిడి, క్రమశిక్షణతో కూడిన పనుల ద్వారా విజయం.',
      );
    } else if (saturnHouseFromMoon == 2) {
      sadeSati = const SadeSatiStatus(
        isActive: true,
        phase: '3rd Phase (Setting / 2nd House)',
        teluguPhase: 'మూడవ దశ (ముగింపు ఏలినాటి శని - 2వ స్థానం)',
        saturnHouseFromMoon: 2,
        description: 'Saturn in 2nd from Moon. Financial rebuilding, family stabilization, and steady recovery.',
        teluguDescription: 'ద్వితీయ శని: ఆర్థిక స్థిరత్వం, కుటుంబ బాధ్యతలు, సమస్యల నుండి క్రమేపీ ఉపశమనం.',
      );
    } else {
      sadeSati = const SadeSatiStatus(
        isActive: false,
        phase: 'No Sade Sati',
        teluguPhase: 'ప్రస్తుతం ఏలినాటి శని లేదు',
        saturnHouseFromMoon: 0,
        description: 'Saturn is currently in a neutral or favorable transit.',
        teluguDescription: 'శని ప్రస్తుతం అనుకూల లేదా సాధారణ గోచారంలో ఉన్నారు.',
      );
    }

    final isKantaka = (saturnHouseFromMoon == 4);
    final isAshtama = (saturnHouseFromMoon == 8);

    return GocharAnalysis(
      transitDate: transitDate,
      transits: transits,
      sadeSati: sadeSati,
      isKantakaShani: isKantaka,
      isAshtamaShani: isAshtama,
      overallFavorableCount: favorableCount,
    );
  }
}
