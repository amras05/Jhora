import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Image,
} from 'react-native';
import { AppColors } from '../theme/appTheme';

interface Props {
  isDark: boolean;
  onToggleTheme: () => void;
  lang: 'te' | 'en';
  onToggleLang: () => void;
  onNavigate: (screen: 'home' | 'birth_input' | 'panchanga' | 'prasna' | 'saved') => void;
}

export const HomeScreen: React.FC<Props> = ({
  isDark,
  onToggleTheme,
  lang,
  onToggleLang,
  onNavigate,
}) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const textMuted = AppColors.getTextMuted(isDark);

  const isTe = lang === 'te';

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Top Brand Bar */}
        <View style={styles.topBar}>
          <View style={[styles.brandBadge, { borderColor: `${gold}40`, backgroundColor: `${gold}15` }]}>
            <Text style={[styles.starIcon, { color: gold }]}>★</Text>
            <Text style={[styles.brandText, { color: gold }]}>JAGANNATHA HORA MOBILE</Text>
          </View>

          <View style={styles.actionsRow}>
            {/* Theme Toggle Button */}
            <TouchableOpacity
              style={[styles.actionBtn, { borderColor, backgroundColor: cardBg }]}
              onPress={onToggleTheme}
              activeOpacity={0.7}
            >
              <Text style={{ fontSize: 16 }}>{isDark ? '☀️' : '🌙'}</Text>
            </TouchableOpacity>

            {/* Language Toggle Button */}
            <TouchableOpacity
              style={[styles.actionBtn, { borderColor, backgroundColor: cardBg, paddingHorizontal: 10 }]}
              onPress={onToggleLang}
              activeOpacity={0.7}
            >
              <Text style={[styles.langText, { color: textPrimary }]}>{isTe ? 'తెలుగు' : 'EN'}</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Hero Vedic Sun & Branding */}
        <View style={styles.heroSection}>
          <View style={[styles.sunCircle, { borderColor: gold, borderWidth: 2, overflow: 'hidden' }]}>
            <Image
              source={require('../../assets/icon.png')}
              style={{ width: '100%', height: '100%' }}
              resizeMode="cover"
            />
          </View>

          <Text style={[styles.heroTitle, { color: textPrimary, fontSize: 18, textAlign: 'center' }]}>
            {isTe ? 'సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం' : 'Sai Bala Tripura Sundari Jyothishalayam'}
          </Text>

          <Text style={[styles.heroSubtitle, { color: `${gold}D0`, textAlign: 'center' }]}>
            {isTe ? 'శ్రీ జగన్నాథ వేద జ్యోతిష సమగ్ర గణన చక్రం' : 'Sri Jagannatha Vedic Astrology Engine'}
          </Text>

          <View style={[styles.sacredShlokaPill, { borderColor: `${gold}40`, backgroundColor: cardBg }]}>
            <Text style={[styles.sacredShlokaText, { color: AppColors.maroonLight }]}>
              {isTe
                ? '|| శ్రీరస్తు శుభమస్తు విజయోస్తు • సాయి బాలా త్రిపుర సుందరి ||'
                : '|| Sri Bala Tripura Sundari Devyai Namaha ||'}
            </Text>
          </View>
        </View>

        {/* 4 Primary Navigation Cards */}
        <View style={styles.cardsContainer}>
          {/* 1. Birth Chart */}
          <TouchableOpacity
            style={[styles.featureCard, { backgroundColor: cardBg, borderColor }]}
            onPress={() => onNavigate('birth_input')}
            activeOpacity={0.8}
          >
            <View style={[styles.cardIconBox, { backgroundColor: `${gold}20` }]}>
              <Text style={{ fontSize: 24 }}>✨</Text>
            </View>
            <View style={styles.cardContent}>
              <Text style={[styles.cardTitle, { color: textPrimary }]}>
                {isTe ? 'జన్మ జాతక చక్రము (Birth Chart)' : 'Birth Chart (Janma Kundali)'}
              </Text>
              <Text style={[styles.cardSubtitle, { color: textSecondary }]}>
                {isTe
                  ? 'రాశి, 16 షోడశవర్గములు, 5-స్థాయి వింశోత్తరి దశలు, షడ్బలం & 25 పుటల రిపోర్ట్'
                  : 'Rashi D1, 16 Divisional Charts, 5-Level Vimshottari Dashas & 25-Page PDF Report'}
              </Text>
            </View>
            <Text style={[styles.cardChevron, { color: gold }]}>›</Text>
          </TouchableOpacity>

          {/* 2. Daily Panchangam */}
          <TouchableOpacity
            style={[styles.featureCard, { backgroundColor: cardBg, borderColor }]}
            onPress={() => onNavigate('panchanga')}
            activeOpacity={0.8}
          >
            <View style={[styles.cardIconBox, { backgroundColor: '#10B98120' }]}>
              <Text style={{ fontSize: 24 }}>📅</Text>
            </View>
            <View style={styles.cardContent}>
              <Text style={[styles.cardTitle, { color: textPrimary }]}>
                {isTe ? 'పంచాంగ దర్శిని (Panchanga)' : 'Daily Panchangam'}
              </Text>
              <Text style={[styles.cardSubtitle, { color: textSecondary }]}>
                {isTe
                  ? 'తిథి, నక్షత్రం, యోగం, కరణం, రాహుకాలం, యమగండం & అభిజిత్ ముహూర్తం'
                  : 'Tithi, Nakshatra, Yoga, Karana, Rahu Kalam, Yamagandam & Abhijit Muhurtha'}
              </Text>
            </View>
            <Text style={[styles.cardChevron, { color: gold }]}>›</Text>
          </TouchableOpacity>

          {/* 3. Prasna Chart */}
          <TouchableOpacity
            style={[styles.featureCard, { backgroundColor: cardBg, borderColor }]}
            onPress={() => onNavigate('prasna')}
            activeOpacity={0.8}
          >
            <View style={[styles.cardIconBox, { backgroundColor: '#8B5CF620' }]}>
              <Text style={{ fontSize: 24 }}>🔮</Text>
            </View>
            <View style={styles.cardContent}>
              <Text style={[styles.cardTitle, { color: textPrimary }]}>
                {isTe ? 'ప్రశ్న శాస్త్రం (Prasna / Horary)' : 'Prasna / Horary Chart'}
              </Text>
              <Text style={[styles.cardSubtitle, { color: textSecondary }]}>
                {isTe
                  ? 'ప్రస్తుత క్షణానికి 1–249 KP సంఖ్యతో తక్షణ ప్రశ్నా చక్రం'
                  : 'Instant horary chart for current moment with 1–249 KP Seed'}
              </Text>
            </View>
            <Text style={[styles.cardChevron, { color: gold }]}>›</Text>
          </TouchableOpacity>

          {/* 4. Saved Horoscopes */}
          <TouchableOpacity
            style={[styles.featureCard, { backgroundColor: cardBg, borderColor }]}
            onPress={() => onNavigate('saved')}
            activeOpacity={0.8}
          >
            <View style={[styles.cardIconBox, { backgroundColor: '#F59E0B20' }]}>
              <Text style={{ fontSize: 24 }}>📑</Text>
            </View>
            <View style={styles.cardContent}>
              <Text style={[styles.cardTitle, { color: textPrimary }]}>
                {isTe ? 'భద్రపరచిన జాతకాలు (Saved Horoscopes)' : 'Saved Horoscopes'}
              </Text>
              <Text style={[styles.cardSubtitle, { color: textSecondary }]}>
                {isTe
                  ? 'గతంలో భద్రపరచిన కుటుంబ మరియు మిత్రుల జాతక ప్రొఫైల్స్'
                  : 'Saved horoscope profiles, history, and quick access'}
              </Text>
            </View>
            <Text style={[styles.cardChevron, { color: gold }]}>›</Text>
          </TouchableOpacity>
        </View>

        {/* Astrologer Credential Card */}
        <View style={[styles.astrologerCard, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.astroTitle, { color: AppColors.maroon }]}>
            సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం
          </Text>
          <Text style={[styles.astroScholar, { color: AppColors.maroonLight }]}>
            జ్యోతిష విద్యాభూషణ-M.B.S.Sastry-9030166610
          </Text>
          <Text style={[styles.astroAddress, { color: textMuted }]}>
            భవానీపురం, విజయవాడ - 12 (BHAVANIPURAM VIJAYAWADA 12)
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  brandBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    borderWidth: 1,
  },
  starIcon: {
    fontSize: 12,
    marginRight: 6,
  },
  brandText: {
    fontSize: 10,
    fontWeight: '800',
    letterSpacing: 1.2,
  },
  actionsRow: {
    flexDirection: 'row',
    gap: 8,
  },
  actionBtn: {
    paddingHorizontal: 8,
    paddingVertical: 5,
    borderRadius: 16,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  langText: {
    fontSize: 11,
    fontWeight: '700',
  },
  heroSection: {
    alignItems: 'center',
    marginBottom: 24,
  },
  sunCircle: {
    width: 68,
    height: 68,
    borderRadius: 34,
    borderWidth: 1.5,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 10,
  },
  sunSymbol: {
    fontSize: 32,
  },
  heroTitle: {
    fontSize: 24,
    fontWeight: '800',
    letterSpacing: 1,
    textAlign: 'center',
  },
  heroSubtitle: {
    fontSize: 12,
    fontWeight: '700',
    letterSpacing: 1.5,
    marginTop: 4,
    textAlign: 'center',
  },
  sacredShlokaPill: {
    marginTop: 12,
    paddingVertical: 6,
    paddingHorizontal: 14,
    borderRadius: 20,
    borderWidth: 1,
  },
  sacredShlokaText: {
    fontSize: 11,
    fontWeight: '700',
    textAlign: 'center',
  },
  cardsContainer: {
    gap: 12,
    marginBottom: 24,
  },
  featureCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 14,
    borderRadius: 12,
    borderWidth: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  cardIconBox: {
    width: 48,
    height: 48,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 14,
  },
  cardContent: {
    flex: 1,
  },
  cardTitle: {
    fontSize: 14,
    fontWeight: '800',
  },
  cardSubtitle: {
    fontSize: 11,
    marginTop: 3,
    lineHeight: 15,
  },
  cardChevron: {
    fontSize: 22,
    fontWeight: '700',
    marginLeft: 6,
  },
  astrologerCard: {
    padding: 14,
    borderRadius: 10,
    borderWidth: 1,
    alignItems: 'center',
    marginTop: 8,
  },
  astroTitle: {
    fontSize: 13,
    fontWeight: '800',
    textAlign: 'center',
  },
  astroScholar: {
    fontSize: 12,
    fontWeight: '700',
    marginTop: 4,
    textAlign: 'center',
  },
  astroAddress: {
    fontSize: 10.5,
    marginTop: 2,
    textAlign: 'center',
  },
});

