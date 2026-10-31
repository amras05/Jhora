import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Modal,
  FlatList,
  SafeAreaView,
  Alert,
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import { CityDatabase, CityEntry } from '../services/cityDatabase';
import { BirthData } from '../models/astroModels';

interface Props {
  isDark: boolean;
  lang: 'te' | 'en';
  onBack: () => void;
  onCalculate: (data: BirthData) => void;
}

const teluguMonths = [
  'జనవరి', 'ఫిబ్రవరి', 'మార్చి', 'ఏప్రిల్', 'మే', 'జూన్',
  'జూలై', 'ఆగస్టు', 'సెప్టెంబర్', 'అక్టోబర్', 'నవంబర్', 'డిసెంబర్'
];

const englishMonths = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

const weekDaysTelugu = ['ఆది', 'సోమ', 'మంగళ', 'బుధ', 'గురు', 'శుక్ర', 'శని'];
const weekDaysEnglish = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

export const BirthInputScreen: React.FC<Props> = ({
  isDark,
  lang,
  onBack,
  onCalculate,
}) => {
  const gold = AppColors.getGold(isDark);
  const bg = AppColors.getBg(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);

  const isTe = lang === 'te';

  // Form states
  const [name, setName] = useState('');
  const [day, setDay] = useState('15');
  const [month, setMonth] = useState('8');
  const [year, setYear] = useState('1990');

  // 12-Hour format states
  const [hour12, setHour12] = useState('10');
  const [minute, setMinute] = useState('30');
  const [second, setSecond] = useState('00');
  const [period, setPeriod] = useState<'AM' | 'PM'>('AM');

  const [gender, setGender] = useState<'Male' | 'Female'>('Male');

  // Calendar Modal state
  const [calendarModalVisible, setCalendarModalVisible] = useState(false);
  const [viewYear, setViewYear] = useState(1990);
  const [viewMonth, setViewMonth] = useState(7); // 0-indexed (August is 7)

  // Selected city
  const [selectedCity, setSelectedCity] = useState<CityEntry>(CityDatabase.cities[0]);
  const [citySearchModal, setCitySearchModal] = useState(false);
  const [cityQuery, setCityQuery] = useState('');
  const [searchResults, setSearchResults] = useState<CityEntry[]>(CityDatabase.cities.slice(0, 10));

  const openCalendar = () => {
    const y = parseInt(year, 10) || 1990;
    const m = (parseInt(month, 10) || 8) - 1;
    setViewYear(Math.min(2100, Math.max(1800, y)));
    setViewMonth(Math.min(11, Math.max(0, m)));
    setCalendarModalVisible(true);
  };

  const handlePrevMonth = () => {
    if (viewMonth === 0) {
      setViewMonth(11);
      setViewYear(prev => prev - 1);
    } else {
      setViewMonth(prev => prev - 1);
    }
  };

  const handleNextMonth = () => {
    if (viewMonth === 11) {
      setViewMonth(0);
      setViewYear(prev => prev + 1);
    } else {
      setViewMonth(prev => prev + 1);
    }
  };

  const handleYearJump = (delta: number) => {
    setViewYear(prev => Math.min(2100, Math.max(1800, prev + delta)));
  };

  const handleSelectDay = (selectedDay: number) => {
    setDay(String(selectedDay).padStart(2, '0'));
    setMonth(String(viewMonth + 1).padStart(2, '0'));
    setYear(String(viewYear));
  };

  const handleSearchCity = (text: string) => {
    setCityQuery(text);
    if (!text.trim()) {
      setSearchResults(CityDatabase.cities.slice(0, 10));
    } else {
      setSearchResults(CityDatabase.search(text));
    }
  };

  const handleSelectCity = (c: CityEntry) => {
    setSelectedCity(c);
    setCitySearchModal(false);
  };

  const handleSubmit = () => {
    const d = parseInt(day, 10);
    const m = parseInt(month, 10);
    const y = parseInt(year, 10);
    const h12 = parseInt(hour12, 10);
    const min = parseInt(minute, 10);
    const s = parseInt(second, 10);

    if (isNaN(d) || d < 1 || d > 31 || isNaN(m) || m < 1 || m > 12 || isNaN(y) || y < 1800 || y > 2100) {
      Alert.alert(
        isTe ? 'తేదీ సరిచూడండి' : 'Invalid Date',
        isTe ? 'దయచేసి సరైన పుట్టిన తేదీని నమోదు చేయండి (DD / MM / YYYY).' : 'Please enter a valid date.'
      );
      return;
    }

    if (isNaN(h12) || h12 < 1 || h12 > 12) {
      Alert.alert(
        isTe ? 'సమయం సరిచూడండి' : 'Invalid Hour',
        isTe ? 'దయచేసి 1 నుండి 12 మధ్య గంటలను (12-Hour) నమోదు చేయండి.' : 'Please enter hour between 1 and 12.'
      );
      return;
    }

    if (isNaN(min) || min < 0 || min > 59) {
      Alert.alert(
        isTe ? 'నిమిషాలు సరిచూడండి' : 'Invalid Minutes',
        isTe ? 'నిమిషాలు 0 నుండి 59 మధ్య ఉండాలి.' : 'Minutes must be between 0 and 59.'
      );
      return;
    }

    if (isNaN(s) || s < 0 || s > 59) {
      Alert.alert(
        isTe ? 'సెకన్లు సరిచూడండి' : 'Invalid Seconds',
        isTe ? 'సెకన్లు 0 నుండి 59 మధ్య ఉండాలి.' : 'Seconds must be between 0 and 59.'
      );
      return;
    }

    // Convert 12-hour format to 24-hour format
    let h24 = h12 % 12;
    if (period === 'PM') {
      h24 += 12;
    }

    const bDate = new Date(y, m - 1, d, h24, min || 0, s || 0);

    const birthData: BirthData = {
      name: name.trim() || (isTe ? 'శ్రీ / కుమారి' : 'Native'),
      dateTime: bDate,
      latitude: selectedCity.latitude,
      longitude: selectedCity.longitude,
      timezone: selectedCity.timezone,
      placeName: `${selectedCity.name}, ${selectedCity.state}`,
      gender: gender === 'Male' ? (isTe ? 'పురుషుడు' : 'Male') : (isTe ? 'స్త్రీ' : 'Female'),
    };

    onCalculate(birthData);
  };

  // Helper to format date display
  const parsedDay = parseInt(day, 10);
  const parsedMonth = parseInt(month, 10);
  const parsedYear = parseInt(year, 10);
  const monthName = !isNaN(parsedMonth) && parsedMonth >= 1 && parsedMonth <= 12
    ? (isTe ? teluguMonths[parsedMonth - 1] : englishMonths[parsedMonth - 1])
    : '';
  const dateFormattedPreview = `${parsedDay || 15} ${monthName} ${parsedYear || 1990}`;

  // Calendar calculation
  const firstDayOfWeek = new Date(viewYear, viewMonth, 1).getDay(); // 0 is Sunday (ఆదివారం)
  const daysInViewMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
  const calendarCells: Array<{ dayNum?: number; isCurrentSelection?: boolean }> = [];

  for (let i = 0; i < firstDayOfWeek; i++) {
    calendarCells.push({});
  }
  for (let d = 1; d <= daysInViewMonth; d++) {
    const isCurrent = d === parsedDay && viewMonth === parsedMonth - 1 && viewYear === parsedYear;
    calendarCells.push({ dayNum: d, isCurrentSelection: isCurrent });
  }
  // Pad trailing empty cells to complete the 7-day row
  const remainder = calendarCells.length % 7;
  if (remainder !== 0) {
    const trailingCount = 7 - remainder;
    for (let i = 0; i < trailingCount; i++) {
      calendarCells.push({});
    }
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: bg }]}>
      {/* Top Header */}
      <View style={[styles.appBar, { borderColor }]}>
        <TouchableOpacity onPress={onBack} style={styles.backBtn}>
          <Text style={[styles.backIcon, { color: gold }]}>‹</Text>
        </TouchableOpacity>
        <Text style={[styles.appBarTitle, { color: textPrimary }]}>
          {isTe ? 'జాతక వివరాల నమోదు' : 'Birth Details Input'}
        </Text>
        <View style={{ width: 30 }} />
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Name input */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.inputLabel, { color: textSecondary }]}>
            {isTe ? 'జాతకుని పేరు (Name):' : "Native's Name:"}
          </Text>
          <TextInput
            style={[styles.input, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
            placeholder={isTe ? 'పేరు నమోదు చేయండి' : 'Enter name'}
            placeholderTextColor="#888"
            value={name}
            onChangeText={setName}
          />
        </View>

        {/* Date of Birth - Calendar Picker Section */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
            <Text style={[styles.inputLabel, { color: textSecondary, marginBottom: 0 }]}>
              {isTe ? 'పుట్టిన తేదీ (Date of Birth - క్యాలెండర్):' : 'Date of Birth (Calendar):'}
            </Text>
            <TouchableOpacity onPress={openCalendar} style={[styles.openCalBadge, { borderColor: gold }]}>
              <Text style={{ fontSize: 11, fontWeight: '700', color: gold }}>
                📅 {isTe ? 'క్యాలెండర్ తెరవండి' : 'Open Calendar'}
              </Text>
            </TouchableOpacity>
          </View>

          {/* Interactive Calendar Button Card */}
          <TouchableOpacity
            style={[
              styles.calendarPreviewCard,
              { borderColor: gold, backgroundColor: isDark ? '#2A1608' : '#FFFBEB' },
            ]}
            onPress={openCalendar}
            activeOpacity={0.7}
          >
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
              <View style={[styles.calendarIconBox, { backgroundColor: AppColors.maroon }]}>
                <Text style={{ fontSize: 18, color: '#FFF' }}>📅</Text>
              </View>
              <View>
                <Text style={[styles.calendarDateMain, { color: AppColors.maroonLight }]}>
                  {dateFormattedPreview}
                </Text>
                <Text style={[styles.calendarDateSub, { color: textSecondary }]}>
                  {day.padStart(2, '0')} / {month.padStart(2, '0')} / {year} • {isTe ? 'క్యాలెండర్ నుండి మార్చడానికి నొక్కండి' : 'Tap to change date'}
                </Text>
              </View>
            </View>
            <Text style={{ fontSize: 16, color: gold, fontWeight: '800' }}>›</Text>
          </TouchableOpacity>

          {/* Direct typing fields */}
          <Text style={[styles.microLabel, { color: textSecondary, marginTop: 8 }]}>
            {isTe ? 'లేదా నేరుగా టైప్ చేయండి (DD / MM / YYYY):' : 'Or enter manually (DD / MM / YYYY):'}
          </Text>
          <View style={styles.row}>
            <TextInput
              style={[styles.input, styles.dateInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
              placeholder="DD"
              placeholderTextColor="#888"
              keyboardType="numeric"
              maxLength={2}
              value={day}
              onChangeText={setDay}
            />
            <TextInput
              style={[styles.input, styles.dateInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
              placeholder="MM"
              placeholderTextColor="#888"
              keyboardType="numeric"
              maxLength={2}
              value={month}
              onChangeText={setMonth}
            />
            <TextInput
              style={[styles.input, styles.yearInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
              placeholder="YYYY"
              placeholderTextColor="#888"
              keyboardType="numeric"
              maxLength={4}
              value={year}
              onChangeText={setYear}
            />
          </View>
        </View>

        {/* Time of Birth - 12-Hour Format */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
            <Text style={[styles.inputLabel, { color: textSecondary, marginBottom: 0 }]}>
              {isTe ? 'పుట్టిన సమయం (12-గంటల ఫార్మాట్ - 12-Hour Format):' : 'Time of Birth (12-Hour Format):'}
            </Text>
            <View style={[styles.timePreviewBadge, { backgroundColor: isDark ? '#2A1608' : '#FEF3C7', borderColor: gold }]}>
              <Text style={{ fontSize: 11, fontWeight: '800', color: gold }}>
                🕒 {hour12.padStart(2, '0')}:{minute.padStart(2, '0')}:{second.padStart(2, '0')} {period}
              </Text>
            </View>
          </View>

          <View style={styles.row}>
            {/* Hour 1-12 */}
            <View style={{ flex: 1 }}>
              <Text style={[styles.fieldSubHeader, { color: textSecondary }]}>
                {isTe ? 'గంటలు (1-12)' : 'Hour (1-12)'}
              </Text>
              <TextInput
                style={[styles.input, styles.timeInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
                placeholder="10"
                placeholderTextColor="#888"
                keyboardType="numeric"
                maxLength={2}
                value={hour12}
                onChangeText={setHour12}
              />
            </View>

            {/* Minute 0-59 */}
            <View style={{ flex: 1 }}>
              <Text style={[styles.fieldSubHeader, { color: textSecondary }]}>
                {isTe ? 'నిమిషాలు' : 'Min (0-59)'}
              </Text>
              <TextInput
                style={[styles.input, styles.timeInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
                placeholder="30"
                placeholderTextColor="#888"
                keyboardType="numeric"
                maxLength={2}
                value={minute}
                onChangeText={setMinute}
              />
            </View>

            {/* Second 0-59 */}
            <View style={{ flex: 1 }}>
              <Text style={[styles.fieldSubHeader, { color: textSecondary }]}>
                {isTe ? 'సెకన్లు' : 'Sec (0-59)'}
              </Text>
              <TextInput
                style={[styles.input, styles.timeInput, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
                placeholder="00"
                placeholderTextColor="#888"
                keyboardType="numeric"
                maxLength={2}
                value={second}
                onChangeText={setSecond}
              />
            </View>

            {/* AM / PM Toggle Buttons */}
            <View style={{ flex: 1.4, justifyContent: 'flex-end' }}>
              <Text style={[styles.fieldSubHeader, { color: textSecondary }]}>
                {isTe ? 'సమయ భాగం' : 'AM / PM'}
              </Text>
              <View style={styles.periodRow}>
                <TouchableOpacity
                  style={[
                    styles.periodBtn,
                    { borderColor },
                    period === 'AM' && { backgroundColor: AppColors.maroon, borderColor: AppColors.maroon },
                  ]}
                  onPress={() => setPeriod('AM')}
                  activeOpacity={0.7}
                >
                  <Text
                    style={[
                      styles.periodText,
                      { color: textSecondary },
                      period === 'AM' && { color: '#FFFFFF', fontWeight: '800' },
                    ]}
                  >
                    AM
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity
                  style={[
                    styles.periodBtn,
                    { borderColor },
                    period === 'PM' && { backgroundColor: AppColors.maroon, borderColor: AppColors.maroon },
                  ]}
                  onPress={() => setPeriod('PM')}
                  activeOpacity={0.7}
                >
                  <Text
                    style={[
                      styles.periodText,
                      { color: textSecondary },
                      period === 'PM' && { color: '#FFFFFF', fontWeight: '800' },
                    ]}
                  >
                    PM
                  </Text>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </View>

        {/* Gender Selection */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.inputLabel, { color: textSecondary }]}>
            {isTe ? 'లింగము (Gender):' : 'Gender:'}
          </Text>
          <View style={styles.row}>
            <TouchableOpacity
              style={[
                styles.genderBtn,
                { borderColor },
                gender === 'Male' && { backgroundColor: gold, borderColor: gold },
              ]}
              onPress={() => setGender('Male')}
            >
              <Text style={[styles.genderText, gender === 'Male' && { color: '#000', fontWeight: '800' }]}>
                {isTe ? 'పురుషుడు (Male)' : 'Male'}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[
                styles.genderBtn,
                { borderColor },
                gender === 'Female' && { backgroundColor: gold, borderColor: gold },
              ]}
              onPress={() => setGender('Female')}
            >
              <Text style={[styles.genderText, gender === 'Female' && { color: '#000', fontWeight: '800' }]}>
                {isTe ? 'స్త్రీ (Female)' : 'Female'}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* City / Place of Birth Selection */}
        <View style={[styles.card, { backgroundColor: cardBg, borderColor }]}>
          <Text style={[styles.inputLabel, { color: textSecondary }]}>
            {isTe ? 'జన్మ స్థలము (Place of Birth):' : 'Place of Birth:'}
          </Text>
          <TouchableOpacity
            style={[styles.cityPickerBtn, { borderColor, backgroundColor: isDark ? '#1C110A' : '#FFFDF9' }]}
            onPress={() => setCitySearchModal(true)}
          >
            <View>
              <Text style={[styles.cityMainText, { color: textPrimary }]}>{selectedCity.name}</Text>
              <Text style={[styles.citySubText, { color: textSecondary }]}>
                {selectedCity.state} ({selectedCity.latitude}°N, {selectedCity.longitude}°E)
              </Text>
            </View>
            <Text style={{ fontSize: 16, color: gold }}>🔍 {isTe ? 'ఎంచుకోండి' : 'Search'}</Text>
          </TouchableOpacity>
        </View>

        {/* Submit Button */}
        <TouchableOpacity style={styles.submitBtn} onPress={handleSubmit} activeOpacity={0.8}>
          <Text style={styles.submitBtnText}>
            {isTe ? '⚡ జాతక చక్ర గణన చేయండి (Calculate Chart)' : '⚡ Calculate Vedic Horoscope'}
          </Text>
        </TouchableOpacity>
      </ScrollView>

      {/* Visual Calendar Modal */}
      <Modal visible={calendarModalVisible} animationType="slide" transparent>
        <SafeAreaView style={[styles.modalOverlay, { backgroundColor: 'rgba(0,0,0,0.7)' }]}>
          <View style={[styles.calendarModalBox, { backgroundColor: cardBg, borderColor: gold }]}>
            {/* Modal Header */}
            <View style={styles.calendarModalHeader}>
              <View>
                <Text style={[styles.calendarModalTitle, { color: AppColors.maroonLight }]}>
                  {isTe ? 'పుట్టిన తేదీ క్యాలెండర్' : 'Date of Birth Calendar'}
                </Text>
                <Text style={{ fontSize: 11, color: textSecondary, marginTop: 1 }}>
                  {dateFormattedPreview}
                </Text>
              </View>
              <TouchableOpacity onPress={() => setCalendarModalVisible(false)} style={styles.closeBtn}>
                <Text style={{ fontSize: 20, color: gold, fontWeight: '700' }}>✕</Text>
              </TouchableOpacity>
            </View>

            {/* Year Jump Controls */}
            <View style={styles.yearJumpBar}>
              <TouchableOpacity onPress={() => handleYearJump(-10)} style={[styles.jumpBtn, { borderColor }]}>
                <Text style={[styles.jumpBtnText, { color: textSecondary }]}>« -10y</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={() => handleYearJump(-1)} style={[styles.jumpBtn, { borderColor }]}>
                <Text style={[styles.jumpBtnText, { color: textSecondary }]}>‹ -1y</Text>
              </TouchableOpacity>
              <Text style={[styles.currentYearDisplay, { color: gold }]}>{viewYear}</Text>
              <TouchableOpacity onPress={() => handleYearJump(1)} style={[styles.jumpBtn, { borderColor }]}>
                <Text style={[styles.jumpBtnText, { color: textSecondary }]}>+1y ›</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={() => handleYearJump(10)} style={[styles.jumpBtn, { borderColor }]}>
                <Text style={[styles.jumpBtnText, { color: textSecondary }]}>+10y »</Text>
              </TouchableOpacity>
            </View>

            {/* Month Navigation Row */}
            <View style={styles.monthNavBar}>
              <TouchableOpacity onPress={handlePrevMonth} style={styles.navBtn}>
                <Text style={[styles.navBtnText, { color: gold }]}>‹</Text>
              </TouchableOpacity>
              <Text style={[styles.currentMonthDisplay, { color: textPrimary }]}>
                {isTe ? teluguMonths[viewMonth] : englishMonths[viewMonth]} {viewYear}
              </Text>
              <TouchableOpacity onPress={handleNextMonth} style={styles.navBtn}>
                <Text style={[styles.navBtnText, { color: gold }]}>›</Text>
              </TouchableOpacity>
            </View>

            {/* Days of Week Header: Exact 7 Equal Columns */}
            <View style={styles.dayOfWeekRow}>
              {(isTe ? weekDaysTelugu : weekDaysEnglish).map((dName, i) => (
                <View key={dName} style={styles.dayOfWeekCol}>
                  <Text
                    style={[
                      styles.dayOfWeekText,
                      { color: i === 0 ? '#DC2626' : (i === 6 ? '#2563EB' : textSecondary) },
                    ]}
                  >
                    {dName}
                  </Text>
                </View>
              ))}
            </View>

            {/* Calendar Grid: Exact 7 Equal Columns (14.2857% each) */}
            <View style={styles.daysGrid}>
              {calendarCells.map((cell, idx) => {
                if (!cell.dayNum) {
                  return <View key={`empty-${idx}`} style={styles.dayCellCol} />;
                }
                const isSelected = cell.isCurrentSelection;
                const colIdx = idx % 7;
                const isSunday = colIdx === 0;
                return (
                  <View key={`day-${cell.dayNum}`} style={styles.dayCellCol}>
                    <TouchableOpacity
                      style={[
                        styles.dayCellCircle,
                        isSelected && {
                          backgroundColor: AppColors.maroon,
                          borderColor: gold,
                          borderWidth: 1.5,
                        },
                      ]}
                      onPress={() => handleSelectDay(cell.dayNum!)}
                      activeOpacity={0.7}
                    >
                      <Text
                        style={[
                          styles.dayCellText,
                          { color: isSunday ? '#DC2626' : textPrimary },
                          isSelected && { color: '#FFFFFF', fontWeight: '800' },
                        ]}
                      >
                        {cell.dayNum}
                      </Text>
                    </TouchableOpacity>
                  </View>
                );
              })}
            </View>

            {/* Confirm / Done Button */}
            <TouchableOpacity
              style={[styles.calendarDoneBtn, { backgroundColor: AppColors.maroon }]}
              onPress={() => setCalendarModalVisible(false)}
            >
              <Text style={styles.calendarDoneBtnText}>
                ✓ {isTe ? 'తేదీని ఖరారు చేయండి (Confirm Date)' : 'Confirm Date'}
              </Text>
            </TouchableOpacity>
          </View>
        </SafeAreaView>
      </Modal>

      {/* City Search Modal */}
      <Modal visible={citySearchModal} animationType="slide" transparent>
        <SafeAreaView style={[styles.modalOverlay, { backgroundColor: isDark ? 'rgba(0,0,0,0.85)' : 'rgba(0,0,0,0.5)' }]}>
          <View style={[styles.modalBox, { backgroundColor: cardBg, borderColor }]}>
            <View style={styles.modalHeader}>
              <Text style={[styles.modalTitle, { color: textPrimary }]}>
                {isTe ? 'నగరాన్ని వెతకండి (Search City)' : 'Select City / Town'}
              </Text>
              <TouchableOpacity onPress={() => setCitySearchModal(false)}>
                <Text style={{ fontSize: 18, color: gold }}>✕</Text>
              </TouchableOpacity>
            </View>

            <TextInput
              style={[styles.input, { borderColor, color: textPrimary, backgroundColor: isDark ? '#1C110A' : '#FFFDF9', marginVertical: 10 }]}
              placeholder={isTe ? 'నగరము లేదా తెలుగు పేరు (ఉదా: విజయవాడ, ఆకివీడు)...' : 'Type city name...'}
              placeholderTextColor="#888"
              value={cityQuery}
              onChangeText={handleSearchCity}
              autoFocus
            />

            <FlatList
              data={searchResults}
              keyExtractor={item => `${item.name}-${item.latitude}`}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={[styles.cityItem, { borderBottomColor: borderColor }]}
                  onPress={() => handleSelectCity(item)}
                >
                  <Text style={[styles.cityName, { color: textPrimary }]}>{item.name}</Text>
                  <Text style={[styles.cityDetails, { color: textSecondary }]}>
                    {item.state} • {item.latitude}° N, {item.longitude}° E
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
    fontSize: 28,
    fontWeight: '700',
  },
  appBarTitle: {
    fontSize: 16,
    fontWeight: '800',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
    gap: 12,
  },
  card: {
    padding: 12,
    borderRadius: 10,
    borderWidth: 1,
  },
  inputLabel: {
    fontSize: 12,
    fontWeight: '700',
    marginBottom: 6,
  },
  microLabel: {
    fontSize: 10.5,
    marginBottom: 4,
  },
  fieldSubHeader: {
    fontSize: 10,
    fontWeight: '600',
    marginBottom: 3,
    textAlign: 'center',
  },
  openCalBadge: {
    borderWidth: 1,
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
  },
  calendarPreviewCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 10,
    borderRadius: 10,
    borderWidth: 1.2,
    marginVertical: 4,
  },
  calendarIconBox: {
    width: 36,
    height: 36,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  },
  calendarDateMain: {
    fontSize: 14,
    fontWeight: '800',
  },
  calendarDateSub: {
    fontSize: 11,
    marginTop: 2,
  },
  timePreviewBadge: {
    borderWidth: 1,
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 12,
  },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 13,
  },
  row: {
    flexDirection: 'row',
    gap: 6,
    alignItems: 'flex-end',
  },
  dateInput: {
    flex: 1,
    textAlign: 'center',
  },
  yearInput: {
    flex: 1.4,
    textAlign: 'center',
  },
  timeInput: {
    textAlign: 'center',
    fontWeight: '700',
  },
  periodRow: {
    flexDirection: 'row',
    gap: 4,
  },
  periodBtn: {
    flex: 1,
    paddingVertical: 8,
    borderRadius: 8,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  periodText: {
    fontSize: 11,
    fontWeight: '700',
  },
  genderBtn: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: 8,
    borderWidth: 1,
    alignItems: 'center',
  },
  genderText: {
    fontSize: 12,
    fontWeight: '700',
  },
  cityPickerBtn: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
  },
  cityMainText: {
    fontSize: 13,
    fontWeight: '800',
  },
  citySubText: {
    fontSize: 11,
    marginTop: 2,
  },
  submitBtn: {
    backgroundColor: '#8B2500',
    paddingVertical: 14,
    borderRadius: 10,
    alignItems: 'center',
    marginTop: 8,
  },
  submitBtnText: {
    color: '#FFFFFF',
    fontWeight: '800',
    fontSize: 13.5,
  },
  modalOverlay: {
    flex: 1,
    justifyContent: 'center',
    padding: 16,
  },
  calendarModalBox: {
    borderRadius: 16,
    borderWidth: 1.5,
    padding: 16,
    maxHeight: '90%',
  },
  calendarModalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    borderBottomWidth: 1,
    borderBottomColor: '#d4af3740',
    paddingBottom: 8,
  },
  calendarModalTitle: {
    fontSize: 15,
    fontWeight: '800',
  },
  closeBtn: {
    padding: 4,
  },
  yearJumpBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 8,
    paddingHorizontal: 4,
  },
  jumpBtn: {
    borderWidth: 1,
    borderRadius: 6,
    paddingHorizontal: 6,
    paddingVertical: 3,
  },
  jumpBtnText: {
    fontSize: 10.5,
    fontWeight: '600',
  },
  currentYearDisplay: {
    fontSize: 15,
    fontWeight: '800',
  },
  monthNavBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 6,
    backgroundColor: '#fde68a20',
    borderRadius: 8,
    paddingHorizontal: 8,
    marginBottom: 8,
  },
  navBtn: {
    paddingHorizontal: 12,
    paddingVertical: 4,
  },
  navBtnText: {
    fontSize: 22,
    fontWeight: '800',
  },
  currentMonthDisplay: {
    fontSize: 14,
    fontWeight: '800',
  },
  dayOfWeekRow: {
    flexDirection: 'row',
    width: '100%',
    marginBottom: 6,
    borderBottomWidth: 1,
    borderBottomColor: '#d4af3730',
    paddingBottom: 4,
  },
  dayOfWeekCol: {
    width: '14.2857%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayOfWeekText: {
    fontSize: 11,
    fontWeight: '800',
    textAlign: 'center',
  },
  daysGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    width: '100%',
    justifyContent: 'flex-start',
  },
  dayCellCol: {
    width: '14.2857%',
    height: 38,
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 1,
  },
  dayCellCircle: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayCellText: {
    fontSize: 12.5,
    fontWeight: '600',
    textAlign: 'center',
  },
  calendarDoneBtn: {
    paddingVertical: 11,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 12,
  },
  calendarDoneBtnText: {
    color: '#FFFFFF',
    fontWeight: '800',
    fontSize: 12.5,
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
