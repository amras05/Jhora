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
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import { AshtakavargaData, PlanetShadbala } from '../models/astroModels';
import { AstroConstants } from '../constants/astroConstants';

interface Props {
  data: AshtakavargaData;
  shadbala?: PlanetShadbala[];
  isDark: boolean;
  lang?: 'te' | 'en';
}

const PLANETS_LIST = [
  'SAV', 'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'
];

export const AshtakavargaView: React.FC<Props> = ({
  data,
  shadbala,
  isDark,
  lang = 'te',
}) => {
  const [selectedPlanet, setSelectedPlanet] = useState<string>('SAV');
  const gold = AppColors.getGold(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const isSAV = selectedPlanet === 'SAV';
  const points: number[] = isSAV
    ? (data.sav || new Array(12).fill(0))
    : (data.bav[selectedPlanet] || new Array(12).fill(0));

  const totalPoints = points.reduce((acc, v) => acc + v, 0);

  const getPlanetLabel = (p: string) => {
    if (p === 'SAV') return isTe ? 'సర్వాష్టకవర్గ (SAV)' : 'Sarvashtakavarga (SAV)';
    return AstroConstants.planetNamesTelugu[p] || p;
  };

  return (
    <View style={styles.container}>
      {/* 1. Selector Chips for SAV & Individual Planets */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.chipsScroll}
      >
        {PLANETS_LIST.map((planet) => {
          const isSelected = selectedPlanet === planet;
          return (
            <TouchableOpacity
              key={planet}
              onPress={() => setSelectedPlanet(planet)}
              style={[
                styles.chip,
                {
                  backgroundColor: isSelected ? gold : (isDark ? '#231408' : '#FEF3C7'),
                  borderColor: isSelected ? gold : borderColor,
                },
              ]}
            >
              <Text
                style={[
                  styles.chipText,
                  {
                    color: isSelected ? (isDark ? '#000' : '#FFF') : textSecondary,
                    fontWeight: isSelected ? '800' : '600',
                  },
                ]}
              >
                {getPlanetLabel(planet)}
              </Text>
            </TouchableOpacity>
          );
        })}
      </ScrollView>

      {/* 2. Summary Card */}
      <View
        style={[
          styles.summaryCard,
          {
            backgroundColor: isDark ? '#231408' : '#FFFDF9',
            borderColor: isDark ? '#F59E0B60' : '#FDE68A',
          },
        ]}
      >
        <View style={styles.summaryLeft}>
          <Text style={[styles.summaryTitle, { color: textSecondary }]}>
            {isSAV
              ? (isTe ? 'సర్వాష్టకవర్గ మొత్తం బిందువులు' : 'Sarvashtakavarga Total Bindus')
              : `${getPlanetLabel(selectedPlanet)} ${isTe ? 'భిన్నాష్టకవర్గ (BAV)' : 'BAV Total'}`}
          </Text>
          <Text style={[styles.summaryPts, { color: gold }]}>
            {totalPoints} {isTe ? 'బిందువులు / రేఖలు' : 'Bindus / Rekhas'}
          </Text>
        </View>

        <View
          style={[
            styles.badgePill,
            {
              backgroundColor: isSAV
                ? (totalPoints >= 337 ? '#10B98125' : '#F59E0B20')
                : '#F59E0B20',
              borderColor: gold,
            },
          ]}
        >
          <Text style={[styles.badgeText, { color: gold }]}>
            {isSAV
              ? (totalPoints === 337 ? (isTe ? 'ప్రామాణికం (337)' : 'Standard (337)') : `${totalPoints} pts`)
              : (isTe ? 'పరాశరి సిద్ధాంతం' : 'Parashari')}
          </Text>
        </View>
      </View>

      {/* 3. 12 Signs Heatmap Grid (3 columns x 4 rows) */}
      <View style={styles.gridContainer}>
        {Array.from({ length: 12 }, (_, idx) => {
          const val = points[idx] || 0;
          const rashiName = AstroConstants.rashisTelugu[idx];

          let badgeBg = cardBg;
          let badgeBorder = borderColor;
          let valColor = textPrimary;
          let statusText = isSAV ? 'Average' : `${val} bindus`;

          if (isSAV) {
            if (val >= 28) {
              badgeBg = isDark ? '#064E3B35' : '#ECFDF5';
              badgeBorder = '#10B98180';
              valColor = isDark ? '#34D399' : '#047857';
              statusText = isTe ? 'శుభ ప్రదం' : 'Auspicious';
            } else if (val < 25) {
              badgeBg = isDark ? '#7F1D1D30' : '#FEF2F2';
              badgeBorder = '#EF444480';
              valColor = isDark ? '#F87171' : '#B91C1C';
              statusText = isTe ? 'అల్ప ఫలితం' : 'Low';
            } else {
              badgeBg = isDark ? '#78350F25' : '#FFFBEB';
              badgeBorder = '#F59E0B50';
              valColor = gold;
              statusText = isTe ? 'మధ్యమం' : 'Average';
            }
          } else {
            if (val >= 5) {
              badgeBg = isDark ? '#064E3B35' : '#ECFDF5';
              badgeBorder = '#10B98180';
              valColor = isDark ? '#34D399' : '#047857';
            } else if (val <= 3) {
              badgeBg = isDark ? '#7F1D1D30' : '#FEF2F2';
              badgeBorder = '#EF444480';
              valColor = isDark ? '#F87171' : '#B91C1C';
            }
          }

          return (
            <View
              key={idx}
              style={[
                styles.gridCell,
                {
                  backgroundColor: badgeBg,
                  borderColor: badgeBorder,
                },
              ]}
            >
              <Text style={[styles.cellRashi, { color: textPrimary }]} numberOfLines={1}>
                {rashiName}
              </Text>
              <Text style={[styles.cellPts, { color: valColor }]}>
                {val}
              </Text>
              <Text style={[styles.cellStatus, { color: valColor }]} numberOfLines={1}>
                {statusText}
              </Text>
            </View>
          );
        })}
      </View>

      {/* 4. Kakshya Division Legend Card */}
      <View style={[styles.legendCard, { backgroundColor: cardBg, borderColor }]}>
        <Text style={[styles.legendTitle, { color: gold }]}>
          ✦ {isTe ? 'కక్ష్యా విభాగాలు (3°45\' క్రమం)' : 'Kakshya Divisions (3°45\' Order)'}
        </Text>
        <Text style={[styles.legendDesc, { color: textSecondary }]}>
          1. Saturn (0°-3°45') • 2. Jupiter (3°45'-7°30') • 3. Mars (7°30'-11°15') • 4. Sun (11°15'-15°00') • 5. Venus (15°00'-18°45') • 6. Mercury (18°45'-22°30') • 7. Moon (22°30'-26°15') • 8. Lagna (26°15'-30°00')
        </Text>
      </View>

      {/* 5. Complete SAV 337 Table Matrix */}
      <View style={[styles.matrixCard, { backgroundColor: cardBg, borderColor }]}>
        <Text style={[styles.matrixHeader, { color: AppColors.maroon }]}>
          {isTe ? 'సర్వాష్టకవర్గ సమగ్ర 337 బిందువుల పట్టిక' : 'Complete Sarvashtakavarga 337 Matrix'}
        </Text>

        <View style={[styles.tableHeader, { backgroundColor: AppColors.maroon }]}>
          <Text style={[styles.tableHCol, { flex: 1.2 }]}>{isTe ? 'రాశి' : 'Sign'}</Text>
          {['రవి', 'చం', 'కు', 'బు', 'గు', 'శు', 'శని'].map((p) => (
            <Text key={p} style={[styles.tableHCol, { flex: 0.8 }]}>{p}</Text>
          ))}
          <Text style={[styles.tableHCol, { flex: 1, backgroundColor: gold, color: '#000' }]}>SAV</Text>
        </View>

        {AstroConstants.rashisTelugu.map((rName, rIdx) => {
          const savPts = data.sav[rIdx] || 0;
          const isHigh = savPts >= 28;
          const isLow = savPts < 25;
          const planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];

          return (
            <View
              key={rName}
              style={[
                styles.tableDataRow,
                { borderBottomColor: borderColor },
                isHigh && { backgroundColor: isDark ? '#064E3B25' : '#F0FDF4' },
                isLow && { backgroundColor: isDark ? '#7F1D1D20' : '#FEF2F2' },
              ]}
            >
              <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '700', color: textPrimary }]}>
                {rName}
              </Text>
              {planets.map((p) => (
                <Text key={p} style={[styles.tableDCol, { flex: 0.8, color: textPrimary }]}>
                  {data.bav[p]?.[rIdx] || 0}
                </Text>
              ))}
              <Text
                style={[
                  styles.tableDCol,
                  {
                    flex: 1,
                    fontWeight: '800',
                    color: isHigh ? '#10B981' : isLow ? '#EF4444' : gold,
                  },
                ]}
              >
                {savPts}
              </Text>
            </View>
          );
        })}
      </View>

      {/* 6. Shadbala Strengths Table */}
      {shadbala && shadbala.length > 0 && (
        <View style={[styles.matrixCard, { backgroundColor: cardBg, borderColor, marginTop: 14 }]}>
          <Text style={[styles.matrixHeader, { color: AppColors.maroon }]}>
            {isTe ? 'షడ్బల బలాబలాల సమగ్ర పట్టిక' : 'Shadbala Strengths'}
          </Text>
          <View style={[styles.tableHeader, { backgroundColor: AppColors.maroon }]}>
            <Text style={[styles.tableHCol, { flex: 1.5 }]}>{isTe ? 'గ్రహము' : 'Planet'}</Text>
            <Text style={[styles.tableHCol, { flex: 1 }]}>{isTe ? 'స్థాన' : 'Sthana'}</Text>
            <Text style={[styles.tableHCol, { flex: 1 }]}>{isTe ? 'దిగ్' : 'Dig'}</Text>
            <Text style={[styles.tableHCol, { flex: 1 }]}>{isTe ? 'కాల' : 'Kala'}</Text>
            <Text style={[styles.tableHCol, { flex: 1.2 }]}>{isTe ? 'రూపాలు' : 'Rupas'}</Text>
            <Text style={[styles.tableHCol, { flex: 0.8 }]}>{isTe ? 'ర్యాంకు' : 'Rank'}</Text>
          </View>
          {shadbala.map((sb) => (
            <View key={sb.planetName} style={[styles.tableDataRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.tableDCol, { flex: 1.5, fontWeight: '700', color: textPrimary }]}>
                {AstroConstants.planetNamesTelugu[sb.planetName] || sb.planetName}
              </Text>
              <Text style={[styles.tableDCol, { flex: 1, color: textPrimary }]}>{sb.sthanaBala.toFixed(0)}</Text>
              <Text style={[styles.tableDCol, { flex: 1, color: textPrimary }]}>{sb.digBala.toFixed(0)}</Text>
              <Text style={[styles.tableDCol, { flex: 1, color: textPrimary }]}>{sb.kalaBala.toFixed(0)}</Text>
              <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '800', color: gold }]}>{sb.totalRupas.toFixed(1)}</Text>
              <Text style={[styles.tableDCol, { flex: 0.8, fontWeight: '800', color: '#10B981' }]}>#{sb.rank}</Text>
            </View>
          ))}
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    paddingBottom: 24,
  },
  chipsScroll: {
    paddingVertical: 4,
    marginBottom: 12,
  },
  chip: {
    paddingHorizontal: 12,
    paddingVertical: 7,
    borderRadius: 18,
    borderWidth: 1,
    marginRight: 8,
  },
  chipText: {
    fontSize: 12,
  },
  summaryCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 14,
    borderRadius: 14,
    borderWidth: 1,
    marginBottom: 16,
  },
  summaryLeft: {
    flex: 1,
  },
  summaryTitle: {
    fontSize: 11,
  },
  summaryPts: {
    fontSize: 16,
    fontWeight: '800',
    marginTop: 2,
  },
  badgePill: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    borderWidth: 1,
  },
  badgeText: {
    fontSize: 11,
    fontWeight: '700',
  },
  gridContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginBottom: 14,
  },
  gridCell: {
    width: '31.5%',
    paddingVertical: 10,
    paddingHorizontal: 6,
    borderRadius: 12,
    borderWidth: 1,
    alignItems: 'center',
    marginBottom: 9,
  },
  cellRashi: {
    fontSize: 11,
    fontWeight: '700',
  },
  cellPts: {
    fontSize: 21,
    fontWeight: '900',
    marginVertical: 2,
  },
  cellStatus: {
    fontSize: 9.5,
    fontWeight: '600',
  },
  legendCard: {
    padding: 12,
    borderRadius: 12,
    borderWidth: 1,
    marginBottom: 14,
  },
  legendTitle: {
    fontSize: 12,
    fontWeight: '800',
    marginBottom: 4,
  },
  legendDesc: {
    fontSize: 10.5,
    lineHeight: 16,
  },
  matrixCard: {
    borderRadius: 12,
    borderWidth: 1,
    overflow: 'hidden',
  },
  matrixHeader: {
    padding: 12,
    fontSize: 14,
    fontWeight: '800',
  },
  tableHeader: {
    flexDirection: 'row',
    paddingVertical: 8,
    paddingHorizontal: 4,
  },
  tableHCol: {
    color: '#FFF',
    fontSize: 10.5,
    fontWeight: '700',
    textAlign: 'center',
  },
  tableDataRow: {
    flexDirection: 'row',
    paddingVertical: 8,
    paddingHorizontal: 4,
    borderBottomWidth: StyleSheet.hairlineWidth,
    alignItems: 'center',
  },
  tableDCol: {
    fontSize: 11,
    textAlign: 'center',
  },
});

