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

export const AstroConstants = {
  planetNames: [
    'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'
  ],

  planetNamesTelugu: {
    Sun: 'సూర్యుడు (రవి)',
    Moon: 'చంద్రుడు',
    Mars: 'కుజుడు (అంగారకుడు)',
    Mercury: 'బుధుడు',
    Jupiter: 'గురుడు (బృహస్పతి)',
    Venus: 'శుక్రుడు',
    Saturn: 'శని (శనైశ్చరుడు)',
    Rahu: 'రాహువు',
    Ketu: 'కేతువు',
    Ascendant: 'లగ్నము'
  } as Record<string, string>,

  planetAbbrTelugu: {
    Sun: 'రవి',
    Moon: 'చం',
    Mars: 'కు',
    Mercury: 'బు',
    Jupiter: 'గు',
    Venus: 'శు',
    Saturn: 'శ',
    Rahu: 'రా',
    Ketu: 'కే',
    Ascendant: 'ల'
  } as Record<string, string>,

  rashis: [
    'Aries', 'Taurus', 'Gemini', 'Cancer',
    'Leo', 'Virgo', 'Libra', 'Scorpio',
    'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ],

  rashisTelugu: [
    'మేషం', 'వృషభం', 'మిథునం', 'కర్కాటకం',
    'సింహం', 'కన్య', 'తుల', 'వృశ్చికం',
    'ధనుస్సు', 'మకరం', 'కుంభం', 'మీనం'
  ],

  rashiLordsTelugu: [
    'కుజుడు', 'శుక్రుడు', 'బుధుడు', 'చంద్రుడు',
    'సూర్యుడు', 'బుధుడు', 'శుక్రుడు', 'కుజుడు',
    'గురుడు', 'శని', 'శని', 'గురుడు'
  ],

  nakshatrasTelugu: [
    'అశ్విని', 'భరణి', 'కృత్తిక', 'రోహిణి', 'మృగశిర', 'ఆరుద్ర',
    'పునర్వసు', 'పుష్యమి', 'ఆశ్లేష', 'మఖ', 'పుబ్బ (పూర్వఫల్గుణి)', 'ఉత్తర (ఉత్తరఫల్గుణి)',
    'హస్త', 'చిత్త', 'స్వాతి', 'విశాఖ', 'అనూరాధ', 'జ్యేష్ఠ',
    'మూల', 'పూర్వాషాఢ', 'ఉత్తరాషాఢ', 'శ్రవణం', 'ధనిష్ట', 'శతభిషం',
    'పూర్వాభాద్ర', 'ఉత్తరాభాద్ర', 'రేవతి'
  ],

  nakshatraLordsTelugu: [
    'కేతువు', 'శుక్రుడు', 'సూర్యుడు', 'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురుడు', 'శని', 'బుధుడు',
    'కేతువు', 'శుక్రుడు', 'సూర్యుడు', 'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురుడు', 'శని', 'బుధుడు',
    'కేతువు', 'శుక్రుడు', 'సూర్యుడు', 'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురుడు', 'శని', 'బుధుడు'
  ],

  dashaSequence: ['Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury'],

  dashaYears: {
    Ketu: 7,
    Venus: 20,
    Sun: 6,
    Moon: 10,
    Mars: 7,
    Rahu: 18,
    Jupiter: 16,
    Saturn: 19,
    Mercury: 17
  } as Record<string, number>,

  // Traditional South Indian 4x4 Zodiac Grid: [row][col] gives Rashi index (0=Aries...11=Pisces)
  southIndianGrid: [
    [11, 0, 1, 2],    // Pisces, Aries, Taurus, Gemini
    [10, -1, -1, 3],  // Aquarius, [center], [center], Cancer
    [9, -1, -1, 4],   // Capricorn, [center], [center], Leo
    [8, 7, 6, 5]      // Sagittarius, Scorpio, Libra, Virgo
  ],

  southIndianGridCoords: {
    11: { r: 0, c: 0 }, // Pisces
    0:  { r: 0, c: 1 }, // Aries
    1:  { r: 0, c: 2 }, // Taurus
    2:  { r: 0, c: 3 }, // Gemini
    3:  { r: 1, c: 3 }, // Cancer
    4:  { r: 2, c: 3 }, // Leo
    5:  { r: 3, c: 3 }, // Virgo
    6:  { r: 3, c: 2 }, // Libra
    7:  { r: 3, c: 1 }, // Scorpio
    8:  { r: 3, c: 0 }, // Sagittarius
    9:  { r: 2, c: 0 }, // Capricorn
    10: { r: 1, c: 0 }, // Aquarius
  } as Record<number, { r: number; c: number }>
};

