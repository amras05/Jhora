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
  TouchableOpacity,
  Modal,
  FlatList,
  TextInput,
  SafeAreaView,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, Card, SectionHeader, KeyValueRow } from '../components/ui';
import { radius, spacing } from '../theme/tokens';
import { CityDatabase, CityEntry } from '../services/cityDatabase';
import { AstroEngine } from '../services/astroEngine';
import { PanchangaData } from '../models/astroModels';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';
import { AstroConstants } from '../constants/astroConstants';

interface Props {
  onBack: () => void;
  // Optional for backward compatibility with App.tsx
  isDark?: boolean;
  lang?: 'te' | 'en';
}

export const PanchangaScreen: React.FC<Props> = ({ onBack }) => {
  const { colors, isDark } = useTheme();
  const { t, isTe } = useI18n();

  const [date, setDate] = useState(new Date());
  const [city, setCity] = useState<CityEntry>(CityDatabase.cities[0]);
  const [cityModal, setCityModal] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<CityEntry[]>(CityDatabase.cities.slice(0, 10));

  const changeDay = (delta: number) => {
    const next = new Date(date);
    next.setDate(next.getDate() + delta);
    setDate(next);
  };

  const handleSearch = (q: string) => {
    setSearchQuery(q);
    if (!q.trim()) setSearchResults(CityDatabase.cities.slice(0, 10));
    else setSearchResults(CityDatabase.search(q));
  };

  // Calculate Panchangam
  const p: PanchangaData = AstroEngine.calculatePanchanga(date, city.latitude, city.longitude, city.timezone);

  const tithiName =
    p.tithiIndex !== undefined
      ? `${p.paksha === 'Shukla Paksha' ? t('panchanga.pakshaShukla') : t('panchanga.pakshaKrishna')}${TeluguPdfReportGenerator.tithisTelugu[p.tithiIndex % 30]}`
      : p.tithi || '';

  const nakshatraName =
    p.nakshatraIndex !== undefined
      ? AstroConstants.nakshatrasTelugu[p.nakshatraIndex % 27]
      : p.nakshatra || '';

  const yogaName =
    p.yogaIndex !== undefined
      ? TeluguPdfReportGenerator.yogasTelugu[p.yogaIndex % 27]
      : p.yoga || '';

  const karanaName =
    TeluguPdfReportGenerator.karanasTelugu[p.karana] || p.karana;

  const weekdayName = TeluguPdfReportGenerator.weekdaysTelugu[date.getDay() % 7];

  return (
    <Screen style={styles.container}>
      <AppBar
        title={t('panchanga.appBarTitle')}
        onBack={onBack}
        rightAction={
          <TouchableOpacity
            onPress={() => setCityModal(true)}
            style={[styles.cityBtn, { backgroundColor: colors.inputBg, borderColor: colors.border }]}
            accessibilityRole="button"
            accessibilityLabel="Select city"
          >
            <Text style={[styles.cityBtnText, { color: colors.gold }]}>
              📍 {city.name}
            </Text>
          </TouchableOpacity>
        }
      />

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Date Selector Row */}
        <Card style={styles.dateCard}>
          <TouchableOpacity
            onPress={() => changeDay(-1)}
            style={[styles.navBtn, { backgroundColor: colors.inputBg }]}
            accessibilityRole="button"
            accessibilityLabel="Previous day"
          >
            <Text style={[styles.navArrow, { color: colors.gold }]}>◀</Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => setDate(new Date())}
            style={styles.dateCenter}
            activeOpacity={0.7}
          >
            <Text style={[styles.dateText, { color: colors.text }]}>
              {TeluguPdfReportGenerator.formatDate(date)}
            </Text>
            <Text style={[styles.dayText, { color: colors.gold }]}>
              {weekdayName}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => changeDay(1)}
            style={[styles.navBtn, { backgroundColor: colors.inputBg }]}
            accessibilityRole="button"
            accessibilityLabel="Next day"
          >
            <Text style={[styles.navArrow, { color: colors.gold }]}>▶</Text>
          </TouchableOpacity>
        </Card>

        {/* Primary Auspicious Elements */}
        <SectionHeader
          title={t('panchanga.coreElementsHeader')}
          icon="📖"
        />

        <Card>
          <KeyValueRow
            label={t('panchanga.tithiLabel')}
            value={tithiName}
            icon="🌕"
          />
          <KeyValueRow
            label={t('panchanga.nakshatraLabel')}
            value={nakshatraName}
            icon="⭐"
          />
          <KeyValueRow
            label={t('panchanga.yogaLabel')}
            value={yogaName}
            icon="✨"
          />
          <KeyValueRow
            label={t('panchanga.karanaLabel')}
            value={karanaName}
            icon="⚡"
          />
          <KeyValueRow
            label={t('panchanga.weekdayLabel')}
            value={weekdayName}
            icon="📅"
            borderBottom={false}
          />
        </Card>

        {/* Solar & Muhurtha Timings */}
        <SectionHeader
          title={t('panchanga.solarTimesHeader')}
          icon="☀️"
        />

        <Card>
          <KeyValueRow
            label={t('panchanga.sunriseRow')}
            value={TeluguPdfReportGenerator.formatTime(p.sunrise)}
            icon="🌅"
            valueColor={colors.gold}
          />
          <KeyValueRow
            label={t('panchanga.sunsetRow')}
            value={TeluguPdfReportGenerator.formatTime(p.sunset)}
            icon="🌇"
            valueColor={colors.accent.orange}
          />
          <KeyValueRow
            label={t('panchanga.abhijitRow')}
            value={`${TeluguPdfReportGenerator.formatTime(p.abhijitMuhurtha[0])} - ${TeluguPdfReportGenerator.formatTime(p.abhijitMuhurtha[1])}`}
            icon="🌟"
            valueColor={colors.accent.green}
          />
          <KeyValueRow
            label={t('panchanga.rahuKalamRow')}
            value={`${TeluguPdfReportGenerator.formatTime(p.rahuKalam[0])} - ${TeluguPdfReportGenerator.formatTime(p.rahuKalam[1])}`}
            icon="⚠️"
            valueColor={colors.accent.red}
          />
          <KeyValueRow
            label={t('panchanga.yamagandamRow')}
            value={`${TeluguPdfReportGenerator.formatTime(p.yamagandam[0])} - ${TeluguPdfReportGenerator.formatTime(p.yamagandam[1])}`}
            icon="⏳"
            valueColor={colors.accent.orange}
          />
          <KeyValueRow
            label={t('panchanga.gulikaRow')}
            value={`${TeluguPdfReportGenerator.formatTime(p.gulika[0])} - ${TeluguPdfReportGenerator.formatTime(p.gulika[1])}`}
            icon="⏱️"
            borderBottom={false}
          />
        </Card>
      </ScrollView>

      {/* City Search Modal */}
      <Modal visible={cityModal} animationType="slide" transparent>
        <SafeAreaView
          style={[styles.modalOverlay, { backgroundColor: colors.overlay }]}
        >
          <View
            style={[
              styles.modalBox,
              { backgroundColor: colors.surface, borderColor: colors.border },
            ]}
          >
            <View style={styles.modalHeader}>
              <Text style={[styles.modalTitle, { color: colors.text }]}>
                {t('panchanga.cityModalTitle')}
              </Text>
              <TouchableOpacity
                onPress={() => setCityModal(false)}
                style={styles.closeBtn}
                accessibilityRole="button"
                accessibilityLabel="Close"
              >
                <Text style={[styles.closeIcon, { color: colors.gold }]}>✕</Text>
              </TouchableOpacity>
            </View>

            <TextInput
              style={[
                styles.searchInput,
                {
                  borderColor: colors.border,
                  color: colors.text,
                  backgroundColor: colors.inputBg,
                },
              ]}
              placeholder={t('panchanga.citySearchPlaceholder')}
              placeholderTextColor={colors.textMuted}
              value={searchQuery}
              onChangeText={handleSearch}
              autoFocus
            />

            <FlatList
              data={searchResults}
              keyExtractor={item => `${item.name}-${item.latitude}`}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={[
                    styles.cityItem,
                    { borderBottomColor: colors.border },
                  ]}
                  onPress={() => {
                    setCity(item);
                    setCityModal(false);
                  }}
                  activeOpacity={0.7}
                >
                  <Text style={[styles.cityName, { color: colors.text }]}>
                    {item.name}
                  </Text>
                  <Text style={[styles.cityDetails, { color: colors.textSecondary }]}>
                    {item.state} ({item.latitude}°N, {item.longitude}°E)
                  </Text>
                </TouchableOpacity>
              )}
            />
          </View>
        </SafeAreaView>
      </Modal>
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
  cityBtn: {
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: radius.full,
    borderWidth: 1,
  },
  cityBtnText: {
    fontSize: 12,
    fontWeight: '700',
  },
  dateCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.md,
    marginVertical: spacing.sm,
  },
  navBtn: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  navArrow: {
    fontSize: 16,
    fontWeight: '700',
  },
  dateCenter: {
    alignItems: 'center',
  },
  dateText: {
    fontSize: 16,
    fontWeight: '800',
  },
  dayText: {
    fontSize: 13,
    marginTop: 2,
    fontWeight: '700',
  },
  modalOverlay: {
    flex: 1,
    justifyContent: 'center',
    padding: spacing.lg,
  },
  modalBox: {
    borderRadius: radius.lg,
    borderWidth: 1,
    padding: spacing.lg,
    maxHeight: '80%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  modalTitle: {
    fontSize: 16,
    fontWeight: '800',
  },
  closeBtn: {
    padding: spacing.xs,
  },
  closeIcon: {
    fontSize: 20,
    fontWeight: '700',
  },
  searchInput: {
    borderWidth: 1,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    fontSize: 14,
    marginBottom: spacing.md,
  },
  cityItem: {
    paddingVertical: spacing.md,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  cityName: {
    fontSize: 14,
    fontWeight: '700',
  },
  cityDetails: {
    fontSize: 11,
    marginTop: 2,
  },
});
