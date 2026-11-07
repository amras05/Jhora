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

import { ChartData, AshtakavargaData } from '../models/astroModels';

export class AshtakavargaService {
  private static readonly sunRules: Record<string, number[]> = {
    Sun: [1, 2, 4, 7, 8, 9, 10, 11],
    Moon: [3, 6, 10, 11],
    Mars: [1, 2, 4, 7, 8, 9, 10, 11],
    Mercury: [3, 5, 6, 9, 10, 11, 12],
    Jupiter: [5, 6, 9, 11],
    Venus: [6, 7, 12],
    Saturn: [1, 2, 4, 7, 8, 9, 10, 11],
    Ascendant: [3, 4, 6, 10, 11, 12],
  };

  private static readonly moonRules: Record<string, number[]> = {
    Sun: [3, 6, 7, 8, 10, 11],
    Moon: [1, 3, 6, 7, 10, 11],
    Mars: [2, 3, 5, 6, 9, 10, 11],
    Mercury: [1, 3, 4, 5, 7, 8, 10, 11],
    Jupiter: [1, 4, 7, 8, 10, 11, 12],
    Venus: [3, 4, 5, 7, 9, 10, 11],
    Saturn: [3, 5, 6, 11],
    Ascendant: [3, 6, 10, 11],
  };

  private static readonly marsRules: Record<string, number[]> = {
    Sun: [3, 5, 6, 10, 11],
    Moon: [3, 6, 11],
    Mars: [1, 2, 4, 7, 8, 10, 11],
    Mercury: [3, 5, 6, 11],
    Jupiter: [6, 10, 11, 12],
    Venus: [6, 8, 11, 12],
    Saturn: [1, 4, 7, 8, 9, 10, 11],
    Ascendant: [1, 3, 6, 10, 11],
  };

  private static readonly mercuryRules: Record<string, number[]> = {
    Sun: [5, 6, 9, 11, 12],
    Moon: [2, 4, 6, 8, 10, 11],
    Mars: [1, 2, 4, 7, 8, 9, 10, 11],
    Mercury: [1, 3, 5, 6, 9, 10, 11, 12],
    Jupiter: [6, 8, 11, 12],
    Venus: [1, 2, 3, 4, 5, 8, 9, 11],
    Saturn: [1, 2, 4, 7, 8, 9, 10, 11],
    Ascendant: [1, 2, 4, 6, 8, 10, 11],
  };

  private static readonly jupiterRules: Record<string, number[]> = {
    Sun: [1, 2, 3, 4, 7, 8, 9, 10, 11],
    Moon: [2, 5, 7, 9, 11],
    Mars: [1, 2, 4, 7, 8, 10, 11],
    Mercury: [1, 2, 4, 5, 6, 9, 10, 11],
    Jupiter: [1, 2, 3, 4, 7, 8, 10, 11],
    Venus: [2, 5, 6, 9, 10, 11],
    Saturn: [3, 5, 6, 12],
    Ascendant: [1, 2, 4, 5, 6, 7, 9, 10, 11],
  };

  private static readonly venusRules: Record<string, number[]> = {
    Sun: [8, 11, 12],
    Moon: [1, 2, 3, 4, 5, 8, 9, 11, 12],
    Mars: [3, 5, 6, 9, 11, 12],
    Mercury: [3, 5, 6, 9, 11],
    Jupiter: [5, 8, 9, 10, 11],
    Venus: [1, 2, 3, 4, 5, 8, 9, 10, 11],
    Saturn: [3, 4, 5, 8, 9, 10, 11],
    Ascendant: [1, 2, 3, 4, 5, 8, 9, 11],
  };

  private static readonly saturnRules: Record<string, number[]> = {
    Sun: [1, 2, 4, 7, 8, 10, 11],
    Moon: [3, 6, 11],
    Mars: [3, 5, 6, 10, 11, 12],
    Mercury: [6, 8, 9, 10, 11, 12],
    Jupiter: [5, 6, 11, 12],
    Venus: [6, 11, 12],
    Saturn: [3, 5, 6, 11],
    Ascendant: [1, 3, 4, 6, 10, 11],
  };

  public static calculate(chart: ChartData): AshtakavargaData {
    const planetSigns: Record<string, number> = {};
    for (const p of chart.planets) {
      planetSigns[p.name] = p.rashiIndex;
    }
    planetSigns['Ascendant'] = chart.ascendant.rashiIndex;

    const bav: Record<string, number[]> = {
      Sun: this.computeBAV(this.sunRules, planetSigns),
      Moon: this.computeBAV(this.moonRules, planetSigns),
      Mars: this.computeBAV(this.marsRules, planetSigns),
      Mercury: this.computeBAV(this.mercuryRules, planetSigns),
      Jupiter: this.computeBAV(this.jupiterRules, planetSigns),
      Venus: this.computeBAV(this.venusRules, planetSigns),
      Saturn: this.computeBAV(this.saturnRules, planetSigns),
    };

    const sav: number[] = new Array(12).fill(0);
    const planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    for (let sign = 0; sign < 12; sign++) {
      let sum = 0;
      for (const p of planets) {
        sum += bav[p][sign] || 0;
      }
      sav[sign] = sum;
    }

    return { bav, sav };
  }

  private static computeBAV(rules: Record<string, number[]>, planetSigns: Record<string, number>): number[] {
    const result = new Array(12).fill(0);
    for (const contributor of Object.keys(rules)) {
      const baseSign = planetSigns[contributor];
      if (baseSign !== undefined) {
        const houses = rules[contributor];
        for (const house of houses) {
          const targetSign = (baseSign + (house - 1)) % 12;
          result[targetSign] += 1;
        }
      }
    }
    return result;
  }
}

