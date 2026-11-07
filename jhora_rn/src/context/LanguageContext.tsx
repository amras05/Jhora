import React, { createContext, useContext, useState, useCallback } from 'react';

// ─── Types ───────────────────────────────────────────────────────────────────
export type Lang = 'te' | 'en';

type LanguageContextValue = {
  lang: Lang;
  isTe: boolean;
  toggleLang: () => void;
  setLang: (lang: Lang) => void;
};

// ─── Context ─────────────────────────────────────────────────────────────────
const LanguageContext = createContext<LanguageContextValue | undefined>(undefined);

// ─── Provider ────────────────────────────────────────────────────────────────
interface LanguageProviderProps {
  children: React.ReactNode;
  defaultLang?: Lang;
}

export const LanguageProvider: React.FC<LanguageProviderProps> = ({
  children,
  defaultLang = 'te',
}) => {
  const [lang, setLangState] = useState<Lang>(defaultLang);

  const toggleLang = useCallback(() => {
    setLangState(prev => (prev === 'te' ? 'en' : 'te'));
  }, []);

  const setLang = useCallback((l: Lang) => {
    setLangState(l);
  }, []);

  const value: LanguageContextValue = {
    lang,
    isTe: lang === 'te',
    toggleLang,
    setLang,
  };

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  );
};

// ─── Hook ────────────────────────────────────────────────────────────────────
export const useLanguage = (): LanguageContextValue => {
  const ctx = useContext(LanguageContext);
  if (!ctx) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return ctx;
};

