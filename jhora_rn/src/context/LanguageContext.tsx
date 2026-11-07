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

