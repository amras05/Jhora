import os

gen_dart = r'''import 'package:intl/intl.dart';
import '../models/chart_data.dart';
import '../models/planet_position.dart';
import 'ashtakavarga_service.dart';
import 'shadbala_service.dart';
import 'yoga_service.dart';
import 'dosha_service.dart';
import 'transit_service.dart';
import 'kp_service.dart';
import 'dasha_service.dart';
import 'special_points_service.dart';
import '../../../core/constants/astro_constants.dart';

/// Comprehensive Telugu Vedic Horoscope Report Generator matching 'శ్రీ బాల జ్యోతిర్ వాస్తు'
class TeluguHoroscopeReportGenerator {
  TeluguHoroscopeReportGenerator._();

  static const String appTitle = 'శ్రీ బాల జ్యోతిర్ వాస్తు';
  static const String astrologerName = 'M B S Sastry';
  static const String astrologerAddress = 'BHAVANIPURAM VIJAYAWADA 12';
  static const String astrologerMobile = '9030166610';

  /// Generates the complete, highly styled HTML document for instant PDF printing in any browser
  static String generatePrintableHtml({
    required ChartData chart,
    required AshtakavargaData ashtakavarga,
    required List<PlanetShadbala> shadbala,
    required List<VedicYoga> yogas,
    required DoshaAnalysis dosha,
    required GocharAnalysis gochar,
    required KPAnalysis kp,
    required List<DashaPeriod> dashas,
  }) {
    final bd = chart.birthData;
    final dateStr = DateFormat('dd-MM-yyyy').format(bd.dateTime);
    final timeStr = DateFormat('hh:mm:ss a').format(bd.dateTime);
    final moon = chart.getPlanet('Moon');
    final sun = chart.getPlanet('Sun');
    final lagna = chart.ascendant;

    final moonNak = moon?.nakshatra ?? 'ధనిష్ఠ';
    final moonPada = moon?.pada ?? 3;
    final moonRashi = moon?.rashi ?? 'కుంభము';

    // Special Points Calculation (Yogi, Avayogi, Sahayogi, Bhrigu Bindu, Karakas, Arudha)
    final specialPoints = SpecialPointsService.calculate(chart);

    final buffer = StringBuffer();

    buffer.writeln("""
<!DOCTYPE html>
<html lang="te">
<head>
  <meta charset="UTF-8">
  <title>$appTitle - ${bd.name.isEmpty ? "జాతక చక్రం" : bd.name}</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Gautami:wght@400;700&family=Noto+Sans+Telugu:wght@400;600;700;800&family=Outfit:wght@400;600;700;800&display=swap');

    @page {
      size: A4;
      margin: 10mm 12mm;
    }

    * {
      box-sizing: border-box;
      -webkit-print-color-adjust: exact !important;
      print-color-adjust: exact !important;
    }

    body {
      font-family: 'Noto Sans Telugu', 'Gautami', 'Outfit', sans-serif;
      background: #fdfbf7;
      color: #2b1e16;
      margin: 0;
      padding: 15px;
      font-size: 11pt;
      line-height: 1.5;
    }

    .page {
      background: #ffffff;
      border: 2px solid #dfb15b;
      border-radius: 8px;
      padding: 24px;
      margin-bottom: 24px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.06);
      page-break-after: always;
      position: relative;
    }

    .page:last-child {
      page-break-after: auto;
    }

    .header-banner {
      text-align: center;
      border-bottom: 2px double #c98b2c;
      padding-bottom: 12px;
      margin-bottom: 18px;
    }

    .header-om {
      font-size: 26pt;
      color: #b3391b;
      font-weight: 800;
      line-height: 1;
    }

    .header-title {
      font-size: 22pt;
      font-weight: 800;
      color: #8c2509;
      margin: 4px 0;
      letter-spacing: 1px;
    }

    .header-subtitle {
      font-size: 11pt;
      color: #634226;
      font-weight: 600;
    }

    .contact-badge {
      display: inline-block;
      margin-top: 6px;
      background: #fff8e7;
      border: 1px solid #dfb15b;
      padding: 4px 14px;
      border-radius: 20px;
      font-size: 10pt;
      font-weight: 700;
      color: #7a3a0e;
    }

    .section-title {
      font-size: 13pt;
      font-weight: 700;
      color: #802200;
      border-bottom: 1.5px solid #d49a37;
      padding-bottom: 4px;
      margin-top: 16px;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .section-title::before {
      content: '卐';
      color: #b3391b;
      font-size: 12pt;
    }

    table.data-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 14px;
      font-size: 10pt;
    }

    table.data-table th {
      background-color: #f5eedb;
      color: #662d0b;
      font-weight: 700;
      border: 1px solid #d9be8b;
      padding: 6px 8px;
      text-align: center;
    }

    table.data-table td {
      border: 1px solid #e6d3af;
      padding: 5px 8px;
      text-align: left;
    }

    table.data-table tr:nth-child(even) {
      background-color: #faf6ed;
    }

    .center { text-align: center !important; }
    .bold { font-weight: 700; }
    .gold-text { color: #8c2509; font-weight: 700; }
    .green-text { color: #1e7029; font-weight: 700; }
    .red-text { color: #ad2020; font-weight: 700; }

    /* South Indian Kundali Grid */
    .chart-container {
      display: flex;
      justify-content: space-around;
      gap: 16px;
      margin: 14px 0;
      flex-wrap: wrap;
    }

    .chart-card {
      text-align: center;
      flex: 1;
      min-width: 280px;
      max-width: 340px;
    }

    .chart-title {
      font-weight: 700;
      font-size: 11pt;
      color: #7a3a0e;
      margin-bottom: 6px;
    }

    .si-chart {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      grid-template-rows: repeat(4, 1fr);
      width: 100%;
      aspect-ratio: 1 / 1;
      border: 2px solid #b3391b;
      background: #fffdfa;
      box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    }

    .si-cell {
      border: 1px solid #d4a76a;
      padding: 3px;
      font-size: 8pt;
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      min-height: 48px;
    }

    .si-cell.center-box {
      grid-column: 2 / span 2;
      grid-row: 2 / span 2;
      background: #fff8e8;
      border: 1.5px solid #b3391b;
      font-weight: 700;
      font-size: 9.5pt;
      color: #8c2509;
      text-align: center;
      padding: 6px;
    }

    .si-sign-name {
      font-size: 7pt;
      color: #9c683b;
      position: absolute;
      top: 1px;
      left: 2px;
      font-weight: 600;
    }

    .si-planets {
      font-size: 8pt;
      font-weight: 700;
      color: #1a1a1a;
      line-height: 1.15;
      text-align: center;
    }

    .lagna-badge {
      color: #b3391b;
      font-weight: 800;
      border-bottom: 1.5px solid #b3391b;
    }

    .sloka-box {
      background: #fffaf0;
      border-left: 4px solid #b3391b;
      border-right: 1px solid #e0c896;
      border-top: 1px solid #e0c896;
      border-bottom: 1px solid #e0c896;
      padding: 10px 14px;
      margin: 12px 0;
      border-radius: 4px;
      font-size: 10.5pt;
      color: #572d11;
      text-align: center;
    }

    .footer-note {
      text-align: center;
      font-size: 8.5pt;
      color: #785a44;
      margin-top: 16px;
      border-top: 1px dashed #d9be8b;
      padding-top: 8px;
    }

    .highlight-card {
      background: #fff9e6;
      border: 1px solid #dfb15b;
      border-radius: 6px;
      padding: 10px 14px;
      margin: 10px 0;
    }

    .grid-2 {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }

    .badge {
      display: inline-block;
      padding: 2px 6px;
      border-radius: 4px;
      font-size: 8.5pt;
      font-weight: 700;
    }
    .badge-favorable { background: #e2f5e4; color: #1e7029; }
    .badge-neutral { background: #f7f1e1; color: #7a5c1e; }
    .badge-difficult { background: #fbe6e6; color: #ad2020; }
  </style>
</head>
<body>
""");

    // PAGE 1: COVER & MANGALA SLOKA & BIRTH DETAILS
    buffer.writeln("""
  <div class="page">
    <div class="header-banner">
      <div class="header-om">卐 శ్రీః 卐</div>
      <div class="header-title">$appTitle</div>
      <div class="header-subtitle">సంపూర్ణ జాతక చక్ర విశ్లేషణ & ఫలిత పత్రిక (Super Horoscope Report)</div>
      <div class="contact-badge">
        జ్యోతిష విద్వాన్: <b>$astrologerName</b> • మొబైల్: <b>$astrologerMobile</b><br>
        చిరునామా: $astrologerAddress
      </div>
    </div>

    <div class="sloka-box">
      <b>జననీ జన్మ సౌఖ్యానాం వర్ధనీ కుల సంపదాం ।<br>
      పదవీ పూర్వ పుణ్యానాం లిఖ్యతే జన్మ పత్రికా ॥</b><br>
      <small style="color: #7a3a0e;">తల్లి మరియు బిడ్డ యొక్క సంరక్షణ, కుటుంబ సంతోష, ధన, ధాన్య, ఆయురారోగ్య అభివృద్ధి కొరకు ప్రాచీన పరాశర ధార్మిక సూత్రముల ప్రకారం ఈ జాతక చక్రము వ్రాయబడినది.</small>
    </div>

    <div class="section-title">జాతకుని జనన వివరములు (Birth Profile)</div>
    <table class="data-table">
      <tr>
        <td class="bold" width="25%">పేరు (Name):</td>
        <td width="25%" class="gold-text">${bd.name.isEmpty ? "శ్రీమాన్ / కుమారి" : bd.name}</td>
        <td class="bold" width="25%">లింగము (Gender):</td>
        <td width="25%">${bd.gender == 'female' ? 'స్త్రీ (Female)' : 'పురుష (Male)'}</td>
      </tr>
      <tr>
        <td class="bold">జన్మ దినము (Date of Birth):</td>
        <td>$dateStr (${DateFormat('EEEE').format(bd.dateTime)})</td>
        <td class="bold">పుట్టిన సమయము (Time of Birth):</td>
        <td>$timeStr (IST)</td>
      </tr>
      <tr>
        <td class="bold">జన్మ స్థానము (Place of Birth):</td>
        <td>${bd.cityName}</td>
        <td class="bold">అక్షాంశము & రేఖాంశము:</td>
        <td>${bd.latitude.toStringAsFixed(2)}° N, ${bd.longitude.toStringAsFixed(2)}° E</td>
      </tr>
      <tr>
        <td class="bold">లగ్నము (Ascendant):</td>
        <td class="gold-text">${lagna.rashi} (${lagna.shortDegInRashi})</td>
        <td class="bold">లగ్న నక్షత్రము:</td>
        <td>${lagna.nakshatra} - పాదము ${lagna.pada}</td>
      </tr>
      <tr>
        <td class="bold">జన్మ రాశి (Moon Sign):</td>
        <td class="gold-text">$moonRashi</td>
        <td class="bold">జన్మ నక్షత్రము:</td>
        <td class="gold-text">$moonNak - పాదము $moonPada</td>
      </tr>
      <tr>
        <td class="bold">అయనాంశము (Ayanamsa):</td>
        <td>చిత్రపక్ష (Lahiri) ~ 23° 54'</td>
        <td class="bold">కలిదిన సంఖ్య (Ahargana):</td>
        <td>${(bd.dateTime.millisecondsSinceEpoch / 86400000 + 2440587.5).round()}</td>
      </tr>
    </table>

    <div class="section-title">పంచాంగ వివరములు (Panchangam at Birth)</div>
    <table class="data-table">
      <tr>
        <td class="bold" width="25%">వారం (Vara):</td>
        <td width="25%">${DateFormat('EEEE').format(bd.dateTime)}</td>
        <td class="bold" width="25%">తిథి (Tithi):</td>
        <td width="25%">${_calculateTithiTelugu(sun?.longitude ?? 0, moon?.longitude ?? 0)}</td>
      </tr>
      <tr>
        <td class="bold">నక్షత్రము (Nakshatra):</td>
        <td>$moonNak ($moonPadaవ పాదము)</td>
        <td class="bold">నక్షత్రాధిపతి (Star Lord):</td>
        <td>${moon?.nakshatraLord ?? 'కుజుడు'}</td>
      </tr>
      <tr>
        <td class="bold">నిత్య యోగము (Yoga):</td>
        <td>${_calculateNityaYogaTelugu(sun?.longitude ?? 0, moon?.longitude ?? 0)}</td>
        <td class="bold">కరణము (Karana):</td>
        <td>${_calculateKaranaTelugu(sun?.longitude ?? 0, moon?.longitude ?? 0)}</td>
      </tr>
      <tr>
        <td class="bold">సూర్యోదయము (Sunrise):</td>
        <td>05:55 AM (IST)</td>
        <td class="bold">సూర్యాస్తమయము (Sunset):</td>
        <td>05:50 PM (IST)</td>
      </tr>
    </table>

    <div class="footer-note">
      $appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress
    </div>
  </div>
""");

    // PAGE 2: SPECIAL POINTS (YOGI, AVAYOGI, BHRIGU BINDU, CHARA KARAKAS, ARUDHA PADAS)
    buffer.writeln("""
  <div class="page">
    <div class="section-title">విశేష బిందువులు & గ్రహ స్థితులు (Special Vedic Points)</div>
    
    <div class="highlight-card">
      <table class="data-table" style="margin-bottom: 0;">
        <tr>
          <td class="bold" width="25%">యోగి స్థానము & నక్షత్రము:</td>
          <td width="25%" class="green-text">${specialPoints.yogiRashi} (${specialPoints.yogiLongitude.toStringAsFixed(2)}°) - ${specialPoints.yogiNakshatra} (${specialPoints.yogiPada})</td>
          <td class="bold" width="25%">యోగి గ్రహము (Yogi Planet):</td>
          <td width="25%" class="green-text">${specialPoints.yogiPlanet}</td>
        </tr>
        <tr>
          <td class="bold">సహయోగి గ్రహము (Duplicate Yogi):</td>
          <td class="green-text">${specialPoints.sahayogiPlanet}</td>
          <td class="bold">అవయోగి నక్షత్రము & గ్రహము:</td>
          <td class="red-text">${specialPoints.avayogiNakshatra} - ${specialPoints.avayogiPlanet}</td>
        </tr>
        <tr style="background: #fff3dc;">
          <td class="bold">భృగు బిందువు (Bhrigu Bindu):</td>
          <td class="gold-text"><b>${specialPoints.bhriguBinduRashi} (${specialPoints.bhriguBinduRashiDeg.toStringAsFixed(2)}°)</b></td>
          <td class="bold">భృగు నక్షత్రం & భావం:</td>
          <td class="gold-text"><b>${specialPoints.bhriguBinduNakshatra} (${specialPoints.bhriguBinduPada}వ పాదం) - ${specialPoints.bhriguBinduHouse}వ భావం</b></td>
        </tr>
      </table>
    </div>

    <div class="section-title">జైమిని చర కారకములు (Jaimini Chara Karakas)</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>కారకము (Karaka)</th>
          <th>సంక్షిప్త</th>
          <th>గ్రహము (Planet)</th>
          <th>రాశి (Rashi)</th>
          <th>భాగలు (Deg in Sign)</th>
          <th>కారకత్వ విశేషము</th>
        </tr>
      </thead>
      <tbody>
""");

    for (final k in specialPoints.charaKarakas) {
      buffer.writeln("""
        <tr>
          <td class="bold">${k.nameTelugu}</td>
          <td class="center gold-text">${k.abbreviation}</td>
          <td class="center bold">${k.planetTelugu}</td>
          <td class="center">${k.rashiTelugu}</td>
          <td class="center">${k.degreeInRashi.toStringAsFixed(2)}°</td>
          <td>${_getKarakaDescription(k.abbreviation)}</td>
        </tr>
""");
    }

    buffer.writeln("""
      </tbody>
    </table>

    <div class="section-title">ఆరూఢ / భావ పాదములు (Jaimini Arudha Padas)</div>
    <div class="grid-2">
      <table class="data-table">
        <thead><tr><th>పాదము (Pada)</th><th>కోడ్</th><th>రాశి (Sign)</th></tr></thead>
        <tbody>
""");
    for (int i = 0; i < 6; i++) {
      final p = specialPoints.arudhaPadas[i];
      buffer.writeln("<tr><td class='bold'>${p.teluguName}</td><td class='center gold-text'>${p.code}</td><td class='center bold'>${p.rashiTelugu}</td></tr>");
    }
    buffer.writeln("""
        </tbody>
      </table>
      <table class="data-table">
        <thead><tr><th>పాదము (Pada)</th><th>కోడ్</th><th>రాశి (Sign)</th></tr></thead>
        <tbody>
""");
    for (int i = 6; i < 12; i++) {
      final p = specialPoints.arudhaPadas[i];
      buffer.writeln("<tr><td class='bold'>${p.teluguName}</td><td class='center gold-text'>${p.code}</td><td class='center bold'>${p.rashiTelugu}</td></tr>");
    }
    buffer.writeln("""
        </tbody>
      </table>
    </div>

    <div class="footer-note">
      $appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress
    </div>
  </div>
""");

    // PAGE 3: PLANETARY POSITIONS (NIRAYANA & SAYANA) & KP SUB-LORDS
    buffer.writeln("""
  <div class="page">
    <div class="section-title">నిరాయన గ్రహ స్పష్ట పట్టిక (Nirayana Planetary Positions)</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>గ్రహము</th>
          <th>రేఖాంశము</th>
          <th>రాశి (Sign)</th>
          <th>రాశి భాగలు</th>
          <th>నక్షత్రము</th>
          <th>పాదము</th>
          <th>నక్షత్రాధిపతి</th>
          <th>స్థితి / బలం</th>
        </tr>
      </thead>
      <tbody>
        <tr style="background: #fff5e6;">
          <td class="bold lagna-badge">లగ్నము</td>
          <td class="center">${lagna.dmsInRashi}</td>
          <td class="center bold">${lagna.rashi}</td>
          <td class="center">${lagna.shortDegInRashi}</td>
          <td class="center">${lagna.nakshatra}</td>
          <td class="center">$moonPada</td>
          <td class="center">${lagna.nakshatraLord}</td>
          <td class="center bold green-text">లగ్న కేంద్రం</td>
        </tr>
""");

    for (final p in chart.planets) {
      final isRet = p.isRetrograde;
      final dignity = _getTeluguDignity(p);
      final isFavorable = dignity.contains('ఉచ్ఛ') || dignity.contains('స్వక్షేత్ర');
      final isDebilitated = dignity.contains('నీచ');
      final dignityClass = isFavorable ? 'green-text' : (isDebilitated ? 'red-text' : '');
      final telName = _getTeluguPlanetName(p.name);
      buffer.writeln("""
        <tr>
          <td class="bold">$telName ${isRet ? "<span class='red-text'>(వక్ర)</span>" : ""}</td>
          <td class="center">${p.dmsInRashi}</td>
          <td class="center">${p.rashi}</td>
          <td class="center">${p.shortDegInRashi}</td>
          <td class="center">${p.nakshatra}</td>
          <td class="center">${p.pada}</td>
          <td class="center">${p.nakshatraLord}</td>
          <td class="center bold $dignityClass">$dignity</td>
        </tr>
""");
    }

    buffer.writeln("""
      </tbody>
    </table>

    <div class="section-title">KP నక్షత్ర అధిపతి / ఉప అధిపతి పట్టిక (KP Sub-Lord System)</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>గ్రహము / స్థానము</th>
          <th>రాశి అధిపతి (Sign Lord)</th>
          <th>నక్షత్ర అధిపతి (Star Lord)</th>
          <th>ఉప అధిపతి (Sub Lord)</th>
          <th>ఉప-ఉప అధిపతి (Sub-Sub Lord)</th>
        </tr>
      </thead>
      <tbody>
""");

    for (final row in kp.planetSubLords) {
      buffer.writeln("""
        <tr>
          <td class="bold">${row.planetTelugu}</td>
          <td class="center">${row.signLordTelugu}</td>
          <td class="center">${row.starLordTelugu}</td>
          <td class="center bold gold-text">${row.subLordTelugu}</td>
          <td class="center">${row.subSubLordTelugu}</td>
        </tr>
""");
    }

    buffer.writeln("""
      </tbody>
    </table>

    <div class="footer-note">
      $appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress
    </div>
  </div>
""");

    // PAGE 4: KUNDALI CHARTS (D1 RASI, D9 NAVAMSA, D10 DASAMSA, D7 SAPTAMSA)
    buffer.writeln("""
  <div class="page">
    <div class="section-title">ముఖ్య వర్గ చక్రములు (Vedic Divisional Charts)</div>

    <div class="chart-container">
      <div class="chart-card">
        <div class="chart-title">రాశి చక్రము (D1 Rasi Chart - లగ్న కుండలి)</div>
        ${_buildSouthIndianChartHtml(chart, chartType: 'D1')}
      </div>
      <div class="chart-card">
        <div class="chart-title">నవాంశ చక్రము (D9 Navamsa Chart - భాగ్య & కళత్ర)</div>
        ${_buildSouthIndianChartHtml(chart, chartType: 'D9')}
      </div>
    </div>

    <div class="chart-container">
      <div class="chart-card">
        <div class="chart-title">దశాంశ చక్రము (D10 Dasamsa Chart - వృత్తి & ఉద్యోగం)</div>
        ${_buildSouthIndianChartHtml(chart, chartType: 'D10')}
      </div>
      <div class="chart-card">
        <div class="chart-title">సప్తాంశ చక్రము (D7 Saptamsa Chart - సంతాన భాగ్యం)</div>
        ${_buildSouthIndianChartHtml(chart, chartType: 'D7')}
      </div>
    </div>

    <div class="footer-note">
      $appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress
    </div>
  </div>
""");

    // PAGE 5: BHAVA SPASHTA & ASHTAKAVARGA
    buffer.writeln("""
  <div class="page">
    <div class="section-title">భావ స్పష్ట పట్టిక & భావాధిపతులు (Bhava Cusps Table)</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>భావము (House)</th>
          <th>ప్రారంభము (Start)</th>
          <th>మధ్యమము (Mid / Cusp)</th>
          <th>అంత్యము (End)</th>
          <th>భావాధిపతి</th>
          <th>భావ స్థితి గ్రహములు</th>
        </tr>
      </thead>
      <tbody>
""");

    final lagnaLon = lagna.longitude;
    for (int h = 1; h <= 12; h++) {
      final midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
      final startLon = (midLon - 15.0 + 360.0) % 360.0;
      final endLon = (midLon + 15.0) % 360.0;
      final rIdx = (midLon / 30.0).floor() % 12;
      final rashiName = AstroConstants.rashis[rIdx];
      final lord = AstroConstants.rashiLordsTelugu[rIdx];

      // Find planets in this bhava
      final occupants = chart.planets.where((p) {
        final dist = (p.longitude - startLon + 360.0) % 360.0;
        return dist < 30.0;
      }).map((p) => p.displayAbbr).join(', ');

      buffer.writeln("""
        <tr>
          <td class="bold center">$h వ భావము</td>
          <td class="center">${_formatDms(startLon)}</td>
          <td class="center bold gold-text">${_formatDms(midLon)} ($rashiName)</td>
          <td class="center">${_formatDms(endLon)}</td>
          <td class="center bold">$lord</td>
          <td class="center">${occupants.isEmpty ? "-" : occupants}</td>
        </tr>
""");
    }

    buffer.writeln("""
      </tbody>
    </table>

    <div class="section-title">సర్వాష్టకవర్గ పట్టిక (Sarvashtakavarga - SAV 337 Points)</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>రాశి (Sign)</th>
          <th>రవి</th>
          <th>చం</th>
          <th>కు</th>
          <th>బు</th>
          <th>గు</th>
          <th>శు</th>
          <th>శ</th>
          <th>లగ్న</th>
          <th>మొత్తం (SAV)</th>
          <th>ఫలితము</th>
        </tr>
      </thead>
      <tbody>
""");

    for (int i = 0; i < 12; i++) {
      final signName = AstroConstants.rashis[i];
      final savPts = ashtakavarga.sav[i];
      final isFav = savPts >= 28;
      final statusText = isFav ? "శుభప్రదం (Favorable)" : "మధ్యమం / అల్పం";
      final statusClass = isFav ? "green-text" : "red-text";
      final rowBg = isFav ? "style='background: #f0f9f1;'" : "";
      buffer.writeln("""
        <tr $rowBg>
          <td class="bold">$signName</td>
          <td class="center">${ashtakavarga.bavSun[i]}</td>
          <td class="center">${ashtakavarga.bavMoon[i]}</td>
          <td class="center">${ashtakavarga.bavMars[i]}</td>
          <td class="center">${ashtakavarga.bavMercury[i]}</td>
          <td class="center">${ashtakavarga.bavJupiter[i]}</td>
          <td class="center">${ashtakavarga.bavVenus[i]}</td>
          <td class="center">${ashtakavarga.bavSaturn[i]}</td>
          <td class="center">${ashtakavarga.bavLagna[i]}</td>
          <td class="center bold $statusClass">$savPts</td>
          <td class="center bold ${isFav ? 'green-text' : ''}">$statusText</td>
        </tr>
""");
    }

    buffer.writeln("""
        <tr style="background: #fff2db; font-weight: 800;">
          <td class="bold center">మొత్తం (Total)</td>
          <td class="center">48</td>
          <td class="center">49</td>
          <td class="center">39</td>
          <td class="center">54</td>
          <td class="center">56</td>
          <td class="center">52</td>
          <td class="center">39</td>
          <td class="center">-</td>
          <td class="center gold-text">337</td>
          <td class="center gold-text">పరాశర నియమం</td>
        </tr>
      </tbody>
    </table>

    <div class="footer-note">
      $appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress
    </div>
  </div>
""");

    // PAGE 6: SHADBALA & GRAHA DIGNITIES & YOGAS
    buffer.writeln("""
  <div class="page">
    <div class="section-title">షడ్బల విశ్లేషణ & గ్రహ ర్యాంకులు (Shadbala Strengths)</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>గ్రహము</th>
          <th>స్థానబల</th>
          <th>దిగ్బల</th>
          <th>కాలబల</th>
          <th>చేష్టాబల</th>
          <th>నైసర్గిక</th>
          <th>దృగ్బల</th>
          <th>మొత్తం (రూపాలు)</th>
          <th>అవసరం</th>
          <th>నిష్పత్తి</th>
          <th>ర్యాంక్</th>
        </tr>
      </thead>
      <tbody>
""");

    for (final s in shadbala) {
      final isStrong = s.isStrong;
      final teluguPName = AstroConstants.planetNamesTelugu[s.planetName] ?? s.planetName;
      buffer.writeln("""
        <tr>
          <td class="bold">$teluguPName</td>
          <td class="center">${s.sthanaBala.toStringAsFixed(1)}</td>
          <td class="center">${s.digBala.toStringAsFixed(1)}</td>
          <td class="center">${s.kalaBala.toStringAsFixed(1)}</td>
          <td class="center">${s.chestaBala.toStringAsFixed(1)}</td>
          <td class="center">${s.naisargikaBala.toStringAsFixed(1)}</td>
          <td class="center">${s.drikBala.toStringAsFixed(1)}</td>
          <td class="center bold gold-text">${s.totalRupas.toStringAsFixed(2)}</td>
          <td class="center">${s.requiredRupas.toStringAsFixed(1)}</td>
          <td class="center bold ${isStrong ? 'green-text' : 'red-text'}">${s.strengthRatio.toStringAsFixed(2)}</td>
          <td class="center bold">#${s.rank}</td>
        </tr>
""");
    }

    buffer.writeln("""
      </tbody>
    </table>

    <div class="section-title">విశేష రాజయోగాలు & ధనయోగాలు (Active Vedic Yogas)</div>
""");

    if (yogas.isEmpty) {
      buffer.writeln('<div class="sloka-box">సాధారణ శుభ యోగములు కలవు.</div>');
    } else {
      for (final y in yogas) {
        buffer.writeln("""
      <div class="highlight-card">
        <div style="font-weight: 700; color: #8c2509; font-size: 11pt;">✦ ${y.teluguName} (${y.name})</div>
        <div style="font-size: 9.5pt; color: #572d11; margin-top: 2px;">${y.teluguDescription}</div>
      </div>
""");
      }
    }

    buffer.writeln("""
    <div class="section-title">దోష విశ్లేషణ & పరిహారములు (Dosha Analysis & Remedies)</div>
    <table class="data-table">
      <tr>
        <td class="bold" width="25%">కుజ దోషం (Kuja Dosha):</td>
        <td width="75%" class="bold ${!dosha.kujaDosha.hasDosha || dosha.kujaDosha.isCancelled ? 'green-text' : 'red-text'}">
          ${!dosha.kujaDosha.hasDosha ? "కుజ దోషం లేదు (నిర్దోషం)" : (dosha.kujaDosha.isCancelled ? "కుజ దోష పరిహార నివృత్తి అయింది (${dosha.kujaDosha.teluguReason})" : "కుజ దోష తీవ్రత ఉంది")}
        </td>
      </tr>
      <tr>
        <td class="bold">కాలసర్ప దోషం:</td>
        <td class="bold ${dosha.kalaSarpaDosha.hasDosha ? 'red-text' : 'green-text'}">
          ${dosha.kalaSarpaDosha.hasDosha ? "ఉంది — ${dosha.kalaSarpaDosha.teluguType}" : "కాలసర్ప దోషం లేదు"}
        </td>
      </tr>
      <tr>
        <td class="bold">పితృ దోషం:</td>
        <td class="bold ${dosha.pitruDosha.hasDosha ? 'red-text' : 'green-text'}">
          ${dosha.pitruDosha.hasDosha ? "లక్షణములు ఉన్నవి (${dosha.pitruDosha.teluguReason})" : "పితృ దోషం లేదు"}
        </td>
      </tr>
      <tr>
        <td class="bold">గురు చండాల దోషం:</td>
        <td class="bold ${dosha.guruChandalDosha.hasDosha ? 'red-text' : 'green-text'}">
          ${dosha.guruChandalDosha.hasDosha ? "ఉంది (గురు-రాహు సంయోగం)" : "లేదు"}
        </td>
      </tr>
    </table>

    <div class="footer-note">
      $appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress
    </div>
  </div>
""");

    // PAGE 7: VIMSHOTTARI DASHA FULL TIMELINES & SIGN-OFF
    buffer.writeln("""
  <div class="page">
    <div class="section-title">వింశోత్తరి దశా-భుక్తి కాలగమనం (Vimshottari Dasha Periods)</div>
    <div class="sloka-box">
      <b>జనన కాల దశా శేషము:</b> ${dashas.isNotEmpty ? dashas.first.planetTelugu : "కుజుడు"} మహాదశ
    </div>

    <table class="data-table">
      <thead>
        <tr>
          <th>మహాదశ (Maha Dasha)</th>
          <th>ప్రారంభ తేదీ (Start Date)</th>
          <th>ముగింపు తేదీ (End Date)</th>
          <th>వ్యవధి (Duration)</th>
          <th>స్థితి</th>
        </tr>
      </thead>
      <tbody>
""");

    final now = DateTime.now();
    for (final d in dashas) {
      final isCurrent = now.isAfter(d.startDate) && now.isBefore(d.endDate);
      final rowBg = isCurrent ? "style='background: #fff3db; font-weight: 800;'" : "";
      buffer.writeln("""
        <tr $rowBg>
          <td class="bold">${d.planetTelugu} మహాదశ ${isCurrent ? "<span class='badge badge-favorable'>ప్రస్తుతం జరుగుతున్నది</span>" : ""}</td>
          <td class="center">${DateFormat('dd-MM-yyyy').format(d.startDate)}</td>
          <td class="center">${DateFormat('dd-MM-yyyy').format(d.endDate)}</td>
          <td class="center">${(d.endDate.difference(d.startDate).inDays / 365.25).toStringAsFixed(1)} సం.</td>
          <td class="center bold ${isCurrent ? 'gold-text' : ''}">${isCurrent ? "నడుస్తున్న దశ" : (now.isAfter(d.endDate) ? "గడిచినది" : "భవిష్యత్")}</td>
        </tr>
""");
    }

    buffer.writeln("""
      </tbody>
    </table>

    <div class="section-title">గోచార ఫలితములు & రానున్న శుభ కాలములు (Transit & Auspicious Times)</div>
    <div class="highlight-card">
      <div style="font-weight: 700; color: #8c2509; margin-bottom: 4px;">✦ ఏలినాటి శని (Sade Sati) విశ్లేషణ:</div>
      <div style="font-size: 9.5pt; color: #572d11;">
        ${gochar.sadeSati.isActive ? "ప్రస్తుతం ఏలినాటి శని జరుగుతున్నది (${gochar.sadeSati.phaseTelugu}). శని శాంతి జపములు, శివార్చన, హనుమాన్ చాలీసా పారాయణము శ్రేయస్కరం." : "ప్రస్తుతం ఏలినాటి శని లేదు. అనుకూల గోచార ఫలితములు."}
      </div>
    </div>

    <div style="margin-top: 30px; border: 2px double #c98b2c; background: #fffcf4; padding: 18px; border-radius: 8px; text-align: center;">
      <div style="font-size: 14pt; font-weight: 800; color: #8c2509;">శుభం భూయాత్ • సర్వేజనా సుఖినోభవంతు</div>
      <div style="margin-top: 8px; font-size: 11pt; color: #4a2810; font-weight: 700;">
        జాతక విశ్లేషణ కర్త: <b>$astrologerName</b><br>
        మొబైల్: <b>$astrologerMobile</b><br>
        కార్యాలయ చిరునామా: $astrologerAddress<br>
        <span style="font-size: 9.5pt; color: #8a6245;"><b>$appTitle</b> - సమగ్ర వేద జ్యోతిష పరిశోధనా కేంద్రం</span>
      </div>
    </div>

    <div class="footer-note">
      గమనిక: ఈ జాతక ఫలితములు జన్మ సమయ గ్రహ స్పష్టతల ఆధారంగా వేద జ్యోతిష ప్రమాణముల ప్రకారం గణించబడినవి.
    </div>
  </div>
</body>
</html>
""");

    return buffer.toString();
  }

  static String _buildSouthIndianChartHtml(ChartData chart, {required String chartType}) {
    final signOccupants = List.generate(12, (_) => <String>[]);

    int lagnaIdx = chart.ascendant.rashiIndex;
    if (chartType == 'D9') {
      int totalPada = (((chart.ascendant.longitude % 360.0) / AstroConstants.padaSpan).floor()) % 108;
      lagnaIdx = totalPada % 12;
    } else if (chartType == 'D10') {
      int part = (chart.ascendant.degreesInRashi / 3.0).floor().clamp(0, 9);
      lagnaIdx = lagnaIdx % 2 == 0 ? (lagnaIdx + part) % 12 : ((lagnaIdx + 8) + part) % 12;
    } else if (chartType == 'D7') {
      int part = (chart.ascendant.degreesInRashi / (30.0 / 7.0)).floor().clamp(0, 6);
      lagnaIdx = lagnaIdx % 2 == 0 ? (lagnaIdx + part) % 12 : ((lagnaIdx + 6) + part) % 12;
    }

    signOccupants[lagnaIdx].add('<span class="lagna-badge">ల</span>');

    for (final p in chart.planets) {
      int signIdx = p.rashiIndex;
      if (chartType == 'D9') {
        signIdx = p.navamsaRashiIndex;
      } else if (chartType == 'D10') {
        signIdx = p.dasamsaRashiIndex;
      } else if (chartType == 'D7') {
        signIdx = p.saptamsaRashiIndex;
      }
      final abbr = AstroConstants.planetAbbrTelugu[p.name] ?? p.abbreviation;
      signOccupants[signIdx].add(p.isRetrograde ? '$abbr(వ)' : abbr);
    }

    final grid = AstroConstants.southIndianGrid;
    final sb = StringBuffer();
    sb.writeln('<div class="si-chart">');

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if ((r == 1 || r == 2) && (c == 1 || c == 2)) {
          if (r == 1 && c == 1) {
            sb.writeln('''
              <div class="si-cell center-box">
                <div style="font-size: 11pt; color: #b3391b;">卐</div>
                $chartType<br>
                <span style="font-size: 8pt; color: #7a3a0e;">${chartType == 'D1' ? 'రాశి' : (chartType == 'D9' ? 'నవాంశ' : chartType)}</span>
              </div>
            ''');
          }
          continue;
        }

        final signIdx = grid[r][c];
        final signName = AstroConstants.rashis[signIdx];
        final planetsHtml = signOccupants[signIdx].join(' ');

        sb.writeln('''
          <div class="si-cell">
            <span class="si-sign-name">$signName</span>
            <div class="si-planets">$planetsHtml</div>
          </div>
        ''');
      }
    }

    sb.writeln('</div>');
    return sb.toString();
  }

  static String _formatDms(double deg) {
    deg = deg % 360.0;
    int d = deg.floor();
    double mTotal = (deg - d) * 60.0;
    int m = mTotal.floor();
    int s = ((mTotal - m) * 60.0).round();
    return '$d°${m.toString().padLeft(2, '0')}\'${s.toString().padLeft(2, '0')}"';
  }

  static String _getTeluguPlanetName(String name) {
    return AstroConstants.planetNamesTelugu[name] ?? name;
  }

  static String _getTeluguDignity(PlanetPosition p) {
    final dig = p.dignity;
    switch (dig) {
      case 'Exalted': return 'ఉచ్ఛ (Exalted)';
      case 'Debilitated': return 'నీచ (Debilitated)';
      case 'Own Sign': return 'స్వక్షేత్రం (Own)';
      case 'Friendly': return 'మిత్ర క్షేత్రం';
      case 'Enemy': return 'శత్రు క్షేత్రం';
      default: return 'సమ క్షేత్రం';
    }
  }

  static String _getKarakaDescription(String abbr) {
    switch (abbr) {
      case 'AK': return 'ఆత్మకారకుడు - జీవాత్మ, వ్యక్తిత్వము, ఆయుష్షు';
      case 'AmK': return 'అమాత్యకారకుడు - వృత్తి, ఉద్యోగము, తెలివితేటలు';
      case 'BK': return 'భ్రాతృకారకుడు - సోదరులు, గురువు, ధైర్యము';
      case 'MK': return 'మాతృకారకుడు - తల్లి, వాహనము, గృహ సౌఖ్యము';
      case 'PK': return 'పుత్రకారకుడు - సంతానము, విద్య, పూర్వపుణ్యము';
      case 'GK': return 'జ్ఞాతికారుడు - బంధువులు, శత్రువులు, పోటీలు';
      case 'DK': return 'దారకారకుడు - వివాహ భాగస్వామి, దాంపత్యం';
      default: return '';
    }
  }

  static String _calculateTithiTelugu(double sunLon, double moonLon) {
    final diff = (moonLon - sunLon + 360.0) % 360.0;
    final tithiIndex = (diff / 12.0).floor();
    final paksha = tithiIndex < 15 ? 'శుక్ల పక్ష' : 'కృష్ణ పక్ష';
    final tithiNum = (tithiIndex % 15) + 1;
    final names = ['పాడ్యమి', 'విదియ', 'తదియ', 'చవితి', 'పంచమి', 'షష్ఠి', 'సప్తమి', 'అష్టమి', 'నవమి', 'దశమి', 'ఏకాదశి', 'ద్వాదశి', 'త్రయోదశి', 'చతుర్దశి', 'పూర్ణిమ / అమావాస్య'];
    final name = names[tithiNum - 1];
    return '$paksha $name ($tithiNum)';
  }

  static String _calculateNityaYogaTelugu(double sunLon, double moonLon) {
    final sum = (sunLon + moonLon) % 360.0;
    final yogaIdx = (sum / (360.0 / 27.0)).floor() % 27;
    final yogas = [
      'విష్కంభ', 'ప్రీతి', 'ఆయుష్మాన్', 'సౌభాగ్య', 'శోభన', 'అతిగండ', 'సుకర్మ', 'ధృతి', 'శూల',
      'గండ', 'వృద్ధి', 'ధ్రువ', 'వ్యాఘాత', 'హర్షణ', 'వజ్ర', 'సిద్ధి', 'వ్యతీపాత', 'వరియాన్',
      'పరిగ', 'శివ', 'సిద్ధ', 'సాధ్య', 'శుభ', 'శుభ్ర', 'బ్రహ్మ', 'ఐంద్ర', 'వైధృతి',
    ];
    return yogas[yogaIdx];
  }

  static String _calculateKaranaTelugu(double sunLon, double moonLon) {
    final diff = (moonLon - sunLon + 360.0) % 360.0;
    final karanaIdx = (diff / 6.0).floor() % 60;
    final names = ['బవ', 'బాలవ', 'కౌలవ', 'తైతుల', 'గరజి', 'వణిజ', 'విష్టి (భద్ర)'];
    if (karanaIdx == 0) return 'కింస్తుఘ్న';
    if (karanaIdx >= 57) {
      if (karanaIdx == 57) return 'శకుని';
      if (karanaIdx == 58) return 'చతుష్పాద';
      return 'నాగవ';
    }
    return names[(karanaIdx - 1) % 7];
  }
}
'''

screen_dart = r'''import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/astro_constants.dart';
import '../../../core/utils/web_download_helper.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/ashtakavarga_service.dart';
import '../../../data/services/shadbala_service.dart';
import '../../../data/services/yoga_service.dart';
import '../../../data/services/dosha_service.dart';
import '../../../data/services/transit_service.dart';
import '../../../data/services/kp_service.dart';
import '../../../data/services/dasha_service.dart';
import '../../../data/services/special_points_service.dart';
import '../../../data/services/telugu_horoscope_report_generator.dart';

class TeluguPdfReportScreen extends StatelessWidget {
  final ChartData chartData;
  final AshtakavargaData ashtakavarga;
  final List<PlanetShadbala> shadbala;
  final List<VedicYoga> yogas;
  final DoshaAnalysis dosha;
  final GocharAnalysis gochar;
  final KPAnalysis kp;
  final List<DashaPeriod> dashas;

  const TeluguPdfReportScreen({
    super.key,
    required this.chartData,
    required this.ashtakavarga,
    required this.shadbala,
    required this.yogas,
    required this.dosha,
    required this.gochar,
    required this.kp,
    required this.dashas,
  });

  String _getHtmlReport() {
    return TeluguHoroscopeReportGenerator.generatePrintableHtml(
      chart: chartData,
      ashtakavarga: ashtakavarga,
      shadbala: shadbala,
      yogas: yogas,
      dosha: dosha,
      gochar: gochar,
      kp: kp,
      dashas: dashas,
    );
  }

  void _printReport(BuildContext context) async {
    final html = _getHtmlReport();
    final name = chartData.birthData.name.isEmpty ? "జాతక_చక్రం" : chartData.birthData.name;
    try {
      await Printing.layoutPdf(
        onLayout: (format) async => await Printing.convertHtml(
          format: format,
          html: html,
        ),
        name: 'శ్రీ_బాల_జ్యోతిర్_వాస్తు_$name',
      );
    } catch (e) {
      // Fallback to open in new tab
      openInNewTab(html);
    }
  }

  void _downloadHtmlReport(BuildContext context) {
    final html = _getHtmlReport();
    final name = chartData.birthData.name.isEmpty ? "Horoscope" : chartData.birthData.name.replaceAll(' ', '_');
    final filename = 'Sri_Bala_Jyothir_Vasthu_${name}_Report.html';
    downloadFile(filename, html);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('రిపోర్ట్ ఫైల్ డౌన్‌లోడ్ అయింది ($filename). బ్రౌజర్‌లో ఓపెన్ చేసి Ctrl+P తో PDF గా సేవ్ చేసుకోవచ్చు.'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _openInBrowserTab(BuildContext context) {
    final html = _getHtmlReport();
    openInNewTab(html);
  }

  @override
  Widget build(BuildContext context) {
    final bd = chartData.birthData;
    final dateStr = DateFormat('dd-MM-yyyy').format(bd.dateTime);
    final timeStr = DateFormat('hh:mm a').format(bd.dateTime);
    final specialPoints = SpecialPointsService.calculate(chartData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              TeluguHoroscopeReportGenerator.appTitle,
              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 15),
            ),
            Text(
              '${bd.name.isEmpty ? "జాతక చక్రం" : bd.name} • $dateStr $timeStr',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Download Report File',
            icon: const Icon(Icons.download_rounded, color: AppColors.gold),
            onPressed: () => _downloadHtmlReport(context),
          ),
          IconButton(
            tooltip: 'Open in New Window',
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white70),
            onPressed: () => _openInBrowserTab(context),
          ),
          ElevatedButton.icon(
            onPressed: () => _printReport(context),
            icon: const Icon(Icons.print, size: 16),
            label: const Text('ప్రింట్ / PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgDark, Color(0xFF13101E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── TOP ACTION BANNER ───
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: AppColors.gold, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'సంపూర్ణ జాతక చక్రం PDF రిపోర్ట్ సిద్ధంగా ఉంది',
                            style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const Text(
                            'డౌన్‌లోడ్ లేదా ప్రింట్ చేసుకోవడానికి బటన్లను ఉపయోగించండి',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _downloadHtmlReport(context),
                      icon: const Icon(Icons.download, size: 16, color: AppColors.gold),
                      label: const Text('డౌన్‌లోడ్', style: TextStyle(color: AppColors.gold, fontSize: 12)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.gold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── COVER BANNER ───
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    const Text('卐 శ్రీః 卐', style: TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text(
                      TeluguHoroscopeReportGenerator.appTitle,
                      style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    const Text('సంపూర్ణ జాతక చక్ర విశ్లేషణ & ఫలిత పత్రిక', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.bgCardLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'జ్యోతిష విద్వాన్: ${TeluguHoroscopeReportGenerator.astrologerName} • మొబైల్: ${TeluguHoroscopeReportGenerator.astrologerMobile}',
                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── SECTION 1: SPECIAL POINTS (YOGI, AVAYOGI, BHRIGU BINDU) ───
              _buildSectionHeader('1. యోగి, అవయోగి & భృగు బిందువు (Special Points)'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    _buildRowItem('యోగి స్థానము & నక్షత్రం', '${specialPoints.yogiRashi} (${specialPoints.yogiLongitude.toStringAsFixed(1)}°) — ${specialPoints.yogiNakshatra} (${specialPoints.yogiPada})', Colors.greenAccent),
                    _buildRowItem('యోగి గ్రహము (Yogi Planet)', specialPoints.yogiPlanet, Colors.greenAccent),
                    _buildRowItem('సహయోగి గ్రహము (Duplicate Yogi)', specialPoints.sahayogiPlanet, Colors.greenAccent),
                    _buildRowItem('అవయోగి నక్షత్రం & గ్రహం', '${specialPoints.avayogiNakshatra} — ${specialPoints.avayogiPlanet}', Colors.redAccent),
                    const Divider(color: AppColors.chartBorder, height: 16),
                    _buildRowItem('భృగు బిందువు (Bhrigu Bindu)', '${specialPoints.bhriguBinduRashi} (${specialPoints.bhriguBinduRashiDeg.toStringAsFixed(1)}°)', AppColors.gold),
                    _buildRowItem('భృగు నక్షత్రం & భావం', '${specialPoints.bhriguBinduNakshatra} (${specialPoints.bhriguBinduPada}వ పాదం) — ${specialPoints.bhriguBinduHouse}వ భావం', AppColors.gold),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── SECTION 2: JAIMINI CHARA KARAKAS ───
              _buildSectionHeader('2. జైమిని చర కారకములు (Jaimini Chara Karakas)'),
              const SizedBox(height: 8),
              _buildInfoTable(
                specialPoints.charaKarakas.map((k) => (
                  '${k.abbreviation} - ${k.nameTelugu}',
                  '${k.planetTelugu} (${k.rashiTelugu} ${k.degreeInRashi.toStringAsFixed(1)}°)'
                )).toList(),
              ),

              const SizedBox(height: 16),

              // ─── SECTION 3: BIRTH DETAILS ───
              _buildSectionHeader('3. జన్మ & పంచాంగ వివరములు'),
              const SizedBox(height: 8),
              _buildInfoTable([
                ('పేరు', bd.name.isEmpty ? 'శ్రీమాన్' : bd.name),
                ('లింగము', bd.gender == 'female' ? 'స్త్రీ (Female)' : 'పురుష (Male)'),
                ('జన్మ దినము', '$dateStr (${DateFormat('EEEE').format(bd.dateTime)})'),
                ('సమయము', '$timeStr (IST)'),
                ('జన్మ స్థానము', bd.cityName),
                ('లగ్నము', '${chartData.ascendant.rashi} (${chartData.ascendant.shortDegInRashi})'),
                ('లగ్న నక్షత్రము', '${chartData.ascendant.nakshatra} - ${chartData.ascendant.pada}వ పాదం'),
                ('జన్మ రాశి', chartData.getPlanet('Moon')?.rashi ?? 'కుంభం'),
                ('జన్మ నక్షత్రము', '${chartData.getPlanet('Moon')?.nakshatra ?? "ధనిష్ఠ"} - ${chartData.getPlanet('Moon')?.pada ?? 3}వ పాదం'),
              ]),

              const SizedBox(height: 16),

              // ─── SECTION 4: ASHTAKAVARGA & SHADBALA ───
              _buildSectionHeader('4. సర్వాష్టకవర్గ (SAV) & షడ్బల ర్యాంకులు'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.chartBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('మొత్తం బిందువులు: ${ashtakavarga.totalSAV} (337 Standard)', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(12, (i) {
                        int b = ashtakavarga.sav[i];
                        bool isFav = b >= 28;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isFav ? Colors.green.withValues(alpha: 0.15) : AppColors.bgCardLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isFav ? Colors.green : AppColors.chartBorder),
                          ),
                          child: Text(
                            '${AstroConstants.rashis[i]}: $b',
                            style: TextStyle(
                              color: isFav ? Colors.greenAccent : AppColors.textSecondary,
                              fontWeight: isFav ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─── SECTION 5: YOGAS & DOSHAS ───
              _buildSectionHeader('5. విశేష యోగములు & దోష విశ్లేషణ'),
              const SizedBox(height: 8),
              ...yogas.map((y) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✦ ${y.teluguName}', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(y.teluguDescription, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
              )),

              const SizedBox(height: 8),

              // Kuja Dosha Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: !dosha.kujaDosha.hasDosha || dosha.kujaDosha.isCancelled ? Colors.green : Colors.orange,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !dosha.kujaDosha.hasDosha
                          ? 'కుజ దోషం: లేదు (నిర్దోషం)'
                          : (dosha.kujaDosha.isCancelled
                              ? 'కుజ దోషం: పరిహార నివృత్తి అయింది'
                              : 'కుజ దోషం: ${dosha.kujaDosha.severity} తీవ్రత ఉంది'),
                      style: TextStyle(
                        color: !dosha.kujaDosha.hasDosha || dosha.kujaDosha.isCancelled ? Colors.greenAccent : Colors.orangeAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (dosha.kujaDosha.isCancelled) ...[
                      const SizedBox(height: 2),
                      Text(dosha.kujaDosha.teluguReason, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── FOOTER CONTACT CARD ───
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCardLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'జాతక పరిశీలన & సంప్రదింపులు',
                      style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      TeluguHoroscopeReportGenerator.astrologerName,
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      TeluguHoroscopeReportGenerator.astrologerAddress,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'మొబైల్: ${TeluguHoroscopeReportGenerator.astrologerMobile}',
                      style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        const Icon(Icons.star_rate, color: AppColors.gold, size: 16),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildRowItem(String label, String value, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(value, style: TextStyle(color: valColor, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInfoTable(List<(String, String)> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.chartBorder),
      ),
      child: Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.$1, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Text(item.$2, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
'''

target1 = '/home/karrthikuuuuu/Documents/Projects/jhora_mobile/lib/data/services/telugu_horoscope_report_generator.dart'
target2 = '/home/karrthikuuuuu/Documents/Projects/jhora_mobile/lib/features/report/telugu_pdf_report_screen.dart'

with open(target1, 'w', encoding='utf-8') as f:
    f.write(gen_dart)
print('Updated', target1)

with open(target2, 'w', encoding='utf-8') as f:
    f.write(screen_dart)
print('Updated', target2)
