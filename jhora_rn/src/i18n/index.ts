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

