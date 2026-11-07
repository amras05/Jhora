import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';
import { Appearance, ColorSchemeName } from 'react-native';
import { Theme, buildTheme } from '../theme/tokens';

// ─── Context ─────────────────────────────────────────────────────────────────
type ThemeContextValue = Theme & {
  toggleTheme: () => void;
  setDark: (dark: boolean) => void;
};

const ThemeContext = createContext<ThemeContextValue | undefined>(undefined);

// ─── Provider ────────────────────────────────────────────────────────────────
interface ThemeProviderProps {
  children: React.ReactNode;
  /** If true, follows system color scheme. Defaults to false (starts light). */
  followSystem?: boolean;
}

export const ThemeProvider: React.FC<ThemeProviderProps> = ({
  children,
  followSystem = false,
}) => {
  const systemScheme = Appearance.getColorScheme();
  const initialDark = followSystem ? systemScheme === 'dark' : false;
  const [isDark, setIsDark] = useState(initialDark);
  const [manualOverride, setManualOverride] = useState(false);

  // Listen for system theme changes (only if not manually overridden)
  useEffect(() => {
    if (!followSystem) return;

    const listener = (prefs: Appearance.AppearancePreferences) => {
      if (!manualOverride) {
        setIsDark(prefs.colorScheme === 'dark');
      }
    };
    const subscription = Appearance.addChangeListener(listener);
    return () => subscription.remove();
  }, [followSystem, manualOverride]);

  const toggleTheme = useCallback(() => {
    setManualOverride(true);
    setIsDark(prev => !prev);
  }, []);

  const setDark = useCallback((dark: boolean) => {
    setManualOverride(true);
    setIsDark(dark);
  }, []);

  const theme = buildTheme(isDark);

  const value: ThemeContextValue = {
    ...theme,
    toggleTheme,
    setDark,
  };

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
};

// ─── Hook ────────────────────────────────────────────────────────────────────
export const useTheme = (): ThemeContextValue => {
  const ctx = useContext(ThemeContext);
  if (!ctx) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return ctx;
};

