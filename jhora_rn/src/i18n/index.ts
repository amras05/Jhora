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

import { stringsTe } from './strings.te';
import { stringsEn } from './strings.en';
import { useLanguage } from '../context/LanguageContext';

export type SupportedLanguage = 'te' | 'en';
export type TranslationTree = typeof stringsTe;

export const translations: Record<SupportedLanguage, TranslationTree> = {
  te: stringsTe,
  en: stringsEn,
};

/**
 * Helper to get a translation by dot-separated path (e.g. 'home.heroTitle')
 * with optional parameter substitution (e.g. { name: 'Ravi', n: '5' })
 */
export function getTranslation(
  lang: SupportedLanguage,
  path: string,
  params?: Record<string, string | number>
): string {
  const dict = translations[lang] || translations.te;
  const parts = path.split('.');
  let current: any = dict;

  for (const part of parts) {
    if (current && typeof current === 'object' && part in current) {
      current = current[part];
    } else {
      // Fallback to Telugu if missing in target lang
      let fallback: any = translations.te;
      for (const p of parts) {
        if (fallback && typeof fallback === 'object' && p in fallback) {
          fallback = fallback[p];
        } else {
          return path; // Not found anywhere
        }
      }
      current = fallback;
      break;
    }
  }

  if (typeof current !== 'string') {
    return path;
  }

  let result = current;
  if (params) {
    for (const [key, val] of Object.entries(params)) {
      result = result.replace(new RegExp(`\\{${key}\\}`, 'g'), String(val));
    }
  }
  return result;
}

/**
 * Hook for using translations in components
 */
export function useI18n() {
  const { lang, isTe, toggleLang, setLang } = useLanguage();
  const t = (path: string, params?: Record<string, string | number>): string => {
    return getTranslation(lang, path, params);
  };
  return { t, lang, isTe, toggleLang, setLang };
}

