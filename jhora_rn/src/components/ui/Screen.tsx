import React from 'react';
import { StyleSheet, View, ViewStyle, Platform, StatusBar as RNStatusBar, StyleProp } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { useTheme } from '../../context/ThemeContext';

interface ScreenProps {
  children: React.ReactNode;
  style?: StyleProp<ViewStyle>;
  padded?: boolean;
}

export const Screen: React.FC<ScreenProps> = ({ children, style, padded = false }) => {
  const { colors, isDark } = useTheme();

  return (
    <View
      style={[
        styles.container,
        {
          backgroundColor: colors.background,
          paddingTop: Platform.OS === 'android' ? (RNStatusBar.currentHeight || 28) : 0,
        },
        padded && styles.padded,
        style,
      ]}
    >
      <StatusBar style={isDark ? 'light' : 'dark'} />
      {children}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  padded: {
    paddingHorizontal: 16,
  },
});
