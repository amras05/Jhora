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
import { DashaPeriod } from '../models/astroModels';

export class DashaService {
  /**
   * Generates 120-Year Vimshottari Mahadashas starting from Moon's nakshatra balance at birth.
   */
  static calculateVimshottariDashas(moonLongitude: number, birthDate: Date): DashaPeriod[] {
    const nakshatraSpan = 360.0 / 27.0; // 13° 20' = 13.333333°
    const normMoon = ((moonLongitude % 360.0) + 360.0) % 360.0;
    const nakIndex = Math.floor(normMoon / nakshatraSpan);
    const nakElapsed = normMoon - nakIndex * nakshatraSpan;
    const nakFractionRemaining = 1.0 - (nakElapsed / nakshatraSpan);

    const firstLord = AstroConstants.nakshatraLordsTelugu[nakIndex % 9] || AstroConstants.dashaSequence[nakIndex % 9];
    // Find sequence index
    const lordEnglish = AstroConstants.dashaSequence[nakIndex % 9];
    const seqIndex = AstroConstants.dashaSequence.indexOf(lordEnglish);

    const periods: DashaPeriod[] = [];
    let currentStart = new Date(birthDate.getTime());

    // 1st Maha Dasha (fraction remaining)
    const firstFullYears = AstroConstants.dashaYears[lordEnglish] || 7;
    const firstRemainingYears = firstFullYears * nakFractionRemaining;
    const firstEndMs = currentStart.getTime() + firstRemainingYears * 365.2425 * 86400 * 1000;
    const firstEndDate = new Date(firstEndMs);
    const elapsedYears = firstFullYears * (1.0 - nakFractionRemaining);
    const nominalStart = new Date(birthDate.getTime() - elapsedYears * 365.2425 * 86400 * 1000);

    periods.push({
      planet: lordEnglish,
      startDate: currentStart,
      endDate: firstEndDate,
      years: firstRemainingYears,
      level: 1,
      nominalStart,
    });
    currentStart = firstEndDate;

    // Remaining 8 Maha Dashas (full periods)
    for (let i = 1; i < 9; i++) {
      const pLord = AstroConstants.dashaSequence[(seqIndex + i) % 9];
      const pYears = AstroConstants.dashaYears[pLord];
      const endMs = currentStart.getTime() + pYears * 365.2425 * 86400 * 1000;
      const endDate = new Date(endMs);

      periods.push({
        planet: pLord,
        startDate: currentStart,
        endDate: endDate,
        years: pYears,
        level: 1,
      });
      currentStart = endDate;
    }

    return periods;
  }

  /**
   * Lazily computes sub-periods (Level N+1) for a given parent period.
   * Accurately preserves uncompressed sub-period spans even during the 1st dasha balance.
   */
  static getSubPeriods(parent: DashaPeriod): DashaPeriod[] {
    if (parent.subPeriods) return parent.subPeriods;
    if (parent.level >= 5) return [];

    const seq = AstroConstants.dashaSequence;
    const parentIndex = seq.indexOf(parent.planet);
    const startIndex = parentIndex >= 0 ? parentIndex : 0;
    const nextLevel = parent.level + 1;

    const baseMs = (parent.nominalStart ?? parent.startDate).getTime();
    const totalParentMs = parent.endDate.getTime() - baseMs;

    const subs: DashaPeriod[] = [];
    let curr = baseMs;

    for (let i = 0; i < 9; i++) {
      const p = seq[(startIndex + i) % 9];
      const end =
        i === 8
          ? parent.endDate.getTime()
          : Math.round(curr + (totalParentMs * AstroConstants.dashaYears[p]) / 120.0);

      if (end > parent.startDate.getTime()) {
        const clipped = curr < parent.startDate.getTime();
        const effectiveStart = Math.max(curr, parent.startDate.getTime());
        subs.push({
          planet: p,
          level: nextLevel,
          startDate: new Date(effectiveStart),
          endDate: new Date(end),
          nominalStart: clipped ? new Date(curr) : undefined,
          years: (end - effectiveStart) / (365.2425 * 86400 * 1000),
        });
      }
      curr = end;
    }

    parent.subPeriods = subs;
    return subs;
  }

  /**
   * Formats duration into human readable string.
   */
  static formatDuration(start: Date, end: Date): string {
    const diffMs = end.getTime() - start.getTime();
    const totalDays = Math.floor(diffMs / (86400 * 1000));
    if (totalDays === 0) {
      const hours = Math.floor(diffMs / (3600 * 1000));
      const mins = Math.floor((diffMs % (3600 * 1000)) / (60 * 1000));
      if (hours > 0) return `${hours}h ${mins}m`;
      const secs = Math.floor((diffMs % (60 * 1000)) / 1000);
      return `${mins}m ${secs}s`;
    }
    const y = Math.floor(totalDays / 365.2425);
    const m = Math.floor((totalDays - y * 365.2425) / 30.4375);
    const d = Math.round(totalDays - y * 365.2425 - m * 30.4375);

    let res = '';
    if (y > 0) res += `${y}Y `;
    if (m > 0 || y > 0) res += `${m}M `;
    res += `${d}D`;
    return res.trim();
  }

  /**
   * Finds the exact 5-level Dasha hierarchy running on a specific target date.
   */
  static findCurrentHierarchy(dashas: DashaPeriod[], targetDate: Date) {
    const t = targetDate.getTime();
    let maha: DashaPeriod | null = null;
    let antar: DashaPeriod | null = null;
    let pratyantar: DashaPeriod | null = null;
    let sookshma: DashaPeriod | null = null;
    let prana: DashaPeriod | null = null;

    for (const d of dashas) {
      if (t >= d.startDate.getTime() && t < d.endDate.getTime()) {
        maha = d;
        break;
      }
    }

    if (maha) {
      const antars = this.getSubPeriods(maha);
      for (const a of antars) {
        if (t >= a.startDate.getTime() && t < a.endDate.getTime()) {
          antar = a;
          break;
        }
      }
    }

    if (antar) {
      const pds = this.getSubPeriods(antar);
      for (const p of pds) {
        if (t >= p.startDate.getTime() && t < p.endDate.getTime()) {
          pratyantar = p;
          break;
        }
      }
    }

    if (pratyantar) {
      const sds = this.getSubPeriods(pratyantar);
      for (const s of sds) {
        if (t >= s.startDate.getTime() && t < s.endDate.getTime()) {
          sookshma = s;
          break;
        }
      }
    }

    if (sookshma) {
      const prs = this.getSubPeriods(sookshma);
      for (const pr of prs) {
        if (t >= pr.startDate.getTime() && t < pr.endDate.getTime()) {
          prana = pr;
          break;
        }
      }
    }

    return { maha, antar, pratyantar, sookshma, prana };
  }
}

