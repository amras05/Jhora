import React, { useState } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  LayoutAnimation,
  Platform,
  UIManager,
} from 'react-native';
import { ChartData, PanchangaData } from '../../models/astroModels';
import { AstroConstants } from '../../constants/astroConstants';
import { TeluguPdfReportGenerator } from '../../services/teluguPdfReportGenerator';
import { PanchangaService } from '../../services/panchangaService';
import { ClassicalAstrologyService } from '../../services/classicalAstrologyService';
import { useTheme } from '../../context/ThemeContext';
import { useI18n } from '../../i18n';
import { radius, spacing } from '../../theme/tokens';

if (Platform.OS === 'android' && UIManager.setLayoutAnimationEnabledExperimental) {
  UIManager.setLayoutAnimationEnabledExperimental(true);
}

interface Props {
  chartData: ChartData;
  panchanga: PanchangaData;
}

export const ClassicalDetailsSection: React.FC<Props> = ({ chartData, panchanga }) => {
  const { colors, isDark } = useTheme();
  const { isTe } = useI18n();

  // Accordion open/close states (default all open so user immediately sees all details)
  const [openSections, setOpenSections] = useState<Record<string, boolean>>({
    janana: true,
    panchanga: true,
    avakahada: true,
    ghata: true,
    adrushta: true,
  });

  const toggleSection = (key: string) => {
    try {
      LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    } catch (_) {}
    setOpenSections(prev => ({ ...prev, [key]: !prev[key] }));
  };

  const birth = chartData.birthData;
  const moon = chartData.planets.find(p => p.name === 'Moon') || chartData.planets[1];
  const sun = chartData.planets.find(p => p.name === 'Sun') || chartData.planets[0];

  const formatDms = (deg: number) => TeluguPdfReportGenerator.formatDms(deg);
  const formatTime = (d: Date | string | undefined) => {
    if (!d) return '-';
    return TeluguPdfReportGenerator.formatTime(d);
  };

  // Calculations
  const avakahada = ClassicalAstrologyService.calculateAvakahada(chartData);
  const ghata = ClassicalAstrologyService.calculateGhata(moon.rashiIndex);
  const adrushta = ClassicalAstrologyService.calculateAdrushta(moon.rashiIndex, chartData.ascendant.rashiIndex);

  const varaIdx = panchanga.varaIndex ?? (birth.dateTime ? new Date(birth.dateTime).getDay() : 0);
  const varaLord = PanchangaService.varaLordsTelugu[varaIdx % 7];
  const varaName = isTe ? PanchangaService.weekdaysTelugu[varaIdx % 7] : (panchanga.vara || PanchangaService.weekdays[varaIdx % 7]);

  const nakIdx = panchanga.nakshatraIndex ?? moon.nakshatraIndex;
  const nakLord = AstroConstants.nakshatraLordsTelugu[nakIdx] || '-';
  const nakName = AstroConstants.nakshatrasTelugu[nakIdx];
  const nakPada = panchanga.nakshatraPada ?? moon.pada;

  const tithiName = TeluguPdfReportGenerator.tithisTelugu[panchanga.tithiIndex % 30] || panchanga.tithi || '';
  const pakshaName = isTe
    ? (panchanga.paksha === 'Shukla Paksha' ? 'శుక్ల పక్ష ' : 'కృష్ణ పక్ష ')
    : `${panchanga.paksha} `;

  const yogaName = TeluguPdfReportGenerator.yogasTelugu[panchanga.yogaIndex % 27] || panchanga.yoga || '';
  const karanaName = TeluguPdfReportGenerator.karanasTelugu[panchanga.karana] || panchanga.karana || '';

  const abhijitRange = panchanga.abhijitMuhurtham || panchanga.abhijitMuhurtha;
  const brahmaRange = panchanga.brahmaMuhurtham;
  const gulikaRange = panchanga.gulikaKalam || panchanga.gulika;

  const headerBg = isDark ? '#2D1F13' : '#FEF3C7';
  const headerBorder = isDark ? '#B45309' : '#FDE68A';
  const headerTextColor = isDark ? '#F59E0B' : '#78350F';
  const cardBg = isDark ? '#1F2937' : '#FFFFFF';
  const rowBorder = isDark ? 'rgba(255,255,255,0.08)' : '#F3F4F6';
  const altRowBg = isDark ? 'rgba(255,255,255,0.02)' : '#FAF5EA';

  const renderAccordionHeader = (title: string, key: string, countInfo?: string) => {
    const isOpen = !!openSections[key];
    return (
      <TouchableOpacity
        onPress={() => toggleSection(key)}
        activeOpacity={0.8}
        style={[
          styles.accordionHeader,
          {
            backgroundColor: headerBg,
            borderColor: headerBorder,
          },
        ]}
      >
        <Text style={[styles.accordionTitle, { color: headerTextColor }]}>
          {title}
        </Text>
        <View style={styles.headerRightGroup}>
          {countInfo && (
            <Text style={[styles.countBadge, { color: colors.textSecondary }]}>
              {countInfo}
            </Text>
          )}
          <Text style={[styles.chevron, { color: headerTextColor }]}>
            {isOpen ? '⌃' : '⌄'}
          </Text>
        </View>
      </TouchableOpacity>
    );
  };

  const renderDataRow = (label: string, value: string, isLast = false, isAlt = false, highlight = false) => (
    <View
      key={label}
      style={[
        styles.dataRow,
        {
          borderBottomColor: isLast ? 'transparent' : rowBorder,
          backgroundColor: isAlt ? altRowBg : 'transparent',
        },
      ]}
    >
      <Text style={[styles.rowLabel, { color: colors.textSecondary }]}>{label}</Text>
      <Text
        style={[
          styles.rowValue,
          { color: highlight ? colors.gold : colors.text },
          highlight && styles.highlightValue,
        ]}
      >
        {value}
      </Text>
    </View>
  );

  return (
    <View style={styles.container}>
      {/* ── 1. జనన వివరములు (Janana Vivaramulu) ── */}
      <View style={[styles.accordionCard, { borderColor: headerBorder, backgroundColor: cardBg }]}>
        {renderAccordionHeader('జనన వివరములు', 'janana')}
        {openSections.janana && (
          <View style={styles.accordionBody}>
            {renderDataRow('పేరు (Name):', birth.name || 'జాతకుడు', false, false, true)}
            {renderDataRow('జన్మ తేదీ (Date of Birth):', TeluguPdfReportGenerator.formatDate(birth.dateTime), false, true)}
            {renderDataRow('జన్మ సమయము (Time):', formatTime(birth.dateTime), false, false)}
            {renderDataRow('జన్మ స్థలము (Place):', birth.placeName, false, true)}
            {renderDataRow('అక్షాంశం / రేఖాంశం:', `${birth.latitude.toFixed(2)}° N, ${birth.longitude.toFixed(2)}° E`, false, false)}
            {renderDataRow('ఆయనాంశము (Ayanamsa):', `లాహిరి (${formatDms(chartData.ayanamsa)})`, false, true)}
            {renderDataRow('జన్మ లగ్నము (Ascendant):', `${AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]} (${formatDms(chartData.ascendant.degreesInRashi)})`, false, false, true)}
            {renderDataRow('జన్మ రాశి (Moon Sign):', `${AstroConstants.rashisTelugu[moon.rashiIndex]} (${formatDms(moon.degreesInRashi)})`, false, true, true)}
            {renderDataRow('జన్మ నక్షత్రం (Nakshatra):', `${nakName} (${nakPada}వ పాదం)`, false, false, true)}
            {renderDataRow('సూర్య రాశి (Sun Sign):', `${AstroConstants.rashisTelugu[sun.rashiIndex]} (${formatDms(sun.degreesInRashi)})`, true, true)}
          </View>
        )}
      </View>

      {/* ── 2. పంచాంగ వివరాలు (Panchanga Vivaralu) ── */}
      <View style={[styles.accordionCard, { borderColor: headerBorder, backgroundColor: cardBg }]}>
        {renderAccordionHeader('పంచాంగ వివరాలు', 'panchanga')}
        {openSections.panchanga && (
          <View style={styles.accordionBody}>
            {renderDataRow('తిథి (Tithi):', `${pakshaName}${tithiName}`, false, false, true)}
            {renderDataRow('వారం (Weekday):', `${varaName} (అధిపతి: ${varaLord})`, false, true)}
            {renderDataRow('నక్షత్రం (Nakshatra):', `${nakName} (${nakPada}వ పాదం - అధిపతి: ${nakLord})`, false, false, true)}
            {renderDataRow('నిత్య యోగం (Yoga):', yogaName, false, true)}
            {renderDataRow('కరణం (Karana):', karanaName, false, false)}
            {renderDataRow('సూర్యోదయం (Sunrise):', formatTime(panchanga.sunrise), false, true)}
            {renderDataRow('సూర్యాస్తమయం (Sunset):', formatTime(panchanga.sunset), false, false)}
            {abhijitRange && abhijitRange[0] && renderDataRow('అభిజిత్ ముహూర్తం (శుభం):', `${formatTime(abhijitRange[0])} - ${formatTime(abhijitRange[1])}`, false, true, true)}
            {brahmaRange && brahmaRange[0] && renderDataRow('బ్రహ్మ ముహూర్తం (శుభం):', `${formatTime(brahmaRange[0])} - ${formatTime(brahmaRange[1])}`, false, false)}
            {panchanga.rahuKalam && panchanga.rahuKalam[0] && renderDataRow('రాహు కాలం (వర్జ్యం):', `${formatTime(panchanga.rahuKalam[0])} - ${formatTime(panchanga.rahuKalam[1])}`, false, true)}
            {panchanga.yamagandam && panchanga.yamagandam[0] && renderDataRow('యమగండం (వర్జ్యం):', `${formatTime(panchanga.yamagandam[0])} - ${formatTime(panchanga.yamagandam[1])}`, false, false)}
            {gulikaRange && gulikaRange[0] && renderDataRow('గుళిక కాలం:', `${formatTime(gulikaRange[0])} - ${formatTime(gulikaRange[1])}`, true, true)}
          </View>
        )}
      </View>

      {/* ── 3. అవకహడ చక్రం (Avakahada Chakram) ── */}
      <View style={[styles.accordionCard, { borderColor: headerBorder, backgroundColor: cardBg }]}>
        {renderAccordionHeader('అవకహడ చక్రం', 'avakahada')}
        {openSections.avakahada && (
          <View style={styles.accordionBody}>
            {renderDataRow('వర్ణము (Varna):', `${avakahada.varna} (అధిపతి: ${avakahada.varnaLord})`, false, false, true)}
            {renderDataRow('వశ్యము (Vashya):', avakahada.vashya, false, true)}
            {renderDataRow('యోని (Yoni):', avakahada.yoni, false, false, true)}
            {renderDataRow('గణము (Gana):', avakahada.gana, false, true, true)}
            {renderDataRow('నాడి (Nadi):', avakahada.nadi, false, false, true)}
            {renderDataRow('రజ్జువు (Rajju):', avakahada.rajju, false, true)}
            {renderDataRow('నామ అక్షరము (Nama Akshara):', avakahada.namaAkshara, false, false, true)}
            {renderDataRow('తార (Tara):', avakahada.tara, false, true)}
            {renderDataRow('చంద్ర రాశి:', avakahada.chandraRashi, false, false)}
            {renderDataRow('జన్మ లగ్నము:', avakahada.janmaLagna, true, true)}
          </View>
        )}
      </View>

      {/* ── 4. ఘాత చక్రం (Ghata Chakram) ── */}
      <View style={[styles.accordionCard, { borderColor: headerBorder, backgroundColor: cardBg }]}>
        {renderAccordionHeader('ఘాత చక్రం', 'ghata')}
        {openSections.ghata && (
          <View style={styles.accordionBody}>
            <View style={styles.noticeBox}>
              <Text style={styles.noticeText}>
                గమనిక: ఈ క్రింది రాశి, తిథి, వారములు శుభకార్యములకు విడిచిపెట్టడం ప్రశస్తము.
              </Text>
            </View>
            {renderDataRow('ఘాత రాశి (Ghata Rashi):', ghata.ghataRashi, false, false, true)}
            {renderDataRow('ఘాత మాసం (Ghata Month):', ghata.ghataMasa, false, true)}
            {renderDataRow('ఘాత తిథి (Ghata Tithi):', ghata.ghataTithi, false, false, true)}
            {renderDataRow('ఘాత వారం (Ghata Weekday):', ghata.ghataVara, false, true, true)}
            {renderDataRow('ఘాత నక్షత్రం (Ghata Nakshatra):', ghata.ghataNakshatra, false, false, true)}
            {renderDataRow('ఘాత లగ్నం (Ghata Lagna):', ghata.ghataLagna, false, true)}
            {renderDataRow('ఘాత ప్రహర / వేళ:', ghata.ghataPrahar, true, false)}
          </View>
        )}
      </View>

      {/* ── 5. అదృష్ట విషయాలు (Adrushta Vishayalu) ── */}
      <View style={[styles.accordionCard, { borderColor: headerBorder, backgroundColor: cardBg }]}>
        {renderAccordionHeader('అదృష్ట విషయాలు', 'adrushta')}
        {openSections.adrushta && (
          <View style={styles.accordionBody}>
            {renderDataRow('రాశ్యాధిపతి (Rashi Lord):', adrushta.rashiLord, false, false, true)}
            {renderDataRow('లగ్నాధిపతి (Lagna Lord):', adrushta.lagnaLord, false, true, true)}
            {renderDataRow('అదృష్ట సంఖ్యలు (Lucky Numbers):', adrushta.luckyNumbers, false, false, true)}
            {renderDataRow('అదృష్ట వారాలు (Lucky Days):', adrushta.luckyDays, false, true)}
            {renderDataRow('అదృష్ట రంగులు (Lucky Colors):', adrushta.luckyColors, false, false)}
            {renderDataRow('అదృష్ట రత్నం (Lucky Gemstone):', adrushta.luckyGemstone, false, true, true)}
            {renderDataRow('అదృష్ట దిక్కు (Lucky Direction):', adrushta.luckyDirection, false, false)}
            {renderDataRow('ఇష్ట దైవం (Ishta Devata):', adrushta.ishtaDevata, false, true, true)}
            {renderDataRow('మిత్ర రాశులు (Friendly Rashis):', adrushta.friendlyRashis, true, false)}
          </View>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.xs,
  },
  accordionCard: {
    borderRadius: radius.md,
    borderWidth: 1,
    marginBottom: spacing.sm,
    overflow: 'hidden',
  },
  accordionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 13,
    paddingHorizontal: 16,
    borderBottomWidth: 1,
  },
  accordionTitle: {
    fontSize: 14.5,
    fontWeight: '800',
    letterSpacing: 0.3,
  },
  headerRightGroup: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  countBadge: {
    fontSize: 11,
    fontWeight: '600',
  },
  chevron: {
    fontSize: 18,
    fontWeight: '800',
    lineHeight: 20,
  },
  accordionBody: {
    paddingVertical: 2,
  },
  dataRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 9,
    paddingHorizontal: 14,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  rowLabel: {
    fontSize: 12.5,
    fontWeight: '600',
    flex: 1.1,
    paddingRight: 6,
  },
  rowValue: {
    fontSize: 12.5,
    fontWeight: '600',
    flex: 1.3,
    textAlign: 'right',
  },
  highlightValue: {
    fontWeight: '800',
  },
  noticeBox: {
    margin: 8,
    padding: 8,
    borderRadius: 6,
    backgroundColor: 'rgba(239, 68, 68, 0.08)',
    borderLeftWidth: 3,
    borderLeftColor: '#EF4444',
  },
  noticeText: {
    fontSize: 11,
    color: '#B91C1C',
    fontWeight: '600',
    lineHeight: 15,
  },
});

