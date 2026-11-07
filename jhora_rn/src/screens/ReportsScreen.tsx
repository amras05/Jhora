import React, { useState, useEffect, useCallback } from 'react';
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  TouchableOpacity,
  Alert,
  RefreshControl,
  ActivityIndicator,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, Card, PrimaryButton, EmptyState } from '../components/ui';
import { radius, spacing } from '../theme/tokens';
import { PdfExportService, SavedReport } from '../services/pdfExportService';

interface Props {
  onBack: () => void;
  onNavigateNew?: () => void;
}

export const ReportsScreen: React.FC<Props> = ({ onBack, onNavigateNew }) => {
  const { colors } = useTheme();
  const { lang } = useI18n();
  const isTe = lang === 'te';

  const [reports, setReports] = useState<SavedReport[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const loadReports = useCallback(async () => {
    try {
      const list = await PdfExportService.listReports();
      setReports(list);
    } catch (e) {
      console.warn('Failed to load reports:', e);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, []);

  useEffect(() => {
    loadReports();
  }, [loadReports]);

  const handleRefresh = () => {
    setRefreshing(true);
    loadReports();
  };

  const handleOpen = async (report: SavedReport) => {
    try {
      await PdfExportService.openReport(report.uri);
    } catch (e: any) {
      Alert.alert(
        isTe ? 'లోపం' : 'Error',
        e?.message || (isTe ? 'నివేదికను తెరవడంలో లోపం ఏర్పడింది' : 'Failed to open report')
      );
    }
  };

  const handleSaveToPhone = async (report: SavedReport) => {
    try {
      const res = await PdfExportService.saveToPhone(report.uri, report.fileName);
      Alert.alert(
        res.ok ? (isTe ? 'విజయం' : 'Success') : (isTe ? 'లోపం' : 'Error'),
        res.message
      );
    } catch (e: any) {
      Alert.alert(
        isTe ? 'లోపం' : 'Error',
        e?.message || (isTe ? 'ఫోల్డర్‌లో భద్రపరచడంలో లోపం' : 'Failed to save to folder')
      );
    }
  };

  const handleDelete = (report: SavedReport) => {
    Alert.alert(
      isTe ? 'నివేదికను తొలగించాలా?' : 'Delete Report?',
      isTe
        ? `"${report.name}" నివేదిక శాశ్వతంగా తొలగించబడుతుంది.`
        : `Delete report "${report.name}"? This action cannot be undone.`,
      [
        { text: isTe ? 'రద్దు' : 'Cancel', style: 'cancel' },
        {
          text: isTe ? 'తొలగించు' : 'Delete',
          style: 'destructive',
          onPress: async () => {
            await PdfExportService.deleteReport(report.uri);
            loadReports();
          },
        },
      ]
    );
  };

  return (
    <Screen style={styles.container}>
      <AppBar
        title={isTe ? 'నా PDF నివేదికలు' : 'My Saved Reports'}
        subtitle={isTe ? `${reports.length} నివేదికలు భద్రపరచబడ్డాయి` : `${reports.length} Reports Saved`}
        onBack={onBack}
      />

      {loading ? (
        <View style={styles.centerBox}>
          <ActivityIndicator size="large" color={colors.primary} />
          <Text style={[styles.loadingText, { color: colors.textSecondary }]}>
            {isTe ? 'నివేదికలు లోడ్ అవుతున్నాయి...' : 'Loading saved reports...'}
          </Text>
        </View>
      ) : reports.length === 0 ? (
        <EmptyState
          icon="📄"
          title={isTe ? 'ఇంకా ఏ నివేదికలు భద్రపరచబడలేదు' : 'No Reports Saved Yet'}
          description={
            isTe
              ? 'జాతక చక్రం ఫలితాల స్క్రీన్ నుండి PDF నివేదికను రూపొందించి మీ ఫోన్‌లో భద్రపరుచుకోవచ్చు.'
              : 'Generate a PDF report from any calculated horoscope to view, share or print offline anytime.'
          }
          actionTitle={isTe ? 'జాతకం లెక్కించండి' : 'Calculate Horoscope'}
          onAction={onNavigateNew || onBack}
        />
      ) : (
        <FlatList
          data={reports}
          keyExtractor={item => item.uri}
          contentContainerStyle={styles.listContent}
          showsVerticalScrollIndicator={false}
          refreshControl={
            <RefreshControl
              refreshing={refreshing}
              onRefresh={handleRefresh}
              tintColor={colors.primary}
              colors={[colors.primary]}
            />
          }
          renderItem={({ item }) => (
            <Card style={styles.reportCard}>
              <View style={styles.headerRow}>
                <View style={styles.titleArea}>
                  <Text style={[styles.reportName, { color: colors.text }]}>
                    {item.name}
                  </Text>
                  <Text style={[styles.reportMeta, { color: colors.textSecondary }]}>
                    {item.dateFormatted} • {item.sizeFormatted}
                  </Text>
                </View>
                <View style={[styles.pageBadge, { backgroundColor: `${colors.gold}25` }]}>
                  <Text style={[styles.pageBadgeText, { color: colors.gold }]}>
                    {item.pageCount} {isTe ? 'పుటలు' : 'Pages'}
                  </Text>
                </View>
              </View>

              <Text style={[styles.fileNameText, { color: colors.textMuted }]} numberOfLines={1}>
                {item.fileName}
              </Text>

              <View style={[styles.actionRow, { borderTopColor: colors.border }]}>
                {/* 1. Open Button */}
                <TouchableOpacity
                  style={[styles.actionBtn, { backgroundColor: colors.stripBg }]}
                  onPress={() => handleOpen(item)}
                  activeOpacity={0.7}
                >
                  <Text style={[styles.actionBtnText, { color: colors.primary }]}>
                    👁 {isTe ? 'ఓపెన్' : 'Open'}
                  </Text>
                </TouchableOpacity>

                {/* 2. Save to Phone */}
                <TouchableOpacity
                  style={[styles.actionBtn, { backgroundColor: colors.stripBg }]}
                  onPress={() => handleSaveToPhone(item)}
                  activeOpacity={0.7}
                >
                  <Text style={[styles.actionBtnText, { color: colors.primaryDark }]}>
                    💾 {isTe ? 'సేవ్' : 'Save'}
                  </Text>
                </TouchableOpacity>

                {/* 3. Share Button */}
                <TouchableOpacity
                  style={[styles.actionBtn, { backgroundColor: colors.stripBg }]}
                  onPress={() => handleOpen(item)}
                  activeOpacity={0.7}
                >
                  <Text style={[styles.actionBtnText, { color: colors.accent.blue }]}>
                    📤 {isTe ? 'షేర్' : 'Share'}
                  </Text>
                </TouchableOpacity>

                {/* 4. Delete Button */}
                <TouchableOpacity
                  style={[styles.actionBtn, styles.deleteBtn, { backgroundColor: `${colors.accent.red}15` }]}
                  onPress={() => handleDelete(item)}
                  activeOpacity={0.7}
                >
                  <Text style={[styles.actionBtnText, { color: colors.accent.red }]}>
                    🗑
                  </Text>
                </TouchableOpacity>
              </View>
            </Card>
          )}
        />
      )}
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  listContent: {
    padding: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  centerBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: spacing.xl,
  },
  loadingText: {
    marginTop: spacing.md,
    fontSize: 14,
  },
  reportCard: {
    marginBottom: spacing.md,
    padding: spacing.md,
  },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  titleArea: {
    flex: 1,
    marginRight: spacing.sm,
  },
  reportName: {
    fontSize: 16,
    fontWeight: '800',
    marginBottom: 2,
  },
  reportMeta: {
    fontSize: 12,
  },
  pageBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: radius.sm,
  },
  pageBadgeText: {
    fontSize: 11,
    fontWeight: '800',
  },
  fileNameText: {
    fontSize: 11,
    marginTop: 6,
    marginBottom: 10,
    fontFamily: 'monospace',
  },
  actionRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
    paddingTop: 10,
    borderTopWidth: StyleSheet.hairlineWidth,
  },
  actionBtn: {
    flex: 1,
    paddingVertical: 7,
    borderRadius: radius.sm,
    alignItems: 'center',
    justifyContent: 'center',
  },
  deleteBtn: {
    flex: 0.5,
  },
  actionBtnText: {
    fontSize: 12,
    fontWeight: '700',
  },
});
