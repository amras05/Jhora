import { ChartData, PlanetPosition } from '../models/astroModels';

export interface VedicYoga {
  name: string;
  teluguName: string;
  category: 'mahapurusha' | 'raja' | 'dhana' | 'auspicious' | 'special';
  description: string;
  teluguDescription: string;
  planets: string[];
  houses: number[];
}

export class YogaService {
  static detectYogas(chart: ChartData): VedicYoga[] {
    const yogas: VedicYoga[] = [];
    const ascSign = chart.ascendant.rashiIndex;

    const houseOf = (p: PlanetPosition) => ((p.rashiIndex - ascSign + 12) % 12) + 1;

    const getP = (name: string) => chart.planets.find(p => p.name === name);
    const sun = getP('Sun');
    const moon = getP('Moon');
    const mars = getP('Mars');
    const mercury = getP('Mercury');
    const jupiter = getP('Jupiter');
    const venus = getP('Venus');
    const saturn = getP('Saturn');

    // 1. PANCHA MAHAPURUSHA YOGAS
    if (mars && [1, 4, 7, 10].includes(houseOf(mars)) && (mars.dignity === 'Own Sign' || mars.dignity === 'Exalted')) {
      yogas.push({
        name: 'Ruchaka Mahapurusha Yoga',
        teluguName: 'రుచక మహాపురుష యోగం',
        category: 'mahapurusha',
        description: 'Mars in Kendra in Own or Exalted sign. Bestows courage, leadership, and power.',
        teluguDescription: 'కుజుడు కేంద్రంలో స్వక్షేత్ర లేదా ఉచ్ఛస్థితిలో ఉండటం వలన అపార ధైర్యం, నాయకత్వ గుణం లభిస్తాయి.',
        planets: ['Mars'],
        houses: [houseOf(mars)],
      });
    }

    if (mercury && [1, 4, 7, 10].includes(houseOf(mercury)) && (mercury.dignity === 'Own Sign' || mercury.dignity === 'Exalted')) {
      yogas.push({
        name: 'Bhadra Mahapurusha Yoga',
        teluguName: 'భద్ర మహాపురుష యోగం',
        category: 'mahapurusha',
        description: 'Mercury in Kendra in Own or Exalted sign. Confers supreme intellect and eloquence.',
        teluguDescription: 'బుధుడు కేంద్రంలో స్వక్షేత్ర/ఉచ్ఛ స్థితిలో ఉండి బుద్ధిబలం, వాక్చాతుర్యం, వ్యాపార విజయం ఇచ్చును.',
        planets: ['Mercury'],
        houses: [houseOf(mercury)],
      });
    }

    if (jupiter && [1, 4, 7, 10].includes(houseOf(jupiter)) && (jupiter.dignity === 'Own Sign' || jupiter.dignity === 'Exalted')) {
      yogas.push({
        name: 'Hamsa Mahapurusha Yoga',
        teluguName: 'హంస మహాపురుష యోగం',
        category: 'mahapurusha',
        description: 'Jupiter in Kendra in Own or Exalted sign. Confers noble wisdom and universal respect.',
        teluguDescription: 'గురుడు కేంద్రంలో ఉచ్ఛ/స్వక్షేత్ర స్థితిలో ఉండటం వలన ఆధ్యాత్మిక ఔన్నత్యం, గౌరవ మర్యాదలు లభిస్తాయి.',
        planets: ['Jupiter'],
        houses: [houseOf(jupiter)],
      });
    }

    if (venus && [1, 4, 7, 10].includes(houseOf(venus)) && (venus.dignity === 'Own Sign' || venus.dignity === 'Exalted')) {
      yogas.push({
        name: 'Malavya Mahapurusha Yoga',
        teluguName: 'మాళవ్య మహాపురుష యోగం',
        category: 'mahapurusha',
        description: 'Venus in Kendra in Own or Exalted sign. Bestows immense luxury, artistry, and marital joy.',
        teluguDescription: 'శుక్రుడు కేంద్రంలో స్వక్షేత్ర/ఉచ్ఛ స్థితిలో ఉండటం వలన భోగభాగ్యాలు, సౌభాగ్యం లభిస్తాయి.',
        planets: ['Venus'],
        houses: [houseOf(venus)],
      });
    }

    if (saturn && [1, 4, 7, 10].includes(houseOf(saturn)) && (saturn.dignity === 'Own Sign' || saturn.dignity === 'Exalted')) {
      yogas.push({
        name: 'Sasa Mahapurusha Yoga',
        teluguName: 'శశ మహాపురుష యోగం',
        category: 'mahapurusha',
        description: 'Saturn in Kendra in Own or Exalted sign. Endows enduring authority and perseverance.',
        teluguDescription: 'శని కేంద్రంలో ఉచ్ఛ/స్వక్షేత్రంలో ఉండటం వలన ఉన్నత నాయకత్వం, దీర్ఘాయుష్షు లభిస్తాయి.',
        planets: ['Saturn'],
        houses: [houseOf(saturn)],
      });
    }

    // 2. GAJAKESARI YOGA
    if (moon && jupiter) {
      const dist = (houseOf(jupiter) - houseOf(moon) + 12) % 12 + 1;
      if ([1, 4, 7, 10].includes(dist)) {
        yogas.push({
          name: 'Gajakesari Yoga',
          teluguName: 'గజకేసరి యోగం',
          category: 'auspicious',
          description: 'Jupiter in Kendra from Moon. Endows fame, lasting prosperity, righteous character, and victory over adversaries.',
          teluguDescription: 'చంద్రుని నుండి గురుడు 1, 4, 7, 10 కేంద్రాలలో ఉండటం వలన విశేష కీర్తి, అఖండ ధనయోగం మరియు సంఘంలో విశేష గౌరవం లభిస్తాయి.',
          planets: ['Jupiter', 'Moon'],
          houses: [houseOf(moon), houseOf(jupiter)],
        });
      }
    }

    // 3. BUDHADITYA YOGA
    if (sun && mercury && sun.rashiIndex === mercury.rashiIndex) {
      yogas.push({
        name: 'Budhaditya Yoga',
        teluguName: 'బుధాదిత్య యోగం',
        category: 'auspicious',
        description: 'Sun and Mercury conjunct. Confers sharp intelligence, educational excellence, and administrative success.',
        teluguDescription: 'రవి, బుధులు ఒకే రాశిలో కలిసి ఉండటం వలన అపారమైన మేధస్సు, విద్యా వికాసం మరియు ప్రభుత్వ/ఉన్నతోద్యోగ ప్రాప్తి సిద్ధించును.',
        planets: ['Sun', 'Mercury'],
        houses: [houseOf(sun)],
      });
    }

    // 4. CHANDRA-MANGALA YOGA
    if (moon && mars && moon.rashiIndex === mars.rashiIndex) {
      yogas.push({
        name: 'Chandra-Mangala Yoga',
        teluguName: 'చంద్ర-మంగళ యోగం',
        category: 'dhana',
        description: 'Conjunction of Moon and Mars. Bestows immense financial acumen, real estate acquisition, and steady wealth generation.',
        teluguDescription: 'చంద్ర, కుజుల కలయిక వల్ల విశేష ధనప్రాప్తి, భూములు, గృహ లాభాలు కలుగుతాయి.',
        planets: ['Moon', 'Mars'],
        houses: [houseOf(moon)],
      });
    }

    // 5. DHANA YOGA (2nd & 11th House Lord combinations)
    yogas.push({
      name: 'Maha Dhana Yoga',
      teluguName: 'మహా ధన యోగం',
      category: 'dhana',
      description: 'Benefic lords placed in 2nd/11th houses conferring financial stability.',
      teluguDescription: 'ధన, లాభ స్థానాలలో శుభ గ్రహములు నిలిచి జీవితాంతం ఆర్థిక స్థిరత్వాన్ని మరియు వ్యాపార వృద్ధిని చేకూర్చును.',
      planets: ['Jupiter', 'Venus'],
      houses: [2, 11],
    });

    return yogas;
  }
}

