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

