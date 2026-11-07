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
import { StyleSheet, View, Text } from 'react-native';
import {
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  SpecialPointsResult,
  DoshaAnalysis,
} from '../../models/astroModels';
import { GocharAnalysis } from '../../services/transitService';
import { VedicYoga } from '../../services/yogaService';
import { AstroConstants } from '../../constants/astroConstants';
import { TeluguPdfReportGenerator } from '../../services/teluguPdfReportGenerator';
import { AshtakavargaView } from '../AshtakavargaView';
import { useTheme } from '../../context/ThemeContext';
import { useI18n } from '../../i18n';
import { Card, SectionHeader, SegmentedControl, KeyValueRow, Chip } from '../ui';
import { radius, spacing } from '../../theme/tokens';

interface AnalysisSectionProps {
  chartData: ChartData;
  ashtakavarga: AshtakavargaData;
  shadbala: PlanetShadbala[];
  specialPoints: SpecialPointsResult;
  dosha: DoshaAnalysis;
  yogas: VedicYoga[];
  gochar: GocharAnalysis | null;
}

export const AnalysisSection: React.FC<AnalysisSectionProps> = ({
  chartData,
  ashtakavarga,
  shadbala,
  specialPoints,
  dosha,
  yogas,
  gochar,
}) => {
  const { colors, isDark } = useTheme();
  const { t, isTe } = useI18n();

  const [subTab, setSubTab] = useState<'transit' | 'yogas' | 'special' | 'ashtakavarga'>('transit');

  const formatDms = (deg: number) => TeluguPdfReportGenerator.formatDms(deg);

  return (
    <View style={styles.container}>
      {/* Sub-group pills */}
      <SegmentedControl
        options={[
          { key: 'transit', label: t('chartResult.tabTransit') },
          { key: 'yogas', label: t('chartResult.tabYogas') },
          { key: 'special', label: t('chartResult.tabSpecial') },
          { key: 'ashtakavarga', label: t('chartResult.tabAshtakavarga') },
        ]}
        selectedKey={subTab}
        onSelect={setSubTab}
        scrollable
      />

      {/* 1. TRANSIT TAB */}
      {subTab === 'transit' && gochar && (
        <View>
          {/* Saturn Sade Sati Card */}
          <Card
            style={[
              styles.infoCard,
              {
                backgroundColor: isDark ? 'rgba(59, 130, 246, 0.12)' : 'rgba(239, 246, 255, 0.9)',
                borderColor: colors.info,
              },
            ]}
          >
            <Text style={[styles.infoTitle, { color: colors.info }]}>
              {t('chartResult.transitSaturn')}
            </Text>
            <Text style={[styles.infoDesc, { color: colors.text }]}>
              {gochar.sadeSatiStatus}
            </Text>
          </Card>

          {/* Guru Bala Card */}
          <Card
            style={[
              styles.infoCard,
              {
                backgroundColor: isDark ? 'rgba(212, 175, 55, 0.12)' : 'rgba(254, 243, 199, 0.7)',
                borderColor: colors.gold,
              },
            ]}
          >
            <Text style={[styles.infoTitle, { color: colors.gold }]}>
              {t('chartResult.guruBala')}
            </Text>
            <Text style={[styles.infoDesc, { color: colors.text }]}>
              {gochar.guruBalaStatus}
            </Text>
          </Card>

          {/* Transit Positions Table */}
          <SectionHeader
            title={t('chartResult.transitHeader')}
            icon="🌌"
          />

          <Card style={styles.tableCard}>
            <View style={[styles.tableHeaderRow, { backgroundColor: colors.primary }]}>
              <Text style={[styles.headerText, { width: 68 }]}>గ్రహము</Text>
              <Text style={[styles.headerText, { width: 68 }]}>గోచార రాశి</Text>
              <Text style={[styles.headerText, { width: 78 }]}>చంద్రుని నుండి</Text>
              <Text style={[styles.headerText, { width: 64 }]}>SAV</Text>
              <Text style={[styles.headerText, { flex: 1 }]}>ప్రభావం</Text>
            </View>

            {gochar.transits.map((item, idx) => {
              const pName = item.teluguName || AstroConstants.planetNamesTelugu[item.planet] || item.planet;
              const rName = item.rashiTelugu || AstroConstants.rashisTelugu[item.rashiIndex];
              const isFav = item.isBenefic;

              return (
                <View
                  key={item.planet}
                  style={[
                    styles.tableRow,
                    { borderBottomColor: colors.border },
                    idx % 2 === 1 && { backgroundColor: isDark ? 'rgba(255,255,255,0.02)' : 'rgba(0,0,0,0.015)' },
                  ]}
                >
                  <Text style={[{ width: 68, fontSize: 13, fontWeight: '700' }, { color: colors.text }]}>
                    {pName}
                  </Text>
                  <Text style={[{ width: 68, fontSize: 12 }, { color: colors.text }]}>
                    {rName}
                  </Text>
                  <Text style={[{ width: 78, fontSize: 11.5, textAlign: 'center' }, { color: colors.textSecondary }]}>
                    {item.houseFromMoon}వ భావం
                  </Text>
                  <Text
                    style={[
                      { width: 64, fontSize: 12, fontWeight: '800', textAlign: 'center' },
                      { color: item.savPoints >= 28 ? colors.accent.green : colors.accent.red },
                    ]}
                  >
                    {item.savPoints} pts
                  </Text>
                  <View style={{ flex: 1, alignItems: 'center' }}>
                    <Chip
                      label={isFav ? 'శుభం' : 'సామాన్యం'}
                      variant={isFav ? 'success' : 'default'}
                      size="sm"
                    />
                  </View>
                </View>
              );
            })}
          </Card>
        </View>
      )}

      {/* 2. YOGAS & DOSHAS TAB */}
      {subTab === 'yogas' && (
        <View>
          {/* Dosha Analysis Cards */}
          <SectionHeader
            title={t('chartResult.doshaHeader')}
            icon="🛡️"
          />

          {/* Kuja Dosha */}
          <Card
            style={[
              styles.infoCard,
              {
                backgroundColor: dosha.kujaDosha.hasDosha
                  ? (isDark ? 'rgba(239, 68, 68, 0.15)' : '#FEF2F2')
                  : (isDark ? 'rgba(16, 185, 129, 0.15)' : '#F0FDF4'),
                borderColor: dosha.kujaDosha.hasDosha ? colors.accent.red : colors.accent.green,
              },
            ]}
          >
            <Text
              style={[
                styles.infoTitle,
                { color: dosha.kujaDosha.hasDosha ? colors.accent.red : colors.accent.green },
              ]}
            >
              {dosha.kujaDosha.hasDosha
                ? t('chartResult.kujaDoshaYes')
                : t('chartResult.kujaDoshaNo')}
            </Text>
            <Text style={[styles.infoDesc, { color: colors.text }]}>
              {dosha.kujaDosha.description}
            </Text>
          </Card>

          {/* Kaal Sarpa Dosha */}
          <Card
            style={[
              styles.infoCard,
              {
                backgroundColor: dosha.kaalSarpa.hasDosha
                  ? (isDark ? 'rgba(239, 68, 68, 0.15)' : '#FEF2F2')
                  : (isDark ? 'rgba(16, 185, 129, 0.15)' : '#F0FDF4'),
                borderColor: dosha.kaalSarpa.hasDosha ? colors.accent.red : colors.accent.green,
              },
            ]}
          >
            <Text
              style={[
                styles.infoTitle,
                { color: dosha.kaalSarpa.hasDosha ? colors.accent.red : colors.accent.green },
              ]}
            >
              {dosha.kaalSarpa.hasDosha
                ? t('chartResult.kaalSarpaYes', { type: dosha.kaalSarpa.teluguTypeName })
                : t('chartResult.kaalSarpaNo')}
            </Text>
            <Text style={[styles.infoDesc, { color: colors.text }]}>
              {dosha.kaalSarpa.description}
            </Text>
          </Card>

          {/* Detected Vedic Yogas */}
          <SectionHeader
            title={t('chartResult.yogasHeader')}
            icon="✨"
          />

          <Card>
            {yogas.map((yg, idx) => (
              <View
                key={yg.name}
                style={[
                  styles.yogaRow,
                  { borderBottomColor: colors.border },
                  idx === yogas.length - 1 && { borderBottomWidth: 0 },
                ]}
              >
                <View style={styles.yogaTop}>
                  <Text style={[styles.yogaTitle, { color: colors.primary }]}>
                    {yg.teluguName} ({yg.name})
                  </Text>
                  <Chip
                    label={yg.category.toUpperCase()}
                    variant={yg.category === 'mahapurusha' ? 'gold' : 'primary'}
                    size="sm"
                  />
                </View>
                <Text style={[styles.yogaDesc, { color: colors.textSecondary }]}>
                  {yg.teluguDescription}
                </Text>
              </View>
            ))}
          </Card>
        </View>
      )}

      {/* 3. SPECIAL POINTS TAB */}
      {subTab === 'special' && (
        <View>
          <SectionHeader
            title={t('chartResult.specialHeader')}
            icon="🎯"
          />

          <Card>
            <KeyValueRow
              label={t('chartResult.bhriguBinduLabel')}
              value={`${specialPoints.bhriguBinduRashi} ${formatDms(specialPoints.bhriguBinduRashiDeg)} (${specialPoints.bhriguBinduHouse}వ భావం)`}
              valueColor={colors.gold}
            />
            <KeyValueRow
              label={t('chartResult.yogiLabel')}
              value={`${specialPoints.yogiPlanet} (${specialPoints.yogiRashi} - ${specialPoints.yogiNakshatra})`}
              valueColor={colors.accent.green}
            />
            <KeyValueRow
              label={t('chartResult.sahayogiLabel')}
              value={specialPoints.sahayogiPlanet}
              valueColor={colors.info}
            />
            <KeyValueRow
              label={t('chartResult.avayogiLabel')}
              value={`${specialPoints.avayogiPlanet} (${specialPoints.avayogiRashi} - ${specialPoints.avayogiNakshatra})`}
              valueColor={colors.accent.red}
              borderBottom={false}
            />
          </Card>

          {/* Bhrigu Bindu Sacred Note */}
          <Card
            variant="outlined"
            style={[
              styles.infoCard,
              { backgroundColor: colors.stripBg, borderColor: `${colors.gold}40`, marginTop: 10 },
            ]}
          >
            <Text style={[styles.noteTitle, { color: colors.primary }]}>
              ✦ {t('chartResult.bhriguBinduLabel')}
            </Text>
            <Text style={[styles.noteBody, { color: colors.textSecondary }]}>
              {t('chartResult.bhriguDescription')}
            </Text>
          </Card>

          {/* 7 Chara Karakas */}
          <SectionHeader
            title={t('chartResult.charaKarakasTitle')}
            icon="⭐"
          />

          <Card style={styles.tableCard}>
            <View style={[styles.tableHeaderRow, { backgroundColor: colors.primary }]}>
              <Text style={[styles.headerText, { width: 100 }]}>కారకము</Text>
              <Text style={[styles.headerText, { width: 100 }]}>గ్రహము</Text>
              <Text style={[styles.headerText, { flex: 1 }]}>రాశి & అంశలు</Text>
            </View>

            {specialPoints.charaKarakas.map((ck, idx) => (
              <View
                key={ck.name}
                style={[
                  styles.tableRow,
                  { borderBottomColor: colors.border },
                  idx % 2 === 1 && { backgroundColor: isDark ? 'rgba(255,255,255,0.02)' : 'rgba(0,0,0,0.015)' },
                ]}
              >
                <Text style={[{ width: 100, fontSize: 13, fontWeight: '700' }, { color: colors.gold }]}>
                  {ck.name} ({ck.nameTelugu})
                </Text>
                <Text style={[{ width: 100, fontSize: 13, fontWeight: '800' }, { color: colors.text }]}>
                  {ck.planetTelugu}
                </Text>
                <Text style={[{ flex: 1, fontSize: 12 }, { color: colors.textSecondary }]}>
                  {ck.rashiTelugu} {formatDms(ck.degreeInRashi)}
                </Text>
              </View>
            ))}
          </Card>
        </View>
      )}

      {/* 4. ASHTAKAVARGA TAB */}
      {subTab === 'ashtakavarga' && (
        <View>
          <SectionHeader
            title={t('chartResult.tabAshtakavarga')}
            icon="📊"
          />
          <AshtakavargaView
            data={ashtakavarga}
            shadbala={shadbala}
            isDark={isDark}
            lang={isTe ? 'te' : 'en'}
          />
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.xs,
  },
  infoCard: {
    padding: spacing.md,
    borderWidth: 1,
    marginVertical: spacing.xs,
  },
  infoTitle: {
    fontSize: 14,
    fontWeight: '800',
    marginBottom: 4,
  },
  infoDesc: {
    fontSize: 12.5,
    lineHeight: 18,
  },
  tableCard: {
    padding: 0,
    overflow: 'hidden',
    borderRadius: radius.md,
  },
  tableHeaderRow: {
    flexDirection: 'row',
    paddingVertical: 10,
    paddingHorizontal: 8,
    alignItems: 'center',
  },
  headerText: {
    color: '#FFFFFF',
    fontSize: 11,
    fontWeight: '800',
    textAlign: 'center',
  },
  tableRow: {
    flexDirection: 'row',
    paddingVertical: 9,
    paddingHorizontal: 8,
    alignItems: 'center',
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  yogaRow: {
    paddingVertical: 10,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  yogaTop: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 4,
  },
  yogaTitle: {
    fontSize: 14,
    fontWeight: '800',
  },
  yogaDesc: {
    fontSize: 12,
    lineHeight: 17,
  },
  noteTitle: {
    fontSize: 13,
    fontWeight: '800',
    marginBottom: 4,
  },
  noteBody: {
    fontSize: 11.5,
    lineHeight: 17,
  },
});
