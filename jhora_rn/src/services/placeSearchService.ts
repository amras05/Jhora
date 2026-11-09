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

import { Platform } from 'react-native';
import { CityEntry } from './cityDatabase';

/**
 * Online place search (villages, towns, hamlets) via OpenStreetMap Nominatim.
 * Usage policy: https://operations.osmfoundation.org/policies/nominatim/
 * (max 1 request/second, identify the app). Callers must debounce.
 */

const NOMINATIM_URL = 'https://nominatim.openstreetmap.org/search';
const APP_USER_AGENT = 'SBJVHora/1.0 (jhora_rn; AGPL-3.0)';

/**
 * Fixed standard offsets for countries where one zone covers the whole country
 * and there is no DST. Anything else needs the user to confirm the zone.
 */
const FIXED_COUNTRY_OFFSETS: Record<string, number> = {
  in: 5.5,
  lk: 5.5,
  np: 5.75,
  bd: 6,
  bt: 6,
  pk: 5,
};

export interface OnlinePlace extends CityEntry {
  /** false when the timezone is only a longitude estimate and must be confirmed by the user */
  timezoneKnown: boolean;
}

interface NominatimAddress {
  village?: string;
  hamlet?: string;
  town?: string;
  city?: string;
  suburb?: string;
  municipality?: string;
  county?: string;
  state_district?: string;
  state?: string;
  country?: string;
  country_code?: string;
}

interface NominatimResult {
  lat: string;
  lon: string;
  name?: string;
  display_name: string;
  addresstype?: string;
  address?: NominatimAddress;
}

export class PlaceSearchError extends Error {
  constructor(message: string, public readonly status?: number) {
    super(message);
    this.name = 'PlaceSearchError';
  }
}

/** Rough UTC offset from longitude, rounded to the nearest half hour. Only a starting value for manual confirmation. */
export function estimateTimezoneFromLongitude(longitude: number): number {
  return Math.round((longitude / 15) * 2) / 2;
}

function toOnlinePlace(r: NominatimResult): OnlinePlace | null {
  const latitude = parseFloat(r.lat);
  const longitude = parseFloat(r.lon);
  if (!isFinite(latitude) || !isFinite(longitude)) return null;

  const a = r.address || {};
  const name =
    r.name ||
    a.village || a.hamlet || a.town || a.city || a.municipality || a.suburb ||
    r.display_name.split(',')[0];

  const regionParts = [a.state_district || a.county, a.state].filter(
    (p, i, arr): p is string => !!p && p !== name && arr.indexOf(p) === i,
  );
  const country = a.country || '';
  const code = (a.country_code || '').toLowerCase();
  const isIndia = code === 'in';
  const state = isIndia || !country
    ? regionParts.join(', ')
    : [...regionParts, country].join(', ');

  const fixed = FIXED_COUNTRY_OFFSETS[code];
  return {
    name,
    state: state || country,
    country,
    latitude: Math.round(latitude * 10000) / 10000,
    longitude: Math.round(longitude * 10000) / 10000,
    timezone: fixed !== undefined ? fixed : estimateTimezoneFromLongitude(longitude),
    timezoneKnown: fixed !== undefined,
    aliases: [],
  };
}

export class PlaceSearchService {
  static readonly MIN_QUERY_LENGTH = 3;

  /**
   * Search places online. Throws PlaceSearchError on network/HTTP failure;
   * rethrows AbortError untouched so callers can ignore cancelled requests.
   */
  static async search(query: string, lang: 'te' | 'en', signal?: AbortSignal): Promise<OnlinePlace[]> {
    const q = query.trim();
    if (q.length < this.MIN_QUERY_LENGTH) return [];

    const params = [
      `q=${encodeURIComponent(q)}`,
      'format=jsonv2',
      'addressdetails=1',
      'limit=10',
      `accept-language=${lang === 'te' ? 'te,en' : 'en'}`,
    ].join('&');

    // Browsers forbid/preflight a custom User-Agent; they send Referer instead, which the policy accepts.
    const headers: Record<string, string> = { Accept: 'application/json' };
    if (Platform.OS !== 'web') headers['User-Agent'] = APP_USER_AGENT;

    let resp: Response;
    try {
      resp = await fetch(`${NOMINATIM_URL}?${params}`, { headers, signal });
    } catch (e: any) {
      if (e?.name === 'AbortError') throw e;
      throw new PlaceSearchError(`Network error: ${e?.message || 'unknown'}`);
    }

    if (!resp.ok) {
      throw new PlaceSearchError(`Place search failed (HTTP ${resp.status})`, resp.status);
    }

    let data: unknown;
    try {
      data = await resp.json();
    } catch (e: any) {
      throw new PlaceSearchError(`Invalid response from place search: ${e?.message || 'parse error'}`);
    }
    if (!Array.isArray(data)) {
      throw new PlaceSearchError('Unexpected response from place search');
    }

    return (data as NominatimResult[])
      .map(toOnlinePlace)
      .filter((p): p is OnlinePlace => p !== null);
  }
}
