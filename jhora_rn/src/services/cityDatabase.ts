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

export interface CityEntry {
  name: string;
  state: string;
  country: string;
  latitude: number;
  longitude: number;
  timezone: number;
  aliases: string[];
}

export class CityDatabase {
  static readonly cities: CityEntry[] = [
    // ANDHRA PRADESH
    { name: 'Vijayawada', state: 'NTR, Andhra Pradesh', country: 'India', latitude: 16.5062, longitude: 80.6480, timezone: 5.5, aliases: ['విజయవాడ', 'Bezawada'] },
    { name: 'Visakhapatnam', state: 'Andhra Pradesh', country: 'India', latitude: 17.6868, longitude: 83.2185, timezone: 5.5, aliases: ['విశాఖపట్నం', 'Vizag'] },
    { name: 'Tirupati', state: 'Tirupati, Andhra Pradesh', country: 'India', latitude: 13.6288, longitude: 79.4192, timezone: 5.5, aliases: ['తిరుపతి'] },
    { name: 'Guntur', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.3067, longitude: 80.4365, timezone: 5.5, aliases: ['గుంటూరు'] },
    { name: 'Rajahmundry', state: 'East Godavari, Andhra Pradesh', country: 'India', latitude: 17.0005, longitude: 81.8040, timezone: 5.5, aliases: ['రాజమండ్రి', 'Rajamahendravaram'] },
    { name: 'Kakinada', state: 'Kakinada, Andhra Pradesh', country: 'India', latitude: 16.9891, longitude: 82.2475, timezone: 5.5, aliases: ['కాకినాడ'] },
    { name: 'Nellore', state: 'SPSR Nellore, Andhra Pradesh', country: 'India', latitude: 14.4426, longitude: 79.9865, timezone: 5.5, aliases: ['నెల్లూరు'] },
    { name: 'Kurnool', state: 'Kurnool, Andhra Pradesh', country: 'India', latitude: 15.8281, longitude: 78.0373, timezone: 5.5, aliases: ['కర్నూలు'] },
    { name: 'Kadapa', state: 'YSR Kadapa, Andhra Pradesh', country: 'India', latitude: 14.4674, longitude: 78.8242, timezone: 5.5, aliases: ['కడప', 'Cuddapah'] },
    { name: 'Anantapur', state: 'Anantapur, Andhra Pradesh', country: 'India', latitude: 14.6819, longitude: 77.6006, timezone: 5.5, aliases: ['అనంతపురం'] },
    { name: 'Eluru', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 16.7107, longitude: 81.0952, timezone: 5.5, aliases: ['ఏలూరు'] },
    { name: 'Ongole', state: 'Prakasam, Andhra Pradesh', country: 'India', latitude: 15.5057, longitude: 80.0499, timezone: 5.5, aliases: ['ఒంగోలు'] },
    { name: 'Bhimavaram', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5449, longitude: 81.5212, timezone: 5.5, aliases: ['భీమవరం'] },
    { name: 'Machilipatnam', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.1875, longitude: 81.1389, timezone: 5.5, aliases: ['మచిలీపట్నం', 'Bandar'] },
    { name: 'Tenali', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.2437, longitude: 80.6400, timezone: 5.5, aliases: ['తెనాలి'] },
    { name: 'Akividu', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5823, longitude: 81.3811, timezone: 5.5, aliases: ['ఆకివీడు'] },
    { name: 'Tadepalligudem', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.8143, longitude: 81.5266, timezone: 5.5, aliases: ['తాడేపల్లిగూడెం'] },
    { name: 'Tanuku', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.7570, longitude: 81.6823, timezone: 5.5, aliases: ['తణుకు'] },
    { name: 'Palakollu', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5167, longitude: 81.7333, timezone: 5.5, aliases: ['పాలకొల్లు'] },
    { name: 'Narsapur', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.4333, longitude: 81.7000, timezone: 5.5, aliases: ['నర్సాపురం'] },
    { name: 'Chittoor', state: 'Chittoor, Andhra Pradesh', country: 'India', latitude: 13.2172, longitude: 79.1003, timezone: 5.5, aliases: ['చిత్తూరు'] },
    { name: 'Srikakulam', state: 'Srikakulam, Andhra Pradesh', country: 'India', latitude: 18.2949, longitude: 83.8938, timezone: 5.5, aliases: ['శ్రీకాకుళం'] },
    { name: 'Vizianagaram', state: 'Vizianagaram, Andhra Pradesh', country: 'India', latitude: 18.1067, longitude: 83.3956, timezone: 5.5, aliases: ['విజయనగరం'] },

    // TELANGANA
    { name: 'Hyderabad', state: 'Telangana', country: 'India', latitude: 17.3850, longitude: 78.4867, timezone: 5.5, aliases: ['హైదరాబాద్', 'Secunderabad'] },
    { name: 'Warangal', state: 'Telangana', country: 'India', latitude: 17.9689, longitude: 79.5941, timezone: 5.5, aliases: ['వరంగల్', 'Hanamkonda'] },
    { name: 'Nizamabad', state: 'Telangana', country: 'India', latitude: 18.6725, longitude: 78.0941, timezone: 5.5, aliases: ['నిజామాబాద్'] },
    { name: 'Karimnagar', state: 'Telangana', country: 'India', latitude: 18.4386, longitude: 79.1288, timezone: 5.5, aliases: ['కరీంనగర్'] },
    { name: 'Khammam', state: 'Telangana', country: 'India', latitude: 17.2473, longitude: 80.1514, timezone: 5.5, aliases: ['ఖమ్మం'] },
    { name: 'Nalgonda', state: 'Telangana', country: 'India', latitude: 17.0500, longitude: 79.2667, timezone: 5.5, aliases: ['నల్గొండ'] },
    { name: 'Mahbubnagar', state: 'Telangana', country: 'India', latitude: 16.7488, longitude: 77.9839, timezone: 5.5, aliases: ['మహబూబ్‌నగర్'] },
    { name: 'Siddipet', state: 'Telangana', country: 'India', latitude: 18.1018, longitude: 78.8520, timezone: 5.5, aliases: ['సిద్దిపేట'] },

    // MAJOR INDIAN METROS
    { name: 'Bengaluru', state: 'Karnataka', country: 'India', latitude: 12.9716, longitude: 77.5946, timezone: 5.5, aliases: ['Bangalore', 'బెంగళూరు'] },
    { name: 'Chennai', state: 'Tamil Nadu', country: 'India', latitude: 13.0827, longitude: 80.2707, timezone: 5.5, aliases: ['Madras', 'చెన్నై'] },
    { name: 'Mumbai', state: 'Maharashtra', country: 'India', latitude: 19.0760, longitude: 72.8777, timezone: 5.5, aliases: ['Bombay', 'ముంబై'] },
    { name: 'New Delhi', state: 'Delhi', country: 'India', latitude: 28.6139, longitude: 77.2090, timezone: 5.5, aliases: ['Delhi', 'ఢిల్లీ'] },
    { name: 'Kolkata', state: 'West Bengal', country: 'India', latitude: 22.5726, longitude: 88.3639, timezone: 5.5, aliases: ['Calcutta', 'కోల్‌కతా'] },
    { name: 'Varanasi', state: 'Uttar Pradesh', country: 'India', latitude: 25.3176, longitude: 82.9739, timezone: 5.5, aliases: ['Kashi', 'Benares', 'కాశీ'] },
  ];

  static search(query: string): CityEntry[] {
    if (!query.trim()) return [];
    const q = query.trim().toLowerCase();

    return this.cities.filter(c =>
      c.name.toLowerCase().includes(q) ||
      c.state.toLowerCase().includes(q) ||
      c.aliases.some(a => a.toLowerCase().includes(q))
    ).slice(0, 15);
  }
}

