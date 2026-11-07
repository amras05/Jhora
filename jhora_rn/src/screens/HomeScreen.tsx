import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  Image,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, Card } from '../components/ui';
import { radius, spacing } from '../theme/tokens';

interface Props {
  onNavigate: (screen: 'home' | 'birth_input' | 'panchanga' | 'prasna' | 'saved') => void;
  // Optional for backward compatibility with App.tsx during migration
  isDark?: boolean;
  onToggleTheme?: () => void;
  lang?: 'te' | 'en';
  onToggleLang?: () => void;
}

export const HomeScreen: React.FC<Props> = ({ onNavigate }) => {
  const { colors, isDark, toggleTheme } = useTheme();
  const { t, lang, toggleLang } = useI18n();

  return (
    <Screen style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* Top Header Bar */}
        <View style={styles.topBar}>
          <View
            style={[
              styles.brandBadge,
              {
                borderColor: `${colors.gold}50`,
                backgroundColor: `${colors.gold}15`,
              },
            ]}
          >
            <Text style={[styles.starIcon, { color: colors.gold }]}>★</Text>
            <Text style={[styles.brandText, { color: colors.gold }]}>
              {t('home.brandBadge')}
            </Text>
          </View>

          <View style={styles.actionsRow}>
            {/* Theme Toggle Button */}
            <TouchableOpacity
              style={[
                styles.actionBtn,
                { borderColor: colors.border, backgroundColor: colors.surface },
              ]}
              onPress={toggleTheme}
              accessibilityRole="button"
              accessibilityLabel="Toggle theme"
              activeOpacity={0.7}
            >
              <Text style={styles.actionIcon}>{isDark ? '☀️' : '🌙'}</Text>
            </TouchableOpacity>

            {/* Language Toggle Button */}
            <TouchableOpacity
              style={[
                styles.actionBtn,
                { borderColor: colors.border, backgroundColor: colors.surface, paddingHorizontal: 12 },
              ]}
              onPress={toggleLang}
              accessibilityRole="button"
              accessibilityLabel="Toggle language"
              activeOpacity={0.7}
            >
              <Text style={[styles.langText, { color: colors.text }]}>
                {lang === 'te' ? 'తెలుగు' : 'EN'}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Hero Section: Bala Amma Image & Sacred Title */}
        <View style={styles.heroSection}>
          <View
            style={[
              styles.avatarContainer,
              {
                borderColor: colors.gold,
                backgroundColor: colors.surface,
                shadowColor: colors.gold,
              },
            ]}
          >
            <Image
              source={require('../../assets/icon.png')}
              style={styles.avatarImage}
              resizeMode="cover"
            />
          </View>

          <Text style={[styles.heroTitle, { color: colors.text }]}>
            {t('home.heroTitle')}
          </Text>

          <Text style={[styles.heroSubtitle, { color: colors.gold }]}>
            {t('home.heroSubtitle')}
          </Text>

          <View
            style={[
              styles.shlokaPill,
              {
                borderColor: `${colors.gold}40`,
                backgroundColor: colors.stripBg,
              },
            ]}
          >
            <Text style={[styles.shlokaText, { color: colors.primary }]}>
              {t('home.sacredShloka')}
            </Text>
          </View>
        </View>

        {/* 4 Primary Navigation Cards */}
        <View style={styles.cardsContainer}>
          {/* 1. Birth Chart */}
          <Card
            onPress={() => onNavigate('birth_input')}
            style={styles.navCard}
          >
            <View style={styles.cardRow}>
              <View
                style={[
                  styles.cardIconBox,
                  { backgroundColor: `${colors.gold}20` },
                ]}
              >
                <Text style={styles.cardEmoji}>✨</Text>
              </View>
              <View style={styles.cardContent}>
                <Text style={[styles.cardTitle, { color: colors.text }]}>
                  {t('home.birthChartTitle')}
                </Text>
                <Text style={[styles.cardSubtitle, { color: colors.textSecondary }]}>
                  {t('home.birthChartSubtitle')}
                </Text>
              </View>
              <Text style={[styles.cardChevron, { color: colors.gold }]}>›</Text>
            </View>
          </Card>

          {/* 2. Daily Panchangam */}
          <Card
            onPress={() => onNavigate('panchanga')}
            style={styles.navCard}
          >
            <View style={styles.cardRow}>
              <View
                style={[
                  styles.cardIconBox,
                  { backgroundColor: `${colors.accent.green}20` },
                ]}
              >
                <Text style={styles.cardEmoji}>📅</Text>
              </View>
              <View style={styles.cardContent}>
                <Text style={[styles.cardTitle, { color: colors.text }]}>
                  {t('home.panchangaTitle')}
                </Text>
                <Text style={[styles.cardSubtitle, { color: colors.textSecondary }]}>
                  {t('home.panchangaSubtitle')}
                </Text>
              </View>
              <Text style={[styles.cardChevron, { color: colors.gold }]}>›</Text>
            </View>
          </Card>

          {/* 3. Prasna Chart */}
          <Card
            onPress={() => onNavigate('prasna')}
            style={styles.navCard}
          >
            <View style={styles.cardRow}>
              <View
                style={[
                  styles.cardIconBox,
                  { backgroundColor: `${colors.accent.blue}20` },
                ]}
              >
                <Text style={styles.cardEmoji}>🔮</Text>
              </View>
              <View style={styles.cardContent}>
                <Text style={[styles.cardTitle, { color: colors.text }]}>
                  {t('home.prasnaTitle')}
                </Text>
                <Text style={[styles.cardSubtitle, { color: colors.textSecondary }]}>
                  {t('home.prasnaSubtitle')}
                </Text>
              </View>
              <Text style={[styles.cardChevron, { color: colors.gold }]}>›</Text>
            </View>
          </Card>

          {/* 4. Saved Horoscopes */}
          <Card
            onPress={() => onNavigate('saved')}
            style={styles.navCard}
          >
            <View style={styles.cardRow}>
              <View
                style={[
                  styles.cardIconBox,
                  { backgroundColor: `${colors.accent.orange}20` },
                ]}
              >
                <Text style={styles.cardEmoji}>📑</Text>
              </View>
              <View style={styles.cardContent}>
                <Text style={[styles.cardTitle, { color: colors.text }]}>
                  {t('home.savedTitle')}
                </Text>
                <Text style={[styles.cardSubtitle, { color: colors.textSecondary }]}>
                  {t('home.savedSubtitle')}
                </Text>
              </View>
              <Text style={[styles.cardChevron, { color: colors.gold }]}>›</Text>
            </View>
          </Card>
        </View>

        {/* Astrologer Credential Card */}
        <Card variant="outlined" style={styles.astrologerCard}>
          <Text style={[styles.astroTitle, { color: colors.primary }]}>
            {t('home.astrologerTitle')}
          </Text>
          <Text style={[styles.astroScholar, { color: colors.primaryDark }]}>
            {t('home.astrologerScholar')}
          </Text>
          <Text style={[styles.astroAddress, { color: colors.textMuted }]}>
            {t('home.astrologerAddress')}
          </Text>
        </Card>
      </ScrollView>
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.sm,
    paddingBottom: spacing.xxl,
  },
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  brandBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs + 1,
    borderRadius: radius.full,
    borderWidth: 1,
  },
  starIcon: {
    fontSize: 12,
    marginRight: 6,
  },
  brandText: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 0.8,
  },
  actionsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  actionBtn: {
    minHeight: 36,
    paddingHorizontal: spacing.sm,
    borderRadius: radius.full,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  actionIcon: {
    fontSize: 16,
  },
  langText: {
    fontSize: 13,
    fontWeight: '700',
  },
  heroSection: {
    alignItems: 'center',
    marginVertical: spacing.sm,
  },
  avatarContainer: {
    width: 92,
    height: 92,
    borderRadius: 46,
    borderWidth: 2.5,
    overflow: 'hidden',
    marginBottom: spacing.md,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.25,
    shadowRadius: 8,
    elevation: 4,
  },
  avatarImage: {
    width: '100%',
    height: '100%',
  },
  heroTitle: {
    fontSize: 18,
    fontWeight: '800',
    textAlign: 'center',
    marginBottom: spacing.xs,
    paddingHorizontal: spacing.md,
  },
  heroSubtitle: {
    fontSize: 13,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: spacing.md,
  },
  shlokaPill: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs + 2,
    borderRadius: radius.full,
    borderWidth: 1,
    marginTop: spacing.xs,
  },
  shlokaText: {
    fontSize: 11,
    fontWeight: '700',
    textAlign: 'center',
  },
  cardsContainer: {
    marginTop: spacing.sm,
  },
  navCard: {
    marginVertical: spacing.xs + 1,
    padding: spacing.md,
  },
  cardRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  cardIconBox: {
    width: 44,
    height: 44,
    borderRadius: radius.md,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
  },
  cardEmoji: {
    fontSize: 22,
  },
  cardContent: {
    flex: 1,
  },
  cardTitle: {
    fontSize: 15,
    fontWeight: '700',
    marginBottom: 2,
  },
  cardSubtitle: {
    fontSize: 12,
    lineHeight: 16,
  },
  cardChevron: {
    fontSize: 24,
    fontWeight: '300',
    marginLeft: spacing.sm,
  },
  astrologerCard: {
    marginTop: spacing.lg,
    padding: spacing.md,
    alignItems: 'center',
  },
  astroTitle: {
    fontSize: 14,
    fontWeight: '800',
    textAlign: 'center',
    marginBottom: 3,
  },
  astroScholar: {
    fontSize: 12,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: 3,
  },
  astroAddress: {
    fontSize: 11,
    textAlign: 'center',
  },
});
