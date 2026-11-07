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

interface KeyValueRowProps {
  label: string;
  value: string | number | React.ReactNode;
  icon?: string;
  subValue?: string;
  valueColor?: string;
  style?: ViewStyle;
  labelStyle?: TextStyle;
  valueStyle?: TextStyle;
  borderBottom?: boolean;
}

export const KeyValueRow: React.FC<KeyValueRowProps> = ({
  label,
  value,
  icon,
  subValue,
  valueColor,
  style,
  labelStyle,
  valueStyle,
  borderBottom = true,
}) => {
  const { colors } = useTheme();

  return (
    <View
      style={[
        styles.row,
        borderBottom && { borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: colors.border },
        style,
      ]}
    >
      <View style={styles.left}>
        {icon ? <Text style={styles.icon}>{icon}</Text> : null}
        <Text style={[styles.label, { color: colors.textSecondary }, labelStyle]}>
          {label}
        </Text>
      </View>

      <View style={styles.right}>
        {typeof value === 'string' || typeof value === 'number' ? (
          <Text
            style={[
              styles.value,
              { color: valueColor || colors.text },
              valueStyle,
            ]}
          >
            {value}
          </Text>
        ) : (
          value
        )}
        {subValue ? (
          <Text style={[styles.subValue, { color: colors.textSecondary }]}>
            {subValue}
          </Text>
        ) : null}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 10,
  },
  left: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
    marginRight: 12,
  },
  icon: {
    fontSize: 16,
    marginRight: 8,
  },
  label: {
    fontSize: 13,
    fontWeight: '500',
  },
  right: {
    alignItems: 'flex-end',
  },
  value: {
    fontSize: 14,
    fontWeight: '600',
  },
  subValue: {
    fontSize: 11,
    marginTop: 2,
  },
});

