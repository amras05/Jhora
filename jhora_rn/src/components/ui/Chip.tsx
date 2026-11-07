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

import React from 'react';
import { StyleSheet, View, Text, ViewStyle, TextStyle } from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { radius } from '../../theme/tokens';

export type ChipVariant =
  | 'default'
  | 'success'
  | 'warning'
  | 'error'
  | 'info'
  | 'primary'
  | 'gold';

interface ChipProps {
  label: string;
  variant?: ChipVariant;
  icon?: string;
  size?: 'sm' | 'md';
  style?: ViewStyle;
  textStyle?: TextStyle;
}

export const Chip: React.FC<ChipProps> = ({
  label,
  variant = 'default',
  icon,
  size = 'sm',
  style,
  textStyle,
}) => {
  const { colors, isDark } = useTheme();

  const getColors = () => {
    switch (variant) {
      case 'success':
        return {
          bg: isDark ? 'rgba(16, 185, 129, 0.2)' : '#ECFDF5',
          border: isDark ? '#059669' : '#A7F3D0',
          text: isDark ? '#34D399' : '#065F46',
        };
      case 'warning':
        return {
          bg: isDark ? 'rgba(245, 158, 11, 0.2)' : '#FFFBEB',
          border: isDark ? '#D97706' : '#FDE68A',
          text: isDark ? '#FBBF24' : '#92400E',
        };
      case 'error':
        return {
          bg: isDark ? 'rgba(239, 68, 68, 0.2)' : '#FEF2F2',
          border: isDark ? '#DC2626' : '#FECACA',
          text: isDark ? '#F87171' : '#991B1B',
        };
      case 'info':
        return {
          bg: isDark ? 'rgba(2, 132, 199, 0.2)' : '#F0F9FF',
          border: isDark ? '#0284C7' : '#BAE6FD',
          text: isDark ? '#38BDF8' : '#075985',
        };
      case 'gold':
        return {
          bg: isDark ? 'rgba(212, 175, 55, 0.2)' : '#FFFBEB',
          border: isDark ? '#D4AF37' : '#FDE68A',
          text: isDark ? '#F5D77F' : '#78350F',
        };
      case 'primary':
        return {
          bg: isDark ? 'rgba(139, 37, 0, 0.25)' : '#FFF5F0',
          border: colors.primary,
          text: colors.primary,
        };
      default:
        return {
          bg: colors.inputBg,
          border: colors.border,
          text: colors.textSecondary,
        };
    }
  };

  const palette = getColors();
  const isSmall = size === 'sm';

  return (
    <View
      style={[
        styles.chip,
        {
          backgroundColor: palette.bg,
          borderColor: palette.border,
          paddingVertical: isSmall ? 2 : 4,
          paddingHorizontal: isSmall ? 8 : 12,
        },
        style,
      ]}
    >
      {icon ? <Text style={[styles.icon, { color: palette.text }]}>{icon}</Text> : null}
      <Text
        style={[
          styles.text,
          {
            color: palette.text,
            fontSize: isSmall ? 11 : 13,
          },
          textStyle,
        ]}
      >
        {label}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  chip: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: radius.full,
    borderWidth: StyleSheet.hairlineWidth,
    alignSelf: 'flex-start',
  },
  icon: {
    fontSize: 12,
    marginRight: 4,
  },
  text: {
    fontWeight: '600',
  },
});

