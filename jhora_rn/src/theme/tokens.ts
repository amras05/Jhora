/**
 * Design tokens for SBJV Hora app.
 * Single source of truth for all colors, spacing, radius, elevation, and typography.
 */

// ─── Spacing Scale (multiples of 4) ──────────────────────────────────────────
export const spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  xxl: 32,
  xxxl: 48,
} as const;

// ─── Border Radius ───────────────────────────────────────────────────────────
export const radius = {
  sm: 6,
  md: 10,
  lg: 16,
  xl: 20,
  full: 999,
} as const;

// ─── Elevation ───────────────────────────────────────────────────────────────
export const elevation = {
  none: { elevation: 0 },
  sm: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.08,
    shadowRadius: 2,
    elevation: 2,
  },
  md: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 4,
  },
  lg: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 8,
  },
  card: 2,
  raised: 4,
  modal: 8,
} as const;

// ─── Brand Palette (constant across themes) ──────────────────────────────────
export const brand = {
  maroon: '#6B1111',
  maroonDark: '#4A0D0D',
  maroonLight: '#8B2500',
  gold: '#F59E0B',
  templeGold: '#D4AF37',
  goldLight: '#FEF3C7',
  goldBright: '#FDE047',
} as const;

// ─── Semantic Colors (per-theme) ─────────────────────────────────────────────
export type ThemeColors = {
  // Canonical backgrounds
  bg: string;
  bgSecondary: string;
  background: string;

  // Surfaces
  card: string;
  surface: string;
  border: string;

  // Text
  text: string;
  textPrimary: string;
  textSecondary: string;
  textMuted: string;

  // Brand (theme-adjusted)
  primary: string;
  primaryDark: string;
  maroon: string;
  gold: string;
  goldDark: string;

  // Feedback
  error: string;
  success: string;
  warning: string;
  info: string;

  // Accent semantic
  accent: {
    green: string;
    red: string;
    blue: string;
    orange: string;
  };
  accentBg: {
    green: string;
    red: string;
    blue: string;
    orange: string;
  };

  // Specific UI
  inputBg: string;
  tabActiveBg: string;
  tabActiveText: string;
  tabInactiveText: string;
  stripBg: string;
  overlay: string;
};

export const lightColors: ThemeColors = {
  bg: '#FDFBF7',
  bgSecondary: '#F9F5EC',
  background: '#FDFBF7',

  card: '#FFFFFF',
  surface: '#FFFFFF',
  border: '#E8DBC5',

  text: '#2B1D0C',
  textPrimary: '#2B1D0C',
  textSecondary: '#6B4E31',
  textMuted: '#9A7B56',

  primary: '#6B1111',
  primaryDark: '#4A0D0D',
  maroon: '#6B1111',
  gold: '#D4AF37',
  goldDark: '#B45309',

  error: '#B91C1C',
  success: '#166534',
  warning: '#D4AF37',
  info: '#0369A1',

  accent: {
    green: '#166534',
    red: '#B91C1C',
    blue: '#0369A1',
    orange: '#EA580C',
  },
  accentBg: {
    green: '#F0FDF4',
    red: '#FEF2F2',
    blue: '#F0F9FF',
    orange: '#FFF7ED',
  },
  inputBg: '#FFFDF9',
  tabActiveBg: '#6B1111',
  tabActiveText: '#FFFFFF',
  tabInactiveText: '#6B4E31',
  stripBg: '#FFFBEB',
  overlay: 'rgba(0,0,0,0.5)',
};

export const darkColors: ThemeColors = {
  bg: '#0D0805',
  bgSecondary: '#1A0F08',
  background: '#0D0805',

  card: '#23150C',
  surface: '#23150C',
  border: '#3E2415',

  text: '#FDFBF7',
  textPrimary: '#FDFBF7',
  textSecondary: '#D1C4B5',
  textMuted: '#948372',

  primary: '#8B2500',
  primaryDark: '#5E1900',
  maroon: '#8B2500',
  gold: '#F59E0B',
  goldDark: '#D97706',

  error: '#EF4444',
  success: '#22C55E',
  warning: '#F59E0B',
  info: '#38BDF8',

  accent: {
    green: '#22C55E',
    red: '#EF4444',
    blue: '#38BDF8',
    orange: '#FB923C',
  },
  accentBg: {
    green: '#064E3B',
    red: '#450A0A',
    blue: '#0C4A6E',
    orange: '#431407',
  },
  inputBg: '#1C110A',
  tabActiveBg: '#8B2500',
  tabActiveText: '#FFFFFF',
  tabInactiveText: '#D1C4B5',
  stripBg: '#231408',
  overlay: 'rgba(0,0,0,0.7)',
};

// ─── Typography Scale ────────────────────────────────────────────────────────
export const typography = {
  h1: {
    fontSize: 22,
    fontWeight: '700' as const,
    lineHeight: 30,
  },
  h2: {
    fontSize: 18,
    fontWeight: '700' as const,
    lineHeight: 26,
  },
  h3: {
    fontSize: 16,
    fontWeight: '600' as const,
    lineHeight: 22,
  },
  body: {
    fontSize: 14,
    fontWeight: '400' as const,
    lineHeight: 20,
  },
  bodyBold: {
    fontSize: 14,
    fontWeight: '600' as const,
    lineHeight: 20,
  },
  caption: {
    fontSize: 12,
    fontWeight: '400' as const,
    lineHeight: 16,
  },
  captionBold: {
    fontSize: 12,
    fontWeight: '600' as const,
    lineHeight: 16,
  },
  label: {
    fontSize: 13,
    fontWeight: '500' as const,
    lineHeight: 18,
  },
  tabLabel: {
    fontSize: 11,
    fontWeight: '600' as const,
    lineHeight: 14,
  },
  tiny: {
    fontSize: 10,
    fontWeight: '400' as const,
    lineHeight: 14,
  },
} as const;

// ─── Full Theme Object ───────────────────────────────────────────────────────
export type Theme = {
  isDark: boolean;
  colors: ThemeColors;
  brand: typeof brand;
  spacing: typeof spacing;
  radius: typeof radius;
  elevation: typeof elevation;
  typography: typeof typography;
};

export const buildTheme = (isDark: boolean): Theme => ({
  isDark,
  colors: isDark ? darkColors : lightColors,
  brand,
  spacing,
  radius,
  elevation,
  typography,
});
