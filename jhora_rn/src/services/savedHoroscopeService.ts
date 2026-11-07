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

import { Paths, File } from 'expo-file-system';
import { BirthData } from '../models/astroModels';

export class SavedHoroscopeService {
  private static memCache: BirthData[] = [
    {
      name: 'శ్రీ వెంకటేశ్వర రావు (Sample)',
      dateTime: new Date(1990, 7, 15, 10, 30, 0),
      latitude: 16.5062,
      longitude: 80.6480,
      timezone: 5.5,
      placeName: 'విజయవాడ (Vijayawada)',
      gender: 'పురుషుడు',
    },
  ];

  static async load(): Promise<BirthData[]> {
    try {
      const file = new File(Paths.document, 'saved_horoscopes.json');
      if (file.exists) {
        const text = await file.text();
        const raw = JSON.parse(text) as any[];
        const parsed = raw.map(item => ({
          ...item,
          dateTime: new Date(item.dateTime),
        }));
        this.memCache = parsed;
        return parsed;
      }
    } catch (_) {
      // Return memory cache
    }
    return this.memCache;
  }

  static async save(profile: BirthData): Promise<void> {
    if (!profile.id) {
      profile.id = `${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
    }
    const existing = await this.load();
    const filtered = existing.filter(p => (profile.id ? p.id !== profile.id : p.name !== profile.name));
    filtered.unshift(profile);
    this.memCache = filtered;

    try {
      const file = new File(Paths.document, 'saved_horoscopes.json');
      await file.write(JSON.stringify(filtered));
    } catch (err) {
      console.error('SavedHoroscopeService write error:', err);
    }
  }

  static async delete(idOrName: string): Promise<void> {
    const existing = await this.load();
    const filtered = existing.filter(p => p.id !== idOrName && p.name !== idOrName);
    this.memCache = filtered;

    try {
      const file = new File(Paths.document, 'saved_horoscopes.json');
      await file.write(JSON.stringify(filtered));
    } catch (err) {
      console.error('SavedHoroscopeService delete write error:', err);
    }
  }
}

