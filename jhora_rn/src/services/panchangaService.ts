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
import { BirthData, PanchangaData } from '../models/astroModels';

export class PanchangaService {
  public static readonly tithis = [
    'Pratipada', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami',
    'Shashthi', 'Saptami', 'Ashtami', 'Navami', 'Dashami',
    'Ekadashi', 'Dwadashi', 'Trayodashi', 'Chaturdashi', 'Purnima',
    'Pratipada', 'Dwitiya', 'Tritiya', 'Chaturthi', 'Panchami',
    'Shashthi', 'Saptami', 'Ashtami', 'Navami', 'Dashami',
    'Ekadashi', 'Dwadashi', 'Trayodashi', 'Chaturdashi', 'Amavasya',
  ];

  public static readonly yogas = [
    'Vishkambha', 'Priti', 'Ayushman', 'Saubhagya', 'Shobhana',
    'Atiganda', 'Sukarma', 'Dhriti', 'Shoola', 'Ganda',
    'Vriddhi', 'Dhruva', 'Vyaghata', 'Harshana', 'Vajra',
    'Siddhi', 'Vyatipata', 'Variyan', 'Parigha', 'Shiva',
    'Siddha', 'Sadhya', 'Shubha', 'Shukla', 'Brahma',
    'Indra', 'Vaidhriti'
  ];

  public static readonly weekdays = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  public static readonly weekdaysTelugu = [
    'ఆదివారం', 'సోమవారం', 'మంగళవారం', 'బుధవారం', 'గురువారం', 'శుక్రవారం', 'శనివారం'
  ];

  public static readonly varaLordsTelugu = [
    'రవి', 'చంద్రుడు', 'కుజుడు', 'బుధుడు', 'గురువు', 'శుక్రుడు', 'శని'
  ];

  // 1-based part of day (1 to 8) for Rahu, Yama, Gulika [Sunday=0 ... Saturday=6]
  private static readonly rahuParts = [8, 2, 7, 5, 6, 4, 3];
  private static readonly yamaParts = [5, 4, 3, 2, 1, 7, 6];
  private static readonly gulikaParts = [7, 6, 5, 4, 3, 2, 1];

  public static calculate(
    date: Date,
    latitude: number,
    longitude: number,
    timezone: number,
    placeName: string,
    sunLon: number,
    moonLon: number
  ): PanchangaData {
    const sLon = ((sunLon % 360.0) + 360.0) % 360.0;
    const mLon = ((moonLon % 360.0) + 360.0) % 360.0;

    // 1. Tithi
    const diff = ((mLon - sLon + 360.0) % 360.0);
    const tithiIndex = Math.floor(diff / 12.0) % 30;
    const tithiProgress = ((diff % 12.0) / 12.0) * 100.0;
    const paksha = tithiIndex < 15 ? 'Shukla Paksha' : 'Krishna Paksha';

    // 2. Vara
    const weekdayIdx = date.getDay() % 7; // 0=Sun..6=Sat
    const varaName = this.weekdays[weekdayIdx];

    // 3. Nakshatra & Pada
    const nakshatraIndex = Math.floor(mLon / (360.0 / 27.0)) % 27;
    const nakshatraPada = Math.floor((mLon % (360.0 / 27.0)) / (360.0 / 108.0)) + 1;
    const nakshatraName = AstroConstants.nakshatrasTelugu[nakshatraIndex];

    // 4. Yoga
    const sum = (sLon + mLon) % 360.0;
    const yogaIndex = Math.floor(sum / (360.0 / 27.0)) % 27;
    const yogaName = this.yogas[yogaIndex];

    // 5. Karana
    const karanaIndex = Math.floor(diff / 6.0) % 60;
    const karanaName = this.getKaranaName(karanaIndex);

    // 6. Solar Times (Sunrise & Sunset)
    const { sunrise, sunset } = this.calculateSunriseSunset(date, latitude, longitude, timezone);

    // 7. Muhurthams & Kaala
    const rahuKalam = this.getOctantPeriod(sunrise, sunset, this.rahuParts[weekdayIdx]);
    const yamagandam = this.getOctantPeriod(sunrise, sunset, this.yamaParts[weekdayIdx]);
    const gulikaKalam = this.getOctantPeriod(sunrise, sunset, this.gulikaParts[weekdayIdx]);

    // Abhijit Muhurtha (8th of 15 muhurthas in daytime)
    const dayDurationMs = sunset.getTime() - sunrise.getTime();
    const muhurthaDurMs = Math.round(dayDurationMs / 15.0);
    const abhijitStart = new Date(sunrise.getTime() + muhurthaDurMs * 7);
    const abhijitEnd = new Date(sunrise.getTime() + muhurthaDurMs * 8);

    // Brahma Muhurtha (96 min to 48 min before sunrise)
    const brahmaStart = new Date(sunrise.getTime() - 96 * 60 * 1000);
    const brahmaEnd = new Date(sunrise.getTime() - 48 * 60 * 1000);

    const sunSignIdx = Math.floor(sLon / 30.0) % 12;
    const moonSignIdx = Math.floor(mLon / 30.0) % 12;

    return {
      date,
      placeName,
      vara: varaName,
      varaIndex: weekdayIdx,
      tithi: this.tithis[tithiIndex],
      tithiIndex,
      paksha,
      tithiProgress,
      nakshatra: nakshatraName,
      nakshatraIndex,
      nakshatraPada,
      yoga: yogaName,
      yogaIndex,
      karana: karanaName,
      karanaIndex,
      sunSign: AstroConstants.rashisTelugu[sunSignIdx],
      moonSign: AstroConstants.rashisTelugu[moonSignIdx],
      sunrise,
      sunset,
      rahuKalam,
      yamagandam,
      gulika: gulikaKalam,
      gulikaKalam,
      abhijitMuhurtha: [abhijitStart, abhijitEnd],
      abhijitMuhurtham: [abhijitStart, abhijitEnd],
      brahmaMuhurtham: [brahmaStart, brahmaEnd],
    };
  }

  private static getOctantPeriod(sunrise: Date, sunset: Date, part1Based: number): [Date, Date] {
    const dayDuration = sunset.getTime() - sunrise.getTime();
    const octantMs = Math.round(dayDuration / 8.0);
    const start = new Date(sunrise.getTime() + octantMs * (part1Based - 1));
    const end = new Date(start.getTime() + octantMs);
    return [start, end];
  }

  private static calculateSunriseSunset(
    date: Date,
    latitude: number,
    longitude: number,
    timezone: number
  ): { sunrise: Date; sunset: Date } {
    let y = date.getFullYear();
    let m = date.getMonth() + 1;
    const d = date.getDate();
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    const a = Math.floor(y / 100);
    const b = 2 - a + Math.floor(a / 4);
    const jd = Math.floor(365.25 * (y + 4716)) + Math.floor(30.6001 * (m + 1)) + d + b - 1524.5;
    const t = (jd - 2451545.0) / 36525.0;

    let l0 = (280.46646 + t * (36000.76983 + 0.0003032 * t)) % 360.0;
    if (l0 < 0) l0 += 360.0;

    let mSun = (357.52911 + t * (35999.05029 - 0.0001537 * t)) % 360.0;
    if (mSun < 0) mSun += 360.0;
    const mRad = (mSun * Math.PI) / 180.0;

    const e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);
    const c =
      Math.sin(mRad) * (1.914602 - t * (0.004817 + 0.000014 * t)) +
      Math.sin(2.0 * mRad) * (0.019993 - 0.000101 * t) +
      Math.sin(3.0 * mRad) * 0.000289;

    const sunTrueLon = l0 + c;
    const omega = 125.04 - 1934.136 * t;
    const lambdaSun = sunTrueLon - 0.00569 - 0.00478 * Math.sin((omega * Math.PI) / 180.0);

    const obliq0 =
      23.0 +
      (26.0 + (21.448 - t * (46.815 + t * (0.00059 - t * 0.001813))) / 60.0) / 60.0;
    const obliq = obliq0 + 0.00256 * Math.cos((omega * Math.PI) / 180.0);

    const sinDec = Math.sin((obliq * Math.PI) / 180.0) * Math.sin((lambdaSun * Math.PI) / 180.0);
    const declination = (Math.asin(sinDec) * 180.0) / Math.PI;

    let yVar = Math.tan(((obliq / 2.0) * Math.PI) / 180.0);
    yVar = yVar * yVar;

    const l0Rad = (l0 * Math.PI) / 180.0;
    const eot =
      4.0 *
      (180.0 / Math.PI) *
      (yVar * Math.sin(2.0 * l0Rad) -
        2.0 * e * Math.sin(mRad) +
        4.0 * e * yVar * Math.sin(mRad) * Math.cos(2.0 * l0Rad) -
        0.5 * (yVar * yVar) * Math.sin(4.0 * l0Rad) -
        1.25 * (e * e) * Math.sin(2.0 * mRad));

    const zenith = 90.8333;
    const latRad = (latitude * Math.PI) / 180.0;
    const decRad = (declination * Math.PI) / 180.0;

    let cosHa =
      (Math.cos((zenith * Math.PI) / 180.0) - Math.sin(latRad) * Math.sin(decRad)) /
      (Math.cos(latRad) * Math.cos(decRad));

    cosHa = Math.max(-1.0, Math.min(1.0, cosHa));
    const haDeg = (Math.acos(cosHa) * 180.0) / Math.PI;

    const solarNoonMin = 720.0 - 4.0 * longitude - eot + timezone * 60.0;
    const haMin = haDeg * 4.0;

    const sunriseMin = solarNoonMin - haMin;
    const sunsetMin = solarNoonMin + haMin;

    const minToDate = (totalMinutes: number): Date => {
      let mTotal = totalMinutes;
      while (mTotal < 0) mTotal += 1440;
      while (mTotal >= 1440) mTotal -= 1440;
      let hour = Math.floor(mTotal / 60);
      let minute = Math.round(mTotal % 60);
      if (minute >= 60) {
        hour += 1;
        minute = 0;
      }
      hour = hour % 24;
      const res = new Date(date);
      res.setHours(hour, minute, 0, 0);
      return res;
    };

    return {
      sunrise: minToDate(sunriseMin),
      sunset: minToDate(sunsetMin),
    };
  }

  private static getKaranaName(index: number): string {
    const repeating = ['Bava', 'Balava', 'Kaulava', 'Taitila', 'Gara', 'Vanija', 'Vishti'];
    if (index === 0) return 'Kimstughna';
    if (index >= 57) {
      return ['Shakuni', 'Chatushpada', 'Naga'][index - 57] || 'Naga';
    }
    return repeating[(index - 1) % repeating.length];
  }
}

