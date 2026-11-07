import React from 'react';
import {
  StyleSheet,
  TouchableOpacity,
  Text,
  ActivityIndicator,
  ViewStyle,
  TextStyle,
  View,
  StyleProp,
} from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { radius, elevation } from '../../theme/tokens';

interface PrimaryButtonProps {
  title: string;
  onPress: () => void;
  loading?: boolean;
  disabled?: boolean;
  icon?: string;
  variant?: 'primary' | 'secondary' | 'gold' | 'outline';
  style?: StyleProp<ViewStyle>;
  textStyle?: StyleProp<TextStyle>;
}

export const PrimaryButton: React.FC<PrimaryButtonProps> = ({
  title,
  onPress,
  loading = false,
  disabled = false,
  icon,
  variant = 'primary',
  style,
  textStyle,
}) => {
  const { colors, isDark } = useTheme();

  const getStyle = (): { btn: ViewStyle; txt: TextStyle } => {
    if (disabled) {
      return {
        btn: {
          backgroundColor: colors.inputBg,
          borderColor: colors.border,
          borderWidth: 1,
        },
        txt: { color: colors.textSecondary },
      };
    }

    switch (variant) {
      case 'gold':
        return {
          btn: {
            backgroundColor: colors.gold,
            borderColor: colors.goldDark,
            borderWidth: 1,
            ...elevation.sm,
          },
          txt: { color: '#000000', fontWeight: '700' },
        };
      case 'secondary':
        return {
          btn: {
            backgroundColor: colors.surface,
            borderColor: colors.border,
            borderWidth: 1,
          },
          txt: { color: colors.text, fontWeight: '600' },
        };
      case 'outline':
        return {
          btn: {
            backgroundColor: 'transparent',
            borderColor: colors.primary,
            borderWidth: 1.5,
          },
          txt: { color: colors.primary, fontWeight: '700' },
        };
      case 'primary':
      default:
        return {
          btn: {
            backgroundColor: colors.primary,
            borderColor: colors.primaryDark,
            borderWidth: 1,
            ...(isDark
              ? { shadowColor: '#000', shadowOpacity: 0.4, shadowRadius: 6, elevation: 3 }
              : elevation.md),
          },
          txt: { color: '#FFFFFF', fontWeight: '700' },
        };
    }
  };

  const btnTheme = getStyle();

  return (
    <TouchableOpacity
      style={[styles.button, btnTheme.btn, style]}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.8}
      accessibilityRole="button"
    >
      {loading ? (
        <ActivityIndicator
          size="small"
          color={variant === 'secondary' || variant === 'outline' ? colors.primary : '#FFFFFF'}
        />
      ) : (
        <View style={styles.content}>
          {icon ? <Text style={[styles.icon, btnTheme.txt]}>{icon} </Text> : null}
          <Text style={[styles.text, btnTheme.txt, textStyle]}>{title}</Text>
        </View>
      )}
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    height: 50,
    borderRadius: radius.md,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
    marginVertical: 8,
  },
  content: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  icon: {
    fontSize: 18,
    marginRight: 6,
  },
  text: {
    fontSize: 16,
  },
});
