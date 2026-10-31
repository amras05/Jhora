import { ChartData, DoshaAnalysis } from '../models/astroModels';

export class DoshaService {
  static analyze(chart: ChartData): DoshaAnalysis {
    const ascSign = chart.ascendant.rashiIndex;
    const houseOf = (rashiIndex: number) => ((rashiIndex - ascSign + 12) % 12) + 1;

    const mars = chart.planets.find(p => p.name === 'Mars');
    const moon = chart.planets.find(p => p.name === 'Moon');
    const venus = chart.planets.find(p => p.name === 'Venus');
    const rahu = chart.planets.find(p => p.name === 'Rahu');
    const ketu = chart.planets.find(p => p.name === 'Ketu');

    // KUJA DOSHA
    let hasKuja = false;
    let kujaDesc = 'కుజ దోషం లేదు. దాంపత్య జీవితం అనుకూలం.';
    if (mars) {
      const hFromAsc = houseOf(mars.rashiIndex);
      const hFromMoon = moon ? ((mars.rashiIndex - moon.rashiIndex + 12) % 12) + 1 : 1;
      const hFromVenus = venus ? ((mars.rashiIndex - venus.rashiIndex + 12) % 12) + 1 : 1;

      const doshaHouses = [1, 2, 4, 7, 8, 12];
      if (doshaHouses.includes(hFromAsc) || doshaHouses.includes(hFromMoon) || doshaHouses.includes(hFromVenus)) {
        hasKuja = true;
        kujaDesc = `కుజుడు లగ్నం నుండి ${hFromAsc}వ భావంలో ఉన్నందున సాధారణ కుజ దోషం ఏర్పడినది. అయితే కుజుడు స్వక్షేత్ర లేదా మిత్ర క్షేత్రంలో ఉన్నచో దోష నివృత్తి కలదు.`;
      }
    }

    // KAAL SARPA DOSHA
    let hasKaalSarpa = false;
    let kaalSarpaType = 'దోషం లేదు';
    let kaalSarpaDesc = 'గ్రహములన్నీ రాహు-కేతువుల మధ్య బంధింపబడలేదు. కాలసర్ప దోషం లేదు.';

    if (rahu && ketu) {
      const rahuLon = rahu.longitude;
      const ketuLon = ketu.longitude;

      let side1Count = 0;
      let side2Count = 0;
      const otherPlanets = chart.planets.filter(p => p.name !== 'Rahu' && p.name !== 'Ketu');

      for (const p of otherPlanets) {
        const dRahu = (p.longitude - rahuLon + 360) % 360;
        if (dRahu < 180) {
          side1Count++;
        } else {
          side2Count++;
        }
      }

      if (side1Count === otherPlanets.length || side2Count === otherPlanets.length) {
        hasKaalSarpa = true;
        const rahuHouse = houseOf(rahu.rashiIndex);
        const typesTelugu = [
          'అనంత కాలసర్ప దోషం (1వ భావం)',
          'కుళిక కాలసర్ప దోషం (2వ భావం)',
          'వాసుకి కాలసర్ప దోషం (3వ భావం)',
          'శంఖపాల కాలసర్ప దోషం (4వ భావం)',
          'పద్మ కాలసర్ప దోషం (5వ భావం)',
          'మహా పద్మ కాలసర్ప దోషం (6వ భావం)',
          'తక్షక కాలసర్ప దోషం (7వ భావం)',
          'కర్కోటక కాలసర్ప దోషం (8వ భావం)',
          'శంఖచూడ కాలసర్ప దోషం (9వ భావం)',
          'ఘాతక కాలసర్ప దోషం (10వ భావం)',
          'విషధర కాలసర్ప దోషం (11వ భావం)',
          'శేషనాగ కాలసర్ప దోషం (12వ భావం)',
        ];
        kaalSarpaType = typesTelugu[(rahuHouse - 1) % 12];
        kaalSarpaDesc = `సమస్త గ్రహములు రాహు-కేతువుల మధ్య స్థితమై ఉన్నందున పూర్ణ కాలసర్ప యోగం ఏర్పడినది (${kaalSarpaType}).`;
      }
    }

    return {
      kujaDosha: {
        hasDosha: hasKuja,
        description: kujaDesc,
      },
      kaalSarpa: {
        hasDosha: hasKaalSarpa,
        teluguTypeName: kaalSarpaType,
        description: kaalSarpaDesc,
      },
    };
  }
}

