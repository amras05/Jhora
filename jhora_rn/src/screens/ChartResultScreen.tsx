import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  ActivityIndicator,
  Alert,
  Platform,
} from 'react-native';
import { AstroConstants } from '../constants/astroConstants';
import {
  BirthData,
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  DashaPeriod,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
  DivisionalChartType,
} from '../models/astroModels';
import { AstroEngine } from '../services/astroEngine';
import { DashaService } from '../services/dashaService';
import { DivisionalChartService } from '../services/divisionalChartService';
import { YogaService, VedicYoga } from '../services/yogaService';
import { DoshaService } from '../services/doshaService';
import { TransitService, GocharAnalysis } from '../services/transitService';
import { SavedHoroscopeService } from '../services/savedHoroscopeService';
import { SouthIndianChart } from '../components/SouthIndianChart';
import { DashaBrowser } from '../components/DashaBrowser';
import { ChartPanchangaView } from '../components/ChartPanchangaView';
import { AshtakavargaView } from '../components/AshtakavargaView';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';
import { AppColors } from '../theme/appTheme';

interface Props {
  birthData: BirthData;
  isDark: boolean;
  onToggleTheme: () => void;
  lang: 'te' | 'en';
  onBack: () => void;
  onOpenPdfReport: (data: {
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    special: SpecialPointsResult;
    panchanga: PanchangaData;
    dosha: DoshaAnalysis;
    dashas: DashaPeriod[];
  }) => void;
}

export const ChartResultScreen: React.FC<Props> = ({
  birthData,
  isDark,
  onToggleTheme,
  lang,
  onBack,
  onOpenPdfReport,
}) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

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

  // Tabs
  const [activeTab, setActiveTab] = useState<
    'panchanga' | 'charts' | 'planets' | 'ashtakavarga' | 'dasha' | 'transit' | 'yogas' | 'special'
  >('charts');

  const [selectedVarga, setSelectedVarga] = useState<DivisionalChartType>(DivisionalChartType.d1);
  const [selectedMahaIdx, setSelectedMahaIdx] = useState(0);

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
      Alert.alert('Error', e?.message || 'Calculation error');
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    await SavedHoroscopeService.save(birthData);
    setIsSaved(true);
    Alert.alert(isTe ? 'విజయవంతం' : 'Saved', isTe ? 'జాతక ప్రొఫైల్ భద్రపరచబడింది!' : 'Horoscope profile saved successfully!');
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
    });
  };

  const formatDms = (deg: number) => TeluguPdfReportGenerator.formatDms(deg);

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      {/* Top App Bar */}
      <View style={[styles.appBar, { borderColor, backgroundColor: cardBg }]}>
        <TouchableOpacity onPress={onBack} style={styles.backBtn}>
          <Text style={[styles.backIcon, { color: gold }]}>‹</Text>
        </TouchableOpacity>

        <View style={styles.appBarCenter}>
          <Text style={[styles.appBarTitle, { color: textPrimary }]} numberOfLines={1}>
            {birthData.name || 'జాతక చక్రము'}
          </Text>
          <Text style={[styles.appBarSub, { color: textSecondary }]} numberOfLines={1}>
            {TeluguPdfReportGenerator.formatDate(birthData.dateTime)} • {birthData.placeName}
          </Text>
        </View>

        <View style={styles.appBarActions}>
          <TouchableOpacity onPress={onToggleTheme} style={styles.actionIconBtn}>
            <Text style={{ fontSize: 16 }}>{isDark ? '☀️' : '🌙'}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={handleSave} style={styles.actionIconBtn}>
            <Text style={{ fontSize: 16 }}>{isSaved ? '🔖' : '📑'}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={handleOpenPdf} style={[styles.pdfTopBtn, { backgroundColor: gold }]}>
            <Text style={styles.pdfTopBtnText}>📄 PDF</Text>
          </TouchableOpacity>
        </View>
      </View>

      {loading ? (
        <View style={styles.loadingBox}>
          <ActivityIndicator size="large" color={gold} />
          <Text style={[styles.loadingText, { color: textPrimary }]}>
            {isTe ? 'సమగ్ర వేద జ్యోతిష గణన జరుగుతోంది...' : 'Calculating Vedic Horoscope...'}
          </Text>
        </View>
      ) : chartData && ashtakavarga && panchanga && specialPoints && dosha ? (
        <>
          {/* Quick Astrological Key Placements Strip */}
          {(() => {
            const moon = chartData.planets.find(p => p.name === 'Moon') || chartData.planets[1];
            return (
              <View style={[styles.summaryStrip, { backgroundColor: isDark ? '#231408' : '#FFFBEB', borderBottomColor: borderColor }]}>
                <Text style={[styles.summaryStripText, { color: textPrimary }]}>
                  <Text style={{ fontWeight: '800', color: gold }}>{isTe ? 'లగ్నం: ' : 'Lagna: '}</Text>
                  {AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}
                  <Text style={{ color: textSecondary }}>  •  </Text>
                  <Text style={{ fontWeight: '800', color: gold }}>{isTe ? 'జన్మ రాశి: ' : 'Rashi: '}</Text>
                  {AstroConstants.rashisTelugu[moon.rashiIndex]}
                  <Text style={{ color: textSecondary }}>  •  </Text>
                  <Text style={{ fontWeight: '800', color: gold }}>{isTe ? 'నక్షత్రం: ' : 'Nakshatra: '}</Text>
                  {AstroConstants.nakshatrasTelugu[moon.nakshatraIndex]} ({moon.pada}{isTe ? 'వ పాదం' : 'P'})
                </Text>
              </View>
            );
          })()}
          {/* 8 Tab Navigation Pills */}
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={[styles.tabBar, { borderColor }]}>
            {[
              { id: 'charts', label: isTe ? '🏛️ చక్రాలు' : '🏛️ Charts' },
              { id: 'panchanga', label: isTe ? '📅 పంచాంగం' : '📅 Panchanga' },
              { id: 'planets', label: isTe ? '🪐 గ్రహాలు & భావాలు' : '🪐 Planets & Houses' },
              { id: 'ashtakavarga', label: isTe ? '📊 అష్టకవర్గ' : '📊 Ashtakavarga' },
              { id: 'dasha', label: isTe ? '⏳ దశలు (80 Yrs)' : '⏳ Dashas' },
              { id: 'transit', label: isTe ? '🌌 గోచారం' : '🌌 Transit' },
              { id: 'yogas', label: isTe ? '✨ యోగాలు & దోషాలు' : '✨ Yogas & Doshas' },
              { id: 'special', label: isTe ? '🎯 యోగీ & భృగు' : '🎯 Yogi & Destiny' },
            ].map(tab => {
              const active = activeTab === tab.id;
              return (
                <TouchableOpacity
                  key={tab.id}
                  style={[
                    styles.tabPill,
                    { borderColor },
                    active && { backgroundColor: AppColors.maroon, borderColor: AppColors.maroon },
                  ]}
                  onPress={() => setActiveTab(tab.id as any)}
                >
                  <Text style={[styles.tabPillText, { color: textSecondary }, active && { color: '#FFF', fontWeight: '800' }]}>
                    {tab.label}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </ScrollView>

          <ScrollView style={{ flex: 1, width: '100%' }} contentContainerStyle={styles.scrollContent}>
            {/* 1. CHARTS TAB */}
            {activeTab === 'charts' && (
              <View>
                <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
                  <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                    {isTe ? 'షోడశవర్గ చక్రములు (16 Classical Divisional Charts)' : '16 Shodashavarga Charts'}
                  </Text>

                  {/* Varga Selector Pills */}
                  <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ marginVertical: 8 }}>
                    {Object.values(DivisionalChartType).map(t => {
                      const isSel = selectedVarga === t;
                      return (
                        <TouchableOpacity
                          key={t}
                          style={[
                            styles.vargaPill,
                            { borderColor },
                            isSel && { backgroundColor: AppColors.maroon, borderColor: AppColors.maroon },
                          ]}
                          onPress={() => setSelectedVarga(t)}
                        >
                          <Text
                            style={[
                              styles.vargaPillText,
                              { color: textSecondary },
                              isSel && { color: '#FFF', fontWeight: '800' },
                            ]}
                          >
                            {t.toUpperCase()} - {DivisionalChartService.getDivisionalCenterName(t)}
                          </Text>
                        </TouchableOpacity>
                      );
                    })}
                  </ScrollView>

                  <View style={{ alignItems: 'center', marginVertical: 8 }}>
                    <SouthIndianChart
                      chart={chartData}
                      title={DivisionalChartService.getDivisionalTitle(selectedVarga)}
                      centerSub={DivisionalChartService.getDivisionalSignificance(selectedVarga)}
                      placements={DivisionalChartService.getPlacementsForType(chartData, selectedVarga)}
                      lagnaSignIndex={DivisionalChartService.getLagnaForType(chartData, selectedVarga)}
                      size={Platform.OS === 'web' ? 360 : 320}
                    />
                  </View>

                  <View style={[styles.infoBanner, { backgroundColor: isDark ? '#1C110A' : '#FFFDF9', borderColor }]}>
                    <Text style={[styles.infoTitle, { color: AppColors.maroonLight }]}>
                      ✦ {DivisionalChartService.getDivisionalTitle(selectedVarga)}
                    </Text>
                    <Text style={[styles.infoDesc, { color: textSecondary }]}>
                      {DivisionalChartService.getDivisionalSignificance(selectedVarga)}
                    </Text>
                  </View>
                </View>
              </View>
            )}

            {/* 2. PANCHANGA TAB */}
            {activeTab === 'panchanga' && (
              <View style={{ width: '100%' }}>
                <ChartPanchangaView
                  chartData={chartData}
                  panchanga={panchanga}
                  isDark={isDark}
                  lang={lang}
                />
              </View>
            )}

            {/* 3. PLANETS & HOUSES TAB */}
            {activeTab === 'planets' && (
              <View>
                {/* Planetary Positions */}
                <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
                  <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                    {isTe ? 'నిరాయణ గ్రహ స్థితిగతుల సమగ్ర పట్టిక' : 'Planetary Positions & Dignities'}
                  </Text>
                  <View style={[styles.tableHeader, { backgroundColor: AppColors.maroon }]}>
                    <Text style={[styles.tableHCol, { flex: 1.2 }]}>గ్రహము</Text>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>రాశి</Text>
                    <Text style={[styles.tableHCol, { flex: 1.3 }]}>అంశలు</Text>
                    <Text style={[styles.tableHCol, { flex: 1.2 }]}>నక్షత్రం</Text>
                    <Text style={[styles.tableHCol, { flex: 0.6 }]}>పాదం</Text>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>స్థితి</Text>
                  </View>

                  <View style={[styles.tableDataRow, { backgroundColor: isDark ? '#2D1606' : '#FFF3E0' }]}>
                    <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '800', color: '#B91C1C' }]}>లగ్నము (ల)</Text>
                    <Text style={[styles.tableDCol, { flex: 1, color: textPrimary }]}>{AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}</Text>
                    <Text style={[styles.tableDCol, { flex: 1.3, color: textPrimary }]}>{formatDms(chartData.ascendant.degreesInRashi)}</Text>
                    <Text style={[styles.tableDCol, { flex: 1.2, color: textPrimary }]}>{AstroConstants.nakshatrasTelugu[chartData.ascendant.nakshatraIndex]}</Text>
                    <Text style={[styles.tableDCol, { flex: 0.6, color: textPrimary }]}>{chartData.ascendant.pada}</Text>
                    <Text style={[styles.tableDCol, { flex: 1, fontWeight: '700', color: gold }]}>లగ్న కేంద్రం</Text>
                  </View>

                  {chartData.planets.map((p, idx) => {
                    const retro = p.isRetrograde ? ' (వ)' : '';
                    const combust = p.isCombust ? ' (మౌ)' : '';
                    return (
                      <View key={p.name} style={[styles.tableDataRow, { borderBottomColor: borderColor }]}>
                        <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '700', color: textPrimary }]}>
                          {AstroConstants.planetNamesTelugu[p.name] || p.name}
                          {retro ? <Text style={{ color: '#EA580C' }}>{retro}</Text> : null}
                          {combust ? <Text style={{ color: '#F59E0B' }}>{combust}</Text> : null}
                        </Text>
                        <Text style={[styles.tableDCol, { flex: 1, color: textPrimary }]}>{AstroConstants.rashisTelugu[p.rashiIndex]}</Text>
                        <Text style={[styles.tableDCol, { flex: 1.3, color: textPrimary }]}>{formatDms(p.degreesInRashi)}</Text>
                        <Text style={[styles.tableDCol, { flex: 1.2, color: textPrimary }]}>{AstroConstants.nakshatrasTelugu[p.nakshatraIndex]}</Text>
                        <Text style={[styles.tableDCol, { flex: 0.6, color: textPrimary }]}>{p.pada}</Text>
                        <Text style={[styles.tableDCol, { flex: 1, fontWeight: '600', color: p.dignity === 'Exalted' ? '#166534' : p.dignity === 'Debilitated' ? '#B91C1C' : textPrimary }]}>
                          {p.dignity === 'Exalted' ? 'ఉచ్ఛ' : p.dignity === 'Debilitated' ? 'నీచ' : p.dignity === 'Own Sign' ? 'స్వక్షేత్రం' : p.dignity || 'సమం'}
                        </Text>
                      </View>
                    );
                  })}
                </View>

                {/* Bhava Spashta 12 Houses */}
                <View style={[styles.card, { backgroundColor: cardBg, borderColor, marginTop: 12 }]}>
                  <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                    {isTe ? 'ద్వాదశ భావ స్ఫుట పట్టిక (12 Houses Bhava Spashta)' : '12 Houses Bhava Spashta'}
                  </Text>
                  <View style={[styles.tableHeader, { backgroundColor: AppColors.maroon }]}>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>భావం</Text>
                    <Text style={[styles.tableHCol, { flex: 1.2 }]}>ఆరంభం</Text>
                    <Text style={[styles.tableHCol, { flex: 1.2 }]}>మధ్యం (స్ఫుటం)</Text>
                    <Text style={[styles.tableHCol, { flex: 1.2 }]}>ముగింపు</Text>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>భావాధిపతి</Text>
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
                      <View key={h} style={[styles.tableDataRow, { borderBottomColor: borderColor }]}>
                        <Text style={[styles.tableDCol, { flex: 1, fontWeight: '700', color: gold }]}>{h}వ భావం</Text>
                        <Text style={[styles.tableDCol, { flex: 1.2, color: textPrimary }]}>{formatDms(startLon)}</Text>
                        <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '700', color: textPrimary }]}>{formatDms(midLon)}</Text>
                        <Text style={[styles.tableDCol, { flex: 1.2, color: textPrimary }]}>{formatDms(endLon)}</Text>
                        <Text style={[styles.tableDCol, { flex: 1, fontWeight: '700', color: textPrimary }]}>{lord}</Text>
                      </View>
                    );
                  })}
                </View>
              </View>
            )}

            {/* 4. ASHTAKAVARGA & SHADBALA TAB */}
            {activeTab === 'ashtakavarga' && (
              <AshtakavargaView
                data={ashtakavarga}
                shadbala={shadbala}
                isDark={isDark}
                lang={lang}
              />
            )}

            {/* 5. VIMSHOTTARI DASHAS TAB (COMPLETE 5-LEVEL PRANA TREE) */}
            {activeTab === 'dasha' && (
              <DashaBrowser dashas={dashas} isDark={isDark} lang={lang} />
            )}

            {/* 6. TRANSIT / GOCHARA TAB */}
            {activeTab === 'transit' && gochar && (
              <View>
                {/* Sade Sati Banner */}
                <View style={[styles.infoBanner, { backgroundColor: isDark ? '#1C110A' : '#FFFDF9', borderColor, marginBottom: 12 }]}>
                  <Text style={[styles.infoTitle, { color: AppColors.maroonLight }]}>🪐 శని గోచారం & ఏలినాటి శని స్థితి:</Text>
                  <Text style={[styles.infoDesc, { color: textPrimary, marginTop: 4 }]}>{gochar.sadeSatiStatus}</Text>
                </View>

                {/* Guru Bala Banner */}
                <View style={[styles.infoBanner, { backgroundColor: isDark ? '#1C110A' : '#FFFDF9', borderColor, marginBottom: 12 }]}>
                  <Text style={[styles.infoTitle, { color: '#D97706' }]}>🌟 గురు బల విశ్లేషణ:</Text>
                  <Text style={[styles.infoDesc, { color: textPrimary, marginTop: 4 }]}>{gochar.guruBalaStatus}</Text>
                </View>

                {/* Transit Table */}
                <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
                  <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                    {isTe ? 'ప్రస్తుత గోచార గ్రహ స్థితిగతులు (జన్మ చంద్రుని నుండి)' : 'Current Transits from Natal Moon'}
                  </Text>
                  <View style={[styles.tableHeader, { backgroundColor: AppColors.maroon }]}>
                    <Text style={[styles.tableHCol, { flex: 1.2 }]}>గ్రహము</Text>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>గోచార రాశి</Text>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>చంద్రుని నుండి</Text>
                    <Text style={[styles.tableHCol, { flex: 1 }]}>SAV బలం</Text>
                    <Text style={[styles.tableHCol, { flex: 1.5 }]}>గోచార ప్రభావం</Text>
                  </View>
                  {gochar.transits.map(tr => (
                    <View key={tr.planet} style={[styles.tableDataRow, { borderBottomColor: borderColor }]}>
                      <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '700', color: textPrimary }]}>{tr.teluguName}</Text>
                      <Text style={[styles.tableDCol, { flex: 1, color: textPrimary }]}>{tr.rashiTelugu}</Text>
                      <Text style={[styles.tableDCol, { flex: 1, fontWeight: '700', color: tr.isBenefic ? '#166534' : textPrimary }]}>{tr.houseFromMoon}వ భావం</Text>
                      <Text style={[styles.tableDCol, { flex: 1, color: tr.savPoints >= 28 ? '#166534' : '#DC2626', fontWeight: '700' }]}>{tr.savPoints}</Text>
                      <Text style={[styles.tableDCol, { flex: 1.5, color: tr.isBenefic ? '#166534' : textSecondary, fontSize: 9.5 }]}>{tr.effectTelugu}</Text>
                    </View>
                  ))}
                </View>
              </View>
            )}

            {/* 7. YOGAS & DOSHAS TAB */}
            {activeTab === 'yogas' && (
              <View>
                {/* Dosha Analysis Card */}
                <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
                  <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                    {isTe ? 'కుజ దోషం & కాలసర్ప దోష విశ్లేషణ' : 'Kuja & Kaal Sarpa Dosha'}
                  </Text>
                  <View style={[styles.infoBanner, { backgroundColor: dosha.kujaDosha.hasDosha ? (isDark ? '#450A0A' : '#FEF2F2') : (isDark ? '#064E3B' : '#F0FDF4'), borderColor: dosha.kujaDosha.hasDosha ? '#EF4444' : '#10B981', marginBottom: 8 }]}>
                    <Text style={[styles.infoTitle, { color: dosha.kujaDosha.hasDosha ? '#DC2626' : '#166534' }]}>
                      {dosha.kujaDosha.hasDosha ? '⚠️ కుజ దోషం (Manglik Dosha)' : '✓ కుజ దోషం లేదు (No Kuja Dosha)'}
                    </Text>
                    <Text style={[styles.infoDesc, { color: textPrimary, marginTop: 4 }]}>{dosha.kujaDosha.description}</Text>
                  </View>

                  <View style={[styles.infoBanner, { backgroundColor: dosha.kaalSarpa.hasDosha ? (isDark ? '#450A0A' : '#FEF2F2') : (isDark ? '#064E3B' : '#F0FDF4'), borderColor: dosha.kaalSarpa.hasDosha ? '#EF4444' : '#10B981' }]}>
                    <Text style={[styles.infoTitle, { color: dosha.kaalSarpa.hasDosha ? '#DC2626' : '#166534' }]}>
                      {dosha.kaalSarpa.hasDosha ? `⚠️ కాలసర్ప దోషం (${dosha.kaalSarpa.teluguTypeName})` : '✓ కాలసర్ప దోషం లేదు'}
                    </Text>
                    <Text style={[styles.infoDesc, { color: textPrimary, marginTop: 4 }]}>{dosha.kaalSarpa.description}</Text>
                  </View>
                </View>

                {/* Yogas List */}
                <View style={[styles.card, { backgroundColor: cardBg, borderColor, marginTop: 12 }]}>
                  <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                    {isTe ? 'జాతకంలోని విశేష వైదిక యోగాలు' : 'Classical Vedic Yogas'}
                  </Text>
                  {yogas.map((yg, idx) => (
                    <View key={idx} style={[styles.yogaItem, { borderBottomColor: borderColor }]}>
                      <View style={styles.yogaTop}>
                        <Text style={[styles.yogaName, { color: AppColors.maroonLight }]}>✦ {yg.teluguName}</Text>
                        <Text style={[styles.yogaCategory, { color: gold }]}>{yg.name}</Text>
                      </View>
                      <Text style={[styles.yogaDesc, { color: textSecondary }]}>{yg.teluguDescription}</Text>
                    </View>
                  ))}
                </View>
              </View>
            )}

            {/* 8. SPECIAL POINTS TAB */}
            {activeTab === 'special' && (
              <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
                <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
                  {isTe ? 'భృగు బిందువు, యోగీ-అవయోగీ & చరకారకములు' : 'Bhrigu Bindu, Yogi & Chara Karakas'}
                </Text>
                {[
                  { k: 'భృగు బిందువు (Bhrigu Bindu):', v: `${specialPoints.bhriguBinduRashi} (${formatDms(specialPoints.bhriguBinduRashiDeg)}) - ${specialPoints.bhriguBinduHouse}వ భాగ్య భావం` },
                  { k: 'యోగ గ్రహము (Yogi):', v: `${specialPoints.yogiPlanet} (${specialPoints.yogiRashi} - ${specialPoints.yogiNakshatra})` },
                  { k: 'సహయోగి గ్రహము:', v: specialPoints.sahayogiPlanet },
                  { k: 'అవయోగ గ్రహము:', v: `${specialPoints.avayogiPlanet} (${specialPoints.avayogiRashi} - ${specialPoints.avayogiNakshatra})` },
                ].map((row, i) => (
                  <View key={i} style={[styles.tableRow, { borderBottomColor: borderColor }]}>
                    <Text style={[styles.tableKey, { color: textSecondary }]}>{row.k}</Text>
                    <Text style={[styles.tableVal, { color: textPrimary, fontWeight: '700' }]}>{row.v}</Text>
                  </View>
                ))}

                <View style={[styles.infoBanner, { backgroundColor: isDark ? '#1C110A' : '#FFFDF9', borderColor, marginTop: 12 }]}>
                  <Text style={[styles.infoTitle, { color: AppColors.maroonLight }]}>✦ భృగు బిందువు విశేష ఫలితము:</Text>
                  <Text style={[styles.infoDesc, { color: textPrimary, marginTop: 4 }]}>
                    రాహువు నుండి చంద్రుని వరకు గల దూరపు ఖచ్చితమైన మధ్య బిందువునే "భృగు బిందువు" (Destiny Point) అంటారు. గోచార గురుడు లేదా శుభ గ్రహములు ఈ బిందువును సంధించిన కాలంలో భాగ్యోదయము, వివాహము, ఉద్యోగ ప్రాప్తి మరియు విశేష ధనలాభములు సిద్ధించును.
                  </Text>
                </View>

                {/* 7 Chara Karakas */}
                <Text style={[styles.cardHeader, { color: AppColors.maroon, marginTop: 16 }]}>
                  జైమిని 7 చరకారకములు (7 Chara Karakas)
                </Text>
                <View style={[styles.tableHeader, { backgroundColor: AppColors.maroon }]}>
                  <Text style={[styles.tableHCol, { flex: 1.5 }]}>కారకము</Text>
                  <Text style={[styles.tableHCol, { flex: 1.2 }]}>గ్రహము</Text>
                  <Text style={[styles.tableHCol, { flex: 1.5 }]}>రాశి & అంశలు</Text>
                </View>
                {specialPoints.charaKarakas.map(k => (
                  <View key={k.name} style={[styles.tableDataRow, { borderBottomColor: borderColor }]}>
                    <Text style={[styles.tableDCol, { flex: 1.5, fontWeight: '700', color: gold }]}>{k.nameTelugu} ({k.name})</Text>
                    <Text style={[styles.tableDCol, { flex: 1.2, fontWeight: '700', color: textPrimary }]}>{k.planetTelugu}</Text>
                    <Text style={[styles.tableDCol, { flex: 1.5, color: textPrimary }]}>{k.rashiTelugu} ({formatDms(k.degreeInRashi)})</Text>
                  </View>
                ))}
              </View>
            )}
          </ScrollView>
        </>
      ) : null}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  appBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderBottomWidth: 1,
  },
  backBtn: {
    padding: 4,
  },
  backIcon: {
    fontSize: 26,
    fontWeight: '700',
  },
  appBarCenter: {
    flex: 1,
    marginHorizontal: 8,
  },
  appBarTitle: {
    fontSize: 14,
    fontWeight: '800',
  },
  appBarSub: {
    fontSize: 10.5,
    marginTop: 1,
  },
  appBarActions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  actionIconBtn: {
    padding: 6,
    borderRadius: 8,
  },
  pdfTopBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 8,
  },
  pdfTopBtnText: {
    color: '#000',
    fontWeight: '800',
    fontSize: 11,
  },
  summaryStrip: {
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderBottomWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  summaryStripText: {
    fontSize: 12,
    fontWeight: '600',
  },
  tabBar: {
    maxHeight: 46,
    borderBottomWidth: 1,
    paddingHorizontal: 8,
    paddingVertical: 6,
  },
  tabPill: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    borderWidth: 1,
    marginRight: 6,
    alignItems: 'center',
    justifyContent: 'center',
  },
  tabPillText: {
    fontSize: 11,
    fontWeight: '600',
  },
  scrollContent: {
    width: '100%',
    padding: 12,
    paddingBottom: 40,
  },
  loadingBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 40,
  },
  loadingText: {
    fontSize: 13,
    fontWeight: '700',
    marginTop: 12,
  },
  card: {
    borderRadius: 10,
    borderWidth: 1,
    padding: 12,
  },
  cardHeader: {
    fontSize: 13.5,
    fontWeight: '800',
    marginBottom: 8,
  },
  vargaPill: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 14,
    borderWidth: 1,
    marginRight: 6,
  },
  vargaPillText: {
    fontSize: 10.5,
    fontWeight: '700',
  },
  infoBanner: {
    borderWidth: 1,
    borderRadius: 8,
    padding: 10,
  },
  infoTitle: {
    fontSize: 12,
    fontWeight: '800',
  },
  infoDesc: {
    fontSize: 11,
    lineHeight: 15,
  },
  tableRow: {
    flexDirection: 'row',
    paddingVertical: 6,
    borderBottomWidth: 0.5,
  },
  tableKey: {
    width: 150,
    fontSize: 11.5,
    fontWeight: '700',
  },
  tableVal: {
    flex: 1,
    fontSize: 11.5,
  },
  tableHeader: {
    flexDirection: 'row',
    paddingVertical: 6,
    paddingHorizontal: 4,
    borderRadius: 4,
  },
  tableHCol: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '700',
    textAlign: 'center',
  },
  tableDataRow: {
    flexDirection: 'row',
    paddingVertical: 5,
    paddingHorizontal: 4,
    borderBottomWidth: 0.5,
    alignItems: 'center',
  },
  tableDCol: {
    fontSize: 10,
    textAlign: 'center',
  },
  activeDashaCard: {
    borderWidth: 1.5,
    borderRadius: 8,
    padding: 10,
    marginBottom: 12,
    backgroundColor: '#FEF3C720',
  },
  activeDashaTitle: {
    fontSize: 12,
    fontWeight: '800',
  },
  activeDashaValue: {
    fontSize: 13,
    fontWeight: '800',
    marginTop: 4,
  },
  activeDashaSub: {
    fontSize: 11,
    marginTop: 2,
  },
  dashaItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    borderBottomWidth: 0.5,
    paddingHorizontal: 6,
  },
  dashaName: {
    fontSize: 12.5,
    fontWeight: '700',
  },
  dashaDates: {
    fontSize: 10.5,
    marginTop: 1,
  },
  subDashaItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 6,
    borderBottomWidth: 0.5,
    paddingHorizontal: 6,
  },
  subDashaName: {
    fontSize: 11.5,
  },
  subDashaDates: {
    fontSize: 10.5,
  },
  yogaItem: {
    paddingVertical: 8,
    borderBottomWidth: 0.5,
  },
  yogaTop: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  yogaName: {
    fontSize: 12.5,
    fontWeight: '800',
  },
  yogaCategory: {
    fontSize: 10,
    fontWeight: '700',
  },
  yogaDesc: {
    fontSize: 11,
    marginTop: 3,
    lineHeight: 15,
  },
});

