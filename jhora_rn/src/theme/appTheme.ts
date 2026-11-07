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

export const AppColors = {
  // Brand Sacred Vedic Colors
  maroon: '#6B1111',
  maroonDark: '#4A0D0D',
  maroonLight: '#8B2500',
  gold: '#F59E0B',
  templeGold: '#D4AF37',
  goldLight: '#FEF3C7',
  goldBright: '#FDE047',

  // Dark Theme Palette
  bgDark: '#0D0805',
  bgDarkSecondary: '#1A0F08',
  cardDark: '#23150C',
  borderDark: '#3E2415',
  textDarkPrimary: '#FDFBF7',
  textDarkSecondary: '#D1C4B5',
  textDarkMuted: '#948372',

  // Light Theme Palette
  bgLight: '#FDFBF7',
  bgLightSecondary: '#F9F5EC',
  cardLight: '#FFFFFF',
  borderLight: '#E8DBC5',
  textLightPrimary: '#2B1D0C',
  textLightSecondary: '#6B4E31',
  textLightMuted: '#9A7B56',

  // Accents
  green: '#166534',
  greenBg: '#F0FDF4',
  red: '#B91C1C',
  redBg: '#FEF2F2',
  blue: '#0369A1',
  blueBg: '#F0F9FF',

  getBg: (isDark: boolean) => (isDark ? AppColors.bgDark : AppColors.bgLight),
  getCard: (isDark: boolean) => (isDark ? AppColors.cardDark : AppColors.cardLight),
  getBorder: (isDark: boolean) => (isDark ? AppColors.borderDark : AppColors.borderLight),
  getTextPrimary: (isDark: boolean) => (isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary),
  getTextSecondary: (isDark: boolean) => (isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
  getTextMuted: (isDark: boolean) => (isDark ? AppColors.textDarkMuted : AppColors.textLightMuted),
  getGold: (isDark: boolean) => (isDark ? AppColors.gold : AppColors.templeGold),
};

