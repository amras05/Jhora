import React from 'react';
import {
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { AppColors } from '../theme/appTheme';
import { ChartData, PanchangaData } from '../models/astroModels';
import { AstroConstants } from '../constants/astroConstants';
import { PanchangaService } from '../services/panchangaService';
import { TeluguPdfReportGenerator } from '../services/teluguPdfReportGenerator';

interface Props {
  chartData: ChartData;
  panchanga: PanchangaData;
  isDark: boolean;
  lang?: 'te' | 'en';
}

export const ChartPanchangaView: React.FC<Props> = ({
  chartData,
  panchanga,
  isDark,
  lang = 'te',
}) => {
  const gold = AppColors.getGold(isDark);
  const cardBg = AppColors.getCard(isDark);
  const borderColor = AppColors.getBorder(isDark);
  const textPrimary = AppColors.getTextPrimary(isDark);
  const textSecondary = AppColors.getTextSecondary(isDark);
  const isTe = lang === 'te';

  const birth = chartData.birthData;
  const sun = chartData.planets.find(p => p.name === 'Sun') || chartData.planets[0];
  const moon = chartData.planets.find(p => p.name === 'Moon') || chartData.planets[1];

  const formatDms = (deg: number) => TeluguPdfReportGenerator.formatDms(deg);
  const formatTime = (d: Date) => TeluguPdfReportGenerator.formatTime(d);

  const varaIdx = panchanga.varaIndex ?? (birth.dateTime ? new Date(birth.dateTime).getDay() : 0);
  const varaLord = PanchangaService.varaLordsTelugu[varaIdx % 7];
  const varaName = isTe ? PanchangaService.weekdaysTelugu[varaIdx % 7] : (panchanga.vara || PanchangaService.weekdays[varaIdx % 7]);

  const nakIdx = panchanga.nakshatraIndex ?? moon.nakshatraIndex;
  const nakPada = panchanga.nakshatraPada ?? moon.pada;
  const nakLord = AstroConstants.nakshatraLordsTelugu[nakIdx] || 'లగ్నాధిపతి';
  const nakName = AstroConstants.nakshatrasTelugu[nakIdx];

  const tithiName = TeluguPdfReportGenerator.tithisTelugu[panchanga.tithiIndex % 30] || panchanga.tithi || '';
  const pakshaName = isTe
    ? (panchanga.paksha === 'Shukla Paksha' ? 'శుక్ల పక్ష ' : 'కృష్ణ పక్ష ')
    : `${panchanga.paksha} `;

  const yogaName = TeluguPdfReportGenerator.yogasTelugu[panchanga.yogaIndex % 27] || panchanga.yoga || '';
  const karanaName = TeluguPdfReportGenerator.karanasTelugu[panchanga.karana] || panchanga.karana || '';

  const tithiProgress = panchanga.tithiProgress !== undefined ? panchanga.tithiProgress.toFixed(1) : '0.0';

  const abhijitRange = panchanga.abhijitMuhurtham || panchanga.abhijitMuhurtha;
  const brahmaRange = panchanga.brahmaMuhurtham;
  const gulikaRange = panchanga.gulikaKalam || panchanga.gulika;

  return (
    <View style={styles.container}>
      {/* 1. Header Card */}
      <View
        style={[
          styles.headerCard,
          {
            backgroundColor: isDark ? '#2A1608' : '#FFFBEB',
            borderColor: isDark ? '#F59E0B60' : '#FDE68A',
          },
        ]}
      >
        <View style={styles.headerTopRow}>
          <Text style={[styles.headerVara, { color: gold }]}>{varaName}</Text>
          <View style={[styles.ayanamsaPill, { borderColor: gold, backgroundColor: isDark ? '#F59E0B25' : '#FEF3C7' }]}>
            <Text style={[styles.ayanamsaText, { color: gold }]}>
              {isTe ? 'ఆయనాంశ:' : 'Ayanamsa:'} {formatDms(chartData.ayanamsa)}
            </Text>
          </View>
        </View>
        <Text style={[styles.headerSub, { color: textSecondary }]}>
          {TeluguPdfReportGenerator.formatDate(birth.dateTime)} {formatTime(birth.dateTime)} • {birth.placeName}
        </Text>
      </View>

      {/* 2. 5 Limbs of Panchanga Section */}
      <View style={styles.sectionHeader}>
        <Text style={[styles.sectionTitle, { color: gold }]}>
          📖 {isTe ? 'పంచాంగ పంచాంగాలు (5 Vedic Limbs)' : 'Panchanga - 5 Vedic Limbs'}
        </Text>
      </View>

      {/* Limb 1: Tithi */}
      <View style={[styles.limbCard, { backgroundColor: cardBg, borderColor }]}>
        <View style={[styles.iconBox, { backgroundColor: '#F59E0B20' }]}>
          <Text style={{ fontSize: 18 }}>🌕</Text>
        </View>
        <View style={styles.limbTextCol}>
          <Text style={[styles.limbTitle, { color: textSecondary }]}>
            {isTe ? 'తిథి (Tithi)' : 'Tithi'}
          </Text>
          <Text style={[styles.limbValue, { color: textPrimary }]}>
            {pakshaName}{tithiName}
          </Text>
          <Text style={[styles.limbSub, { color: textSecondary }]}>
            {isTe ? `పూర్తయినది: ${tithiProgress}%` : `Elapsed: ${tithiProgress}%`}
          </Text>
        </View>
      </View>

      {/* Limb 2: Vara */}
      <View style={[styles.limbCard, { backgroundColor: cardBg, borderColor }]}>
        <View style={[styles.iconBox, { backgroundColor: '#EA580C20' }]}>
          <Text style={{ fontSize: 18 }}>📅</Text>
        </View>
        <View style={styles.limbTextCol}>
          <Text style={[styles.limbTitle, { color: textSecondary }]}>
            {isTe ? 'వారం (Vara)' : 'Weekday (Vara)'}
          </Text>
          <Text style={[styles.limbValue, { color: textPrimary }]}>
            {varaName}
          </Text>
          <Text style={[styles.limbSub, { color: textSecondary }]}>
            {isTe ? `అధిపతి: ${varaLord}` : `Lord: ${varaLord}`}
          </Text>
        </View>
      </View>

      {/* Limb 3: Nakshatra */}
      <View style={[styles.limbCard, { backgroundColor: cardBg, borderColor }]}>
        <View style={[styles.iconBox, { backgroundColor: '#10B98120' }]}>
          <Text style={{ fontSize: 18 }}>⭐</Text>
        </View>
        <View style={styles.limbTextCol}>
          <Text style={[styles.limbTitle, { color: textSecondary }]}>
            {isTe ? 'నక్షత్రం (Nakshatra)' : 'Nakshatra'}
          </Text>
          <Text style={[styles.limbValue, { color: textPrimary }]}>
            {nakName} ({nakPada}{isTe ? 'వ పాదం' : ' Pada'})
          </Text>
          <Text style={[styles.limbSub, { color: textSecondary }]}>
            {isTe ? `నక్షత్రాధిపతి: ${nakLord}` : `Nakshatra Lord: ${nakLord}`}
          </Text>
        </View>
      </View>

      {/* Limb 4: Yoga */}
      <View style={[styles.limbCard, { backgroundColor: cardBg, borderColor }]}>
        <View style={[styles.iconBox, { backgroundColor: '#06B6D420' }]}>
          <Text style={{ fontSize: 18 }}>♾️</Text>
        </View>
        <View style={styles.limbTextCol}>
          <Text style={[styles.limbTitle, { color: textSecondary }]}>
            {isTe ? 'నిత్య యోగం (Yoga)' : 'Nitya Yoga'}
          </Text>
          <Text style={[styles.limbValue, { color: textPrimary }]}>
            {yogaName}
          </Text>
          <Text style={[styles.limbSub, { color: textSecondary }]}>
            {isTe ? 'సూర్య-చంద్రుల మొత్తం స్పష్టత ఆధారితం' : 'Sun + Moon longitude sum'}
          </Text>
        </View>
      </View>

      {/* Limb 5: Karana */}
      <View style={[styles.limbCard, { backgroundColor: cardBg, borderColor }]}>
        <View style={[styles.iconBox, { backgroundColor: '#8B5CF620' }]}>
          <Text style={{ fontSize: 18 }}>⏳</Text>
        </View>
        <View style={styles.limbTextCol}>
          <Text style={[styles.limbTitle, { color: textSecondary }]}>
            {isTe ? 'కరణం (Karana)' : 'Karana'}
          </Text>
          <Text style={[styles.limbValue, { color: textPrimary }]}>
            {karanaName}
          </Text>
          <Text style={[styles.limbSub, { color: textSecondary }]}>
            {isTe ? 'తిథి యొక్క అర్ధభాగము' : 'Half of a Tithi (6°)'}
          </Text>
        </View>
      </View>

      {/* 3. Celestial Placements at Birth Card */}
      <View style={[styles.sectionHeader, { marginTop: 14 }]}>
        <Text style={[styles.sectionTitle, { color: gold }]}>
          🧭 {isTe ? 'జన్మ రాశి & లగ్న వివరాలు' : 'Celestial Placements at Birth'}
        </Text>
      </View>

      <View style={[styles.detailCard, { backgroundColor: cardBg, borderColor }]}>
        <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'జన్మ లగ్నము (Ascendant):' : 'Ascendant (Lagna):'}
          </Text>
          <Text style={[styles.detailVal, { color: textPrimary }]}>
            {AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]} ({formatDms(chartData.ascendant.degreesInRashi)})
          </Text>
        </View>

        <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'జన్మ రాశి (Moon Sign):' : 'Moon Sign (Rashi):'}
          </Text>
          <Text style={[styles.detailVal, { color: textPrimary }]}>
            {AstroConstants.rashisTelugu[moon.rashiIndex]} ({formatDms(moon.degreesInRashi)})
          </Text>
        </View>

        <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'సూర్య రాశి (Sun Sign):' : 'Sun Sign:'}
          </Text>
          <Text style={[styles.detailVal, { color: textPrimary }]}>
            {AstroConstants.rashisTelugu[sun.rashiIndex]} ({formatDms(sun.degreesInRashi)})
          </Text>
        </View>

        <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'సూర్యోదయము (Sunrise):' : 'Sunrise:'}
          </Text>
          <Text style={[styles.detailVal, { color: '#F59E0B' }]}>
            {formatTime(panchanga.sunrise)}
          </Text>
        </View>

        <View style={styles.detailRow}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'సూర్యాస్తమయము (Sunset):' : 'Sunset:'}
          </Text>
          <Text style={[styles.detailVal, { color: '#EA580C' }]}>
            {formatTime(panchanga.sunset)}
          </Text>
        </View>
      </View>

      {/* 4. Muhurthams & Timings Card */}
      <View style={[styles.sectionHeader, { marginTop: 14 }]}>
        <Text style={[styles.sectionTitle, { color: gold }]}>
          ⏱️ {isTe ? 'ముహూర్తములు & కాలాలు (Muhurthams)' : 'Auspicious & Inauspicious Muhurthams'}
        </Text>
      </View>

      <View style={[styles.detailCard, { backgroundColor: cardBg, borderColor }]}>
        {abhijitRange && (
          <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
            <Text style={[styles.detailKey, { color: textSecondary }]}>
              {isTe ? 'అభిజిత్ ముహూర్తం (శుభం):' : 'Abhijit Muhurtham (Good):'}
            </Text>
            <Text style={[styles.detailVal, { color: '#10B981', fontWeight: '800' }]}>
              {formatTime(abhijitRange[0])} - {formatTime(abhijitRange[1])}
            </Text>
          </View>
        )}

        {brahmaRange && (
          <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
            <Text style={[styles.detailKey, { color: textSecondary }]}>
              {isTe ? 'బ్రహ్మ ముహూర్తం (శుభం):' : 'Brahma Muhurtham (Good):'}
            </Text>
            <Text style={[styles.detailVal, { color: '#10B981', fontWeight: '800' }]}>
              {formatTime(brahmaRange[0])} - {formatTime(brahmaRange[1])}
            </Text>
          </View>
        )}

        <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'రాహు కాలం (వర్జ్యం):' : 'Rahu Kalam (Avoid):'}
          </Text>
          <Text style={[styles.detailVal, { color: '#EF4444', fontWeight: '800' }]}>
            {formatTime(panchanga.rahuKalam[0])} - {formatTime(panchanga.rahuKalam[1])}
          </Text>
        </View>

        <View style={[styles.detailRow, { borderBottomColor: borderColor }]}>
          <Text style={[styles.detailKey, { color: textSecondary }]}>
            {isTe ? 'యమగండం (వర్జ్యం):' : 'Yamagandam (Avoid):'}
          </Text>
          <Text style={[styles.detailVal, { color: '#F97316', fontWeight: '800' }]}>
            {formatTime(panchanga.yamagandam[0])} - {formatTime(panchanga.yamagandam[1])}
          </Text>
        </View>

        {gulikaRange && (
          <View style={styles.detailRow}>
            <Text style={[styles.detailKey, { color: textSecondary }]}>
              {isTe ? 'గుళిక కాలం:' : 'Gulika Kalam:'}
            </Text>
            <Text style={[styles.detailVal, { color: textPrimary }]}>
              {formatTime(gulikaRange[0])} - {formatTime(gulikaRange[1])}
            </Text>
          </View>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    width: '100%',
    paddingBottom: 24,
  },
  headerCard: {
    width: '100%',
    padding: 14,
    borderRadius: 14,
    borderWidth: 1,
    marginBottom: 14,
  },
  headerTopRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    flexWrap: 'wrap',
    gap: 6,
  },
  headerVara: {
    fontSize: 18,
    fontWeight: '800',
  },
  ayanamsaPill: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 16,
    borderWidth: 1,
  },
  ayanamsaText: {
    fontSize: 11,
    fontWeight: '700',
  },
  headerSub: {
    fontSize: 12,
    marginTop: 6,
    lineHeight: 17,
  },
  sectionHeader: {
    marginBottom: 8,
  },
  sectionTitle: {
    fontSize: 15,
    fontWeight: '800',
  },
  limbCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderRadius: 12,
    borderWidth: 1,
    marginBottom: 8,
    width: '100%',
  },
  iconBox: {
    width: 38,
    height: 38,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  limbTextCol: {
    flex: 1,
    minWidth: 0,
  },
  limbTitle: {
    fontSize: 11,
  },
  limbValue: {
    fontSize: 14,
    fontWeight: '800',
    marginTop: 1,
  },
  limbSub: {
    fontSize: 11,
    marginTop: 2,
  },
  detailCard: {
    width: '100%',
    padding: 14,
    borderRadius: 12,
    borderWidth: 1,
    marginBottom: 12,
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 8,
    borderBottomWidth: StyleSheet.hairlineWidth,
    width: '100%',
  },
  detailKey: {
    fontSize: 12.5,
    flex: 1,
    paddingRight: 8,
  },
  detailVal: {
    fontSize: 12.5,
    fontWeight: '700',
    textAlign: 'right',
  },
});

