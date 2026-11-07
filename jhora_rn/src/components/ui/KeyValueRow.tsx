import React from 'react';
import { StyleSheet, View, Text, ViewStyle, TextStyle } from 'react-native';
import { useTheme } from '../../context/ThemeContext';

interface KeyValueRowProps {
  label: string;
  value: string | number | React.ReactNode;
  icon?: string;
  subValue?: string;
  valueColor?: string;
  style?: ViewStyle;
  labelStyle?: TextStyle;
  valueStyle?: TextStyle;
  borderBottom?: boolean;
}

export const KeyValueRow: React.FC<KeyValueRowProps> = ({
  label,
  value,
  icon,
  subValue,
  valueColor,
  style,
  labelStyle,
  valueStyle,
  borderBottom = true,
}) => {
  const { colors } = useTheme();

  return (
    <View
      style={[
        styles.row,
        borderBottom && { borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: colors.border },
        style,
      ]}
    >
      <View style={styles.left}>
        {icon ? <Text style={styles.icon}>{icon}</Text> : null}
        <Text style={[styles.label, { color: colors.textSecondary }, labelStyle]}>
          {label}
        </Text>
      </View>

      <View style={styles.right}>
        {typeof value === 'string' || typeof value === 'number' ? (
          <Text
            style={[
              styles.value,
              { color: valueColor || colors.text },
              valueStyle,
            ]}
          >
            {value}
          </Text>
        ) : (
          value
        )}
        {subValue ? (
          <Text style={[styles.subValue, { color: colors.textSecondary }]}>
            {subValue}
          </Text>
        ) : null}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 10,
  },
  left: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
    marginRight: 12,
  },
  icon: {
    fontSize: 16,
    marginRight: 8,
  },
  label: {
    fontSize: 13,
    fontWeight: '500',
  },
  right: {
    alignItems: 'flex-end',
  },
  value: {
    fontSize: 14,
    fontWeight: '600',
  },
  subValue: {
    fontSize: 11,
    marginTop: 2,
  },
});

