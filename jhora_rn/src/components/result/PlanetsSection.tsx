import React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import { ChartData, PanchangaData } from '../../models/astroModels';
import { AstroConstants } from '../../constants/astroConstants';
import { TeluguPdfReportGenerator } from '../../services/teluguPdfReportGenerator';
import { ClassicalDetailsSection } from './ClassicalDetailsSection';
import { useTheme } from '../../context/ThemeContext';
import { useI18n } from '../../i18n';
import { Card, SectionHeader, Chip } from '../ui';
import { radius, spacing } from '../../theme/tokens';

interface PlanetsSectionProps {
  chartData: ChartData;
  panchanga: PanchangaData;
}

export const PlanetsSection: React.FC<PlanetsSectionProps> = ({ chartData, panchanga }) => {
  const { colors, isDark } = useTheme();
  const { t, isTe } = useI18n();

  const formatDms = (deg: number) => TeluguPdfReportGenerator.formatDms(deg);

  return (
    <View style={styles.container}>
      {/* 1. Planetary Positions */}
      <SectionHeader
        title={t('chartResult.planetsHeader')}
        icon="🪐"
      />

      <Card style={styles.tableCard}>
        {/* Table Header */}
        <View style={[styles.tableHeaderRow, { backgroundColor: colors.primary }]}>
          <Text style={[styles.headerCol, styles.colPlanet, styles.headerText]}>
            {t('chartResult.tableHeaderPlanet')}
          </Text>
          <Text style={[styles.headerCol, styles.colSign, styles.headerText]}>
            {t('chartResult.tableHeaderRashi')}
          </Text>
          <Text style={[styles.headerCol, styles.colDeg, styles.headerText]}>
            {t('chartResult.tableHeaderDegrees')}
          </Text>
          <Text style={[styles.headerCol, styles.colNak, styles.headerText]}>
            {t('chartResult.tableHeaderNakshatra')}
          </Text>
          <Text style={[styles.headerCol, styles.colDignity, styles.headerText]}>
            {t('chartResult.tableHeaderDignity')}
          </Text>
        </View>

        {/* Lagna Row */}
        <View
          style={[
            styles.tableRow,
            {
              backgroundColor: isDark ? 'rgba(212, 175, 55, 0.12)' : 'rgba(254, 243, 199, 0.6)',
              borderBottomColor: colors.border,
            },
          ]}
        >
          <Text style={[styles.colPlanet, styles.lagnaText, { color: colors.primary }]}>
            {t('chartResult.lagnaRow')}
          </Text>
          <Text style={[styles.colSign, styles.cellText, { color: colors.text }]}>
            {AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}
          </Text>
          <Text style={[styles.colDeg, styles.cellText, { color: colors.text }]}>
            {formatDms(chartData.ascendant.degreesInRashi || 0)}
          </Text>
          <Text style={[styles.colNak, styles.cellText, { color: colors.textSecondary }]}>
            -
          </Text>
          <Text style={[styles.colDignity, styles.cellText, { color: colors.gold, fontWeight: '700' }]}>
            {t('chartResult.lagnaCenter')}
          </Text>
        </View>

        {/* 9 Planets Rows */}
        {chartData.planets.map((p, idx) => {
          const isRetro = p.isRetrograde;
          const isCombust = p.isCombust;
          const teluguName = AstroConstants.planetNamesTelugu[p.name] || p.name;
          const rashiName = AstroConstants.rashisTelugu[p.rashiIndex];
          const nakName = AstroConstants.nakshatrasTelugu[p.nakshatraIndex];
          const padaText = `${p.pada}${t('chartResult.padaSuffix')}`;

          const dignityVariant =
            p.dignity === 'Exalted'
              ? 'success'
              : p.dignity === 'Debilitated'
              ? 'error'
              : p.dignity === 'Own Sign'
              ? 'gold'
              : 'default';

          return (
            <View
              key={p.name}
              style={[
                styles.tableRow,
                { borderBottomColor: colors.border },
                idx % 2 === 1 && { backgroundColor: isDark ? 'rgba(255,255,255,0.02)' : 'rgba(0,0,0,0.015)' },
              ]}
            >
              <View style={[styles.colPlanet, styles.planetCell]}>
                <Text style={[styles.planetName, { color: colors.text }]}>
                  {teluguName}
                </Text>
                {isRetro && (
                  <Text style={[styles.flagText, { color: colors.accent.orange }]}>
                    {t('chartResult.retroSuffix')}
                  </Text>
                )}
                {isCombust && (
                  <Text style={[styles.flagText, { color: colors.gold }]}>
                    {t('chartResult.combustSuffix')}
                  </Text>
                )}
              </View>

              <Text style={[styles.colSign, styles.cellText, { color: colors.text }]}>
                {rashiName}
              </Text>

              <Text style={[styles.colDeg, styles.cellText, { color: colors.text }]}>
                {formatDms(p.degreesInRashi)}
              </Text>

              <View style={[styles.colNak, styles.nakCell]}>
                <Text style={[styles.cellText, { color: colors.text }]}>
                  {nakName}
                </Text>
                <Text style={[styles.subText, { color: colors.textSecondary }]}>
                  {padaText}
                </Text>
              </View>

              <View style={[styles.colDignity, styles.dignityCell]}>
                <Chip
                  label={
                    p.dignity === 'Exalted'
                      ? t('chartResult.dignityExalted')
                      : p.dignity === 'Debilitated'
                      ? t('chartResult.dignityDebilitated')
                      : p.dignity === 'Own Sign'
                      ? t('chartResult.dignityOwnSign')
                      : t('chartResult.dignityNeutral')
                  }
                  variant={dignityVariant}
                  size="sm"
                />
              </View>
            </View>
          );
        })}
      </Card>

      {/* 2. Bhava Spashta (12 Houses) */}
      <SectionHeader
        title={t('chartResult.housesHeader')}
        icon="🏠"
      />

      <Card style={styles.tableCard}>
        <View style={[styles.tableHeaderRow, { backgroundColor: colors.primary }]}>
          <Text style={[styles.headerText, { flex: 1 }]}>భావం</Text>
          <Text style={[styles.headerText, { flex: 1.2 }]}>ఆరంభం</Text>
          <Text style={[styles.headerText, { flex: 1.2 }]}>మధ్యం (స్ఫుటం)</Text>
          <Text style={[styles.headerText, { flex: 1.2 }]}>ముగింపు</Text>
          <Text style={[styles.headerText, { flex: 1 }]}>భావాధిపతి</Text>
        </View>

        {Array.from({ length: 12 }, (_, i) => {
          const h = i + 1;
          const lagnaLon = chartData.ascendant.longitude;
          const midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
          const startLon = (midLon - 15.0 + 360.0) % 360.0;
          const endLon = (midLon + 15.0) % 360.0;
          const rIdx = Math.floor(midLon / 30.0) % 12;
          const lord = AstroConstants.rashiLordsTelugu[rIdx];

          return (
            <View
              key={h}
              style={[
                styles.tableRow,
                { borderBottomColor: colors.border },
                i % 2 === 1 && { backgroundColor: isDark ? 'rgba(255,255,255,0.02)' : 'rgba(0,0,0,0.015)' },
              ]}
            >
              <Text style={[{ flex: 1, fontSize: 12, fontWeight: '700' }, { color: colors.gold }]}>
                {t('chartResult.bhavaNumber', { n: h })}
              </Text>
              <Text style={[styles.houseCell, { color: colors.textSecondary }]}>
                {formatDms(startLon)}
              </Text>
              <Text style={[styles.houseCell, { color: colors.text, fontWeight: '700' }]}>
                {formatDms(midLon)}
              </Text>
              <Text style={[styles.houseCell, { color: colors.textSecondary }]}>
                {formatDms(endLon)}
              </Text>
              <Text style={[styles.houseCell, { color: colors.primary, fontWeight: '700' }]}>
                {lord}
              </Text>
            </View>
          );
        })}
      </Card>

      {/* 3. Birth Panchangam & Classical Details */}
      <SectionHeader
        title={t('chartPanchanga.sectionPanchanga')}
        icon="📖"
      />
      <ClassicalDetailsSection
        chartData={chartData}
        panchanga={panchanga}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.xs,
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
  headerCol: {},
  colPlanet: {
    width: 74,
  },
  colSign: {
    width: 66,
    textAlign: 'center',
  },
  colDeg: {
    width: 78,
    textAlign: 'center',
  },
  colNak: {
    flex: 1,
    paddingHorizontal: 4,
  },
  colDignity: {
    width: 68,
    alignItems: 'center',
  },
  planetCell: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  planetName: {
    fontSize: 12.5,
    fontWeight: '700',
  },
  lagnaText: {
    fontSize: 12.5,
    fontWeight: '800',
  },
  flagText: {
    fontSize: 10,
    fontWeight: '800',
  },
  cellText: {
    fontSize: 12,
  },
  subText: {
    fontSize: 10,
  },
  nakCell: {
    justifyContent: 'center',
  },
  dignityCell: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  houseCell: {
    flex: 1.2,
    fontSize: 11,
    textAlign: 'center',
  },
});
