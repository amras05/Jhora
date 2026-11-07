import React from 'react';
import { StyleSheet, View, TouchableOpacity, ViewStyle, StyleProp } from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { radius, elevation } from '../../theme/tokens';

interface CardProps {
  children: React.ReactNode;
  onPress?: () => void;
  style?: StyleProp<ViewStyle>;
  variant?: 'elevated' | 'outlined' | 'flat';
  activeOpacity?: number;
}

export const Card: React.FC<CardProps> = ({
  children,
  onPress,
  style,
  variant = 'elevated',
  activeOpacity = 0.75,
}) => {
  const { colors, isDark } = useTheme();

  const variantStyle: ViewStyle = {
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderWidth: variant === 'outlined' ? 1 : StyleSheet.hairlineWidth,
    ...(variant === 'elevated'
      ? isDark
        ? { shadowColor: '#000', shadowOpacity: 0.3, shadowRadius: 4, elevation: 2 }
        : elevation.sm
      : {}),
  };

  if (onPress) {
    return (
      <TouchableOpacity
        style={[styles.card, variantStyle, style]}
        onPress={onPress}
        activeOpacity={activeOpacity}
      >
        {children}
      </TouchableOpacity>
    );
  }

  return <View style={[styles.card, variantStyle, style]}>{children}</View>;
};

const styles = StyleSheet.create({
  card: {
    borderRadius: radius.md,
    padding: 14,
    marginVertical: 6,
  },
});
