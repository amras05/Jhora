import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, Card, PrimaryButton } from '../components/ui';
import { radius, spacing } from '../theme/tokens';
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
  onBack: () => void;
  // Optional for backward compatibility with App.tsx
  isDark?: boolean;
  lang?: 'te' | 'en';
}

export const TeluguPdfReportScreen: React.FC<Props> = ({
  chartData,
  ashtakavarga,
  shadbala,
  special,
  panchanga,
  dosha,
  dashas,
  onBack,
}) => {
  const { colors } = useTheme();
  const { t, isTe } = useI18n();

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
        Alert.alert(t('pdfReport.alertErrorTitle'), res.message);
      } else {
        Alert.alert(t('pdfReport.alertSuccessTitle'), res.message);
      }
    } catch (e: any) {
      Alert.alert(t('pdfReport.alertErrorTitle'), e?.message || 'PDF Generation Error');
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
    <Screen style={styles.container}>
      <AppBar
        title={t('pdfReport.appBarTitle')}
        onBack={onBack}
      />

      {/* Direct Save Action Bar */}
      <View style={[styles.actionBanner, { backgroundColor: colors.primaryDark }]}>
        <PrimaryButton
          title={exporting ? t('pdfReport.downloadBtnExporting') : t('pdfReport.downloadBtnReady')}
          onPress={handleDownload}
          loading={exporting}
          variant="gold"
          style={styles.downloadBtn}
        />
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Sacred Header Preview Box */}
        <Card
          variant="outlined"
          style={[styles.headerCard, { backgroundColor: colors.stripBg, borderColor: colors.border }]}
        >
          <Text style={[styles.blessingText, { color: colors.primary }]}>
            {TeluguPdfReportGenerator.blessingHeader}
          </Text>
          <Text style={[styles.guruText, { color: colors.primaryDark }]}>
            {TeluguPdfReportGenerator.guruBlessing}
          </Text>
          <Text style={[styles.templeTitle, { color: colors.primary }]}>
            {TeluguPdfReportGenerator.appTitle}
          </Text>
          <Text style={[styles.expertiseText, { color: colors.textSecondary }]}>
            {TeluguPdfReportGenerator.expertiseLine}
          </Text>

          <View style={[styles.scholarBadge, { backgroundColor: colors.primary }]}>
            <Text style={styles.scholarBadgeText}>
              {TeluguPdfReportGenerator.astrologerTitleAndMobile}
            </Text>
          </View>

          <Text style={[styles.shlokaText, { color: colors.primary }]}>
            {TeluguPdfReportGenerator.invocationShloka}
          </Text>
        </Card>

        {/* 25-Page Outline */}
        <Card style={styles.outlineCard}>
          <Text style={[styles.outlineTitle, { color: colors.primary }]}>
            {t('pdfReport.tocHeader')}
          </Text>

          {pagesSummary.map((item, idx) => (
            <View
              key={idx}
              style={[
                styles.pageRow,
                { borderBottomColor: colors.border },
                idx === pagesSummary.length - 1 && { borderBottomWidth: 0 },
              ]}
            >
              <View style={[styles.pageBadge, { backgroundColor: colors.gold }]}>
                <Text style={styles.pageBadgeText}>{item.page}</Text>
              </View>
              <Text style={[styles.pageTitle, { color: colors.textSecondary }]}>
                {item.title}
              </Text>
            </View>
          ))}
        </Card>
      </ScrollView>
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  actionBanner: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.sm,
  },
  downloadBtn: {
    marginVertical: 0,
  },
  scrollContent: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.md,
    paddingBottom: spacing.xxl,
  },
  headerCard: {
    alignItems: 'center',
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  blessingText: {
    fontSize: 13,
    fontWeight: '800',
    textAlign: 'center',
    marginBottom: 4,
  },
  guruText: {
    fontSize: 12,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: 6,
  },
  templeTitle: {
    fontSize: 16,
    fontWeight: '800',
    textAlign: 'center',
    marginBottom: 4,
  },
  expertiseText: {
    fontSize: 11,
    textAlign: 'center',
    marginBottom: 8,
  },
  scholarBadge: {
    paddingHorizontal: spacing.md,
    paddingVertical: 5,
    borderRadius: radius.sm,
    marginBottom: 8,
  },
  scholarBadgeText: {
    color: '#FFFFFF',
    fontWeight: '800',
    fontSize: 12,
    textAlign: 'center',
  },
  shlokaText: {
    fontSize: 10.5,
    fontWeight: '700',
    textAlign: 'center',
  },
  outlineCard: {
    padding: spacing.md,
  },
  outlineTitle: {
    fontSize: 14,
    fontWeight: '800',
    marginBottom: spacing.md,
  },
  pageRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  pageBadge: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: radius.sm,
    marginRight: 10,
    minWidth: 64,
    alignItems: 'center',
  },
  pageBadgeText: {
    color: '#000000',
    fontSize: 10,
    fontWeight: '800',
  },
  pageTitle: {
    flex: 1,
    fontSize: 12,
    lineHeight: 16,
  },
});
