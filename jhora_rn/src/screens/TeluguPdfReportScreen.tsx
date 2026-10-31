import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import {
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  DashaPeriod,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
} from '../models/astroModels';
import { PdfExportService } from '../services/pdfExportService';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';

interface Props {
  chartData: ChartData;
  ashtakavarga: AshtakavargaData;
  shadbala: PlanetShadbala[];
  special: SpecialPointsResult;
  panchanga: PanchangaData;
  dosha: DoshaAnalysis;
  dashas: DashaPeriod[];
  isDark: boolean;
  lang: 'te' | 'en';
  onBack: () => void;
}

export const TeluguPdfReportScreen: React.FC<Props> = ({
  chartData,
  ashtakavarga,
  shadbala,
  special,
  panchanga,
  dosha,
  dashas,
  isDark,
  lang,
  onBack,
}) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const [exporting, setExporting] = useState(false);

  const handleDownload = async () => {
    setExporting(true);
    try {
      const res = await PdfExportService.exportTeluguPdfReport({
        chartData,
        ashtakavarga,
        shadbala,
        special,
        panchanga,
        dosha,
        dashas,
      });

      if (!res.success) {
        Alert.alert(isTe ? 'లోపం' : 'Error', res.message);
      } else {
        Alert.alert(isTe ? 'విజయవంతం' : 'Success', res.message);
      }
    } catch (e: any) {
      Alert.alert('Error', e?.message || 'PDF Generation Error');
    } finally {
      setExporting(false);
    }
  };

  const pagesSummary = [
    { page: 'పుట 1', title: 'జాతక ప్రాథమిక వివరాలు, పంచాంగం & నిరాయణ గ్రహ స్థానాలు (Dignities)' },
    { page: 'పుట 2', title: 'షోడశవర్గ చక్రములు - భాగము 1: రాశి (D1), నవాంశ (D9), హోరా (D2), ద్రేక్కాణ (D3)' },
    { page: 'పుట 3', title: 'షోడశవర్గ చక్రములు - భాగము 2: చతుర్థాంశ (D4), సప్తాంశ (D7), దశాంశ (D10), ద్వాదశాంశ (D12)' },
    { page: 'పుట 4', title: 'షోడశవర్గ చక్రములు - భాగము 3: షోడశాంశ (D16), వింశాంశ (D20), చతుర్వింశాంశ (D24), సప్తవింశాంశ (D27)' },
    { page: 'పుట 5', title: 'షోడశవర్గ చక్రములు - భాగము 4: త్రింశాంశ (D30), ఖవేదాంశ (D40), అక్షవేదాంశ (D45), షష్ట్యంశ (D60)' },
    { page: 'పుట 6', title: 'ద్వాదశ భావ స్ఫుట పట్టిక (12 Houses) & సర్వాష్టకవర్గము (SAV 337)' },
    { page: 'పుట 7', title: 'షడ్బల బలాబలాలు, భృగు బిందువు (Destiny Point), యోగీ-అవయోగీ & జైమిని చరకారకములు' },
    { page: 'పుట 8', title: 'వింశోత్తరి మహాదశల క్రమము & అంతర్దశలు (జన్మ నుండి 40 సం. వరకు)' },
    { page: 'పుట 9', title: 'అంతర్దశల సమగ్ర పట్టిక (40 నుండి 80+ సంవత్సరాలు)' },
    { page: 'పుట 10-12', title: 'ప్రత్యంతర దశల సమగ్ర కాలచక్రం (Level 3: Pratyantar Dashas up to 80 Years)' },
    { page: 'పుట 13-14', title: 'సూక్ష్మ దశల సమగ్ర విశ్లేషణ (Level 4: Sookshma Dashas up to 80 Years)' },
    { page: 'పుట 15-24', title: 'సమగ్ర ప్రాణ దశల మహాపట్టిక (Level 5: Prana Dashas for ALL 80 YEARS down to Seconds)' },
    { page: 'పుట 25', title: 'ఆశీర్వచన పత్రము & కార్యాలయ సంప్రదింపు చిరునామా (సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)' },
  ];

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      {/* Top Header */}
      <View style={[styles.appBar, { borderColor, backgroundColor: cardBg }]}>
        <TouchableOpacity onPress={onBack} style={styles.backBtn}>
          <Text style={[styles.backIcon, { color: gold }]}>‹</Text>
        </TouchableOpacity>
        <Text style={[styles.appBarTitle, { color: textPrimary }]}>
          {isTe ? 'సంపూర్ణ తెలుగు జాతక నివేదిక' : 'Full 25-Page Telugu Report'}
        </Text>
        <View style={{ width: 30 }} />
      </View>

      {/* Direct Save Action Bar */}
      <View style={[styles.actionBanner, { backgroundColor: AppColors.maroonDark }]}>
        <TouchableOpacity
          style={[styles.downloadBtn, exporting && styles.btnDisabled]}
          onPress={handleDownload}
          disabled={exporting}
          activeOpacity={0.8}
        >
          {exporting ? (
            <ActivityIndicator color="#000" size="small" style={{ marginRight: 8 }} />
          ) : (
            <Text style={{ fontSize: 18, marginRight: 8 }}>🖨️</Text>
          )}
          <Text style={styles.downloadBtnText}>
            {exporting
              ? '25 పుటల PDF సిద్ధమవుతోంది...'
              : 'సంపూర్ణ 25 పుటల PDF డౌన్‌లోడ్ (Save as PDF)'}
          </Text>
        </TouchableOpacity>
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Sacred Header Card */}
        <View style={[styles.sacredCard, { backgroundColor: cardBg, borderColor: AppColors.maroon }]}>
          <Text style={styles.blessing}>{TeluguPdfReportGenerator.blessingHeader}</Text>
          <Text style={styles.guruBlessing}>❖ {TeluguPdfReportGenerator.guruBlessing} ❖</Text>
          <Text style={styles.templeTitle}>{TeluguPdfReportGenerator.appTitle}</Text>
          <Text style={styles.expertise}>{TeluguPdfReportGenerator.expertiseLine}</Text>
          <View style={styles.scholarPill}>
            <Text style={styles.scholarText}>{TeluguPdfReportGenerator.astrologerTitleAndMobile}</Text>
          </View>
          <Text style={styles.shloka}>
            {TeluguPdfReportGenerator.invocationShloka}
          </Text>
        </View>

        {/* 25 Pages Table of Contents */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor, marginTop: 12 }]}>
          <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
            📑 సంపూర్ణ 25 పుటల నివేదిక వివరాలు (25-Page Report Outline)
          </Text>

          {pagesSummary.map((item, idx) => (
            <View key={idx} style={[styles.outlineItem, { borderBottomColor: borderColor }]}>
              <View style={[styles.pageBadge, { backgroundColor: gold }]}>
                <Text style={styles.pageBadgeText}>{item.page}</Text>
              </View>
              <Text style={[styles.outlineTitle, { color: textPrimary }]}>{item.title}</Text>
            </View>
          ))}
        </View>
      </ScrollView>
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
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
  },
  backBtn: {
    padding: 4,
  },
  backIcon: {
    fontSize: 26,
    fontWeight: '700',
  },
  appBarTitle: {
    fontSize: 15,
    fontWeight: '800',
  },
  actionBanner: {
    padding: 10,
    alignItems: 'center',
  },
  downloadBtn: {
    backgroundColor: '#F59E0B',
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
  },
  btnDisabled: {
    opacity: 0.7,
  },
  downloadBtnText: {
    color: '#000',
    fontSize: 13,
    fontWeight: '800',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  sacredCard: {
    padding: 16,
    borderRadius: 12,
    borderWidth: 2,
    alignItems: 'center',
    textAlign: 'center',
  },
  blessing: {
    fontSize: 13,
    fontWeight: '800',
    color: '#8B2500',
  },
  guruBlessing: {
    fontSize: 11,
    fontWeight: '700',
    color: '#92400E',
    marginTop: 2,
  },
  templeTitle: {
    fontSize: 18,
    fontWeight: '800',
    color: '#6B1111',
    marginTop: 4,
    textAlign: 'center',
  },
  expertise: {
    fontSize: 11,
    fontWeight: '700',
    color: '#78350F',
    marginTop: 2,
  },
  scholarPill: {
    backgroundColor: '#6B1111',
    paddingVertical: 4,
    paddingHorizontal: 14,
    borderRadius: 14,
    marginTop: 6,
  },
  scholarText: {
    color: '#FFF',
    fontSize: 11,
    fontWeight: '800',
  },
  shloka: {
    fontSize: 10.5,
    fontWeight: '700',
    color: '#6B1111',
    marginTop: 8,
    textAlign: 'center',
    lineHeight: 16,
  },
  card: {
    padding: 14,
    borderRadius: 10,
    borderWidth: 1,
  },
  cardHeader: {
    fontSize: 13.5,
    fontWeight: '800',
    marginBottom: 10,
  },
  outlineItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    borderBottomWidth: 0.5,
  },
  pageBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
    marginRight: 10,
  },
  pageBadgeText: {
    fontSize: 10,
    fontWeight: '800',
    color: '#000',
  },
  outlineTitle: {
    flex: 1,
    fontSize: 11.5,
    lineHeight: 15,
  },
});

