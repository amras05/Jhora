import React from 'react';
import {
  StyleSheet,
  View,
  Text,
  TextInput,
  TextInputProps,
  TouchableOpacity,
  ViewStyle,
} from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { radius } from '../../theme/tokens';

interface ThemedTextInputProps extends TextInputProps {
  label?: string;
  error?: string;
  hint?: string;
  containerStyle?: ViewStyle;
  onClear?: () => void;
  rightElement?: React.ReactNode;
}

export const ThemedTextInput: React.FC<ThemedTextInputProps> = ({
  label,
  error,
  hint,
  containerStyle,
  onClear,
  rightElement,
  value,
  style,
  ...inputProps
}) => {
  const { colors } = useTheme();

  return (
    <View style={[styles.container, containerStyle]}>
      {label ? (
        <Text style={[styles.label, { color: colors.textSecondary }]}>{label}</Text>
      ) : null}

      <View
        style={[
          styles.inputWrapper,
          {
            backgroundColor: colors.inputBg,
            borderColor: error ? colors.error : colors.border,
          },
        ]}
      >
        <TextInput
          style={[styles.input, { color: colors.text }, style]}
          placeholderTextColor={colors.textSecondary}
          value={value}
          {...inputProps}
        />

        {value && onClear ? (
          <TouchableOpacity
            style={styles.clearBtn}
            onPress={onClear}
            accessibilityRole="button"
            accessibilityLabel="Clear text"
          >
            <Text style={[styles.clearText, { color: colors.textSecondary }]}>✕</Text>
          </TouchableOpacity>
        ) : null}

        {rightElement}
      </View>

      {error ? (
        <Text style={[styles.errorText, { color: colors.error }]}>{error}</Text>
      ) : hint ? (
        <Text style={[styles.hintText, { color: colors.textSecondary }]}>{hint}</Text>
      ) : null}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: 6,
  },
  label: {
    fontSize: 13,
    fontWeight: '600',
    marginBottom: 6,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: radius.md,
    borderWidth: 1,
    minHeight: 46,
    paddingHorizontal: 12,
  },
  input: {
    flex: 1,
    fontSize: 15,
    paddingVertical: 10,
  },
  clearBtn: {
    padding: 6,
    justifyContent: 'center',
    alignItems: 'center',
  },
  clearText: {
    fontSize: 14,
    fontWeight: '700',
  },
  errorText: {
    fontSize: 11,
    marginTop: 4,
    fontWeight: '500',
  },
  hintText: {
    fontSize: 11,
    marginTop: 4,
  },
});

