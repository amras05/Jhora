import React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, Platform } from 'react-native';
import { useNavigation, TabType } from './NavigationContext';
import { useTheme } from '../context/ThemeContext';
import { useI18n } from '../i18n';
import { radius, spacing } from '../theme/tokens';

interface TabItem {
  id: TabType;
  icon: string;
  labelTe: string;
  labelEn: string;
}

const TABS: TabItem[] = [
  { id: 'home', icon: '🏛️', labelTe: 'హోమ్', labelEn: 'Home' },
  { id: 'panchanga', icon: '📅', labelTe: 'పంచాంగం', labelEn: 'Panchangam' },
  { id: 'prasna', icon: '🔮', labelTe: 'ప్రశ్న', labelEn: 'Prasna' },
  { id: 'saved', icon: '📑', labelTe: 'సేవ్ చేసినవి', labelEn: 'Saved' },
];

export const BottomNavBar: React.FC = () => {
  const { currentTab, switchTab, currentScreen } = useNavigation();
  const { colors, isDark } = useTheme();
  const { isTe } = useI18n();

  // Hide bottom tab bar on full-screen detail views if preferred
  const isFullScreenDetail = currentScreen === 'pdf_report';
  if (isFullScreenDetail) {
    return null;
  }

  return (
    <View
      style={[
        styles.container,
        {
          backgroundColor: colors.surface,
          borderTopColor: colors.border,
          shadowColor: isDark ? '#000' : colors.primary,
        },
      ]}
    >
      <View style={styles.tabsRow}>
        {TABS.map(tab => {
          const isActive = currentTab === tab.id && (currentScreen === tab.id || currentScreen === 'home');
          const label = isTe ? tab.labelTe : tab.labelEn;

          return (
            <TouchableOpacity
              key={tab.id}
              style={[
                styles.tabBtn,
                isActive && [
                  styles.tabBtnActive,
                  {
                    backgroundColor: isDark ? 'rgba(212, 175, 55, 0.15)' : 'rgba(107, 17, 17, 0.08)',
                  },
                ],
              ]}
              onPress={() => switchTab(tab.id)}
              activeOpacity={0.7}
              accessibilityRole="tab"
              accessibilityState={{ selected: isActive }}
              accessibilityLabel={label}
            >
              <Text style={[styles.tabIcon, isActive && styles.tabIconActive]}>
                {tab.icon}
              </Text>
              <Text
                style={[
                  styles.tabLabel,
                  { color: isActive ? (isDark ? colors.gold : colors.primary) : colors.textSecondary },
                  isActive && styles.tabLabelActive,
                ]}
                numberOfLines={1}
              >
                {label}
              </Text>
              {isActive && (
                <View
                  style={[
                    styles.activeIndicator,
                    { backgroundColor: isDark ? colors.gold : colors.primary },
                  ]}
                />
              )}
            </TouchableOpacity>
          );
        })}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    height: Platform.OS === 'ios' ? 78 : 62,
    borderTopWidth: StyleSheet.hairlineWidth,
    paddingBottom: Platform.OS === 'ios' ? 20 : 6,
    paddingTop: 6,
    paddingHorizontal: 8,
    shadowOffset: { width: 0, height: -3 },
    shadowOpacity: 0.08,
    shadowRadius: 6,
    elevation: 8,
  },
  tabsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    height: '100%',
  },
  tabBtn: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 4,
    paddingHorizontal: 6,
    borderRadius: radius.md,
    position: 'relative',
  },
  tabBtnActive: {
    paddingVertical: 5,
  },
  tabIcon: {
    fontSize: 20,
    marginBottom: 2,
  },
  tabIconActive: {
    transform: [{ scale: 1.1 }],
  },
  tabLabel: {
    fontSize: 11,
    fontWeight: '500',
  },
  tabLabelActive: {
    fontWeight: '700',
  },
  activeIndicator: {
    position: 'absolute',
    top: 0,
    width: 24,
    height: 2.5,
    borderRadius: 2,
  },
});

