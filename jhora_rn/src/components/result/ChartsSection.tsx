import React, { useState } from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity } from 'react-native';
import { ChartData, DivisionalChartType } from '../../models/astroModels';
import { DivisionalChartService } from '../../services/divisionalChartService';
import { SouthIndianChart } from '../SouthIndianChart';
import { useTheme } from '../../context/ThemeContext';
import { useI18n } from '../../i18n';
import { Card, SectionHeader } from '../ui';
import { radius, spacing } from '../../theme/tokens';

interface ChartsSectionProps {
  chartData: ChartData;
}

export const ChartsSection: React.FC<ChartsSectionProps> = ({ chartData }) => {
  const { colors } = useTheme();
  const { t } = useI18n();

  const [selectedVarga, setSelectedVarga] = useState<DivisionalChartType>(DivisionalChartType.d1);

  return (
    <View style={styles.container}>
      <SectionHeader
        title={t('chartResult.chartsHeader')}
        icon="🏛️"
      />

      {/* Varga Selector Pills */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.vargaScroll}
      >
        {Object.values(DivisionalChartType).map(vType => {
          const isSelected = selectedVarga === vType;
          return (
            <TouchableOpacity
              key={vType}
              style={[
                styles.vargaPill,
                {
                  backgroundColor: isSelected ? colors.primary : colors.inputBg,
                  borderColor: isSelected ? colors.primary : colors.border,
                },
              ]}
              onPress={() => setSelectedVarga(vType)}
              activeOpacity={0.7}
              accessibilityRole="tab"
              accessibilityState={{ selected: isSelected }}
            >
              <Text
                style={[
                  styles.vargaPillText,
                  { color: isSelected ? '#FFFFFF' : colors.textSecondary },
                  isSelected && styles.vargaPillTextActive,
                ]}
              >
                {vType.toUpperCase()}
              </Text>
            </TouchableOpacity>
          );
        })}
      </ScrollView>

      {/* Chart Display Card */}
      <Card style={styles.chartCard}>
        <View style={styles.chartWrapper}>
          <SouthIndianChart
            chart={chartData}
            title={DivisionalChartService.getDivisionalTitle(selectedVarga)}
            centerSub={DivisionalChartService.getDivisionalSignificance(selectedVarga)}
            placements={DivisionalChartService.getPlacementsForType(chartData, selectedVarga)}
            lagnaSignIndex={DivisionalChartService.getLagnaForType(chartData, selectedVarga)}
            size={320}
          />
        </View>
      </Card>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.xs,
  },
  vargaScroll: {
    flexDirection: 'row',
    gap: 6,
    paddingVertical: spacing.xs,
    paddingHorizontal: 2,
    marginBottom: spacing.xs,
  },
  vargaPill: {
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: radius.full,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  vargaPillText: {
    fontSize: 12,
    fontWeight: '600',
  },
  vargaPillTextActive: {
    fontWeight: '800',
  },
  chartCard: {
    padding: spacing.md,
    alignItems: 'center',
  },
  chartWrapper: {
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
  },
});
