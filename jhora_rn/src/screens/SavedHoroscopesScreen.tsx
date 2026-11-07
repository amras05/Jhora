import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  Text,
  View,
  FlatList,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { Screen, AppBar, Card, ThemedTextInput, EmptyState } from '../components/ui';
import { radius, spacing } from '../theme/tokens';
import { SavedHoroscopeService } from '../services/savedHoroscopeService';
import { BirthData } from '../models/astroModels';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';

interface Props {
  onBack: () => void;
  onSelectProfile: (data: BirthData) => void;
  onAddNew: () => void;
  // Optional for backward compatibility with App.tsx
  isDark?: boolean;
  lang?: 'te' | 'en';
}

export const SavedHoroscopesScreen: React.FC<Props> = ({
  onBack,
  onSelectProfile,
  onAddNew,
}) => {
  const { colors } = useTheme();
  const { t } = useI18n();

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
      t('saved.deleteAlertTitle'),
      t('saved.deleteAlertMsg', { name }),
      [
        { text: t('common.cancel'), style: 'cancel' },
        {
          text: t('common.delete'),
          style: 'destructive',
          onPress: async () => {
            await SavedHoroscopeService.delete(name);
            loadProfiles();
          },
        },
      ]
    );
  };

  const filtered = profiles.filter(
    p =>
      p.name.toLowerCase().includes(search.toLowerCase()) ||
      p.placeName.toLowerCase().includes(search.toLowerCase())
  );

  const getInitials = (name: string) => {
    const clean = name.trim();
    if (!clean) return '★';
    return clean.charAt(0);
  };

  return (
    <Screen style={styles.container}>
      <AppBar
        title={t('saved.appBarTitle')}
        onBack={onBack}
        rightAction={
          <TouchableOpacity
            onPress={onAddNew}
            style={[styles.addBtn, { backgroundColor: colors.inputBg, borderColor: colors.border }]}
            accessibilityRole="button"
            accessibilityLabel="Add new horoscope"
          >
            <Text style={[styles.addIcon, { color: colors.gold }]}>＋</Text>
          </TouchableOpacity>
        }
      />

      <View style={styles.content}>
        {/* Search Bar */}
        <ThemedTextInput
          placeholder={t('saved.searchPlaceholder')}
          value={search}
          onChangeText={setSearch}
          onClear={() => setSearch('')}
          containerStyle={styles.searchContainer}
        />

        {filtered.length === 0 ? (
          <EmptyState
            icon="📑"
            title={t('saved.emptyText')}
            actionTitle={t('saved.addNewButton')}
            onAction={onAddNew}
          />
        ) : (
          <FlatList
            data={filtered}
            keyExtractor={item => `${item.name}-${item.dateTime.getTime()}`}
            contentContainerStyle={styles.listContent}
            renderItem={({ item }) => (
              <Card
                onPress={() => onSelectProfile(item)}
                style={styles.profileCard}
              >
                <View style={styles.cardRow}>
                  {/* Avatar Initials */}
                  <View
                    style={[
                      styles.avatar,
                      {
                        backgroundColor: `${colors.gold}20`,
                        borderColor: colors.gold,
                      },
                    ]}
                  >
                    <Text style={[styles.avatarText, { color: colors.gold }]}>
                      {getInitials(item.name)}
                    </Text>
                  </View>

                  <View style={styles.profileLeft}>
                    <Text
                      style={[styles.profileName, { color: colors.text }]}
                      numberOfLines={1}
                    >
                      {item.name}
                    </Text>
                    <Text
                      style={[styles.profileDetails, { color: colors.textSecondary }]}
                    >
                      {TeluguPdfReportGenerator.formatDate(item.dateTime)} •{' '}
                      {TeluguPdfReportGenerator.formatTime(item.dateTime)}
                    </Text>
                    <Text
                      style={[styles.profilePlace, { color: colors.gold }]}
                      numberOfLines={1}
                    >
                      📍 {item.placeName}
                    </Text>
                  </View>

                  <TouchableOpacity
                    onPress={() => handleDelete(item.name)}
                    style={[styles.deleteBtn, { backgroundColor: colors.inputBg }]}
                    accessibilityRole="button"
                    accessibilityLabel="Delete"
                  >
                    <Text style={styles.deleteIcon}>🗑️</Text>
                  </TouchableOpacity>
                </View>
              </Card>
            )}
          />
        )}
      </View>
    </Screen>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.xs,
  },
  addBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  addIcon: {
    fontSize: 20,
    fontWeight: '700',
    lineHeight: 22,
  },
  searchContainer: {
    marginBottom: spacing.xs,
  },
  listContent: {
    paddingBottom: spacing.xxl,
  },
  profileCard: {
    marginVertical: spacing.xs,
    padding: spacing.md,
  },
  cardRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
  },
  avatarText: {
    fontSize: 18,
    fontWeight: '800',
  },
  profileLeft: {
    flex: 1,
    marginRight: spacing.sm,
  },
  profileName: {
    fontSize: 15,
    fontWeight: '800',
    marginBottom: 2,
  },
  profileDetails: {
    fontSize: 12,
    marginBottom: 2,
  },
  profilePlace: {
    fontSize: 12,
    fontWeight: '600',
  },
  deleteBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
  },
  deleteIcon: {
    fontSize: 15,
  },
});
