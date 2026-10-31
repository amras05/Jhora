import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  ScrollView,
} from 'react-native';
import { AstroConstants } from '../constants/astroConstants';
import { DashaPeriod } from '../models/astroModels';
import { DashaService } from '../services/dashaService';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';
import { AppColors } from '../theme/appTheme';

interface Props {
  dashas: DashaPeriod[];
  isDark: boolean;
  lang: 'te' | 'en';
}

export const DashaBrowser: React.FC<Props> = ({ dashas, isDark, lang }) => {
  const gold = AppColors.getGold(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const now = new Date();
  const hierarchy = DashaService.findCurrentHierarchy(dashas, now);

  // Expanded nodes state: keys like "Maha_Saturn", "Antar_Saturn_Mercury", "Prat_Saturn_Mercury_Venus", "Sook_Saturn_Mercury_Venus_Sun"
  const [expandedNodes, setExpandedNodes] = useState<Record<string, boolean>>(() => {
    const init: Record<string, boolean> = {};
    if (hierarchy.maha) {
      init[`M_${hierarchy.maha.planet}`] = true;
      if (hierarchy.antar) {
        init[`A_${hierarchy.maha.planet}_${hierarchy.antar.planet}`] = true;
        if (hierarchy.pratyantar) {
          init[`P_${hierarchy.maha.planet}_${hierarchy.antar.planet}_${hierarchy.pratyantar.planet}`] = true;
          if (hierarchy.sookshma) {
            init[`S_${hierarchy.maha.planet}_${hierarchy.antar.planet}_${hierarchy.pratyantar.planet}_${hierarchy.sookshma.planet}`] = true;
          }
        }
      }
    }
    return init;
  });

  const toggleNode = (nodeKey: string) => {
    setExpandedNodes(prev => ({
      ...prev,
      [nodeKey]: !prev[nodeKey],
    }));
  };

  const getPlanetName = (p: string) =>
    isTe ? (AstroConstants.planetNamesTelugu[p] || p) : p;

  const formatDate = (d: Date) => TeluguPdfReportGenerator.formatDate(d);
  const formatTime = (d: Date) => TeluguPdfReportGenerator.formatDateTime(d);
  const formatTimeSec = (d: Date) => TeluguPdfReportGenerator.formatDateTimeSeconds(d);

  return (
    <View style={styles.container}>
      {/* ─── 1. CURRENT 5-LEVEL DASHA HIGHLIGHT CARD (LIVE UP TO PRANA DASHA) ─── */}
      <View style={[styles.liveCard, { backgroundColor: isDark ? '#23150C' : '#FFFBEB', borderColor: gold }]}>
        <View style={styles.liveHeader}>
          <Text style={[styles.liveTitle, { color: isDark ? gold : AppColors.maroon }]}>
            ★ {isTe ? 'నడుస్తున్న సమగ్ర దశలు (5-స్థాయి ప్రాణ దశ వరకు)' : 'Currently Active 5-Level Dasha'}
          </Text>
          <View style={styles.liveBadge}>
            <View style={styles.liveDot} />
            <Text style={styles.liveBadgeText}>LIVE</Text>
          </View>
        </View>

        {/* 5-Level Pills Row: MD -> AD -> PD -> SD -> PrD */}
        <View style={styles.pillsRow}>
          {hierarchy.maha && (
            <View style={[styles.pill, { backgroundColor: '#F59E0B25', borderColor: '#F59E0B' }]}>
              <Text style={[styles.pillLabel, { color: '#B45309' }]}>MD</Text>
              <Text style={[styles.pillValue, { color: textPrimary }]}>{getPlanetName(hierarchy.maha.planet)}</Text>
            </View>
          )}

          {hierarchy.antar && (
            <View style={[styles.pill, { backgroundColor: '#EA580C25', borderColor: '#EA580C' }]}>
              <Text style={[styles.pillLabel, { color: '#C2410C' }]}>AD</Text>
              <Text style={[styles.pillValue, { color: textPrimary }]}>{getPlanetName(hierarchy.antar.planet)}</Text>
            </View>
          )}

          {hierarchy.pratyantar && (
            <View style={[styles.pill, { backgroundColor: '#10B98125', borderColor: '#10B981' }]}>
              <Text style={[styles.pillLabel, { color: '#15803D' }]}>PD</Text>
              <Text style={[styles.pillValue, { color: textPrimary }]}>{getPlanetName(hierarchy.pratyantar.planet)}</Text>
            </View>
          )}

          {hierarchy.sookshma && (
            <View style={[styles.pill, { backgroundColor: '#0284C725', borderColor: '#0284C7' }]}>
              <Text style={[styles.pillLabel, { color: '#0369A1' }]}>SD</Text>
              <Text style={[styles.pillValue, { color: textPrimary }]}>{getPlanetName(hierarchy.sookshma.planet)}</Text>
            </View>
          )}

          {hierarchy.prana && (
            <View style={[styles.pill, { backgroundColor: '#BE185D25', borderColor: '#BE185D' }]}>
              <Text style={[styles.pillLabel, { color: '#BE185D' }]}>PrD</Text>
              <Text style={[styles.pillValue, { color: textPrimary }]}>{getPlanetName(hierarchy.prana.planet)}</Text>
            </View>
          )}
        </View>

        {/* Detailed 5 Rows with Timestamps */}
        <View style={[styles.detailsBox, { backgroundColor: isDark ? '#140B06' : '#FFFFFF', borderColor }]}>
          {hierarchy.maha && (
            <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.detailKey, { color: '#B45309' }]}>మహాదశ (MD):</Text>
              <Text style={[styles.detailVal, { color: textPrimary }]}>
                <Text style={{ fontWeight: '800' }}>{getPlanetName(hierarchy.maha.planet)}</Text> ({formatDate(hierarchy.maha.startDate)} → {formatDate(hierarchy.maha.endDate)})
              </Text>
            </View>
          )}

          {hierarchy.antar && (
            <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.detailKey, { color: '#C2410C' }]}>అంతర్దశ (AD):</Text>
              <Text style={[styles.detailVal, { color: textPrimary }]}>
                <Text style={{ fontWeight: '800' }}>{getPlanetName(hierarchy.antar.planet)}</Text> ({formatDate(hierarchy.antar.startDate)} → {formatDate(hierarchy.antar.endDate)})
              </Text>
            </View>
          )}

          {hierarchy.pratyantar && (
            <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.detailKey, { color: '#15803D' }]}>ప్రత్యంతర (PD):</Text>
              <Text style={[styles.detailVal, { color: textPrimary }]}>
                <Text style={{ fontWeight: '800' }}>{getPlanetName(hierarchy.pratyantar.planet)}</Text> ({formatDate(hierarchy.pratyantar.startDate)} → {formatDate(hierarchy.pratyantar.endDate)})
              </Text>
            </View>
          )}

          {hierarchy.sookshma && (
            <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.detailKey, { color: '#0369A1' }]}>సూక్ష్మ దశ (SD):</Text>
              <Text style={[styles.detailVal, { color: textPrimary }]}>
                <Text style={{ fontWeight: '800' }}>{getPlanetName(hierarchy.sookshma.planet)}</Text> ({formatTime(hierarchy.sookshma.startDate)} → {formatTime(hierarchy.sookshma.endDate)})
              </Text>
            </View>
          )}

          {hierarchy.prana && (
            <View style={styles.detailRow}>
              <Text style={[styles.detailKey, { color: '#BE185D', fontWeight: '800' }]}>ప్రాణ దశ (PrD):</Text>
              <Text style={[styles.detailVal, { color: '#BE185D', fontWeight: '700' }]}>
                <Text style={{ fontWeight: '800' }}>{getPlanetName(hierarchy.prana.planet)}</Text> ({formatTimeSec(hierarchy.prana.startDate)} → {formatTimeSec(hierarchy.prana.endDate)})
              </Text>
            </View>
          )}
        </View>
      </View>

      {/* ─── 2. 5-LEVEL EXPANDABLE VIMSHOTTARI TREE (DOWN TO LEVEL 5 PRANA) ─── */}
      <View style={[styles.treeCard, { backgroundColor: cardBg, borderColor }]}>
        <Text style={[styles.treeHeader, { color: AppColors.maroon }]}>
          {isTe
            ? '🌳 వింశోత్తరి దశల సమగ్ర మహావృక్షం (5 Levels down to Prana)'
            : '5-Level Vimshottari Dasha Explorer'}
        </Text>
        <Text style={[styles.treeSub, { color: textSecondary }]}>
          {isTe
            ? 'ఏ దశపైనైనా నొక్కి క్రింది స్థాయి ప్రత్యంతర, సూక్ష్మ & ప్రాణ దశలను (సెకన్లతో సహా) చూడవచ్చు:'
            : 'Tap any period to expand sub-periods down to Prana Dasha:'}
        </Text>

        {dashas.map(maha => {
          const mKey = `M_${maha.planet}`;
          const isMOpen = !!expandedNodes[mKey];
          const isMActive = now >= maha.startDate && now < maha.endDate;
          const antars = isMOpen ? DashaService.getSubPeriods(maha) : [];

          return (
            <View key={maha.planet} style={[styles.nodeBox, { borderColor }]}>
              {/* Level 1: Maha Dasha */}
              <TouchableOpacity
                style={[
                  styles.nodeHeader,
                  { backgroundColor: isMActive ? (isDark ? '#3D200E' : '#FEF3C7') : 'transparent' },
                ]}
                onPress={() => toggleNode(mKey)}
                activeOpacity={0.7}
              >
                <View style={[styles.nodeIcon, { backgroundColor: isMActive ? gold : '#E2E8F0' }]}>
                  <Text style={[styles.nodeIconText, { color: isMActive ? '#000' : '#475569' }]}>
                    {AstroConstants.planetAbbrTelugu[maha.planet] || maha.planet.substring(0, 2)}
                  </Text>
                </View>

                <View style={styles.nodeMeta}>
                  <View style={styles.nodeTitleRow}>
                    <Text style={[styles.nodeTitle, { color: textPrimary }, isMActive && { color: AppColors.maroonLight, fontWeight: '800' }]}>
                      {getPlanetName(maha.planet)} మహాదశ
                    </Text>
                    {isMActive && (
                      <View style={styles.activeTag}>
                        <Text style={styles.activeTagText}>ప్రస్తుతం</Text>
                      </View>
                    )}
                  </View>
                  <Text style={[styles.nodeDates, { color: textSecondary }]}>
                    {formatDate(maha.startDate)} → {formatDate(maha.endDate)} ({maha.years?.toFixed(1)} సం.)
                  </Text>
                </View>

                <Text style={{ fontSize: 14, color: gold, paddingHorizontal: 6 }}>
                  {isMOpen ? '▼' : '▶'}
                </Text>
              </TouchableOpacity>

              {/* Level 2: Antar Dashas */}
              {isMOpen && (
                <View style={styles.levelContainer}>
                  {antars.map(antar => {
                    const aKey = `A_${maha.planet}_${antar.planet}`;
                    const isAOpen = !!expandedNodes[aKey];
                    const isAActive = now >= antar.startDate && now < antar.endDate;
                    const pratyantars = isAOpen ? DashaService.getSubPeriods(antar) : [];

                    return (
                      <View key={antar.planet} style={styles.antarWrapper}>
                        <TouchableOpacity
                          style={[
                            styles.subNodeHeader,
                            { paddingLeft: 16 },
                            isAActive && { backgroundColor: isDark ? '#4A2A14' : '#FEF3C7' },
                          ]}
                          onPress={() => toggleNode(aKey)}
                        >
                          <Text style={{ fontSize: 10, color: gold, marginRight: 6 }}>↳</Text>
                          <View style={{ flex: 1 }}>
                            <View style={styles.nodeTitleRow}>
                              <Text style={[styles.subNodeTitle, { color: textPrimary }, isAActive && { color: '#C2410C', fontWeight: '800' }]}>
                                {getPlanetName(antar.planet)} అంతర
                              </Text>
                              {isAActive && <View style={[styles.activeTag, { backgroundColor: '#EA580C' }]}><Text style={styles.activeTagText}>AD</Text></View>}
                            </View>
                            <Text style={[styles.subNodeDates, { color: textSecondary }]}>
                              {formatDate(antar.startDate)} → {formatDate(antar.endDate)}
                            </Text>
                          </View>
                          <Text style={{ fontSize: 12, color: gold, paddingHorizontal: 4 }}>
                            {isAOpen ? '▼' : '▶'}
                          </Text>
                        </TouchableOpacity>

                        {/* Level 3: Pratyantar Dashas */}
                        {isAOpen && (
                          <View style={styles.levelContainer}>
                            {pratyantars.map(prat => {
                              const pKey = `P_${maha.planet}_${antar.planet}_${prat.planet}`;
                              const isPOpen = !!expandedNodes[pKey];
                              const isPActive = now >= prat.startDate && now < prat.endDate;
                              const sookshmas = isPOpen ? DashaService.getSubPeriods(prat) : [];

                              return (
                                <View key={prat.planet} style={styles.pratWrapper}>
                                  <TouchableOpacity
                                    style={[
                                      styles.subNodeHeader,
                                      { paddingLeft: 28 },
                                      isPActive && { backgroundColor: isDark ? '#064E3B30' : '#ECFDF5' },
                                    ]}
                                    onPress={() => toggleNode(pKey)}
                                  >
                                    <Text style={{ fontSize: 8, color: '#10B981', marginRight: 6 }}>●</Text>
                                    <View style={{ flex: 1 }}>
                                      <View style={styles.nodeTitleRow}>
                                        <Text style={[styles.pratNodeTitle, { color: textPrimary }, isPActive && { color: '#15803D', fontWeight: '800' }]}>
                                          {getPlanetName(prat.planet)} ప్రత్యంతర
                                        </Text>
                                        {isPActive && <View style={[styles.activeTag, { backgroundColor: '#10B981' }]}><Text style={styles.activeTagText}>PD</Text></View>}
                                      </View>
                                      <Text style={[styles.subNodeDates, { color: textSecondary }]}>
                                        {formatDate(prat.startDate)} → {formatDate(prat.endDate)}
                                      </Text>
                                    </View>
                                    <Text style={{ fontSize: 11, color: gold, paddingHorizontal: 4 }}>
                                      {isPOpen ? '▼' : '▶'}
                                    </Text>
                                  </TouchableOpacity>

                                  {/* Level 4: Sookshma Dashas */}
                                  {isPOpen && (
                                    <View style={styles.levelContainer}>
                                      {sookshmas.map(sook => {
                                        const sKey = `S_${maha.planet}_${antar.planet}_${prat.planet}_${sook.planet}`;
                                        const isSOpen = !!expandedNodes[sKey];
                                        const isSActive = now >= sook.startDate && now < sook.endDate;
                                        const pranas = isSOpen ? DashaService.getSubPeriods(sook) : [];

                                        return (
                                          <View key={sook.planet} style={styles.sookWrapper}>
                                            <TouchableOpacity
                                              style={[
                                                styles.subNodeHeader,
                                                { paddingLeft: 40 },
                                                isSActive && { backgroundColor: isDark ? '#0C4A6E30' : '#E0F2FE' },
                                              ]}
                                              onPress={() => toggleNode(sKey)}
                                            >
                                              <Text style={{ fontSize: 8, color: '#0284C7', marginRight: 6 }}>◈</Text>
                                              <View style={{ flex: 1 }}>
                                                <View style={styles.nodeTitleRow}>
                                                  <Text style={[styles.sookNodeTitle, { color: textPrimary }, isSActive && { color: '#0369A1', fontWeight: '800' }]}>
                                                    {getPlanetName(sook.planet)} సూక్ష్మ
                                                  </Text>
                                                  {isSActive && <View style={[styles.activeTag, { backgroundColor: '#0284C7' }]}><Text style={styles.activeTagText}>SD</Text></View>}
                                                </View>
                                                <Text style={[styles.sookNodeDates, { color: textSecondary }]}>
                                                  {formatTime(sook.startDate)} → {formatTime(sook.endDate)}
                                                </Text>
                                              </View>
                                              <Text style={{ fontSize: 10, color: gold, paddingHorizontal: 4 }}>
                                                {isSOpen ? '▼' : '▶'}
                                              </Text>
                                            </TouchableOpacity>

                                            {/* Level 5: Prana Dashas (Down to Seconds) */}
                                            {isSOpen && (
                                              <View style={styles.pranaContainer}>
                                                {pranas.map(prana => {
                                                  const isPrActive = now >= prana.startDate && now < prana.endDate;
                                                  return (
                                                    <View
                                                      key={prana.planet}
                                                      style={[
                                                        styles.pranaRow,
                                                        isPrActive && { backgroundColor: isDark ? '#83184330' : '#FCE7F3' },
                                                      ]}
                                                    >
                                                      <Text style={{ fontSize: 7, color: '#BE185D', marginRight: 6 }}>★</Text>
                                                      <View style={{ flex: 1 }}>
                                                        <View style={styles.nodeTitleRow}>
                                                          <Text style={[styles.pranaTitle, { color: isPrActive ? '#BE185D' : textPrimary }, isPrActive && { fontWeight: '800' }]}>
                                                            {getPlanetName(prana.planet)} ప్రాణ దశ
                                                          </Text>
                                                          {isPrActive && (
                                                            <View style={[styles.activeTag, { backgroundColor: '#BE185D' }]}>
                                                              <Text style={styles.activeTagText}>PRANA</Text>
                                                            </View>
                                                          )}
                                                        </View>
                                                        <Text style={[styles.pranaDates, { color: isPrActive ? '#BE185D' : textSecondary }]}>
                                                          {formatTimeSec(prana.startDate)} నుండి {formatTimeSec(prana.endDate)}
                                                        </Text>
                                                      </View>
                                                    </View>
                                                  );
                                                })}
                                              </View>
                                            )}
                                          </View>
                                        );
                                      })}
                                    </View>
                                  )}
                                </View>
                              );
                            })}
                          </View>
                        )}
                      </View>
                    );
                  })}
                </View>
              )}
            </View>
          );
        })}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    gap: 12,
  },
  liveCard: {
    borderWidth: 1.5,
    borderRadius: 12,
    padding: 14,
  },
  liveHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  liveTitle: {
    fontSize: 13,
    fontWeight: '800',
  },
  liveBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#166534',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 12,
  },
  liveDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: '#4ADE80',
    marginRight: 4,
  },
  liveBadgeText: {
    color: '#FFF',
    fontSize: 9,
    fontWeight: '800',
  },
  pillsRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 6,
    marginBottom: 10,
  },
  pill: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 8,
    paddingVertical: 4,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  pillLabel: {
    fontSize: 10,
    fontWeight: '800',
  },
  pillValue: {
    fontSize: 11,
    fontWeight: '700',
  },
  detailsBox: {
    borderWidth: 1,
    borderRadius: 8,
    padding: 8,
  },
  detailRow: {
    flexDirection: 'row',
    paddingVertical: 4,
    borderBottomWidth: 0.5,
    alignItems: 'center',
  },
  detailKey: {
    width: 105,
    fontSize: 11,
    fontWeight: '700',
  },
  detailVal: {
    flex: 1,
    fontSize: 10.5,
  },
  treeCard: {
    borderRadius: 12,
    borderWidth: 1,
    padding: 12,
  },
  treeHeader: {
    fontSize: 14,
    fontWeight: '800',
    marginBottom: 2,
  },
  treeSub: {
    fontSize: 11,
    marginBottom: 10,
    lineHeight: 15,
  },
  nodeBox: {
    borderWidth: 0.8,
    borderRadius: 8,
    marginBottom: 8,
    overflow: 'hidden',
  },
  nodeHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 10,
  },
  nodeIcon: {
    width: 32,
    height: 32,
    borderRadius: 6,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 10,
  },
  nodeIconText: {
    fontSize: 11,
    fontWeight: '800',
  },
  nodeMeta: {
    flex: 1,
  },
  nodeTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  nodeTitle: {
    fontSize: 13,
    fontWeight: '700',
  },
  activeTag: {
    backgroundColor: '#166534',
    paddingHorizontal: 5,
    paddingVertical: 1,
    borderRadius: 4,
  },
  activeTagText: {
    color: '#FFF',
    fontSize: 8,
    fontWeight: '800',
  },
  nodeDates: {
    fontSize: 10.5,
    marginTop: 2,
  },
  levelContainer: {
    borderTopWidth: 0.5,
    borderTopColor: '#CBD5E140',
  },
  antarWrapper: {
    borderBottomWidth: 0.5,
    borderBottomColor: '#CBD5E130',
  },
  subNodeHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 7,
    paddingRight: 10,
  },
  subNodeTitle: {
    fontSize: 12,
    fontWeight: '600',
  },
  subNodeDates: {
    fontSize: 10,
    marginTop: 1,
  },
  pratWrapper: {
    borderBottomWidth: 0.5,
    borderBottomColor: '#CBD5E120',
  },
  pratNodeTitle: {
    fontSize: 11.5,
    fontWeight: '600',
  },
  sookWrapper: {
    borderBottomWidth: 0.5,
    borderBottomColor: '#CBD5E120',
  },
  sookNodeTitle: {
    fontSize: 11,
    fontWeight: '600',
  },
  sookNodeDates: {
    fontSize: 9.5,
    marginTop: 1,
  },
  pranaContainer: {
    backgroundColor: '#00000008',
  },
  pranaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 6,
    paddingLeft: 52,
    paddingRight: 12,
    borderBottomWidth: 0.5,
    borderBottomColor: '#CBD5E120',
  },
  pranaTitle: {
    fontSize: 10.5,
  },
  pranaDates: {
    fontSize: 9,
    marginTop: 1,
  },
});

