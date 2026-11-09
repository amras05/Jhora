/**
 * Copyright (C) 2024-2026 Karrthikeya Sarma (SBJV Hora Team)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

import React, { useState } from 'react';
import { StyleSheet, Text, TextInput, TouchableOpacity, View, ActivityIndicator } from 'react-native';
import { CityEntry } from '../services/cityDatabase';
import { PlaceSearchStatus } from '../hooks/usePlaceSearch';

export interface PlaceFormColors {
  text: string;
  textSecondary: string;
  border: string;
  inputBg: string;
  gold: string;
  button: string;
}

interface Props {
  lang: 'te' | 'en';
  colors: PlaceFormColors;
  /** Pre-filled values, e.g. from an online result whose timezone must be confirmed */
  initial?: Partial<CityEntry>;
  /** Show the "please confirm the time zone" warning */
  confirmTimezone?: boolean;
  onSubmit: (place: CityEntry) => void;
  onCancel: () => void;
}

export const ManualPlaceForm: React.FC<Props> = ({ lang, colors, initial, confirmTimezone, onSubmit, onCancel }) => {
  const isTe = lang === 'te';
  const [name, setName] = useState(initial?.name ?? '');
  const [lat, setLat] = useState(initial?.latitude !== undefined ? String(initial.latitude) : '');
  const [lon, setLon] = useState(initial?.longitude !== undefined ? String(initial.longitude) : '');
  const [tz, setTz] = useState(initial?.timezone !== undefined ? String(initial.timezone) : '5.5');
  const [error, setError] = useState('');

  const handleSave = () => {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lon);
    const timezone = parseFloat(tz);

    if (!name.trim()) {
      setError(isTe ? 'ప్రదేశం పేరు నమోదు చేయండి.' : 'Enter a place name.');
      return;
    }
    if (!isFinite(latitude) || latitude < -90 || latitude > 90) {
      setError(isTe ? 'అక్షాంశం -90 నుండి 90 మధ్య ఉండాలి (దక్షిణం అయితే -).' : 'Latitude must be between -90 and 90 (negative for South).');
      return;
    }
    if (!isFinite(longitude) || longitude < -180 || longitude > 180) {
      setError(isTe ? 'రేఖాంశం -180 నుండి 180 మధ్య ఉండాలి (పడమర అయితే -).' : 'Longitude must be between -180 and 180 (negative for West).');
      return;
    }
    if (!isFinite(timezone) || timezone < -12 || timezone > 14) {
      setError(isTe ? 'టైమ్ జోన్ -12 నుండి +14 గంటల మధ్య ఉండాలి (భారత్ = 5.5).' : 'Time zone must be between -12 and +14 hours (India = 5.5).');
      return;
    }

    setError('');
    onSubmit({
      name: name.trim(),
      state: initial?.state ?? '',
      country: initial?.country ?? '',
      latitude,
      longitude,
      timezone,
      aliases: [],
    });
  };

  const inputStyle = [styles.input, { borderColor: colors.border, color: colors.text, backgroundColor: colors.inputBg }];

  return (
    <View style={styles.container}>
      <Text style={[styles.title, { color: colors.text }]}>
        {isTe ? 'ప్రదేశాన్ని నేరుగా నమోదు చేయండి' : 'Enter place manually'}
      </Text>
      <Text style={[styles.helper, { color: colors.textSecondary }]}>
        {isTe
          ? 'అక్షాంశ/రేఖాంశాలను Google Maps లో ప్రదేశంపై నొక్కి పొందవచ్చు.'
          : 'You can get latitude/longitude by long-pressing the place in a maps app.'}
      </Text>

      {confirmTimezone && (
        <Text style={[styles.warning, { color: colors.gold }]}>
          {isTe
            ? '⚠ ఈ దేశానికి టైమ్ జోన్ అంచనా మాత్రమే. పుట్టిన తేదీ నాటి సరైన UTC తేడాను (వేసవి సమయంతో సహా) సరిచూడండి.'
            : '⚠ Time zone is only an estimate for this country. Confirm the correct UTC offset on the birth date (including daylight saving).'}
        </Text>
      )}

      <Text style={[styles.label, { color: colors.textSecondary }]}>{isTe ? 'ప్రదేశం పేరు' : 'Place name'}</Text>
      <TextInput style={inputStyle} value={name} onChangeText={setName} placeholder={isTe ? 'ఉదా: ఆకివీడు' : 'e.g. Akividu'} placeholderTextColor="#888" />

      <View style={styles.row}>
        <View style={styles.col}>
          <Text style={[styles.label, { color: colors.textSecondary }]}>{isTe ? 'అక్షాంశం (N +)' : 'Latitude (N +)'}</Text>
          <TextInput style={inputStyle} value={lat} onChangeText={setLat} keyboardType="numbers-and-punctuation" placeholder="16.5823" placeholderTextColor="#888" />
        </View>
        <View style={styles.col}>
          <Text style={[styles.label, { color: colors.textSecondary }]}>{isTe ? 'రేఖాంశం (E +)' : 'Longitude (E +)'}</Text>
          <TextInput style={inputStyle} value={lon} onChangeText={setLon} keyboardType="numbers-and-punctuation" placeholder="81.3811" placeholderTextColor="#888" />
        </View>
      </View>

      <Text style={[styles.label, { color: colors.textSecondary }]}>{isTe ? 'టైమ్ జోన్ (UTC నుండి గంటలు)' : 'Time zone (hours from UTC)'}</Text>
      <TextInput style={inputStyle} value={tz} onChangeText={setTz} keyboardType="numbers-and-punctuation" placeholder="5.5" placeholderTextColor="#888" />

      {!!error && <Text style={styles.error}>{error}</Text>}

      <View style={styles.row}>
        <TouchableOpacity style={[styles.btn, { borderColor: colors.border, borderWidth: 1 }]} onPress={onCancel} accessibilityRole="button">
          <Text style={[styles.btnText, { color: colors.text }]}>{isTe ? 'వెనుకకు' : 'Back'}</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.btn, { backgroundColor: colors.button }]} onPress={handleSave} accessibilityRole="button">
          <Text style={[styles.btnText, { color: '#FFFFFF' }]}>{isTe ? 'ఈ ప్రదేశం వాడండి' : 'Use this place'}</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

interface StatusProps {
  lang: 'te' | 'en';
  status: PlaceSearchStatus;
  hasQuery: boolean;
  colors: PlaceFormColors;
  onManualEntry: () => void;
}

/** Status line under the search box plus the "enter manually" link. */
export const PlaceSearchStatusBar: React.FC<StatusProps> = ({ lang, status, hasQuery, colors, onManualEntry }) => {
  const isTe = lang === 'te';
  let message = '';
  if (status === 'loading') message = isTe ? 'గ్రామాలు/పట్టణాలు ఆన్‌లైన్‌లో వెతుకుతోంది…' : 'Searching villages & towns online…';
  else if (status === 'error') message = isTe ? 'ఆన్‌లైన్ శోధన విఫలమైంది. ఇంటర్నెట్ సరిచూడండి లేదా నేరుగా నమోదు చేయండి.' : 'Online search failed. Check internet or enter the place manually.';
  else if (!hasQuery) message = isTe ? 'కనీసం 3 అక్షరాలు టైప్ చేస్తే గ్రామాలు కూడా వస్తాయి.' : 'Type at least 3 letters to also search villages.';

  return (
    <View style={styles.statusBar}>
      {status === 'loading' && <ActivityIndicator size="small" color={colors.gold} />}
      {!!message && (
        <Text style={[styles.statusText, { color: status === 'error' ? '#C62828' : colors.textSecondary }]}>{message}</Text>
      )}
      <TouchableOpacity onPress={onManualEntry} accessibilityRole="button" style={styles.manualLink}>
        <Text style={[styles.manualLinkText, { color: colors.gold }]}>
          {isTe ? '✎ నేరుగా నమోదు' : '✎ Enter manually'}
        </Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { gap: 6, paddingVertical: 6 },
  title: { fontSize: 15, fontWeight: '800' },
  helper: { fontSize: 11 },
  warning: { fontSize: 11.5, fontWeight: '700' },
  label: { fontSize: 11, fontWeight: '700', marginTop: 4 },
  input: { borderWidth: 1, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8, fontSize: 14 },
  row: { flexDirection: 'row', gap: 10, marginTop: 6 },
  col: { flex: 1 },
  error: { color: '#C62828', fontSize: 12, fontWeight: '600' },
  btn: { flex: 1, borderRadius: 8, paddingVertical: 10, alignItems: 'center' },
  btnText: { fontSize: 13, fontWeight: '800' },
  statusBar: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 6, flexWrap: 'wrap' },
  statusText: { fontSize: 11, flex: 1 },
  manualLink: { paddingVertical: 4, marginLeft: 'auto' },
  manualLinkText: { fontSize: 12, fontWeight: '800' },
});
