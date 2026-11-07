/**
 * Copyright (C) 2024-2026 Karrthikeya Sarma (SBJV Hora Team)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

import { AstroConstants } from '../constants/astroConstants';
import { ChartData, DivisionalChartType, PlanetPosition } from '../models/astroModels';

export class DivisionalChartService {
  static getDivisionalTitle(type: DivisionalChartType): string {
    switch (type) {
      case DivisionalChartType.d1: return 'D1 రాశి చక్రము (Rasi - Body & General Life)';
      case DivisionalChartType.d2: return 'D2 హోరా చక్రము (Hora - Wealth & Prosperity)';
      case DivisionalChartType.d3: return 'D3 ద్రేక్కాణ చక్రము (Drekkana - Siblings & Courage)';
      case DivisionalChartType.d4: return 'D4 చతుర్థాంశ చక్రము (Chaturthamsha - Assets & Fortune)';
      case DivisionalChartType.d7: return 'D7 సప్తాంశ చక్రము (Saptamsha - Progeny & Children)';
      case DivisionalChartType.d9: return 'D9 నవాంశ చక్రము (Navamsha - Dharma, Spouse & Destiny)';
      case DivisionalChartType.d10: return 'D10 దశాంశ చక్రము (Dashamsha - Career, Honors & Status)';
      case DivisionalChartType.d12: return 'D12 ద్వాదశాంశ చక్రము (Dwadashamsha - Parents & Ancestry)';
      case DivisionalChartType.d16: return 'D16 షోడశాంశ చక్రము (Shodashamsha - Vehicles & Luxuries)';
      case DivisionalChartType.d20: return 'D20 వింశాంశ చక్రము (Vimshamsha - Spirituality & Upasana)';
      case DivisionalChartType.d24: return 'D24 చతుర్వింశాంశ చక్రము (Siddhamsha - Higher Learning)';
      case DivisionalChartType.d27: return 'D27 సప్తవింశాంశ చక్రము (Bhamsha - Strength & Vulnerabilities)';
      case DivisionalChartType.d30: return 'D30 త్రింశాంశ చక్రము (Trimshamsha - Misfortunes & Arishta)';
      case DivisionalChartType.d40: return 'D40 ఖవేదాంశ చక్రము (Khavedamsha - Auspicious Results)';
      case DivisionalChartType.d45: return 'D45 అక్షవేదాంశ చక్రము (Akshavedamsha - All Character Qualities)';
      case DivisionalChartType.d60: return 'D60 షష్ట్యంశ చక్రము (Shashtiamsha - All Life Results & Karma)';
    }
  }

  static getDivisionalCenterName(type: DivisionalChartType): string {
    switch (type) {
      case DivisionalChartType.d1: return 'రాశి (D1)';
      case DivisionalChartType.d2: return 'హోరా (D2)';
      case DivisionalChartType.d3: return 'ద్రేక్కాణ (D3)';
      case DivisionalChartType.d4: return 'చతుర్థాంశ (D4)';
      case DivisionalChartType.d7: return 'సప్తాంశ (D7)';
      case DivisionalChartType.d9: return 'నవాంశ (D9)';
      case DivisionalChartType.d10: return 'దశాంశ (D10)';
      case DivisionalChartType.d12: return 'ద్వాదశాంశ (D12)';
      case DivisionalChartType.d16: return 'షోడశాంశ (D16)';
      case DivisionalChartType.d20: return 'వింశాంశ (D20)';
      case DivisionalChartType.d24: return 'చతుర్వింశాంశ (D24)';
      case DivisionalChartType.d27: return 'సప్తవింశాంశ (D27)';
      case DivisionalChartType.d30: return 'త్రింశాంశ (D30)';
      case DivisionalChartType.d40: return 'ఖవేదాంశ (D40)';
      case DivisionalChartType.d45: return 'అక్షవేదాంశ (D45)';
      case DivisionalChartType.d60: return 'షష్ట్యంశ (D60)';
    }
  }

  static getDivisionalSignificance(type: DivisionalChartType): string {
    switch (type) {
      case DivisionalChartType.d1: return 'శరీరము & సమగ్ర జీవితం';
      case DivisionalChartType.d2: return 'సంపద, కుటుంబం & ధనయోగం';
      case DivisionalChartType.d3: return 'సోదరులు, పరాక్రమం & ధైర్యం';
      case DivisionalChartType.d4: return 'స్థిరాస్తులు, వాహనాలు, గృహం';
      case DivisionalChartType.d7: return 'సంతానం, వంశవృద్ధి & మనవళ్లు';
      case DivisionalChartType.d9: return 'ధర్మం, కళత్రం (భార్య/భర్త) & భాగ్యం';
      case DivisionalChartType.d10: return 'కీర్తి, ప్రతిష్ట, ఉద్యోగం & వృత్తి';
      case DivisionalChartType.d12: return 'తల్లిదండ్రులు & పితృ రుణాలు';
      case DivisionalChartType.d16: return 'సుఖ-సంతోషాలు, శ్రేయస్సు, వాహనాలు';
      case DivisionalChartType.d20: return 'ఉపాసన, దైవభక్తి & ఆధ్యాత్మికత';
      case DivisionalChartType.d24: return 'విద్యాభ్యాసం, జ్ఞానం, మేధస్సు';
      case DivisionalChartType.d27: return 'బలాబలాలు, సహజ లక్షణాలు';
      case DivisionalChartType.d30: return 'అరిష్టాలు, రోగాలు & పాపఫలితాలు';
      case DivisionalChartType.d40: return 'శుభాశుభ ఫలాలు, ఉత్తమ గుణాలు';
      case DivisionalChartType.d45: return 'సమగ్ర నడవడిక, ప్రవర్తన, పుణ్యం';
      case DivisionalChartType.d60: return 'సర్వకర్మలు, పూర్వజన్మ సంచితం';
    }
  }

  /**
   * Calculates the sign index (0-11) for a given longitude in a specific divisional chart type.
   */
  static calculateVargaSign(longitude: number, type: DivisionalChartType): number {
    const norm = ((longitude % 360.0) + 360.0) % 360.0;
    const rashi = Math.floor(norm / 30.0);
    const degInRashi = norm - rashi * 30.0;
    const isOdd = rashi % 2 === 0; // Aries=0 (odd sign in astrology 1st), Taurus=1 (even)

    switch (type) {
      case DivisionalChartType.d1:
        return rashi;

      case DivisionalChartType.d2: {
        // Hora: 15 deg per part.
        // In odd signs: first 15 Sun (Leo=4), second 15 Moon (Cancer=3).
        // In even signs: first 15 Moon (Cancer=3), second 15 Sun (Leo=4).
        const firstHalf = degInRashi < 15.0;
        return isOdd ? (firstHalf ? 4 : 3) : (firstHalf ? 3 : 4);
      }

      case DivisionalChartType.d3: {
        // Drekkana: 10 deg per part.
        // Part 1: same sign, Part 2: 5th sign, Part 3: 9th sign.
        const part = Math.floor(degInRashi / 10.0);
        return (rashi + part * 4) % 12;
      }

      case DivisionalChartType.d4: {
        // Chaturthamsha: 7.5 deg per part.
        // Part 1: same sign, Part 2: 4th, Part 3: 7th, Part 4: 10th.
        const part = Math.floor(degInRashi / 7.5);
        return (rashi + part * 3) % 12;
      }

      case DivisionalChartType.d7: {
        // Saptamsha: 30/7 = 4.2857 deg per part.
        // Odd signs start from same sign; Even signs start from 7th sign.
        const part = Math.floor(degInRashi / (30.0 / 7.0));
        const startSign = isOdd ? rashi : (rashi + 6) % 12;
        return (startSign + part) % 12;
      }

      case DivisionalChartType.d9: {
        // Navamsha: 3°20' (3.3333°) per part.
        // Fire signs (0,4,8) start from Aries (0).
        // Earth signs (1,5,9) start from Capricorn (9).
        // Air signs (2,6,10) start from Libra (6).
        // Water signs (3,7,11) start from Cancer (3).
        const part = Math.floor(degInRashi / (30.0 / 9.0));
        let baseSign = 0;
        if ([0, 4, 8].includes(rashi)) baseSign = 0;
        else if ([1, 5, 9].includes(rashi)) baseSign = 9;
        else if ([2, 6, 10].includes(rashi)) baseSign = 6;
        else baseSign = 3;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d10: {
        // Dashamsha: 3 deg per part.
        // Odd signs start from same sign; Even signs start from 9th sign.
        const part = Math.floor(degInRashi / 3.0);
        const startSign = isOdd ? rashi : (rashi + 8) % 12;
        return (startSign + part) % 12;
      }

      case DivisionalChartType.d12: {
        // Dwadashamsha: 2.5 deg per part.
        // Starts from the same sign and counts forward.
        const part = Math.floor(degInRashi / 2.5);
        return (rashi + part) % 12;
      }

      case DivisionalChartType.d16: {
        // Shodashamsha: 1.875 deg per part.
        // Moveable signs (0,3,6,9) start from Aries (0).
        // Fixed signs (1,4,7,10) start from Leo (4).
        // Dual signs (2,5,8,11) start from Sagittarius (8).
        const part = Math.floor(degInRashi / (30.0 / 16.0));
        let baseSign = 0;
        if ([0, 3, 6, 9].includes(rashi)) baseSign = 0;
        else if ([1, 4, 7, 10].includes(rashi)) baseSign = 4;
        else baseSign = 8;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d20: {
        // Vimshamsha: 1.5 deg per part.
        // Moveable signs start from Aries (0), Fixed from Sagittarius (8), Dual from Leo (4).
        const part = Math.floor(degInRashi / 1.5);
        let baseSign = 0;
        if ([0, 3, 6, 9].includes(rashi)) baseSign = 0;
        else if ([1, 4, 7, 10].includes(rashi)) baseSign = 8;
        else baseSign = 4;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d24: {
        // Chaturvimshamsha: 1.25 deg per part.
        // Odd signs start from Leo (4); Even signs start from Cancer (3).
        const part = Math.floor(degInRashi / 1.25);
        const baseSign = isOdd ? 4 : 3;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d27: {
        // Saptavimshamsha: 30/27 = 1.1111 deg per part.
        // Fire signs start from Aries (0), Earth from Cancer (3), Air from Libra (6), Water from Capricorn (9).
        const part = Math.floor(degInRashi / (30.0 / 27.0));
        let baseSign = 0;
        if ([0, 4, 8].includes(rashi)) baseSign = 0;
        else if ([1, 5, 9].includes(rashi)) baseSign = 3;
        else if ([2, 6, 10].includes(rashi)) baseSign = 6;
        else baseSign = 9;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d30: {
        // Trimshamsha (Parashara):
        // Odd signs: 0-5° Mars (Aries=0), 5-10° Saturn (Aquarius=10), 10-18° Jupiter (Sagittarius=8), 18-25° Mercury (Gemini=2), 25-30° Venus (Libra=6).
        // Even signs: 0-5° Venus (Taurus=1), 5-12° Mercury (Virgo=5), 12-20° Jupiter (Pisces=11), 20-25° Saturn (Capricorn=9), 25-30° Mars (Scorpio=7).
        if (isOdd) {
          if (degInRashi < 5.0) return 0;
          if (degInRashi < 10.0) return 10;
          if (degInRashi < 18.0) return 8;
          if (degInRashi < 25.0) return 2;
          return 6; // Libra (was 1 Taurus)
        } else {
          if (degInRashi < 5.0) return 1;
          if (degInRashi < 12.0) return 5;
          if (degInRashi < 20.0) return 11;
          if (degInRashi < 25.0) return 9;
          return 7;
        }
      }

      case DivisionalChartType.d40: {
        // Khavedamsha: 0.75 deg per part (40 divisions).
        // Odd signs start from Aries (0); Even signs start from Libra (6).
        const part = Math.floor(degInRashi / 0.75);
        const baseSign = isOdd ? 0 : 6;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d45: {
        // Akshavedamsha: 30/45 = 0.6666 deg per part.
        // Moveable start from Aries (0), Fixed from Leo (4), Dual from Sagittarius (8).
        const part = Math.floor(degInRashi / (30.0 / 45.0));
        let baseSign = 0;
        if ([0, 3, 6, 9].includes(rashi)) baseSign = 0;
        else if ([1, 4, 7, 10].includes(rashi)) baseSign = 4;
        else baseSign = 8;
        return (baseSign + part) % 12;
      }

      case DivisionalChartType.d60: {
        // Shashtiamsha: 0.5 deg per part (60 divisions).
        // Starts from the sign itself and counts forward by (part % 12).
        const part = Math.floor(degInRashi / 0.5);
        return (rashi + part) % 12;
      }
    }
  }

  static getPlacementsForType(chart: ChartData, type: DivisionalChartType): Record<number, PlanetPosition[]> {
    const placements: Record<number, PlanetPosition[]> = {};
    for (let i = 0; i < 12; i++) placements[i] = [];

    for (const p of chart.planets) {
      const s = this.calculateVargaSign(p.longitude, type);
      placements[s].push(p);
    }
    return placements;
  }

  static getLagnaForType(chart: ChartData, type: DivisionalChartType): number {
    return this.calculateVargaSign(chart.ascendant.longitude, type);
  }
}

