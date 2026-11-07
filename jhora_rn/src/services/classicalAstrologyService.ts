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

import { ChartData } from '../models/astroModels';
import { AstroConstants } from '../constants/astroConstants';

export interface AvakahadaChakra {
  varna: string;
  varnaLord: string;
  vashya: string;
  tara: string;
  yoni: string;
  gana: string;
  nadi: string;
  rajju: string;
  namaAkshara: string;
  chandraRashi: string;
  suryaRashi: string;
  janmaLagna: string;
}

export interface GhataChakra {
  ghataRashi: string;
  ghataMasa: string;
  ghataTithi: string;
  ghataVara: string;
  ghataNakshatra: string;
  ghataLagna: string;
  ghataPrahar: string;
}

export interface AdrushtaVishayalu {
  rashiLord: string;
  lagnaLord: string;
  luckyNumbers: string;
  luckyDays: string;
  luckyColors: string;
  luckyGemstone: string;
  luckyDirection: string;
  ishtaDevata: string;
  friendlyRashis: string;
}

export class ClassicalAstrologyService {
  // 1. Avakahada Varna (వర్ణము)
  static getVarna(rashiIdx: number): { varna: string; varnaLord: string } {
    const r = ((rashiIdx % 12) + 12) % 12;
    if (r === 3 || r === 7 || r === 11) {
      // Cancer, Scorpio, Pisces
      return { varna: 'బ్రాహ్మణ (విప్ర)', varnaLord: 'గురు, శుక్ర' };
    }
    if (r === 0 || r === 4 || r === 8) {
      // Aries, Leo, Sagittarius
      return { varna: 'క్షత్రియ', varnaLord: 'సూర్య, కుజ' };
    }
    if (r === 1 || r === 5 || r === 9) {
      // Taurus, Virgo, Capricorn
      return { varna: 'వైశ్య', varnaLord: 'చంద్ర, బుధ' };
    }
    // Gemini, Libra, Aquarius
    return { varna: 'శూద్ర', varnaLord: 'శని' };
  }

  // 2. Avakahada Vashya (వశ్యము)
  static getVashya(rashiIdx: number, degInRashi: number = 0): string {
    const r = ((rashiIdx % 12) + 12) % 12;
    switch (r) {
      case 0: // Mesha
      case 1: // Vrishabha
        return 'చతుష్పాద (జంతు జాతి)';
      case 2: // Mithuna
      case 5: // Kanya
      case 6: // Tula
      case 10: // Kumbha
        return 'ద్విపద / మానవ';
      case 3: // Karka
      case 11: // Meena
        return 'జలచర (జల జీవి)';
      case 4: // Simha
        return 'వనచర / సింహ';
      case 7: // Vrischika
        return 'కీటక (కీటకం)';
      case 8: // Dhanu
        return degInRashi < 15 ? 'ద్విపద / మానవ' : 'చతుష్పాద';
      case 9: // Makara
        return degInRashi < 15 ? 'చతుష్పాద' : 'జలచర';
      default:
        return 'ద్విపద';
    }
  }

  // 3. Yoni (యోని) - 27 Nakshatras
  static readonly yonisTelugu = [
    'అశ్వ (గుర్రము)',      // 0 Ashwini
    'గజ (ఏనుగు)',         // 1 Bharani
    'మేష (పొట్టేలు)',      // 2 Krittika
    'సర్ప (పాము)',         // 3 Rohini
    'సర్ప (పాము)',         // 4 Mrigashira
    'శ్వాన (కుక్క)',       // 5 Ardra
    'మార్జాల (పిల్లి)',    // 6 Punarvasu
    'మేష (గొర్రె)',        // 7 Pushya
    'మార్జాల (పిల్లి)',    // 8 Ashlesha
    'మూషిక (ఎలుక)',       // 9 Magha
    'మూషిక (ఎలుక)',       // 10 Purva Phalguni
    'గోవు (ఆవు)',          // 11 Uttara Phalguni
    'మహిష (గేదె)',        // 12 Hasta
    'వ్యాఘ్ర (పులి)',      // 13 Chitra
    'మహిష (గేదె)',        // 14 Swati
    'వ్యాఘ్ర (పులి)',      // 15 Vishakha
    'హరిణ (లేడి)',         // 16 Anuradha
    'హరిణ (లేడి)',         // 17 Jyeshtha
    'శ్వాన (కుక్క)',       // 18 Mula
    'వానర (కోతి)',        // 19 Purva Ashadha
    'నకుల (ముంగిస)',       // 20 Uttara Ashadha
    'వానర (కోతి)',        // 21 Shravana
    'సింహం (సింహము)',      // 22 Dhanishta
    'అశ్వ (గుర్రము)',      // 23 Shatabhisha
    'సింహం (సింహము)',      // 24 Purva Bhadra
    'గోవు (ఆవు)',          // 25 Uttara Bhadra
    'గజ (ఏనుగు)',         // 26 Revati
  ];

  // 4. Gana (గణము)
  static readonly ganasTelugu = [
    'దేవ గణము',     // 0 Ashwini
    'మనుష్య గణము',   // 1 Bharani
    'రాక్షస గణము',   // 2 Krittika
    'మనుష్య గణము',   // 3 Rohini
    'దేవ గణము',     // 4 Mrigashira
    'మనుష్య గణము',   // 5 Ardra
    'దేవ గణము',     // 6 Punarvasu
    'దేవ గణము',     // 7 Pushya
    'రాక్షస గణము',   // 8 Ashlesha
    'రాక్షస గణము',   // 9 Magha
    'మనుష్య గణము',   // 10 Purva Phalguni
    'మనుష్య గణము',   // 11 Uttara Phalguni
    'దేవ గణము',     // 12 Hasta
    'రాక్షస గణము',   // 13 Chitra
    'దేవ గణము',     // 14 Swati
    'రాక్షస గణము',   // 15 Vishakha
    'దేవ గణము',     // 16 Anuradha
    'రాక్షస గణము',   // 17 Jyeshtha
    'రాక్షస గణము',   // 18 Mula
    'మనుష్య గణము',   // 19 Purva Ashadha
    'మనుష్య గణము',   // 20 Uttara Ashadha
    'దేవ గణము',     // 21 Shravana
    'రాక్షస గణము',   // 22 Dhanishta
    'రాక్షస గణము',   // 23 Shatabhisha
    'మనుష్య గణము',   // 24 Purva Bhadra
    'మనుష్య గణము',   // 25 Uttara Bhadra
    'దేవ గణము',     // 26 Revati
  ];

  // 5. Nadi (నాడి)
  static readonly nadisTelugu = [
    'ఆది నాడి',    // 0 Ashwini
    'మధ్య నాడి',   // 1 Bharani
    'అంత్య నాడి',   // 2 Krittika
    'అంత్య నాడి',   // 3 Rohini
    'మధ్య నాడి',   // 4 Mrigashira
    'ఆది నాడి',    // 5 Ardra
    'ఆది నాడి',    // 6 Punarvasu
    'మధ్య నాడి',   // 7 Pushya
    'అంత్య నాడి',   // 8 Ashlesha
    'అంత్య నాడి',   // 9 Magha
    'మధ్య నాడి',   // 10 Purva Phalguni
    'ఆది నాడి',    // 11 Uttara Phalguni
    'ఆది నాడి',    // 12 Hasta
    'మధ్య నాడి',   // 13 Chitra
    'అంత్య నాడి',   // 14 Swati
    'అంత్య నాడి',   // 15 Vishakha
    'మధ్య నాడి',   // 16 Anuradha
    'ఆది నాడి',    // 17 Jyeshtha
    'ఆది నాడి',    // 18 Mula
    'మధ్య నాడి',   // 19 Purva Ashadha
    'అంత్య నాడి',   // 20 Uttara Ashadha
    'అంత్య నాడి',   // 21 Shravana
    'మధ్య నాడి',   // 22 Dhanishta
    'ఆది నాడి',    // 23 Shatabhisha
    'ఆది నాడి',    // 24 Purva Bhadra
    'మధ్య నాడి',   // 25 Uttara Bhadra
    'అంత్య నాడి',   // 26 Revati
  ];

  // 6. Rajju (రజ్జువు)
  static readonly rajjusTelugu = [
    'పాద రజ్జు',   // 0 Ashwini
    'కటి రజ్జు',    // 1 Bharani
    'నాభి రజ్జు',   // 2 Krittika
    'కంఠ రజ్జు',   // 3 Rohini
    'శిరో రజ్జు',   // 4 Mrigashira
    'కంఠ రజ్జు',   // 5 Ardra
    'నాభి రజ్జు',   // 6 Punarvasu
    'కటి రజ్జు',    // 7 Pushya
    'పాద రజ్జు',   // 8 Ashlesha
    'పాద రజ్జు',   // 9 Magha
    'కటి రజ్జు',    // 10 Purva Phalguni
    'నాభి రజ్జు',   // 11 Uttara Phalguni
    'కంఠ రజ్జు',   // 12 Hasta
    'శిరో రజ్జు',   // 13 Chitra
    'కంఠ రజ్జు',   // 14 Swati
    'నాభి రజ్జు',   // 15 Vishakha
    'కటి రజ్జు',    // 16 Anuradha
    'పాద రజ్జు',   // 17 Jyeshtha
    'పాద రజ్జు',   // 18 Mula
    'కటి రజ్జు',    // 19 Purva Ashadha
    'నాభి రజ్జు',   // 20 Uttara Ashadha
    'కంఠ రజ్జు',   // 21 Shravana
    'శిరో రజ్జు',   // 22 Dhanishta
    'కంఠ రజ్జు',   // 23 Shatabhisha
    'నాభి రజ్జు',   // 24 Purva Bhadra
    'కటి రజ్జు',    // 25 Uttara Bhadra
    'పాద రజ్జు',   // 26 Revati
  ];

  // 7. Nama Aksharas (నామ అక్షరములు - 27 Nakshatras x 4 Padas)
  static readonly namaAksharasTelugu: string[][] = [
    ['చూ', 'చే', 'చో', 'లా'],       // 0 Ashwini
    ['లీ', 'లూ', 'లే', 'లో'],       // 1 Bharani
    ['ఆ', 'ఈ', 'ఊ', 'ఏ'],           // 2 Krittika
    ['ఓ', 'వా', 'వీ', 'వూ'],        // 3 Rohini
    ['వే', 'వో', 'కా', 'కీ'],       // 4 Mrigashira
    ['కూ', 'ఘ', 'ఙ', 'ఛ'],         // 5 Ardra
    ['కే', 'కో', 'హా', 'హీ'],       // 6 Punarvasu
    ['హూ', 'హే', 'హో', 'డా'],       // 7 Pushya
    ['డీ', 'డూ', 'డే', 'డో'],       // 8 Ashlesha
    ['మా', 'మీ', 'మూ', 'మే'],       // 9 Magha
    ['మో', 'టా', 'టీ', 'టూ'],       // 10 Purva Phalguni
    ['టే', 'టో', 'పా', 'పీ'],       // 11 Uttara Phalguni
    ['పూ', 'ష', 'ణ', 'ఠ'],         // 12 Hasta
    ['పే', 'పో', 'రా', 'రీ'],       // 13 Chitra
    ['రూ', 'రే', 'రో', 'తా'],       // 14 Swati
    ['తీ', 'తూ', 'తే', 'తో'],       // 15 Vishakha
    ['నా', 'నీ', 'నూ', 'నే'],       // 16 Anuradha
    ['నో', 'యా', 'యీ', 'యూ'],       // 17 Jyeshtha
    ['యే', 'యో', 'బా', 'బీ'],       // 18 Mula
    ['భూ', 'ధా', 'భా', 'ఢా'],       // 19 Purva Ashadha
    ['భే', 'భో', 'జా', 'జీ'],       // 20 Uttara Ashadha
    ['ఖీ', 'ఖూ', 'ఖే', 'ఖో'],       // 21 Shravana
    ['గా', 'గీ', 'గూ', 'గే'],       // 22 Dhanishta
    ['గో', 'సా', 'సీ', 'సూ'],       // 23 Shatabhisha
    ['సే', 'సో', 'దా', 'దీ'],       // 24 Purva Bhadra
    ['దూ', 'థ', 'ఝ', 'ఞ'],         // 25 Uttara Bhadra
    ['దే', 'దో', 'చా', 'చీ'],       // 26 Revati
  ];

  // 8. Ghata Chakra Definitions for 12 Rashis
  static readonly ghataTable: Record<number, GhataChakra> = {
    0: { // Mesha
      ghataRashi: 'వృశ్చికం',
      ghataMasa: 'కార్తిక మాసం',
      ghataTithi: 'నంద (1, 6, 11 తిథులు)',
      ghataVara: 'ఆదివారం',
      ghataNakshatra: 'మఘ',
      ghataLagna: 'మేషం',
      ghataPrahar: '1వ ప్రహర (ఉదయం)',
    },
    1: { // Vrishabha
      ghataRashi: 'కన్య',
      ghataMasa: 'మార్గశిర మాసం',
      ghataTithi: 'భద్ర (2, 7, 12 తిథులు)',
      ghataVara: 'శనివారం',
      ghataNakshatra: 'హస్త',
      ghataLagna: 'వృషభం',
      ghataPrahar: '2వ ప్రహర (మధ్యాహ్నం)',
    },
    2: { // Mithuna
      ghataRashi: 'ధనుస్సు',
      ghataMasa: 'ఆషాఢ మాసం',
      ghataTithi: 'జయ (3, 8, 13 తిథులు)',
      ghataVara: 'సోమవారం',
      ghataNakshatra: 'స్వాతి',
      ghataLagna: 'మిథునం',
      ghataPrahar: '3వ ప్రహర (సాయంత్రం)',
    },
    3: { // Karka
      ghataRashi: 'కుంభం',
      ghataMasa: 'పౌష మాసం',
      ghataTithi: 'రిక్త (4, 9, 14 తిథులు)',
      ghataVara: 'బుధవారం',
      ghataNakshatra: 'అనూరాధ',
      ghataLagna: 'కర్కాటకం',
      ghataPrahar: '4వ ప్రహర (రాత్రి)',
    },
    4: { // Simha
      ghataRashi: 'మకరం',
      ghataMasa: 'జ్యేష్ఠ మాసం',
      ghataTithi: 'పూర్ణ (5, 10, 15, 30 తిథులు)',
      ghataVara: 'శనివారం',
      ghataNakshatra: 'మూల',
      ghataLagna: 'సింహం',
      ghataPrahar: '1వ ప్రహర (ఉదయం)',
    },
    5: { // Kanya
      ghataRashi: 'మీనం',
      ghataMasa: 'చైత్ర మాసం',
      ghataTithi: 'భద్ర (2, 7, 12 తిథులు)',
      ghataVara: 'శనివారం',
      ghataNakshatra: 'శ్రవణం',
      ghataLagna: 'కన్య',
      ghataPrahar: '2వ ప్రహర (మధ్యాహ్నం)',
    },
    6: { // Tula
      ghataRashi: 'మేషం',
      ghataMasa: 'వైశాఖ మాసం',
      ghataTithi: 'రిక్త (4, 9, 14 తిథులు)',
      ghataVara: 'గురువారం',
      ghataNakshatra: 'శతభిషం',
      ghataLagna: 'తుల',
      ghataPrahar: '3వ ప్రహర (సాయంత్రం)',
    },
    7: { // Vrischika
      ghataRashi: 'వృషభం',
      ghataMasa: 'ఆశ్వయుజ మాసం',
      ghataTithi: 'నంద (1, 6, 11 తిథులు)',
      ghataVara: 'శుక్రవారం',
      ghataNakshatra: 'రేవతి',
      ghataLagna: 'వృశ్చికం',
      ghataPrahar: '4వ ప్రహర (రాత్రి)',
    },
    8: { // Dhanu
      ghataRashi: 'మిథునం',
      ghataMasa: 'భాద్రపద మాసం',
      ghataTithi: 'జయ (3, 8, 13 తిథులు)',
      ghataVara: 'శుక్రవారం',
      ghataNakshatra: 'భరణి',
      ghataLagna: 'ధనుస్సు',
      ghataPrahar: '1వ ప్రహర (ఉదయం)',
    },
    9: { // Makara
      ghataRashi: 'సింహం',
      ghataMasa: 'మాఘ మాసం',
      ghataTithi: 'రిక్త (4, 9, 14 తిథులు)',
      ghataVara: 'మంగళవారం',
      ghataNakshatra: 'రోహిణి',
      ghataLagna: 'మకరం',
      ghataPrahar: '2వ ప్రహర (మధ్యాహ్నం)',
    },
    10: { // Kumbha
      ghataRashi: 'కర్కాటకం',
      ghataMasa: 'శ్రావణ మాసం',
      ghataTithi: 'జయ (3, 8, 13 తిథులు)',
      ghataVara: 'గురువారం',
      ghataNakshatra: 'ఆరుద్ర',
      ghataLagna: 'కుంభం',
      ghataPrahar: '3వ ప్రహర (సాయంత్రం)',
    },
    11: { // Meena
      ghataRashi: 'తుల',
      ghataMasa: 'ఫాల్గుణ మాసం',
      ghataTithi: 'పూర్ణ (5, 10, 15, 30 తిథులు)',
      ghataVara: 'శుక్రవారం',
      ghataNakshatra: 'ఆశ్లేష',
      ghataLagna: 'మీనం',
      ghataPrahar: '4వ ప్రహర (రాత్రి)',
    },
  };

  // 9. Adrushta Vishayalu Definitions for 12 Rashis
  static readonly adrushtaTable: Record<number, {
    luckyNumbers: string;
    luckyDays: string;
    luckyColors: string;
    luckyGemstone: string;
    luckyDirection: string;
    ishtaDevata: string;
    friendlyRashis: string;
  }> = {
    0: { // Mesha
      luckyNumbers: '9, 1, 3',
      luckyDays: 'మంగళవారం, ఆదివారం, గురువారం',
      luckyColors: 'ఎరుపు, సిందూరం, కాషాయం',
      luckyGemstone: 'పగడం (Red Coral)',
      luckyDirection: 'తూర్పు / దక్షిణం',
      ishtaDevata: 'శ్రీ సుబ్రహ్మణ్య స్వామి, ఆంజనేయ స్వామి',
      friendlyRashis: 'సింహం, ధనుస్సు, కర్కాటకం',
    },
    1: { // Vrishabha
      luckyNumbers: '6, 5, 8',
      luckyDays: 'శుక్రవారం, బుధవారం, శనివారం',
      luckyColors: 'తెలుపు, గులాబీ, వెండి వర్ణం',
      luckyGemstone: 'వజ్రం (Diamond) / ఓపల్',
      luckyDirection: 'ఆగ్నేయం',
      ishtaDevata: 'శ్రీ మహాలక్ష్మి అమ్మవారు',
      friendlyRashis: 'కన్య, మకరం, తుల',
    },
    2: { // Mithuna
      luckyNumbers: '5, 6, 1',
      luckyDays: 'బుధవారం, శుక్రవారం',
      luckyColors: 'ఆకుపచ్చ (Emerald Green), లేత పసుపు',
      luckyGemstone: 'మరకత పచ్చ (Emerald)',
      luckyDirection: 'ఉత్తరం',
      ishtaDevata: 'శ్రీ మహావిష్ణువు, వేంకటేశ్వర స్వామి',
      friendlyRashis: 'తుల, కుంభం, కన్య',
    },
    3: { // Karka
      luckyNumbers: '2, 7, 9',
      luckyDays: 'సోమవారం, మంగళవారం',
      luckyColors: 'తెలుపు, ముత్యపు వర్ణం, క్రీమ్',
      luckyGemstone: 'ముత్యం (Natural Pearl)',
      luckyDirection: 'వాయవ్యం',
      ishtaDevata: 'శ్రీ పార్వతీ దేవి, పరమశివుడు',
      friendlyRashis: 'వృశ్చికం, మీనం, మేషం',
    },
    4: { // Simha
      luckyNumbers: '1, 4, 9',
      luckyDays: 'ఆదివారం, మంగళవారం',
      luckyColors: 'బంగారు రంగు, నారింజ, ఎరుపు',
      luckyGemstone: 'మాణిక్యం (Ruby)',
      luckyDirection: 'తూర్పు',
      ishtaDevata: 'శ్రీ సూర్యనారాయణ మూర్తి, గాయత్రీ దేవి',
      friendlyRashis: 'మేషం, ధనుస్సు, కర్కాటకం',
    },
    5: { // Kanya
      luckyNumbers: '5, 6, 2',
      luckyDays: 'బుధవారం, శుక్రవారం',
      luckyColors: 'ఆకుపచ్చ, తెలుపు, బూడిద',
      luckyGemstone: 'మరకత పచ్చ (Emerald)',
      luckyDirection: 'ఉత్తరం',
      ishtaDevata: 'శ్రీ విష్ణువు, మహాలక్ష్మి',
      friendlyRashis: 'వృషభం, మకరం, మిథునం',
    },
    6: { // Tula
      luckyNumbers: '6, 8, 5',
      luckyDays: 'శుక్రవారం, శనివారం',
      luckyColors: 'తెలుపు, లేత నీలం, క్రీమ్',
      luckyGemstone: 'వజ్రం (Diamond) / వైట్ సఫైర్',
      luckyDirection: 'పడమర / వాయవ్యం',
      ishtaDevata: 'శ్రీ లక్ష్మీ దేవి, దుర్గా భవాని',
      friendlyRashis: 'మిథునం, కుంభం, వృషభం',
    },
    7: { // Vrischika
      luckyNumbers: '9, 3, 1',
      luckyDays: 'మంగళవారం, గురువారం',
      luckyColors: 'ఎరుపు, పగడపు వర్ణం, సిందూరం',
      luckyGemstone: 'పగడం (Red Coral)',
      luckyDirection: 'దక్షిణం',
      ishtaDevata: 'శ్రీ సుబ్రహ్మణ్యేశ్వర స్వామి, హనుమాన్',
      friendlyRashis: 'కర్కాటకం, మీనం, సింహం',
    },
    8: { // Dhanu
      luckyNumbers: '3, 9, 1',
      luckyDays: 'గురువారం, ఆదివారం',
      luckyColors: 'పసుపు, బంగారు వర్ణం, కేసరి',
      luckyGemstone: 'పుష్యరాగం (Yellow Sapphire)',
      luckyDirection: 'ఈశాన్యం',
      ishtaDevata: 'శ్రీ దత్తాత్రేయ స్వామి, దక్షిణామూర్తి',
      friendlyRashis: 'మేషం, సింహం, మీనం',
    },
    9: { // Makara
      luckyNumbers: '8, 5, 6',
      luckyDays: 'శనివారం, శుక్రవారం, బుధవారం',
      luckyColors: 'నీలం, నలుపు, ముదురు బూడిద',
      luckyGemstone: 'నీలం (Blue Sapphire)',
      luckyDirection: 'పడమర',
      ishtaDevata: 'శ్రీ వేంకటేశ్వర స్వామి, అయ్యప్ప స్వామి, ఆంజనేయ స్వామి',
      friendlyRashis: 'వృషభం, కన్య, కుంభం',
    },
    10: { // Kumbha
      luckyNumbers: '8, 4, 6',
      luckyDays: 'శనివారం, శుక్రవారం',
      luckyColors: 'నీలం, వంగపండు రంగు, ఆకాశ నీలం',
      luckyGemstone: 'నీలం (Blue Sapphire) / జామునియా',
      luckyDirection: 'పడమర',
      ishtaDevata: 'శ్రీ రుద్రుడు / శివుడు, హనుమంతుడు',
      friendlyRashis: 'మిథునం, తుల, మకరం',
    },
    11: { // Meena
      luckyNumbers: '3, 7, 9',
      luckyDays: 'గురువారం, సోమవారం, మంగళవారం',
      luckyColors: 'పసుపు, కుంకుమ రంగు, పీతాంబర వర్ణం',
      luckyGemstone: 'పుష్యరాగం (Yellow Sapphire)',
      luckyDirection: 'ఈశాన్యం',
      ishtaDevata: 'శ్రీ మహావిష్ణువు, శ్రీ దక్షిణామూర్తి',
      friendlyRashis: 'కర్కాటకం, వృశ్చికం, ధనుస్సు',
    },
  };

  /** Calculate Avakahada Chakra based on ChartData */
  static calculateAvakahada(chartData: ChartData): AvakahadaChakra {
    const moon = chartData.planets.find(p => p.name === 'Moon') || chartData.planets[1];
    const sun = chartData.planets.find(p => p.name === 'Sun') || chartData.planets[0];

    const rIdx = moon.rashiIndex;
    const nakIdx = moon.nakshatraIndex;
    const pada = Math.max(1, Math.min(4, moon.pada || 1));

    const { varna, varnaLord } = this.getVarna(rIdx);
    const vashya = this.getVashya(rIdx, moon.degreesInRashi);
    const yoni = this.yonisTelugu[nakIdx % 27] || 'అశ్వ';
    const gana = this.ganasTelugu[nakIdx % 27] || 'దేవ గణము';
    const nadi = this.nadisTelugu[nakIdx % 27] || 'మధ్య నాడి';
    const rajju = this.rajjusTelugu[nakIdx % 27] || 'నాభి రజ్జు';

    const padas = this.namaAksharasTelugu[nakIdx % 27] || ['గా', 'గీ', 'గూ', 'గే'];
    const namaAkshara = padas[pada - 1] || padas[0];

    return {
      varna,
      varnaLord,
      vashya,
      tara: 'జన్మ తార',
      yoni,
      gana,
      nadi,
      rajju,
      namaAkshara,
      chandraRashi: AstroConstants.rashisTelugu[rIdx],
      suryaRashi: AstroConstants.rashisTelugu[sun.rashiIndex],
      janmaLagna: AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex],
    };
  }

  /** Calculate Ghata Chakra based on Moon Sign */
  static calculateGhata(moonRashiIndex: number): GhataChakra {
    const idx = ((moonRashiIndex % 12) + 12) % 12;
    return this.ghataTable[idx] || this.ghataTable[0];
  }

  /** Calculate Adrushta Vishayalu based on Moon Sign and Lagna */
  static calculateAdrushta(moonRashiIndex: number, lagnaRashiIndex: number): AdrushtaVishayalu {
    const mIdx = ((moonRashiIndex % 12) + 12) % 12;
    const lIdx = ((lagnaRashiIndex % 12) + 12) % 12;

    const base = this.adrushtaTable[mIdx] || this.adrushtaTable[0];
    const rashiLord = AstroConstants.rashiLordsTelugu[mIdx];
    const lagnaLord = AstroConstants.rashiLordsTelugu[lIdx];

    return {
      rashiLord,
      lagnaLord,
      luckyNumbers: base.luckyNumbers,
      luckyDays: base.luckyDays,
      luckyColors: base.luckyColors,
      luckyGemstone: base.luckyGemstone,
      luckyDirection: base.luckyDirection,
      ishtaDevata: base.ishtaDevata,
      friendlyRashis: base.friendlyRashis,
    };
  }
}

