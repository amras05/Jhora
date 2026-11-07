import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  Switch,
  Modal,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, Card, PrimaryButton, SegmentedControl, Chip } from '../components/ui';
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
import { AstroConstants } from '../constants/astroConstants';
import {
  PdfExportService,
  PdfStage,
  SavedReport,
} from '../services/pdfExportService';
import {
  TeluguPdfReportGenerator,
  PdfPreset,
  PdfSectionOptions,
} from '../services/teluguPdfReportGenerator';
import { VedicYoga } from '../services/yogaService';
import { GocharAnalysis } from '../services/transitService';

interface Props {
  chartData: ChartData;
  ashtakavarga: AshtakavargaData;
  shadbala: PlanetShadbala[];
  special: SpecialPointsResult;
  panchanga: PanchangaData;
  dosha: DoshaAnalysis;
  dashas: DashaPeriod[];
  yogas?: VedicYoga[];
  gochar?: GocharAnalysis | null;
  onBack: () => void;
  onNavigateReports?: () => void;
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
  yogas,
  gochar,
  onBack,
  onNavigateReports,
}) => {
  const { colors } = useTheme();
  const { lang } = useI18n();
  const isTe = lang === 'te';

  const [preset, setPreset] = useState<PdfPreset>('standard');
  const [showCustomizer, setShowCustomizer] = useState(false);
  const [sections, setSections] = useState<Required<PdfSectionOptions>>(() =>
    TeluguPdfReportGenerator.resolveSectionOptions({ preset: 'standard' })
  );

  const [stage, setStage] = useState<PdfStage>('idle');
  const [stageMessage, setStageMessage] = useState<string>('');
  const [lastSavedReport, setLastSavedReport] = useState<SavedReport | null>(null);

  const handlePresetChange = (newPreset: string) => {
    const p = newPreset as PdfPreset;
    setPreset(p);
    setSections(TeluguPdfReportGenerator.resolveSectionOptions({ preset: p }));
  };

  const toggleSection = (key: keyof PdfSectionOptions) => {
    setSections(prev => {
      const updated = { ...prev, [key]: !prev[key] };
      return updated;
    });
  };

  const calculatedTotalPages = TeluguPdfReportGenerator.countTotalPages({
    preset,
    sections,
  });

  const birth = chartData?.birthData;
  const bDate = TeluguPdfReportGenerator.toDate(birth?.dateTime);
  const moon = chartData?.planets?.find(p => p.name === 'Moon') || chartData?.planets?.[1];
  const lagnaRashi = chartData?.ascendant ? AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex] : '';
  const moonRashi = moon ? AstroConstants.rashisTelugu[moon.rashiIndex] : '';
  const moonNak = moon ? AstroConstants.nakshatrasTelugu[moon.nakshatraIndex] : '';

  const handleExport = async (mode: 'save' | 'share') => {
    setStage('preparing');
    try {
      const res = await PdfExportService.createReport(
        {
          chartData,
          ashtakavarga,
          shadbala,
          special,
          panchanga,
          dosha,
          dashas,
          yogas,
          gochar: gochar ?? undefined,
        },
        { preset, sections },
        (s, msg) => {
          setStage(s);
          if (msg) setStageMessage(msg);
        }
      );

      setLastSavedReport(res.report);

      if (mode === 'save') {
        setStage('saving');
        setStageMessage(isTe ? 'ఫోల్డర్‌లో భద్రపరుస్తోంది...' : 'Saving to selected folder...');
        const saveRes = await PdfExportService.saveToPhone(res.uri, res.fileName);
        setStage('complete');
        if (!saveRes.ok) {
          Alert.alert(isTe ? 'సూచన' : 'Notice', saveRes.message);
        }
      } else {
        setStage('complete');
        try {
          await PdfExportService.openReport(res.uri);
        } catch (shareErr: any) {
          Alert.alert(isTe ? 'లోపం' : 'Error', shareErr?.message || 'Failed to share PDF');
        }
      }
    } catch (err: any) {
      setStage('error');
      Alert.alert(isTe ? 'లోపం' : 'Error', err?.message || 'PDF Generation Error');
    }
  };

  const handleOpenPreview = async (uri: string) => {
    try {
      await PdfExportService.openReport(uri);
    } catch (e: any) {
      Alert.alert(isTe ? 'లోపం' : 'Error', e?.message || 'Failed to open PDF report');
    }
  };

  const presetOptions = [
    { key: 'summary', label: isTe ? 'సంక్షిప్త (~10 పు.)' : 'Summary (10p)' },
    { key: 'standard', label: isTe ? 'ప్రామాణిక (~17 పు.)' : 'Standard (17p)' },
    { key: 'full', label: isTe ? 'సంపూర్ణ (28 పు.)' : 'Full (28p)' },
  ];

  const sectionItems: Array<{
    key: keyof PdfSectionOptions;
    title: string;
    pages: number;
  }> = [
    { key: 'basicAndPanchanga', title: isTe ? '1. జాతక ప్రాథమిక వివరాలు & పంచాంగం' : '1. Basic Info & Panchangam', pages: 1 },
    { key: 'classicalChakras', title: isTe ? '2. అవకహడ, ఘాత చక్రాలు & అదృష్ట విషయాలు' : '2. Avakahada, Ghata & Lucky Factors', pages: 1 },
    { key: 'shodashavargaPart1', title: isTe ? '3. రాశి, నవాంశ, హోరా, ద్రేక్కాణ (D1-D3)' : '3. D1, D9, D2, D3 Charts', pages: 1 },
    { key: 'shodashavargaPart2', title: isTe ? '4. చతుర్థాంశ, సప్తాంశ, దశాంశ, ద్వాదశాంశ (D4-D12)' : '4. D4, D7, D10, D12 Charts', pages: 1 },
    { key: 'shodashavargaPart3', title: isTe ? '5. షోడశాంశ, వింశాంశ, చతుర్వింశాంశ, సప్తవింశాంశ' : '5. D16, D20, D24, D27 Charts', pages: 1 },
    { key: 'shodashavargaPart4', title: isTe ? '6. త్రింశాంశ, ఖవేదాంశ, అక్షవేదాంశ, షష్ట్యంశ' : '6. D30, D40, D45, D60 Charts', pages: 1 },
    { key: 'bhavaAndSav', title: isTe ? '7. ద్వాదశ భావాలు & సర్వాష్టకవర్గము (SAV 337)' : '7. 12 Houses & SAV 337', pages: 1 },
    { key: 'shadbalaAndSpecial', title: isTe ? '8. షడ్బల, భృగు బిందువు, యోగీ-అవయోగీ, చరకారకాలు' : '8. Shadbala, Destiny Pt & Karakas', pages: 1 },
    { key: 'yogasAndDoshas', title: isTe ? '9. విశేష యోగములు & సమగ్ర దోష విశ్లేషణ' : '9. Yogas & Dosha Analysis', pages: 1 },
    { key: 'gocharAnalysis', title: isTe ? '10. ప్రస్తుత గోచారము & ఏలినాటి శని దర్శిని' : '10. Current Transits & Sade Sati', pages: 1 },
    { key: 'dashaOverview', title: isTe ? '11. వింశోత్తరి మహాదశలు & అంతరదశలు (0-40 సం.)' : '11. Mahadashas & Antar (0-40y)', pages: 1 },
    { key: 'dashaAntar40to80', title: isTe ? '12. అంతర్దశల సమగ్ర పట్టిక (40-80+ సం.)' : '12. Antardashas (40-80+y)', pages: 1 },
    { key: 'pratyantarDashas', title: isTe ? '13. ప్రత్యంతర దశలు (Level 3 - 3 పుటలు)' : '13. Pratyantar Dashas (L3 - 3p)', pages: 3 },
    { key: 'sookshmaDashas', title: isTe ? '14. సూక్ష్మ దశల విశ్లేషణ (Level 4 - 2 పుటలు)' : '14. Sookshma Dashas (L4 - 2p)', pages: 2 },
    { key: 'pranaDashas', title: isTe ? '15. సమగ్ర ప్రాణ దశలు (Level 5 - 10 పుటలు)' : '15. Prana Dashas (L5 - 10p)', pages: 10 },
    { key: 'blessingPage', title: isTe ? '16. పరిహారాలు (Pariharalu)' : '16. Pariharalu (Remedies)', pages: 1 },
  ];

  return (
    <Screen style={styles.container}>
      <AppBar
        title={isTe ? 'జాతక చక్రం PDF నివేదిక' : 'Horoscope PDF Report'}
        subtitle={isTe ? '100% ఆఫ్‌లైన్ ప్రింటింగ్ & సేవింగ్' : '100% Offline Printing & Saving'}
        onBack={onBack}
      />

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Profile Card & Astrological Snapshot */}
        <Card style={styles.profileCard}>
          <View style={styles.profileHeader}>
            <View>
              <Text style={[styles.profileName, { color: colors.text }]}>
                {birth.name || (isTe ? 'శ్రీ / కుమారి' : 'Horoscope')}
              </Text>
              <Text style={[styles.profileBirth, { color: colors.textSecondary }]}>
                {TeluguPdfReportGenerator.formatDate(bDate)} • {TeluguPdfReportGenerator.formatTime(bDate)} • {birth?.placeName || ''}
              </Text>
            </View>
            {onNavigateReports && (
              <TouchableOpacity
                style={[styles.myReportsBtn, { backgroundColor: `${colors.gold}20`, borderColor: colors.gold }]}
                onPress={onNavigateReports}
                activeOpacity={0.7}
              >
                <Text style={[styles.myReportsBtnText, { color: colors.primaryDark }]}>
                  📁 {isTe ? 'నా నివేదికలు' : 'My Reports'}
                </Text>
              </TouchableOpacity>
            )}
          </View>

          <View style={styles.chipsRow}>
            <Chip
              label={`${isTe ? 'లగ్నం' : 'Lagna'}: ${lagnaRashi}`}
              variant="gold"
            />
            <Chip
              label={`${isTe ? 'రాశి' : 'Rashi'}: ${moonRashi}`}
              variant="default"
            />
            <Chip
              label={`${isTe ? 'నక్షత్రం' : 'Star'}: ${moonNak} (${moon.pada}వ పాదం)`}
              variant="default"
            />
          </View>
        </Card>

        {/* Report Size Preset Selector */}
        <Card style={styles.presetCard}>
          <Text style={[styles.sectionTitle, { color: colors.primary }]}>
            {isTe ? 'నివేదిక పరిమాణము ఎంచుకోండి' : 'Select Report Size'}
          </Text>

          <SegmentedControl
            options={presetOptions}
            selectedKey={preset}
            onSelect={handlePresetChange}
            style={styles.segmentedCtrl}
          />

          <View style={[styles.presetInfoBanner, { backgroundColor: colors.stripBg, borderColor: colors.border }]}>
            <Text style={[styles.presetDesc, { color: colors.textSecondary }]}>
              {preset === 'summary' &&
                (isTe
                  ? '✦ సంక్షిప్త జాతకం: ప్రాథమిక వివరాలు, D1, D9, భావములు, అష్టకవర్గము & 80 సం. మహాదశలు.'
                  : '✦ Summary Report: Basic details, D1, D9, Houses, SAV 337, and 80-year Mahadasha overview.')}
              {preset === 'standard' &&
                (isTe
                  ? '✦ ప్రామాణిక నివేదిక: సమగ్ర 16 షోడశవర్గ చక్రాలు, భావాలు, షడ్బల బలాబలాలు, లెవల్ 4 సూక్ష్మ దశల వరకు విశ్లేషణ.'
                  : '✦ Standard Report: All 16 divisional charts, Bhava Sputa, Shadbala, and up to Level 4 Sookshma Dashas.')}
              {preset === 'full' &&
                (isTe
                  ? '✦ సంపూర్ణ నివేదిక: పూర్తి 25 పుటల వేద జ్యోతిష గ్రంథం, 80 సంవత్సరాల సమగ్ర ప్రాణ దశలతో (Level 5).'
                  : '✦ Full Complete Report: 25-page comprehensive report including all 10 stages of Level 5 Prana Dashas.')}
            </Text>

            <View style={styles.totalBadgeRow}>
              <Text style={[styles.totalEstimateText, { color: colors.primaryDark }]}>
                {isTe ? 'మొత్తం పుటల అంచనా: ' : 'Total Pages: '}
                <Text style={{ fontWeight: '800' }}>
                  {calculatedTotalPages} {isTe ? 'పుటలు' : 'Pages'}
                </Text>
              </Text>
            </View>
          </View>
        </Card>

        {/* Customize Sections Toggle */}
        <Card style={styles.customizerCard}>
          <TouchableOpacity
            style={styles.customizerHeader}
            onPress={() => setShowCustomizer(!showCustomizer)}
            activeOpacity={0.7}
          >
            <View>
              <Text style={[styles.customizerTitle, { color: colors.text }]}>
                {isTe ? 'విభాగాలను సర్దుబాటు చేయండి' : 'Customize Sections'}
              </Text>
              <Text style={[styles.customizerSub, { color: colors.textSecondary }]}>
                {showCustomizer
                  ? (isTe ? 'విభాగాల జాబితాను దాచడానికి నొక్కండి' : 'Tap to collapse section list')
                  : (isTe ? 'వ్యక్తిగత విభాగాలను ఎంచుకోవడానికి నొక్కండి' : 'Tap to show/hide individual sections')}
              </Text>
            </View>
            <Text style={[styles.chevronText, { color: colors.gold }]}>
              {showCustomizer ? '▲' : '▼'}
            </Text>
          </TouchableOpacity>

          {showCustomizer && (
            <View style={styles.sectionsList}>
              {sectionItems.map(item => (
                <View
                  key={item.key}
                  style={[styles.switchRow, { borderBottomColor: colors.border }]}
                >
                  <View style={styles.switchInfo}>
                    <Text style={[styles.switchTitle, { color: colors.text }]}>
                      {item.title}
                    </Text>
                    <Text style={[styles.switchPageBadge, { color: colors.textMuted }]}>
                      {item.pages} {isTe ? 'పుట' : 'page'}{item.pages > 1 ? 'లు' : ''}
                    </Text>
                  </View>
                  <Switch
                    value={!!sections[item.key]}
                    onValueChange={() => toggleSection(item.key)}
                    trackColor={{ false: colors.border, true: colors.primary }}
                    thumbColor={sections[item.key] ? colors.gold : '#f4f3f4'}
                  />
                </View>
              ))}
            </View>
          )}
        </Card>

        {/* Success Card (Shown after export) */}
        {lastSavedReport && stage === 'complete' && (
          <Card style={[styles.successCard, { borderColor: colors.accent.green, backgroundColor: `${colors.accent.green}10` }]}>
            <View style={styles.successHeader}>
              <Text style={styles.checkIcon}>✅</Text>
              <View style={styles.successTitleArea}>
                <Text style={[styles.successTitle, { color: colors.accent.green }]}>
                  {isTe ? 'PDF విజయవంతంగా రూపొందించబడింది!' : 'PDF Generated Successfully!'}
                </Text>
                <Text style={[styles.successDetails, { color: colors.text }]}>
                  {lastSavedReport.fileName} ({lastSavedReport.sizeFormatted} • {lastSavedReport.pageCount} {isTe ? 'పుటలు' : 'Pages'})
                </Text>
              </View>
            </View>

            <View style={styles.successActions}>
              <PrimaryButton
                title={isTe ? 'ఓపెన్ / ప్రివ్యూ' : 'Open / Preview'}
                onPress={() => handleOpenPreview(lastSavedReport.uri)}
                variant="primary"
                style={styles.successActionBtn}
              />
              <PrimaryButton
                title={isTe ? 'ఫోల్డర్‌కు సేవ్' : 'Save to Folder'}
                onPress={() => handleExport('save')}
                variant="gold"
                style={styles.successActionBtn}
              />
            </View>
          </Card>
        )}
      </ScrollView>

      {/* Sticky Bottom Action Bar */}
      <View style={[styles.bottomBar, { backgroundColor: colors.surface, borderTopColor: colors.border }]}>
        <View style={styles.bottomBarRow}>
          <PrimaryButton
            title={isTe ? `ఫోన్‌కు భద్రపరచండి (${calculatedTotalPages} పుటలు)` : `Save to Phone (${calculatedTotalPages}p)`}
            onPress={() => handleExport('save')}
            variant="gold"
            style={styles.mainSaveBtn}
          />
          <TouchableOpacity
            style={[styles.shareBtn, { backgroundColor: colors.stripBg, borderColor: colors.border }]}
            onPress={() => handleExport('share')}
            activeOpacity={0.7}
          >
            <Text style={[styles.shareBtnText, { color: colors.primary }]}>
              📤 {isTe ? 'షేర్' : 'Share'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Progress Stepper Modal */}
      <Modal
        visible={stage === 'preparing' || stage === 'generating' || stage === 'saving'}
        transparent
        animationType="fade"
      >
        <View style={styles.modalOverlay}>
          <View style={[styles.stepperBox, { backgroundColor: colors.surface, borderColor: colors.gold }]}>
            <ActivityIndicator size="large" color={colors.primary} style={styles.spinner} />
            <Text style={[styles.stepperTitle, { color: colors.primary }]}>
              {isTe ? 'నివేదిక తయారవుతోంది...' : 'Generating PDF Report...'}
            </Text>
            <Text style={[styles.stepperSub, { color: colors.textSecondary }]}>
              {stageMessage || (isTe ? 'దయచేసి వేచి ఉండండి...' : 'Please wait...')}
            </Text>

            <View style={styles.stagesTrack}>
              <View style={[styles.stageItem, stage === 'preparing' && styles.stageItemActive]}>
                <Text style={styles.stageNumber}>1</Text>
                <Text style={[styles.stageLabel, { color: colors.text }]}>
                  {isTe ? 'డేటా సిద్ధం' : 'Preparing'}
                </Text>
              </View>
              <View style={[styles.stageItem, stage === 'generating' && styles.stageItemActive]}>
                <Text style={styles.stageNumber}>2</Text>
                <Text style={[styles.stageLabel, { color: colors.text }]}>
                  {isTe ? 'PDF రూపకల్పన' : 'Rendering'}
                </Text>
              </View>
              <View style={[styles.stageItem, stage === 'saving' && styles.stageItemActive]}>
                <Text style={styles.stageNumber}>3</Text>
                <Text style={[styles.stageLabel, { color: colors.text }]}>
                  {isTe ? 'భద్రపరచడం' : 'Saving'}
                </Text>
              </View>
            </View>
          </View>
        </View>
      </Modal>
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    padding: spacing.lg,
    paddingBottom: 110,
  },
  profileCard: {
    padding: spacing.md,
    marginBottom: spacing.md,
  },
  profileHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: spacing.sm,
  },
  profileName: {
    fontSize: 18,
    fontWeight: '800',
    marginBottom: 2,
  },
  profileBirth: {
    fontSize: 12,
  },
  myReportsBtn: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: radius.sm,
    borderWidth: 1,
  },
  myReportsBtnText: {
    fontSize: 12,
    fontWeight: '700',
  },
  chipsRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.xs,
    marginTop: 4,
  },
  presetCard: {
    padding: spacing.md,
    marginBottom: spacing.md,
  },
  sectionTitle: {
    fontSize: 15,
    fontWeight: '800',
    marginBottom: spacing.sm,
  },
  segmentedCtrl: {
    marginBottom: spacing.md,
  },
  presetInfoBanner: {
    padding: spacing.md,
    borderRadius: radius.sm,
    borderWidth: 1,
  },
  presetDesc: {
    fontSize: 13,
    lineHeight: 18,
    marginBottom: 8,
  },
  totalBadgeRow: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
  },
  totalEstimateText: {
    fontSize: 14,
    fontWeight: '700',
  },
  customizerCard: {
    padding: spacing.md,
    marginBottom: spacing.md,
  },
  customizerHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  customizerTitle: {
    fontSize: 15,
    fontWeight: '800',
    marginBottom: 2,
  },
  customizerSub: {
    fontSize: 12,
  },
  chevronText: {
    fontSize: 16,
    fontWeight: '800',
  },
  sectionsList: {
    marginTop: spacing.md,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: '#e5e7eb',
    paddingTop: spacing.xs,
  },
  switchRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 10,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  switchInfo: {
    flex: 1,
    marginRight: spacing.md,
  },
  switchTitle: {
    fontSize: 13,
    fontWeight: '600',
  },
  switchPageBadge: {
    fontSize: 11,
    marginTop: 2,
  },
  successCard: {
    padding: spacing.md,
    marginBottom: spacing.md,
    borderWidth: 1.5,
  },
  successHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  checkIcon: {
    fontSize: 24,
    marginRight: 10,
  },
  successTitleArea: {
    flex: 1,
  },
  successTitle: {
    fontSize: 15,
    fontWeight: '800',
  },
  successDetails: {
    fontSize: 12,
    marginTop: 2,
  },
  successActions: {
    flexDirection: 'row',
    gap: spacing.sm,
    marginTop: spacing.xs,
  },
  successActionBtn: {
    flex: 1,
    marginVertical: 0,
  },
  bottomBar: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderTopWidth: 1,
    elevation: 8,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: -2 },
  },
  bottomBarRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  mainSaveBtn: {
    flex: 1,
    marginVertical: 0,
  },
  shareBtn: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: radius.md,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  shareBtnText: {
    fontSize: 14,
    fontWeight: '700',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.6)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  stepperBox: {
    width: '100%',
    maxWidth: 340,
    borderRadius: radius.lg,
    borderWidth: 1.5,
    padding: spacing.xl,
    alignItems: 'center',
  },
  spinner: {
    marginBottom: spacing.md,
  },
  stepperTitle: {
    fontSize: 17,
    fontWeight: '800',
    marginBottom: 4,
    textAlign: 'center',
  },
  stepperSub: {
    fontSize: 13,
    marginBottom: spacing.lg,
    textAlign: 'center',
  },
  stagesTrack: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    width: '100%',
    paddingTop: spacing.xs,
  },
  stageItem: {
    alignItems: 'center',
    flex: 1,
    opacity: 0.4,
  },
  stageItemActive: {
    opacity: 1,
  },
  stageNumber: {
    width: 26,
    height: 26,
    borderRadius: 13,
    backgroundColor: '#8b2500',
    color: '#fff',
    textAlign: 'center',
    lineHeight: 26,
    fontSize: 12,
    fontWeight: '800',
    marginBottom: 4,
  },
  stageLabel: {
    fontSize: 11,
    fontWeight: '700',
  },
});
