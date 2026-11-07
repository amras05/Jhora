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
import { StyleSheet, View, TouchableOpacity, ViewStyle, StyleProp } from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { radius, elevation } from '../../theme/tokens';

interface CardProps {
  children: React.ReactNode;
  onPress?: () => void;
  style?: StyleProp<ViewStyle>;
  variant?: 'elevated' | 'outlined' | 'flat';
  activeOpacity?: number;
}

export const Card: React.FC<CardProps> = ({
  children,
  onPress,
  style,
  variant = 'elevated',
  activeOpacity = 0.75,
}) => {
  const { colors, isDark } = useTheme();

  const variantStyle: ViewStyle = {
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderWidth: variant === 'outlined' ? 1 : StyleSheet.hairlineWidth,
    ...(variant === 'elevated'
      ? isDark
        ? { shadowColor: '#000', shadowOpacity: 0.3, shadowRadius: 4, elevation: 2 }
        : elevation.sm
      : {}),
  };

  if (onPress) {
    return (
      <TouchableOpacity
        style={[styles.card, variantStyle, style]}
        onPress={onPress}
        activeOpacity={activeOpacity}
      >
        {children}
      </TouchableOpacity>
    );
  }

  return <View style={[styles.card, variantStyle, style]}>{children}</View>;
};

const styles = StyleSheet.create({
  card: {
    borderRadius: radius.md,
    padding: 14,
    marginVertical: 6,
  },
});
