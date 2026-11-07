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

import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  ScrollView,
  TouchableOpacity,
  Text,
  ActivityIndicator,
  Alert,
} from 'react-native';
import {
  BirthData,
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  DashaPeriod,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
} from '../models/astroModels';
import { AstroEngine } from '../services/astroEngine';
import { DashaService } from '../services/dashaService';
import { YogaService, VedicYoga } from '../services/yogaService';
import { DoshaService } from '../services/doshaService';
import { TransitService, GocharAnalysis } from '../services/transitService';
import { SavedHoroscopeService } from '../services/savedHoroscopeService';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, SegmentedControl } from '../components/ui';
import {
  ChartHeroHeader,
  ChartsSection,
  PlanetsSection,
  ClassicalDetailsSection,
  DashaSection,
  AnalysisSection,
} from '../components/result';
import { spacing } from '../theme/tokens';

type ResultTab = 'charts' | 'panchanga' | 'planets' | 'dasha' | 'analysis';

interface Props {
  birthData: BirthData;
  onBack: () => void;
  onOpenPdfReport: (data: {
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    special: SpecialPointsResult;
    panchanga: PanchangaData;
    dosha: DoshaAnalysis;
    dashas: DashaPeriod[];
    yogas?: VedicYoga[];
    gochar?: GocharAnalysis | null;
  }) => void;
  // Optional for backward compatibility with App.tsx
  isDark?: boolean;
  onToggleTheme?: () => void;
  lang?: 'te' | 'en';
}

export const ChartResultScreen: React.FC<Props> = ({
  birthData,
  onBack,
  onOpenPdfReport,
}) => {
  const { colors } = useTheme();
  const { t, isTe } = useI18n();

  const [loading, setLoading] = useState(true);
  const [chartData, setChartData] = useState<ChartData | null>(null);
  const [ashtakavarga, setAshtakavarga] = useState<AshtakavargaData | null>(null);
  const [shadbala, setShadbala] = useState<PlanetShadbala[]>([]);
  const [panchanga, setPanchanga] = useState<PanchangaData | null>(null);
  const [specialPoints, setSpecialPoints] = useState<SpecialPointsResult | null>(null);
  const [dosha, setDosha] = useState<DoshaAnalysis | null>(null);
  const [yogas, setYogas] = useState<VedicYoga[]>([]);
  const [gochar, setGochar] = useState<GocharAnalysis | null>(null);
  const [dashas, setDashas] = useState<DashaPeriod[]>([]);
  const [isSaved, setIsSaved] = useState(false);

  // 4 Primary Tab Groups
  const [activeTab, setActiveTab] = useState<ResultTab>('charts');

  useEffect(() => {
    calculateAll();
  }, [birthData]);

  const calculateAll = async () => {
    setLoading(true);
    try {
      const res = await AstroEngine.calculateChart(birthData);
      const moon = res.chartData.planets.find(p => p.name === 'Moon') || res.chartData.planets[1];
      const dList = DashaService.calculateVimshottariDashas(moon.longitude, birthData.dateTime);
      const ygList = YogaService.detectYogas(res.chartData);
      const ds = DoshaService.analyze(res.chartData);
      const gc = TransitService.calculateGochar(res.chartData, new Date(), res.ashtakavarga);

      setChartData(res.chartData);
      setAshtakavarga(res.ashtakavarga);
      setShadbala(res.shadbala);
      setPanchanga(res.panchanga);
      setSpecialPoints(res.specialPoints);
      setDosha(ds);
      setYogas(ygList);
      setGochar(gc);
      setDashas(dList);
    } catch (e: any) {
      Alert.alert(t('common.error'), e?.message || 'Calculation error');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    await SavedHoroscopeService.save(birthData);
    setIsSaved(true);
    Alert.alert(t('chartResult.alertSavedTitle'), t('chartResult.alertSavedMsg'));
  };

  const handleOpenPdf = () => {
    if (!chartData || !ashtakavarga || !panchanga || !specialPoints || !dosha) return;
    onOpenPdfReport({
      chartData,
      ashtakavarga,
      shadbala,
      special: specialPoints,
      panchanga,
      dosha,
      dashas,
      yogas,
      gochar,
    });
  };

  return (
    <Screen style={styles.container}>
      <AppBar
        title={birthData.name || t('chartResult.fallbackAppBarTitle')}
        subtitle={`${TeluguPdfReportGenerator.formatDate(birthData.dateTime)} • ${birthData.placeName}`}
        onBack={onBack}
        showThemeToggle
        rightAction={
          <View style={styles.appBarActions}>
            <TouchableOpacity
              onPress={handleSave}
              style={[styles.actionIconBtn, { backgroundColor: colors.inputBg, borderColor: colors.border }]}
              accessibilityRole="button"
              accessibilityLabel="Save horoscope"
            >
              <Text style={styles.actionIcon}>{isSaved ? '🔖' : '📑'}</Text>
            </TouchableOpacity>

            <TouchableOpacity
              onPress={handleOpenPdf}
              style={[styles.pdfTopBtn, { backgroundColor: colors.gold }]}
              accessibilityRole="button"
              accessibilityLabel="Download PDF report"
            >
              <Text style={styles.pdfTopBtnText}>{t('chartResult.pdfButtonLabel')}</Text>
            </TouchableOpacity>
          </View>
        }
      />

      {loading ? (
        <View style={styles.loadingBox}>
          <ActivityIndicator size="large" color={colors.gold} />
          <Text style={[styles.loadingText, { color: colors.text }]}>
            {t('chartResult.loading')}
          </Text>
        </View>
      ) : chartData && ashtakavarga && panchanga && specialPoints && dosha ? (
        <View style={styles.content}>
          {/* Sticky Astrological Placement Stats */}
          <ChartHeroHeader chartData={chartData} />

          {/* 5 Primary Segmented Tabs */}
          <SegmentedControl<ResultTab>
            scrollable={true}
            options={[
              { key: 'charts', label: t('chartResult.tabCharts') },
              { key: 'panchanga', label: isTe ? '📅 పంచాంగం & వివరాలు' : '📅 Panchangam' },
              { key: 'planets', label: t('chartResult.tabPlanets') },
              { key: 'dasha', label: t('chartResult.tabDasha') },
              { key: 'analysis', label: isTe ? '📊 విశ్లేషణ' : '📊 Analysis' },
            ]}
            selectedKey={activeTab}
            onSelect={setActiveTab}
          />

          <ScrollView
            style={styles.scrollArea}
            contentContainerStyle={styles.scrollContent}
            showsVerticalScrollIndicator={false}
          >
            {activeTab === 'charts' && (
              <ChartsSection chartData={chartData} />
            )}

            {activeTab === 'panchanga' && (
              <ClassicalDetailsSection chartData={chartData} panchanga={panchanga} />
            )}

            {activeTab === 'planets' && (
              <PlanetsSection chartData={chartData} panchanga={panchanga} />
            )}

            {activeTab === 'dasha' && (
              <DashaSection dashas={dashas} />
            )}

            {activeTab === 'analysis' && (
              <AnalysisSection
                chartData={chartData}
                ashtakavarga={ashtakavarga}
                shadbala={shadbala}
                specialPoints={specialPoints}
                dosha={dosha}
                yogas={yogas}
                gochar={gochar}
              />
            )}
          </ScrollView>
        </View>
      ) : null}
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    paddingHorizontal: spacing.md,
  },
  appBarActions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  actionIconBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  actionIcon: {
    fontSize: 16,
  },
  pdfTopBtn: {
    paddingHorizontal: 12,
    paddingVertical: 7,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pdfTopBtnText: {
    color: '#000000',
    fontWeight: '800',
    fontSize: 12,
  },
  loadingBox: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.xl,
  },
  loadingText: {
    marginTop: 12,
    fontSize: 14,
    fontWeight: '600',
    textAlign: 'center',
  },
  scrollArea: {
    flex: 1,
  },
  scrollContent: {
    paddingBottom: spacing.xxxl,
  },
});
