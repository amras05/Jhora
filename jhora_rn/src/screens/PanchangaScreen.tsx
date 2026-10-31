import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Modal,
  FlatList,
  TextInput,
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import { CityDatabase, CityEntry } from '../services/cityDatabase';
import { AstroEngine } from '../services/astroEngine';
import { PanchangaData } from '../models/astroModels';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';
import { AstroConstants } from '../constants/astroConstants';

interface Props {
  isDark: boolean;
  lang: 'te' | 'en';
  onBack: () => void;
}

export const PanchangaScreen: React.FC<Props> = ({ isDark, lang, onBack }) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const [date, setDate] = useState(new Date());
  const [city, setCity] = useState<CityEntry>(CityDatabase.cities[0]);
  const [cityModal, setCityModal] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<CityEntry[]>(CityDatabase.cities.slice(0, 10));

  const changeDay = (delta: number) => {
    const next = new Date(date);
    next.setDate(next.getDate() + delta);
    setDate(next);
  };

  const handleSearch = (q: string) => {
    setSearchQuery(q);
    if (!q.trim()) setSearchResults(CityDatabase.cities.slice(0, 10));
    else setSearchResults(CityDatabase.search(q));
  };

  // Calculate Panchangam
  const p: PanchangaData = AstroEngine.calculatePanchanga(date, city.latitude, city.longitude, city.timezone);

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      {/* Top App Bar */}
      <View style={[styles.appBar, { borderColor, backgroundColor: cardBg }]}>
        <TouchableOpacity onPress={onBack} style={styles.backBtn}>
          <Text style={[styles.backIcon, { color: gold }]}>‹</Text>
        </TouchableOpacity>
        <Text style={[styles.appBarTitle, { color: textPrimary }]}>
          {isTe ? 'పంచాంగ దర్శిని (Panchangam)' : 'Daily Panchangam'}
        </Text>
        <TouchableOpacity onPress={() => setCityModal(true)} style={styles.cityBtn}>
          <Text style={[styles.cityBtnText, { color: gold }]}>📍 {city.name}</Text>
        </TouchableOpacity>
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Date Selector Row */}
        <View style={[styles.dateRow, { backgroundColor: cardBg, borderColor }]}>
          <TouchableOpacity onPress={() => changeDay(-1)} style={styles.navBtn}>
            <Text style={{ fontSize: 16, color: gold }}>◀</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => setDate(new Date())} style={styles.dateCenter}>
            <Text style={[styles.dateText, { color: textPrimary }]}>
              {TeluguPdfReportGenerator.formatDate(date)}
            </Text>
            <Text style={[styles.dayText, { color: textSecondary }]}>
              {TeluguPdfReportGenerator.weekdaysTelugu[date.getDay() % 7]}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => changeDay(1)} style={styles.navBtn}>
            <Text style={{ fontSize: 16, color: gold }}>▶</Text>
          </TouchableOpacity>
        </View>

        {/* Primary Auspicious Elements */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
            {isTe ? 'ప్రధాన పంచాంగ అంగములు' : 'Core Panchanga Elements'}
          </Text>

          {[
            {
              k: isTe ? 'తిథి' : 'Tithi',
              v: `${p.paksha === 'Shukla Paksha' ? 'శుక్ల పక్ష ' : 'కృష్ణ పక్ష '}${TeluguPdfReportGenerator.tithisTelugu[p.tithiIndex % 30]}`,
            },
            {
              k: isTe ? 'నక్షత్రం' : 'Nakshatra',
              v: AstroConstants.nakshatrasTelugu[Math.floor((date.getDate() * 1.5) % 27)],
            },
            {
              k: isTe ? 'నిత్య యోగం' : 'Yoga',
              v: TeluguPdfReportGenerator.yogasTelugu[p.yogaIndex % 27],
            },
            {
              k: isTe ? 'కరణం' : 'Karana',
              v: TeluguPdfReportGenerator.karanasTelugu[p.karana] || p.karana,
            },
            {
              k: isTe ? 'వారం' : 'Weekday',
              v: TeluguPdfReportGenerator.weekdaysTelugu[date.getDay() % 7],
            },
          ].map((row, i) => (
            <View key={i} style={[styles.tableRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.tableKey, { color: textSecondary }]}>{row.k}:</Text>
              <Text style={[styles.tableVal, { color: textPrimary, fontWeight: '700' }]}>{row.v}</Text>
            </View>
          ))}
        </View>

        {/* Solar Times */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor, marginTop: 12 }]}>
          <Text style={[styles.cardHeader, { color: AppColors.maroon }]}>
            {isTe ? 'సూర్యోదయ & ముహూర్త కాలములు' : 'Solar & Muhurtha Timings'}
          </Text>

          {[
            { k: 'సూర్యోదయం (Sunrise)', v: TeluguPdfReportGenerator.formatTime(p.sunrise) },
            { k: 'సూర్యాస్తమయం (Sunset)', v: TeluguPdfReportGenerator.formatTime(p.sunset) },
            { k: 'అభిజిత్ ముహూర్తం (శుభ సమయం)', v: `${TeluguPdfReportGenerator.formatTime(p.abhijitMuhurtha[0])} - ${TeluguPdfReportGenerator.formatTime(p.abhijitMuhurtha[1])}` },
            { k: 'రాహు కాలం (వర్జ్యం)', v: `${TeluguPdfReportGenerator.formatTime(p.rahuKalam[0])} - ${TeluguPdfReportGenerator.formatTime(p.rahuKalam[1])}` },
            { k: 'యమగండం', v: `${TeluguPdfReportGenerator.formatTime(p.yamagandam[0])} - ${TeluguPdfReportGenerator.formatTime(p.yamagandam[1])}` },
            { k: 'గుళిక కాలం', v: `${TeluguPdfReportGenerator.formatTime(p.gulika[0])} - ${TeluguPdfReportGenerator.formatTime(p.gulika[1])}` },
          ].map((row, i) => (
            <View key={i} style={[styles.tableRow, { borderBottomColor: borderColor }]}>
              <Text style={[styles.tableKey, { color: textSecondary }]}>{row.k}:</Text>
              <Text style={[styles.tableVal, { color: row.k.includes('అభిజిత్') ? '#166534' : row.k.includes('రాహు') ? '#DC2626' : textPrimary, fontWeight: '700' }]}>
                {row.v}
              </Text>
            </View>
          ))}
        </View>
      </ScrollView>

      {/* City Search Modal */}
      <Modal visible={cityModal} animationType="slide" transparent>
        <SafeAreaView style={[styles.modalOverlay, { backgroundColor: isDark ? 'rgba(0,0,0,0.85)' : 'rgba(0,0,0,0.5)' }]}>
          <View style={[styles.modalBox, { backgroundColor: cardBg, borderColor }]}>
            <View style={styles.modalHeader}>
              <Text style={[styles.modalTitle, { color: textPrimary }]}>నగరాన్ని ఎంచుకోండి</Text>
              <TouchableOpacity onPress={() => setCityModal(false)}>
                <Text style={{ fontSize: 18, color: gold }}>✕</Text>
              </TouchableOpacity>
            </View>

            <TextInput
              style={[styles.input, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9', marginVertical: 10 }]}
              placeholder="నగర పేరు నమోదు చేయండి..."
              placeholderTextColor="#888"
              value={searchQuery}
              onChangeText={handleSearch}
              autoFocus
            />

            <FlatList
              data={searchResults}
              keyExtractor={item => `${item.name}-${item.latitude}`}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={[styles.cityItem, { borderBottomColor: borderColor }]}
                  onPress={() => {
                    setCity(item);
                    setCityModal(false);
                  }}
                >
                  <Text style={[styles.cityName, { color: textPrimary }]}>{item.name}</Text>
                  <Text style={[styles.cityDetails, { color: textSecondary }]}>
                    {item.state} ({item.latitude}°N, {item.longitude}°E)
                  </Text>
                </TouchableOpacity>
              )}
            />
          </View>
        </SafeAreaView>
      </Modal>
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
  cityBtn: {
    paddingVertical: 4,
    paddingHorizontal: 8,
  },
  cityBtnText: {
    fontSize: 12,
    fontWeight: '700',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  dateRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 10,
    borderRadius: 10,
    borderWidth: 1,
    marginBottom: 12,
  },
  navBtn: {
    padding: 8,
  },
  dateCenter: {
    alignItems: 'center',
  },
  dateText: {
    fontSize: 15,
    fontWeight: '800',
  },
  dayText: {
    fontSize: 12,
    marginTop: 2,
    fontWeight: '600',
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
  tableRow: {
    flexDirection: 'row',
    paddingVertical: 6,
    borderBottomWidth: 0.5,
  },
  tableKey: {
    width: 160,
    fontSize: 12,
    fontWeight: '600',
  },
  tableVal: {
    flex: 1,
    fontSize: 12,
  },
  modalOverlay: {
    flex: 1,
    justifyContent: 'center',
    padding: 16,
  },
  modalBox: {
    borderRadius: 12,
    borderWidth: 1,
    padding: 16,
    maxHeight: '80%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  modalTitle: {
    fontSize: 15,
    fontWeight: '800',
  },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 8,
    fontSize: 13,
  },
  cityItem: {
    paddingVertical: 10,
    borderBottomWidth: 0.5,
  },
  cityName: {
    fontSize: 13,
    fontWeight: '700',
  },
  cityDetails: {
    fontSize: 11,
    marginTop: 2,
  },
});

