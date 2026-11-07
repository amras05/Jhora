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
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { useLanguage } from '../../context/LanguageContext';

interface AppBarProps {
  title: string;
  subtitle?: string;
  onBack?: () => void;
  showThemeToggle?: boolean;
  showLangToggle?: boolean;
  rightAction?: React.ReactNode;
}

export const AppBar: React.FC<AppBarProps> = ({
  title,
  subtitle,
  onBack,
  showThemeToggle = false,
  showLangToggle = false,
  rightAction,
}) => {
  const { colors, isDark, toggleTheme } = useTheme();
  const { lang, toggleLang } = useLanguage();

  return (
    <View
      style={[
        styles.container,
        {
          backgroundColor: colors.surface,
          borderBottomColor: colors.border,
        },
      ]}
    >
      <View style={styles.leftSection}>
        {onBack && (
          <TouchableOpacity
            style={[styles.iconButton, { backgroundColor: colors.inputBg }]}
            onPress={onBack}
            accessibilityRole="button"
            accessibilityLabel="Go back"
            activeOpacity={0.7}
          >
            <Text style={[styles.backIcon, { color: colors.primary }]}>‹</Text>
          </TouchableOpacity>
        )}
        <View style={styles.titleContainer}>
          <Text
            style={[styles.title, { color: colors.text }]}
            numberOfLines={1}
            ellipsizeMode="tail"
          >
            {title}
          </Text>
          {subtitle && (
            <Text
              style={[styles.subtitle, { color: colors.textSecondary }]}
              numberOfLines={1}
            >
              {subtitle}
            </Text>
          )}
        </View>
      </View>

      <View style={styles.rightSection}>
        {rightAction}

        {showLangToggle && (
          <TouchableOpacity
            style={[styles.toggleBtn, { backgroundColor: colors.inputBg, borderColor: colors.border }]}
            onPress={toggleLang}
            accessibilityRole="button"
            accessibilityLabel="Switch language"
            activeOpacity={0.7}
          >
            <Text style={[styles.toggleBtnText, { color: colors.text }]}>
              {lang === 'te' ? 'తెలుగు' : 'EN'}
            </Text>
          </TouchableOpacity>
        )}

        {showThemeToggle && (
          <TouchableOpacity
            style={[styles.toggleBtn, { backgroundColor: colors.inputBg, borderColor: colors.border }]}
            onPress={toggleTheme}
            accessibilityRole="button"
            accessibilityLabel="Toggle dark/light mode"
            activeOpacity={0.7}
          >
            <Text style={[styles.toggleBtnText, { color: colors.text }]}>
              {isDark ? '☀️' : '🌙'}
            </Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    height: 56,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  leftSection: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 8,
  },
  iconButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 10,
  },
  backIcon: {
    fontSize: 28,
    lineHeight: 30,
    fontWeight: '600',
  },
  titleContainer: {
    flex: 1,
  },
  title: {
    fontSize: 17,
    fontWeight: '700',
  },
  subtitle: {
    fontSize: 11,
    marginTop: 1,
  },
  rightSection: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  toggleBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 16,
    borderWidth: 1,
    minWidth: 40,
    alignItems: 'center',
  },
  toggleBtnText: {
    fontSize: 12,
    fontWeight: '600',
  },
});

