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
import { View, Text, StyleSheet, useWindowDimensions } from 'react-native';
import { AstroConstants } from '../constants/astroConstants';
import { ChartData, PlanetPosition } from '../models/astroModels';

interface Props {
  chart: ChartData;
  title: string;
  centerSub?: string;
  placements?: Record<number, PlanetPosition[]>;
  lagnaSignIndex?: number;
  size?: number;
}

export const SouthIndianChart: React.FC<Props> = ({
  chart,
  title,
  centerSub,
  placements,
  lagnaSignIndex,
  size,
}) => {
  const { width } = useWindowDimensions();
  const effectiveSize = size || Math.min(width - 32, 360);
  const cellSize = effectiveSize / 4;

  const lagnaIdx = lagnaSignIndex !== undefined ? lagnaSignIndex : chart.ascendant.rashiIndex;
  const lagnaName = AstroConstants.rashisTelugu[lagnaIdx];

  // Organize occupants per sign (0-11)
  const signOccupants: Record<number, string[]> = {};
  for (let i = 0; i < 12; i++) signOccupants[i] = [];

  signOccupants[lagnaIdx].push('ల');

  if (placements) {
    for (let sign = 0; sign < 12; sign++) {
      for (const p of placements[sign] || []) {
        const abbr = AstroConstants.planetAbbrTelugu[p.name] || p.abbreviation;
        const retro = p.isRetrograde ? '(వ)' : '';
        const combust = p.isCombust ? '(మౌ)' : '';
        signOccupants[sign].push(`${abbr}${retro}${combust}`);
      }
    }
  } else {
    for (const p of chart.planets) {
      const abbr = AstroConstants.planetAbbrTelugu[p.name] || p.abbreviation;
      const retro = p.isRetrograde ? '(వ)' : '';
      const combust = p.isCombust ? '(మౌ)' : '';
      signOccupants[p.rashiIndex].push(`${abbr}${retro}${combust}`);
    }
  }

  return (
    <View style={styles.wrapper}>
      {title ? <Text style={styles.chartTitle}>{title}</Text> : null}
      <View style={[styles.gridContainer, { width: effectiveSize, height: effectiveSize }]}>
        {/* Central 2x2 Box */}
        <View
          style={[
            styles.centerBox,
            {
              left: cellSize,
              top: cellSize,
              width: cellSize * 2,
              height: cellSize * 2,
            },
          ]}
        >
          <Text style={styles.centerSwastika}>卐</Text>
          <Text style={styles.centerHeading}>{title.split(' ')[0] || 'చక్రము'}</Text>
          {centerSub ? <Text style={styles.centerSubText} numberOfLines={2}>{centerSub}</Text> : null}
          <Text style={styles.centerLagna}>లగ్నం: {lagnaName}</Text>
        </View>

        {/* 12 Outer Sign Boxes */}
        {Object.entries(AstroConstants.southIndianGridCoords).map(([signStr, coord]) => {
          const signIdx = Number(signStr);
          const signName = AstroConstants.rashisTelugu[signIdx];
          const isLagna = signIdx === lagnaIdx;
          const occupants = signOccupants[signIdx] || [];

          return (
            <View
              key={signIdx}
              style={[
                styles.cell,
                {
                  left: coord.c * cellSize,
                  top: coord.r * cellSize,
                  width: cellSize,
                  height: cellSize,
                  backgroundColor: isLagna ? '#FFF7ED' : occupants.length > 0 ? '#FFFDF5' : '#FFFFFF',
                },
              ]}
            >
              <View style={styles.cellHeader}>
                <Text style={[styles.signName, isLagna && styles.lagnaSignName]} numberOfLines={1}>
                  {isLagna ? `★ ${signName}` : signName}
                </Text>
              </View>

              <View style={styles.planetsContainer}>
                {occupants.map((occ, idx) => {
                  const isL = occ === 'ల';
                  const isCombust = occ.includes('(మౌ)');
                  const isRetro = occ.includes('(వ)');

                  return (
                    <View
                      key={idx}
                      style={[
                        styles.planetPill,
                        isL && styles.lagnaPill,
                        isCombust && styles.combustPill,
                        isRetro && styles.retroPill,
                      ]}
                    >
                      <Text
                        style={[
                          styles.planetText,
                          isL && styles.lagnaBadge,
                          isCombust && styles.combustText,
                          isRetro && styles.retroText,
                        ]}
                      >
                        {occ}
                      </Text>
                    </View>
                  );
                })}
              </View>
            </View>
          );
        })}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    alignItems: 'center',
    marginVertical: 6,
  },
  chartTitle: {
    fontSize: 13,
    fontWeight: '800',
    color: '#6B1111',
    marginBottom: 6,
    textAlign: 'center',
  },
  gridContainer: {
    borderWidth: 2,
    borderColor: '#8B2500',
    position: 'relative',
    backgroundColor: '#FFFFFF',
    borderRadius: 6,
    overflow: 'hidden',
  },
  cell: {
    position: 'absolute',
    borderWidth: 0.5,
    borderColor: '#D4AF37',
    padding: 3,
    justifyContent: 'flex-start',
  },
  cellHeader: {
    borderBottomWidth: 0.5,
    borderBottomColor: '#FDE68A50',
    paddingBottom: 1,
    marginBottom: 2,
  },
  signName: {
    fontSize: 8,
    fontWeight: '800',
    color: '#78350F',
    lineHeight: 11,
  },
  lagnaSignName: {
    color: '#8B2500',
  },
  planetsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'center',
    alignItems: 'center',
    gap: 2,
  },
  planetPill: {
    paddingHorizontal: 2.5,
    paddingVertical: 1,
    borderRadius: 3,
  },
  lagnaPill: {
    backgroundColor: '#FEE2E2',
    borderWidth: 0.8,
    borderColor: '#EF4444',
  },
  combustPill: {
    backgroundColor: '#FEF3C7',
  },
  retroPill: {
    backgroundColor: '#FFEDD5',
  },
  planetText: {
    fontSize: 8.5,
    fontWeight: '800',
    color: '#1E293B',
    lineHeight: 11,
  },
  lagnaBadge: {
    color: '#B91C1C',
    fontWeight: '900',
  },
  combustText: {
    color: '#D97706',
  },
  retroText: {
    color: '#EA580C',
  },
  centerBox: {
    position: 'absolute',
    borderWidth: 1.5,
    borderColor: '#8B2500',
    backgroundColor: '#FFFBF0',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 4,
    zIndex: 2,
  },
  centerSwastika: {
    fontSize: 16,
    color: '#D4AF37',
    fontWeight: '900',
  },
  centerHeading: {
    fontSize: 12,
    fontWeight: '800',
    color: '#6B1111',
    marginTop: 1,
  },
  centerSubText: {
    fontSize: 8.5,
    color: '#8B2500',
    fontWeight: '600',
    textAlign: 'center',
    marginTop: 1,
    lineHeight: 11,
  },
  centerLagna: {
    fontSize: 8.5,
    color: '#166534',
    fontWeight: '800',
    marginTop: 2,
  },
});
