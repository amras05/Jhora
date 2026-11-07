import React from 'react';
import { StyleSheet, View } from 'react-native';
import { DashaPeriod } from '../../models/astroModels';
import { DashaBrowser } from '../DashaBrowser';
import { useTheme } from '../../context/ThemeContext';
import { useI18n } from '../../i18n';
import { SectionHeader } from '../ui';
import { spacing } from '../../theme/tokens';

interface DashaSectionProps {
  dashas: DashaPeriod[];
}

export const DashaSection: React.FC<DashaSectionProps> = ({ dashas }) => {
  const { isDark } = useTheme();
  const { t, isTe } = useI18n();

  return (
    <View style={styles.container}>
      <SectionHeader
        title={t('chartResult.tabDasha')}
        subtitle={t('dasha.treeSubtitle')}
        icon="⏳"
      />

      <DashaBrowser
        dashas={dashas}
        isDark={isDark}
        lang={isTe ? 'te' : 'en'}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.xs,
  },
});

