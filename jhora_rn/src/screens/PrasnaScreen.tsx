import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TextInput,
  TouchableOpacity,
  SafeAreaView,
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import { CityDatabase, CityEntry } from '../services/cityDatabase';
import { BirthData } from '../models/astroModels';

interface Props {
  isDark: boolean;
  lang: 'te' | 'en';
  onBack: () => void;
  onGeneratePrasna: (birthData: BirthData) => void;
}

export const PrasnaScreen: React.FC<Props> = ({
  isDark,
  lang,
  onBack,
  onGeneratePrasna,
}) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const [query, setQuery] = useState('');
  const [kpNumber, setKpNumber] = useState('1');
  const [city, setCity] = useState<CityEntry>(CityDatabase.cities[0]);

  const handleGenerate = () => {
    const now = new Date();
    const kpNum = parseInt(kpNumber, 10) || 1;
    const clampedKp = Math.min(249, Math.max(1, kpNum));

    const title = query.trim()
      ? `ప్రశ్న: ${query.trim()} (#${clampedKp})`
      : `ప్రశ్నా చక్రం (KP #${clampedKp})`;

    const birthData: BirthData = {
      name: title,
      dateTime: now,
      latitude: city.latitude,
      longitude: city.longitude,
      timezone: city.timezone,
      placeName: `${city.name}, ${city.state}`,
      gender: 'ప్రశ్న',
    };

    onGeneratePrasna(birthData);
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      {/* Top Header */}
      <View style={[styles.appBar, { borderColor, backgroundColor: cardBg }]}>
        <TouchableOpacity onPress={onBack} style={styles.backBtn}>
          <Text style={[styles.backIcon, { color: gold }]}>‹</Text>
        </TouchableOpacity>
        <Text style={[styles.appBarTitle, { color: textPrimary }]}>
          {isTe ? 'ప్రశ్న శాస్త్రం (Prasna / Horary)' : 'Prasna / Horary Chart'}
        </Text>
        <View style={{ width: 30 }} />
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Info Banner */}
        <View style={[styles.banner, { backgroundColor: `${gold}15`, borderColor: `${gold}40` }]}>
          <Text style={[styles.bannerTitle, { color: gold }]}>
            ✦ {isTe ? 'తక్షణ ప్రశ్న విచారణ & KP విధానం' : 'Instant Horary & KP Seed'}
          </Text>
          <Text style={[styles.bannerDesc, { color: textSecondary }]}>
            {isTe
              ? 'ప్రశ్న అడిగిన సమయానికి లగ్న గ్రహ స్థితులు మరియు 1 నుండి 249 వరకు గల KP సంఖ్య ఆధారంగా తక్షణ జాతక విశ్లేషణ సిద్ధమవుతుంది.'
              : 'Generates instant chart for current moment using 1–249 Krishnamurti Padhdhati seed.'}
          </Text>
        </View>

        {/* Query Input */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.inputLabel, { color: textSecondary }]}>
            {isTe ? 'ప్రశ్న వివరాలు (Query / Question):' : 'Enter Question:'}
          </Text>
          <TextInput
            style={[styles.input, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
            placeholder={isTe ? 'ఉదా: ఉద్యోగ ప్రాప్తి ఎప్పుడు? / వివాహం ఎప్పుడు?' : 'e.g. When will I get a job?'}
            placeholderTextColor="#888"
            value={query}
            onChangeText={setQuery}
          />
        </View>

        {/* KP Number Input */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.inputLabel, { color: textSecondary }]}>
            {isTe ? 'KP సంఖ్య (Seed Number 1 to 249):' : 'KP Seed Number (1 to 249):'}
          </Text>
          <TextInput
            style={[styles.input, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
            placeholder="1 to 249"
            placeholderTextColor="#888"
            keyboardType="numeric"
            value={kpNumber}
            onChangeText={setKpNumber}
          />
        </View>

        {/* Current Time Banner */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.inputLabel, { color: textSecondary }]}>
            {isTe ? 'ప్రశ్నా సమయం & స్థలము:' : 'Prasna Moment & City:'}
          </Text>
          <Text style={[styles.timeText, { color: textPrimary }]}>
            {new Date().toLocaleTimeString()} • {city.name}, {city.state}
          </Text>
        </View>

        {/* Submit */}
        <TouchableOpacity style={styles.submitBtn} onPress={handleGenerate} activeOpacity={0.8}>
          <Text style={styles.submitBtnText}>
            {isTe ? '🔮 తక్షణ ప్రశ్నా చక్రం గణన చేయండి' : '🔮 Generate Prasna Chart'}
          </Text>
        </TouchableOpacity>
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
    fontSize: 16,
    fontWeight: '800',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
    gap: 12,
  },
  banner: {
    padding: 12,
    borderRadius: 10,
    borderWidth: 1,
  },
  bannerTitle: {
    fontSize: 13,
    fontWeight: '800',
  },
  bannerDesc: {
    fontSize: 11,
    marginTop: 4,
    lineHeight: 15,
  },
  card: {
    padding: 12,
    borderRadius: 10,
    borderWidth: 1,
  },
  inputLabel: {
    fontSize: 12,
    fontWeight: '700',
    marginBottom: 6,
  },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 8,
    fontSize: 13,
  },
  timeText: {
    fontSize: 13,
    fontWeight: '700',
  },
  submitBtn: {
    backgroundColor: '#8B2500',
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
    marginTop: 8,
  },
  submitBtnText: {
    color: '#FFF',
    fontSize: 13.5,
    fontWeight: '800',
  },
});

