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

import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, Card, ThemedTextInput, PrimaryButton } from '../components/ui';
import { radius, spacing } from '../theme/tokens';
import { CityDatabase, CityEntry } from '../services/cityDatabase';
import { BirthData } from '../models/astroModels';
import { AstroEngine } from '../services/astroEngine';

interface Props {
  onBack: () => void;
  onGeneratePrasna: (birthData: BirthData) => void;
  // Optional for backward compatibility with App.tsx
  isDark?: boolean;
  lang?: 'te' | 'en';
}

export const PrasnaScreen: React.FC<Props> = ({
  onBack,
  onGeneratePrasna,
}) => {
  const { colors } = useTheme();
  const { t, isTe } = useI18n();

  const [query, setQuery] = useState('');
  const [kpNumber, setKpNumber] = useState('1');
  const [city] = useState<CityEntry>(CityDatabase.cities[0]);

  const handleGenerate = () => {
    const now = new Date();
    const kpNum = parseInt(kpNumber, 10) || 1;
    const clampedKp = Math.min(249, Math.max(1, kpNum));

    const title = query.trim()
      ? t('prasna.defaultTitleWithQuery', { query: query.trim(), kp: clampedKp })
      : t('prasna.defaultTitleNoQuery', { kp: clampedKp });

    const birthData: BirthData = {
      name: title,
      dateTime: now,
      latitude: city.latitude,
      longitude: city.longitude,
      timezone: city.timezone,
      placeName: `${city.name}, ${city.state}`,
      gender: t('prasna.genderValue'),
      kpNumber: clampedKp,
      customAscendantLon: AstroEngine.getKp249Longitude(clampedKp),
    };

    onGeneratePrasna(birthData);
  };

  return (
    <Screen style={styles.container}>
      <AppBar
        title={t('prasna.appBarTitle')}
        onBack={onBack}
      />

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Info Banner */}
        <Card
          variant="outlined"
          style={[
            styles.banner,
            {
              backgroundColor: `${colors.gold}15`,
              borderColor: `${colors.gold}40`,
            },
          ]}
        >
          <Text style={[styles.bannerTitle, { color: colors.gold }]}>
            {t('prasna.bannerTitle')}
          </Text>
          <Text style={[styles.bannerDesc, { color: colors.textSecondary }]}>
            {t('prasna.bannerDesc')}
          </Text>
        </Card>

        {/* Query Input */}
        <Card>
          <ThemedTextInput
            label={t('prasna.queryLabel')}
            placeholder={t('prasna.queryPlaceholder')}
            value={query}
            onChangeText={setQuery}
            onClear={() => setQuery('')}
          />
        </Card>

        {/* KP Number Input */}
        <Card>
          <ThemedTextInput
            label={t('prasna.kpLabel')}
            placeholder={t('prasna.kpPlaceholder')}
            keyboardType="numeric"
            value={kpNumber}
            onChangeText={setKpNumber}
            hint="Valid range: 1 to 249"
          />
        </Card>

        {/* Current Time Banner */}
        <Card>
          <Text style={[styles.timeLabel, { color: colors.textSecondary }]}>
            {t('prasna.momentLabel')}
          </Text>
          <Text style={[styles.timeValue, { color: colors.text }]}>
            {new Date().toLocaleTimeString()} • {city.name}, {city.state}
          </Text>
        </Card>

        {/* Submit */}
        <PrimaryButton
          title={t('prasna.submitButton')}
          onPress={handleGenerate}
          style={styles.submitBtn}
        />
      </ScrollView>
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.sm,
    paddingBottom: spacing.xxl,
  },
  banner: {
    padding: spacing.md,
    marginBottom: spacing.sm,
  },
  bannerTitle: {
    fontSize: 14,
    fontWeight: '800',
    marginBottom: spacing.xs,
  },
  bannerDesc: {
    fontSize: 12,
    lineHeight: 18,
  },
  timeLabel: {
    fontSize: 13,
    fontWeight: '600',
    marginBottom: 4,
  },
  timeValue: {
    fontSize: 14,
    fontWeight: '700',
  },
  submitBtn: {
    marginTop: spacing.md,
  },
});
