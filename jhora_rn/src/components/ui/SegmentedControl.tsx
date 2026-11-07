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
import { StyleSheet, View, Text, TouchableOpacity, ScrollView, ViewStyle } from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { radius } from '../../theme/tokens';

export interface SegmentOption<T extends string = string> {
  key: T;
  label: string;
  badge?: string | number;
}

interface SegmentedControlProps<T extends string = string> {
  options: SegmentOption<T>[];
  selectedKey: T;
  onSelect: (key: T) => void;
  scrollable?: boolean;
  style?: ViewStyle;
}

export function SegmentedControl<T extends string = string>({
  options,
  selectedKey,
  onSelect,
  scrollable = false,
  style,
}: SegmentedControlProps<T>) {
  const { colors } = useTheme();

  const renderItem = (opt: SegmentOption<T>) => {
    const isSelected = opt.key === selectedKey;
    return (
      <TouchableOpacity
        key={opt.key}
        style={[
          styles.segment,
          {
            backgroundColor: isSelected ? colors.primary : colors.inputBg,
            borderColor: isSelected ? colors.primary : colors.border,
          },
          !scrollable && styles.flexSegment,
        ]}
        onPress={() => onSelect(opt.key)}
        activeOpacity={0.7}
        accessibilityRole="tab"
        accessibilityState={{ selected: isSelected }}
      >
        <Text
          style={[
            styles.segmentText,
            { color: isSelected ? '#FFFFFF' : colors.text },
            isSelected && styles.segmentTextSelected,
          ]}
          numberOfLines={1}
        >
          {opt.label}
        </Text>
        {opt.badge !== undefined && (
          <View
            style={[
              styles.badge,
              {
                backgroundColor: isSelected
                  ? 'rgba(255,255,255,0.25)'
                  : colors.border,
              },
            ]}
          >
            <Text
              style={[
                styles.badgeText,
                { color: isSelected ? '#FFFFFF' : colors.textSecondary },
              ]}
            >
              {opt.badge}
            </Text>
          </View>
        )}
      </TouchableOpacity>
    );
  };

  if (scrollable) {
    return (
      <View style={[styles.scrollWrapper, style]}>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.scrollContainer}
        >
          {options.map(renderItem)}
        </ScrollView>
      </View>
    );
  }

  return <View style={[styles.fittedContainer, style]}>{options.map(renderItem)}</View>;
}

const styles = StyleSheet.create({
  scrollWrapper: {
    flexGrow: 0,
    flexShrink: 0,
    marginVertical: 4,
  },
  fittedContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginVertical: 8,
  },
  scrollContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingVertical: 2,
    paddingHorizontal: 2,
  },
  flexSegment: {
    flex: 1,
  },
  segment: {
    paddingVertical: 8,
    paddingHorizontal: 14,
    borderRadius: radius.full,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
  segmentText: {
    fontSize: 13,
    fontWeight: '500',
  },
  segmentTextSelected: {
    fontWeight: '700',
  },
  badge: {
    marginLeft: 6,
    paddingHorizontal: 6,
    paddingVertical: 1,
    borderRadius: radius.full,
  },
  badgeText: {
    fontSize: 10,
    fontWeight: '700',
  },
});

