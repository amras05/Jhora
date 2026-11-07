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

    // KUJA DOSHA (Classical Parashara)
    let hasKuja = false;
    let kujaDesc = 'కుజ దోషం లేదు. దాంపత్య జీవితం అనుకూలం.';
    if (mars) {
      const hFromAsc = houseOf(mars.rashiIndex);
      const hFromMoon = moon ? ((mars.rashiIndex - moon.rashiIndex + 12) % 12) + 1 : 1;
      const hFromVenus = venus ? ((mars.rashiIndex - venus.rashiIndex + 12) % 12) + 1 : 1;

      const doshaHouses = [1, 2, 4, 7, 8, 12];
      const triggers: string[] = [];
      if (doshaHouses.includes(hFromAsc)) triggers.push(`లగ్నం నుండి ${hFromAsc}వ స్థానం`);
      if (doshaHouses.includes(hFromMoon)) triggers.push(`చంద్రుని నుండి ${hFromMoon}వ స్థానం`);
      if (doshaHouses.includes(hFromVenus)) triggers.push(`శుక్రుని నుండి ${hFromVenus}వ స్థానం`);

      if (triggers.length > 0) {
        // Classical Cancellations (కుజ దోష నివృత్తి సూత్రములు)
        // 1. Mars in own signs (Aries=0, Scorpio=7) or exalted (Capricorn=9)
        const isOwnOrExalted = mars.rashiIndex === 0 || mars.rashiIndex === 7 || mars.rashiIndex === 9;
        // 2. Mars in Aries in 1st, Scorpio in 4th, Capricorn in 7th, Leo/Aquarius in 8th, Sagittarius/Pisces in 12th
        const isSpecificExemption =
          (hFromAsc === 1 && mars.rashiIndex === 0) ||
          (hFromAsc === 4 && mars.rashiIndex === 7) ||
          (hFromAsc === 7 && mars.rashiIndex === 9) ||
          (hFromAsc === 8 && (mars.rashiIndex === 4 || mars.rashiIndex === 10)) ||
          (hFromAsc === 12 && (mars.rashiIndex === 8 || mars.rashiIndex === 11));
        // 3. Jupiter conjunction or aspect on Mars (Guru Drishti)
        const jupiter = chart.planets.find(p => p.name === 'Jupiter');
        const jupDist = jupiter ? ((mars.rashiIndex - jupiter.rashiIndex + 12) % 12) : -1;
        const hasJupiterAspect = jupDist === 0 || jupDist === 4 || jupDist === 6 || jupDist === 8;

        if (isOwnOrExalted || isSpecificExemption || hasJupiterAspect) {
          hasKuja = false;
          let reason = isOwnOrExalted ? 'కుజుడు స్వక్షేత్రం/ఉచ్ఛ క్షేత్రంలో ఉన్నందున' : '';
          if (isSpecificExemption) reason = 'కుజుడు శుభ క్షేత్ర విశేష స్థానంలో ఉన్నందున';
          if (hasJupiterAspect) reason = 'దేవగురువు బృహస్పతి పవిత్ర దృష్టి లేదా సంయోగం ఉన్నందున';
          kujaDesc = `కుజుడు ${triggers.join(', ')}లో స్థితమైనప్పటికీ, ${reason} శాస్త్రోక్త కుజ దోష నివృత్తి (దోష భంగం) జరిగినది. దాంపత్యం శుభప్రదం.`;
        } else {
          hasKuja = true;
          kujaDesc = `కుజుడు ${triggers.join(', ')}లో స్థితమై ఉన్నందున సాధారణ కుజ దోషం ఏర్పడినది. నివారణకు సుబ్రహ్మణ్యేశ్వర స్వామి లేదా ఆంజనేయ స్వామి ఆరాధన శ్రేయస్కరం.`;
        }
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

