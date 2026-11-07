import { AstroConstants } from '../constants/astroConstants';
import { ChartData, AshtakavargaData, PlanetPosition } from '../models/astroModels';
import { AstroEngine } from './astroEngine';

export interface TransitItem {
  planet: string;
  teluguName: string;
  rashiIndex: number;
  rashiTelugu: string;
  houseFromMoon: number;
  isBenefic: boolean;
  savPoints: number;
  effectTelugu: string;
}

export interface GocharAnalysis {
  transitDate: Date;
  transits: TransitItem[];
  sadeSatiStatus: string;
  guruBalaStatus: string;
}

export class TransitService {
  static calculateGochar(
    natalChart: ChartData,
    transitDate: Date,
    ashtakavarga: AshtakavargaData
  ): GocharAnalysis {
    const moon = natalChart.planets.find(p => p.name === 'Moon') || natalChart.planets[1];
    const moonRashi = moon.rashiIndex;

    // Calculate precise Keplerian Nirayana planetary positions for the transit date
    const currentPlanetPositions = AstroEngine.calculatePlanetLongitudes(transitDate);

    const planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
    const transits: TransitItem[] = [];

    // Classical benefic houses from natal Moon
    const beneficHouses: Record<string, number[]> = {
      Sun: [3, 6, 10, 11],
      Moon: [1, 3, 6, 7, 10, 11],
      Mars: [3, 6, 11],
      Mercury: [2, 4, 6, 8, 10, 11],
      Jupiter: [2, 5, 7, 9, 11],
      Venus: [1, 2, 3, 4, 5, 8, 9, 11, 12],
      Saturn: [3, 6, 11],
      Rahu: [3, 6, 11],
      Ketu: [3, 6, 11],
    };

    let saturnHouseFromMoon = 1;
    let jupiterHouseFromMoon = 1;

    for (const p of planets) {
      const pos = currentPlanetPositions[p] || { longitude: 0, rashiIndex: 0 };
      const rIdx = pos.rashiIndex;
      const hFromMoon = ((rIdx - moonRashi + 12) % 12) + 1;
      const isBenefic = (beneficHouses[p] || []).includes(hFromMoon);
      const savPts = ashtakavarga.sav[rIdx] || 28;

      if (p === 'Saturn') saturnHouseFromMoon = hFromMoon;
      if (p === 'Jupiter') jupiterHouseFromMoon = hFromMoon;

      let effect = isBenefic ? 'అనుకూల శుభ గోచారం' : 'సాధారణ / జాగ్రత్త వహించవలసిన సమయం';
      if (savPts >= 30) effect += ' (SAV బలం అనుకూలం)';

      transits.push({
        planet: p,
        teluguName: AstroConstants.planetNamesTelugu[p] || p,
        rashiIndex: rIdx,
        rashiTelugu: AstroConstants.rashisTelugu[rIdx],
        houseFromMoon: hFromMoon,
        isBenefic,
        savPoints: savPts,
        effectTelugu: effect,
      });
    }

    // Sade Sati Status
    let sadeSati = 'ఏలినాటి శని ప్రభావం లేదు.';
    if (saturnHouseFromMoon === 12) {
      sadeSati = 'ప్రారంభ ఏలినాటి శని (వ్యయ శని - 12వ భావం) నడుస్తున్నది. జాగ్రత్తలు అవసరం.';
    } else if (saturnHouseFromMoon === 1) {
      sadeSati = 'జన్మ శని (మధ్య ఏలినాటి శని - 1వ భావం) నడుస్తున్నది. ప్రతిరోజూ హనుమాన్ చాలీసా పఠించండి.';
    } else if (saturnHouseFromMoon === 2) {
      sadeSati = 'అంత్య ఏలినాటి శని (ధన శని - 2వ భావం) నడుస్తున్నది. వ్యయ నియంత్రణ అవసరం.';
    } else if (saturnHouseFromMoon === 4) {
      sadeSati = 'అర్ధాష్టమ శని (4వ భావం) ప్రభావం ఉన్నది.';
    } else if (saturnHouseFromMoon === 8) {
      sadeSati = 'అష్టమ శని (8వ భావం) ప్రభావం ఉన్నది. శివారాధన శుభకరం.';
    }

    // Guru Bala
    const isGuruBala = [2, 5, 7, 9, 11].includes(jupiterHouseFromMoon);
    const guruBala = isGuruBala
      ? `గురు బలం సంపూర్ణంగా ఉన్నది (${jupiterHouseFromMoon}వ శుభ భావం). వివాహాది శుభకార్యాలకు అత్యంత అనుకూలం.`
      : `గురు బలం సామాన్యంగా ఉన్నది (${jupiterHouseFromMoon}వ భావం). గురువారం శనగలు దానం లేదా గురు ధ్యానం మంచిది.`;

    return {
      transitDate,
      transits,
      sadeSatiStatus: sadeSati,
      guruBalaStatus: guruBala,
    };
  }
}

