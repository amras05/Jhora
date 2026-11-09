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

import { useCallback, useEffect, useRef, useState } from 'react';
import { CityDatabase, CityEntry } from '../services/cityDatabase';
import { PlaceSearchService } from '../services/placeSearchService';

/** A search result; timezoneKnown === false means the zone is a longitude estimate. */
export type PlaceResult = CityEntry & { timezoneKnown?: boolean };

export type PlaceSearchStatus = 'idle' | 'loading' | 'done' | 'error';

const DEBOUNCE_MS = 700; // Nominatim allows at most 1 request/second
const DEFAULT_LIST = CityDatabase.cities.slice(0, 10);

function isSamePlace(a: CityEntry, b: CityEntry): boolean {
  return (
    Math.abs(a.latitude - b.latitude) < 0.02 &&
    Math.abs(a.longitude - b.longitude) < 0.02
  );
}

/**
 * Bundled city list first (instant, offline), then OpenStreetMap results
 * for villages/towns not in the list, after a debounce.
 */
export function usePlaceSearch(lang: 'te' | 'en') {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<PlaceResult[]>(DEFAULT_LIST);
  const [status, setStatus] = useState<PlaceSearchStatus>('idle');

  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const abortRef = useRef<AbortController | null>(null);

  const cancelPending = () => {
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
    if (abortRef.current) {
      abortRef.current.abort();
      abortRef.current = null;
    }
  };

  useEffect(() => cancelPending, []);

  const onChangeQuery = useCallback(
    (text: string) => {
      setQuery(text);
      cancelPending();

      const trimmed = text.trim();
      if (!trimmed) {
        setResults(DEFAULT_LIST);
        setStatus('idle');
        return;
      }

      const local: PlaceResult[] = CityDatabase.search(trimmed);
      setResults(local);

      if (trimmed.length < PlaceSearchService.MIN_QUERY_LENGTH) {
        setStatus('idle');
        return;
      }

      setStatus('loading');
      timerRef.current = setTimeout(async () => {
        const controller = new AbortController();
        abortRef.current = controller;
        try {
          const online = await PlaceSearchService.search(trimmed, lang, controller.signal);
          if (controller.signal.aborted) return;
          const extra = online.filter(o => !local.some(l => isSamePlace(l, o)));
          setResults([...local, ...extra]);
          setStatus('done');
        } catch (e: any) {
          if (e?.name === 'AbortError' || controller.signal.aborted) return;
          // Do not log the query itself (birth place is personal data).
          console.warn('[PlaceSearch] online search failed:', e?.message || e);
          setStatus('error');
        } finally {
          if (abortRef.current === controller) abortRef.current = null;
        }
      }, DEBOUNCE_MS);
    },
    [lang],
  );

  return { query, results, status, onChangeQuery };
}

/** "16.5062° N, 80.6480° E" with correct hemisphere letters. */
export function formatLatLon(lat: number, lon: number): string {
  const ns = lat >= 0 ? 'N' : 'S';
  const ew = lon >= 0 ? 'E' : 'W';
  return `${Math.abs(lat).toFixed(4)}° ${ns}, ${Math.abs(lon).toFixed(4)}° ${ew}`;
}
