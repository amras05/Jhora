import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  TextInput,
  TouchableOpacity,
  SafeAreaView,
  Alert,
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import { SavedHoroscopeService } from '../services/savedHoroscopeService';
import { BirthData } from '../models/astroModels';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';

interface Props {
  isDark: boolean;
  lang: 'te' | 'en';
  onBack: () => void;
  onSelectProfile: (data: BirthData) => void;
  onAddNew: () => void;
}

export const SavedHoroscopesScreen: React.FC<Props> = ({
  isDark,
  lang,
  onBack,
  onSelectProfile,
  onAddNew,
}) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const [profiles, setProfiles] = useState<BirthData[]>([]);
  const [search, setSearch] = useState('');

  useEffect(() => {
    loadProfiles();
  }, []);

  const loadProfiles = async () => {
    const list = await SavedHoroscopeService.load();
    setProfiles(list);
  };

  const handleDelete = (name: string) => {
    Alert.alert(
      isTe ? 'జాతకం తొలగింపు' : 'Delete Horoscope',
      isTe ? `నిజంగా "${name}" జాతకాన్ని తొలగించాలనుకుంటున్నారా?` : `Are you sure you want to delete "${name}"?`,
      [
        { text: isTe ? 'రద్దు' : 'Cancel', style: 'cancel' },
        {
          text: isTe ? 'తొలగించు' : 'Delete',
          style: 'destructive',
          onPress: async () => {
            await SavedHoroscopeService.delete(name);
            loadProfiles();
          },
        },
      ]
    );
  };

  const filtered = profiles.filter(p =>
    p.name.toLowerCase().includes(search.toLowerCase()) ||
    p.placeName.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      {/* Top Header */}
      <View style={[styles.appBar, { borderColor, backgroundColor: cardBg }]}>
        <TouchableOpacity onPress={onBack} style={styles.backBtn}>
          <Text style={[styles.backIcon, { color: gold }]}>‹</Text>
        </TouchableOpacity>
        <Text style={[styles.appBarTitle, { color: textPrimary }]}>
          {isTe ? 'భద్రపరచిన జాతకాలు (Saved)' : 'Saved Horoscopes'}
        </Text>
        <TouchableOpacity onPress={onAddNew} style={styles.addBtn}>
          <Text style={{ fontSize: 20, color: gold }}>＋</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.content}>
        {/* Search Bar */}
        <TextInput
          style={[styles.searchInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
          placeholder={isTe ? 'పేరు లేదా నగరంతో వెతకండి...' : 'Search by name or place...'}
          placeholderTextColor="#888"
          value={search}
          onChangeText={setSearch}
        />

        {filtered.length === 0 ? (
          <View style={styles.emptyBox}>
            <Text style={{ fontSize: 36, marginBottom: 10 }}>📑</Text>
            <Text style={[styles.emptyText, { color: textSecondary }]}>
              {isTe ? 'ఎటువంటి భద్రపరచిన జాతకాలు లేవు.' : 'No saved horoscopes found.'}
            </Text>
            <TouchableOpacity style={[styles.addNewBtn, { backgroundColor: gold }]} onPress={onAddNew}>
              <Text style={styles.addNewBtnText}>{isTe ? 'కొత్త జాతకం నమోదు చేయండి' : 'Create New Chart'}</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <FlatList
            data={filtered}
            keyExtractor={item => `${item.name}-${item.dateTime.getTime()}`}
            renderItem={({ item }) => (
              <TouchableOpacity
                style={[styles.profileCard, { backgroundColor: cardBg, borderColor }]}
                onPress={() => onSelectProfile(item)}
                activeOpacity={0.8}
              >
                <View style={styles.profileLeft}>
                  <Text style={[styles.profileName, { color: textPrimary }]}>{item.name}</Text>
                  <Text style={[styles.profileDetails, { color: textSecondary }]}>
                    {TeluguPdfReportGenerator.formatDate(item.dateTime)} • {TeluguPdfReportGenerator.formatTime(item.dateTime)}
                  </Text>
                  <Text style={[styles.profilePlace, { color: gold }]}>📍 {item.placeName}</Text>
                </View>

                <TouchableOpacity onPress={() => handleDelete(item.name)} style={styles.deleteBtn}>
                  <Text style={{ fontSize: 16 }}>🗑️</Text>
                </TouchableOpacity>
              </TouchableOpacity>
            )}
          />
        )}
      </View>
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
  addBtn: {
    padding: 4,
  },
  content: {
    flex: 1,
    padding: 16,
  },
  searchInput: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 8,
    fontSize: 13,
    marginBottom: 12,
  },
  emptyBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 30,
  },
  emptyText: {
    fontSize: 13,
    textAlign: 'center',
  },
  addNewBtn: {
    marginTop: 16,
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 8,
  },
  addNewBtnText: {
    color: '#000',
    fontWeight: '800',
    fontSize: 12.5,
  },
  profileCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 12,
    borderRadius: 10,
    borderWidth: 1,
    marginBottom: 10,
  },
  profileLeft: {
    flex: 1,
  },
  profileName: {
    fontSize: 14,
    fontWeight: '800',
  },
  profileDetails: {
    fontSize: 11,
    marginTop: 2,
  },
  profilePlace: {
    fontSize: 11,
    marginTop: 2,
    fontWeight: '600',
  },
  deleteBtn: {
    padding: 8,
  },
});

