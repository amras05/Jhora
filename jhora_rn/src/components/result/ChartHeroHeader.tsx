import React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import { ChartData } from '../../models/astroModels';
import { AstroConstants } from '../../constants/astroConstants';
import { useTheme } from '../../context/ThemeContext';
import { useI18n } from '../../i18n';
import { Card, Chip } from '../ui';
import { radius, spacing } from '../../theme/tokens';

interface ChartHeroHeaderProps {
  chartData: ChartData;
}

export const ChartHeroHeader: React.FC<ChartHeroHeaderProps> = ({ chartData }) => {
  const { colors, isDark } = useTheme();
  const { t, isTe } = useI18n();

  const moon = chartData.planets.find(p => p.name === 'Moon') || chartData.planets[1];
  const lagnaRashi = AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex];
  const moonRashi = AstroConstants.rashisTelugu[moon.rashiIndex];
  const nakshatra = AstroConstants.nakshatrasTelugu[moon.nakshatraIndex];
  const pada = `${moon.pada}${t('chartResult.padaSuffix')}`;

  return (
    <Card
      style={[
        styles.heroCard,
        {
          backgroundColor: colors.stripBg,
          borderColor: `${colors.gold}40`,
        },
      ]}
    >
      <View style={styles.statsRow}>
        {/* Lagna Chip */}
        <View style={styles.statCol}>
          <Text style={[styles.statLabel, { color: colors.gold }]}>
            {t('chartResult.lagnaLabel').replace(':', '')}
          </Text>
          <Text style={[styles.statValue, { color: colors.text }]}>{lagnaRashi}</Text>
          <Text style={[styles.statDegree, { color: colors.textSecondary }]}>
            {(chartData.ascendant.degreesInRashi || 0).toFixed(1)}°
          </Text>
        </View>

        <View style={[styles.divider, { backgroundColor: `${colors.gold}30` }]} />

        {/* Rashi Chip */}
        <View style={styles.statCol}>
          <Text style={[styles.statLabel, { color: colors.gold }]}>
            {t('chartResult.rashiLabel').replace(':', '')}
          </Text>
          <Text style={[styles.statValue, { color: colors.text }]}>{moonRashi}</Text>
          <Text style={[styles.statDegree, { color: colors.textSecondary }]}>
            {moon.degreesInRashi.toFixed(1)}°
          </Text>
        </View>

        <View style={[styles.divider, { backgroundColor: `${colors.gold}30` }]} />

        {/* Nakshatra Chip */}
        <View style={styles.statCol}>
          <Text style={[styles.statLabel, { color: colors.gold }]}>
            {t('chartResult.nakshatraLabel').replace(':', '')}
          </Text>
          <Text style={[styles.statValue, { color: colors.text }]} numberOfLines={1}>
            {nakshatra}
          </Text>
          <Text style={[styles.statDegree, { color: colors.textSecondary }]}>{pada}</Text>
        </View>
      </View>
    </Card>
  );
};

const styles = StyleSheet.create({
  heroCard: {
    marginVertical: spacing.xs,
    paddingVertical: spacing.sm + 2,
    paddingHorizontal: spacing.md,
    borderRadius: radius.md,
    borderWidth: 1,
  },
  statsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  statCol: {
    flex: 1,
    alignItems: 'center',
    paddingHorizontal: 2,
  },
  statLabel: {
    fontSize: 11,
    fontWeight: '800',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: 2,
  },
  statValue: {
    fontSize: 15,
    fontWeight: '800',
    textAlign: 'center',
  },
  statDegree: {
    fontSize: 10.5,
    fontWeight: '600',
    marginTop: 1,
  },
  divider: {
    width: StyleSheet.hairlineWidth,
    height: 36,
  },
});

