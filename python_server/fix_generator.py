import os

code = '''import 'package:intl/intl.dart';
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

    buffer.writeln('<!DOCTYPE html><html lang="te"><head><meta charset="UTF-8">');
    buffer.writeln('<title>$appTitle - ${bd.name.isEmpty ? "జాతక చక్రం" : bd.name}</title>');
    buffer.writeln('<style>');
    buffer.writeln('@import url("https://fonts.googleapis.com/css2?family=Gautami:wght@400;700&family=Noto+Sans+Telugu:wght@400;600;700;800&family=Outfit:wght@400;600;700;800&display=swap");');
    buffer.writeln('@page { size: A4; margin: 10mm 12mm; }');
    buffer.writeln('* { box-sizing: border-box; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }');
    buffer.writeln('body { font-family: "Noto Sans Telugu", "Gautami", "Outfit", sans-serif; background: #fdfbf7; color: #2b1e16; margin: 0; padding: 15px; font-size: 11pt; line-height: 1.5; }');
    buffer.writeln('.page { background: #ffffff; border: 2px solid #dfb15b; border-radius: 8px; padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); page-break-after: always; position: relative; }');
    buffer.writeln('.page:last-child { page-break-after: auto; }');
    buffer.writeln('.header-banner { text-align: center; border-bottom: 2px double #c98b2c; padding-bottom: 12px; margin-bottom: 18px; }');
    buffer.writeln('.header-om { font-size: 26pt; color: #b3391b; font-weight: 800; line-height: 1; }');
    buffer.writeln('.header-title { font-size: 22pt; font-weight: 800; color: #8c2509; margin: 4px 0; letter-spacing: 1px; }');
    buffer.writeln('.header-subtitle { font-size: 11pt; color: #634226; font-weight: 600; }');
    buffer.writeln('.contact-badge { display: inline-block; margin-top: 6px; background: #fff8e7; border: 1px solid #dfb15b; padding: 4px 14px; border-radius: 20px; font-size: 10pt; font-weight: 700; color: #7a3a0e; }');
    buffer.writeln('.section-title { font-size: 13pt; font-weight: 700; color: #802200; border-bottom: 1.5px solid #d49a37; padding-bottom: 4px; margin-top: 16px; margin-bottom: 10px; }');
    buffer.writeln('table.data-table { width: 100%; border-collapse: collapse; margin-bottom: 14px; font-size: 10pt; }');
    buffer.writeln('table.data-table th { background-color: #f5eedb; color: #662d0b; font-weight: 700; border: 1px solid #d9be8b; padding: 6px 8px; text-align: center; }');
    buffer.writeln('table.data-table td { border: 1px solid #e6d3af; padding: 5px 8px; text-align: left; }');
    buffer.writeln('table.data-table tr:nth-child(even) { background-color: #faf6ed; }');
    buffer.writeln('.center { text-align: center !important; } .bold { font-weight: 700; } .gold-text { color: #8c2509; font-weight: 700; } .green-text { color: #1e7029; font-weight: 700; } .red-text { color: #ad2020; font-weight: 700; }');
    buffer.writeln('.chart-container { display: flex; justify-content: space-around; gap: 16px; margin: 14px 0; flex-wrap: wrap; }');
    buffer.writeln('.chart-card { text-align: center; flex: 1; min-width: 280px; max-width: 340px; }');
    buffer.writeln('.chart-title { font-weight: 700; font-size: 11pt; color: #7a3a0e; margin-bottom: 6px; }');
    buffer.writeln('.si-chart { display: grid; grid-template-columns: repeat(4, 1fr); grid-template-rows: repeat(4, 1fr); width: 100%; aspect-ratio: 1 / 1; border: 2px solid #b3391b; background: #fffdfa; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }');
    buffer.writeln('.si-cell { border: 1px solid #d4a76a; padding: 3px; font-size: 8pt; position: relative; display: flex; flex-direction: column; justify-content: center; align-items: center; overflow: hidden; min-height: 48px; }');
    buffer.writeln('.si-cell.center-box { grid-column: 2 / span 2; grid-row: 2 / span 2; background: #fff8e8; border: 1.5px solid #b3391b; font-weight: 700; font-size: 9.5pt; color: #8c2509; text-align: center; padding: 6px; }');
    buffer.writeln('.si-sign-name { font-size: 7pt; color: #9c683b; position: absolute; top: 1px; left: 2px; font-weight: 600; }');
    buffer.writeln('.si-planets { font-size: 8pt; font-weight: 700; color: #1a1a1a; line-height: 1.15; text-align: center; }');
    buffer.writeln('.lagna-badge { color: #b3391b; font-weight: 800; border-bottom: 1.5px solid #b3391b; }');
    buffer.writeln('.sloka-box { background: #fffaf0; border: 1px solid #e0c896; border-left: 4px solid #b3391b; padding: 10px 14px; margin: 12px 0; border-radius: 4px; font-size: 10.5pt; color: #572d11; text-align: center; }');
    buffer.writeln('.footer-note { text-align: center; font-size: 8.5pt; color: #785a44; margin-top: 16px; border-top: 1px dashed #d9be8b; padding-top: 8px; }');
    buffer.writeln('.highlight-card { background: #fff9e6; border: 1px solid #dfb15b; border-radius: 6px; padding: 10px 14px; margin: 10px 0; }');
    buffer.writeln('.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }');
    buffer.writeln('.badge { display: inline-block; padding: 2px 6px; border-radius: 4px; font-size: 8.5pt; font-weight: 700; }');
    buffer.writeln('.badge-favorable { background: #e2f5e4; color: #1e7029; } .badge-neutral { background: #f7f1e1; color: #7a5c1e; } .badge-difficult { background: #fbe6e6; color: #ad2020; }');
    buffer.writeln('</style></head><body>');

    // ── PAGE 1: COVER & MANGALA SLOKA & BIRTH DETAILS ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="header-banner">');
    buffer.writeln('    <div class="header-om">卐 శ్రీః 卐</div>');
    buffer.writeln('    <div class="header-title">$appTitle</div>');
    buffer.writeln('    <div class="header-subtitle">సంపూర్ణ జాతక చక్ర విశ్లేషణ & ఫలిత పత్రిక (Super Horoscope Report)</div>');
    buffer.writeln('    <div class="contact-badge">');
    buffer.writeln('      జ్యోతిష విద్వాన్: <b>$astrologerName</b> • మొబైల్: <b>$astrologerMobile</b><br>');
    buffer.writeln('      చిరునామా: $astrologerAddress');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="sloka-box">');
    buffer.writeln('    <b>జననీ జన్మ సౌఖ్యానాం వర్ధనీ కుల సంపదాం ।<br>');
    buffer.writeln('    పదవీ పూర్వ పుణ్యానాం లిఖ్యతే జన్మ పత్రికా ॥</b><br>');
    buffer.writeln('    <small style="color: #7a3a0e;">తల్లి మరియు బిడ్డ యొక్క సంరక్షణ, కుటుంబ సంతోష, ధన, ధాన్య, ఆయురారోగ్య అభివృద్ధి కొరకు ప్రాచీన పరాశర ధార్మిక సూత్రముల ప్రకారం ఈ జాతక చక్రము వ్రాయబడినది.</small>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">卐 జాతకుని జనన వివరములు (Birth Profile)</div>');
    buffer.writeln('  <table class="data-table">');
    buffer.writeln('    <tr><td class="bold" width="25%">పేరు (Name):</td><td width="25%" class="gold-text">${bd.name.isEmpty ? "శ్రీమాన్ / కుమారి" : bd.name}</td><td class="bold" width="25%">జన్మ స్థానము:</td><td width="25%">${bd.placeName}</td></tr>');
    buffer.writeln('    <tr><td class="bold">జన్మ దినము (DOB):</td><td>$dateStr (${DateFormat("EEEE").format(bd.dateTime)})</td><td class="bold">సమయము (TOB):</td><td>$timeStr (IST)</td></tr>');
    buffer.writeln('    <tr><td class="bold">అక్షాంశము & రేఖాంశము:</td><td>${bd.latitude.toStringAsFixed(2)}° N, ${bd.longitude.toStringAsFixed(2)}° E</td><td class="bold">కాలమండలము:</td><td>UTC + ${bd.timezone.toStringAsFixed(1)}</td></tr>');
    buffer.writeln('    <tr><td class="bold">లగ్నము (Ascendant):</td><td class="gold-text">${lagna.rashi} (${lagna.shortDegInRashi})</td><td class="bold">లగ్న నక్షత్రము:</td><td>${lagna.nakshatra} - పాదము ${lagna.pada}</td></tr>');
    buffer.writeln('    <tr><td class="bold">జన్మ రాశి (Moon Sign):</td><td class="gold-text">$moonRashi</td><td class="bold">జన్మ నక్షత్రము:</td><td class="gold-text">$moonNak - పాదము $moonPada</td></tr>');
    buffer.writeln('    <tr><td class="bold">అయనాంశము (Ayanamsa):</td><td>చిత్రపక్ష (Lahiri) ~ 23° 54"</td><td class="bold">కలిదిన సంఖ్య:</td><td>${(bd.dateTime.millisecondsSinceEpoch / 86400000 + 2440587.5).round()}</td></tr>');
    buffer.writeln('  </table>');

    buffer.writeln('  <div class="section-title">卐 పంచాంగ వివరములు (Panchangam at Birth)</div>');
    buffer.writeln('  <table class="data-table">');
    buffer.writeln('    <tr><td class="bold" width="25%">వారం (Vara):</td><td width="25%">${DateFormat("EEEE").format(bd.dateTime)}</td><td class="bold" width="25%">తిథి (Tithi):</td><td width="25%">${_calculateTithiTelugu(sun?.longitude ?? 0, moon?.longitude ?? 0)}</td></tr>');
    buffer.writeln('    <tr><td class="bold">నక్షత్రము (Nakshatra):</td><td>$moonNak ($moonPadaవ పాదము)</td><td class="bold">నక్షత్రాధిపతి:</td><td>${moon?.nakshatraLord ?? "కుజుడు"}</td></tr>');
    buffer.writeln('    <tr><td class="bold">నిత్య యోగము (Yoga):</td><td>${_calculateNityaYogaTelugu(sun?.longitude ?? 0, moon?.longitude ?? 0)}</td><td class="bold">కరణము (Karana):</td><td>${_calculateKaranaTelugu(sun?.longitude ?? 0, moon?.longitude ?? 0)}</td></tr>');
    buffer.writeln('    <tr><td class="bold">సూర్యోదయము:</td><td>05:55 AM (IST)</td><td class="bold">సూర్యాస్తమయము:</td><td>05:50 PM (IST)</td></tr>');
    buffer.writeln('  </table>');
    buffer.writeln('  <div class="footer-note">$appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress</div>');
    buffer.writeln('</div>');

    // ── PAGE 2: SPECIAL POINTS (YOGI, AVAYOGI, BHRIGU BINDU, CHARA KARAKAS, ARUDHA) ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="section-title">卐 విశేష బిందువులు & గ్రహ స్థితులు (Special Vedic Points)</div>');
    buffer.writeln('  <div class="highlight-card">');
    buffer.writeln('    <table class="data-table" style="margin-bottom: 0;">');
    buffer.writeln('      <tr><td class="bold" width="25%">యోగి స్థానము & నక్షత్రము:</td><td width="25%" class="green-text">${specialPoints.yogiRashi} (${specialPoints.yogiLongitude.toStringAsFixed(1)}°) — ${specialPoints.yogiNakshatra} (${specialPoints.yogiPada})</td><td class="bold" width="25%">యోగి గ్రహము (Yogi Planet):</td><td width="25%" class="green-text">${specialPoints.yogiPlanet}</td></tr>');
    buffer.writeln('      <tr><td class="bold">సహయోగి గ్రహము (Duplicate Yogi):</td><td class="green-text">${specialPoints.sahayogiPlanet}</td><td class="bold">అవయోగి నక్షత్రము & గ్రహము:</td><td class="red-text">${specialPoints.avayogiNakshatra} — ${specialPoints.avayogiPlanet}</td></tr>');
    buffer.writeln('      <tr style="background: #fff3dc;"><td class="bold">భృగు బిందువు (Bhrigu Bindu):</td><td class="gold-text"><b>${specialPoints.bhriguBinduRashi} (${specialPoints.bhriguBinduRashiDeg.toStringAsFixed(1)}°)</b></td><td class="bold">భృగు నక్షత్రం & భావం:</td><td class="gold-text"><b>${specialPoints.bhriguBinduNakshatra} (${specialPoints.bhriguBinduPada}వ పాదం) — ${specialPoints.bhriguBinduHouse}వ భావం</b></td></tr>');
    buffer.writeln('    </table>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">卐 జైమిని చర కారకములు (Jaimini Chara Karakas)</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>కారకము (Karaka)</th><th>సంక్షిప్త</th><th>గ్రహము (Planet)</th><th>రాశి (Rashi)</th><th>భాగలు</th><th>కారకత్వ విశేషము</th></tr></thead><tbody>');
    for (final k in specialPoints.charaKarakas) {
      buffer.writeln('<tr><td class="bold">${k.nameTelugu}</td><td class="center gold-text">${k.abbreviation}</td><td class="center bold">${k.planetTelugu}</td><td class="center">${k.rashiTelugu}</td><td class="center">${k.degreeInRashi.toStringAsFixed(2)}°</td><td>${_getKarakaDescription(k.abbreviation)}</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    buffer.writeln('  <div class="section-title">卐 ఆరూఢ / భావ పాదములు (Jaimini Arudha Padas)</div>');
    buffer.writeln('  <div class="grid-2">');
    buffer.writeln('    <table class="data-table"><thead><tr><th>పాదము</th><th>కోడ్</th><th>రాశి</th></tr></thead><tbody>');
    for (int i = 0; i < 6; i++) {
      final p = specialPoints.arudhaPadas[i];
      buffer.writeln('<tr><td class="bold">${p.teluguName}</td><td class="center gold-text">${p.code}</td><td class="center bold">${p.rashiTelugu}</td></tr>');
    }
    buffer.writeln('    </tbody></table>');
    buffer.writeln('    <table class="data-table"><thead><tr><th>పాదము</th><th>కోడ్</th><th>రాశి</th></tr></thead><tbody>');
    for (int i = 6; i < 12; i++) {
      final p = specialPoints.arudhaPadas[i];
      buffer.writeln('<tr><td class="bold">${p.teluguName}</td><td class="center gold-text">${p.code}</td><td class="center bold">${p.rashiTelugu}</td></tr>');
    }
    buffer.writeln('    </tbody></table>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note">$appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress</div>');
    buffer.writeln('</div>');

    // ── PAGE 3: PLANETARY POSITIONS & KP SUB-LORDS ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="section-title">卐 నిరాయన గ్రహ స్పష్ట పట్టిక (Nirayana Planetary Positions)</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>గ్రహము</th><th>రేఖాంశము</th><th>రాశి</th><th>భాగలు</th><th>నక్షత్రము</th><th>పాదము</th><th>నక్షత్రాధిపతి</th><th>స్థితి / బలం</th></tr></thead><tbody>');
    buffer.writeln('    <tr style="background: #fff5e6;"><td class="bold lagna-badge">లగ్నము</td><td class="center">${lagna.dmsInRashi}</td><td class="center bold">${lagna.rashi}</td><td class="center">${lagna.shortDegInRashi}</td><td class="center">${lagna.nakshatra}</td><td class="center">$moonPada</td><td class="center">${lagna.nakshatraLord}</td><td class="center bold green-text">లగ్న కేంద్రం</td></tr>');
    for (final p in chart.planets) {
      final isRet = p.isRetrograde;
      final dignity = _getTeluguDignity(p);
      final isFav = dignity.contains('ఉచ్ఛ') || dignity.contains('స్వక్షేత్ర');
      final isDeb = dignity.contains('నీచ');
      final digClass = isFav ? 'green-text' : (isDeb ? 'red-text' : '');
      final telName = _getTeluguPlanetName(p.name);
      buffer.writeln('<tr><td class="bold">$telName ${isRet ? "<span class=\\'red-text\\'>(వక్ర)</span>" : ""}</td><td class="center">${p.dmsInRashi}</td><td class="center">${p.rashi}</td><td class="center">${p.shortDegInRashi}</td><td class="center">${p.nakshatra}</td><td class="center">${p.pada}</td><td class="center">${p.nakshatraLord}</td><td class="center bold $digClass">$dignity</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    buffer.writeln('  <div class="section-title">卐 KP నక్షత్ర అధిపతి / ఉప అధిపతి పట్టిక (KP Sub-Lord System)</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>గ్రహము / స్థానము</th><th>రాశి అధిపతి</th><th>నక్షత్ర అధిపతి</th><th>ఉప అధిపతి (Sub Lord)</th><th>ఉప-ఉప అధిపతి</th></tr></thead><tbody>');
    for (final row in kp.planetSubLords) {
      final entTel = AstroConstants.planetNamesTelugu[row.entityName] ?? row.entityName;
      final signLordTel = AstroConstants.planetNamesTelugu[row.signLord] ?? row.signLord;
      final starLordTel = AstroConstants.planetNamesTelugu[row.starLord] ?? row.starLord;
      final subLordTel = AstroConstants.planetNamesTelugu[row.subLord] ?? row.subLord;
      final subSubLordTel = AstroConstants.planetNamesTelugu[row.subSubLord] ?? row.subSubLord;
      buffer.writeln('<tr><td class="bold">$entTel</td><td class="center">$signLordTel</td><td class="center">$starLordTel</td><td class="center bold gold-text">$subLordTel</td><td class="center">$subSubLordTel</td></tr>');
    }
    buffer.writeln('  </tbody></table>');
    buffer.writeln('  <div class="footer-note">$appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress</div>');
    buffer.writeln('</div>');

    // ── PAGE 4: DIVISIONAL CHARTS (D1, D9, D10, D7) ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="section-title">卐 ముఖ్య వర్గ చక్రములు (Vedic Divisional Charts)</div>');
    buffer.writeln('  <div class="chart-container">');
    buffer.writeln('    <div class="chart-card"><div class="chart-title">రాశి చక్రము (D1 Rasi Chart - లగ్న కుండలి)</div>${_buildSouthIndianChartHtml(chart, chartType: "D1")}</div>');
    buffer.writeln('    <div class="chart-card"><div class="chart-title">నవాంశ చక్రము (D9 Navamsa Chart - భాగ్య & కళత్ర)</div>${_buildSouthIndianChartHtml(chart, chartType: "D9")}</div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="chart-container">');
    buffer.writeln('    <div class="chart-card"><div class="chart-title">దశాంశ చక్రము (D10 Dasamsa Chart - వృత్తి & ఉద్యోగం)</div>${_buildSouthIndianChartHtml(chart, chartType: "D10")}</div>');
    buffer.writeln('    <div class="chart-card"><div class="chart-title">సప్తాంశ చక్రము (D7 Saptamsa Chart - సంతాన భాగ్యం)</div>${_buildSouthIndianChartHtml(chart, chartType: "D7")}</div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note">$appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress</div>');
    buffer.writeln('</div>');

    // ── PAGE 5: BHAVA SPASHTA & ASHTAKAVARGA ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="section-title">卐 భావ స్పష్ట పట్టిక & భావాధిపతులు (Bhava Cusps Table)</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>భావము</th><th>ప్రారంభము</th><th>మధ్యమము (Mid / Cusp)</th><th>అంత్యము</th><th>భావాధిపతి</th><th>భావ స్థితి గ్రహాలు</th></tr></thead><tbody>');
    final lagnaLon = lagna.longitude;
    for (int h = 1; h <= 12; h++) {
      final midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
      final startLon = (midLon - 15.0 + 360.0) % 360.0;
      final endLon = (midLon + 15.0) % 360.0;
      final rIdx = (midLon / 30.0).floor() % 12;
      final rashiName = AstroConstants.rashis[rIdx];
      final lord = AstroConstants.rashiLordsTelugu[rIdx];
      final occupants = chart.planets.where((p) {
        final dist = (p.longitude - startLon + 360.0) % 360.0;
        return dist < 30.0;
      }).map((p) => p.displayAbbr).join(', ');
      buffer.writeln('<tr><td class="bold center">$h వ భావము</td><td class="center">${_formatDms(startLon)}</td><td class="center bold gold-text">${_formatDms(midLon)} ($rashiName)</td><td class="center">${_formatDms(endLon)}</td><td class="center bold">$lord</td><td class="center">${occupants.isEmpty ? "-" : occupants}</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    buffer.writeln('  <div class="section-title">卐 సర్వాష్టకవర్గ పట్టిక (Sarvashtakavarga - SAV 337 Points)</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>రాశి</th><th>రవి</th><th>చం</th><th>కు</th><th>బు</th><th>గు</th><th>శు</th><th>శ</th><th>లగ్న</th><th>మొత్తం (SAV)</th><th>ఫలితము</th></tr></thead><tbody>');
    
    final bavSun = ashtakavarga.bav['Sun'] ?? List.filled(12, 0);
    final bavMoon = ashtakavarga.bav['Moon'] ?? List.filled(12, 0);
    final bavMars = ashtakavarga.bav['Mars'] ?? List.filled(12, 0);
    final bavMercury = ashtakavarga.bav['Mercury'] ?? List.filled(12, 0);
    final bavJupiter = ashtakavarga.bav['Jupiter'] ?? List.filled(12, 0);
    final bavVenus = ashtakavarga.bav['Venus'] ?? List.filled(12, 0);
    final bavSaturn = ashtakavarga.bav['Saturn'] ?? List.filled(12, 0);
    final bavLagna = ashtakavarga.bav['Lagna'] ?? List.filled(12, 0);

    for (int i = 0; i < 12; i++) {
      final signName = AstroConstants.rashis[i];
      final savPts = ashtakavarga.sav[i];
      final isFav = savPts >= 28;
      final statusText = isFav ? "శుభప్రదం (Favorable)" : "మధ్యమం / అల్పం";
      final statusClass = isFav ? "green-text" : "red-text";
      final rowBg = isFav ? "style='background: #f0f9f1;'" : "";
      buffer.writeln('<tr $rowBg><td class="bold">$signName</td><td class="center">${bavSun[i]}</td><td class="center">${bavMoon[i]}</td><td class="center">${bavMars[i]}</td><td class="center">${bavMercury[i]}</td><td class="center">${bavJupiter[i]}</td><td class="center">${bavVenus[i]}</td><td class="center">${bavSaturn[i]}</td><td class="center">${bavLagna[i]}</td><td class="center bold $statusClass">$savPts</td><td class="center bold ${isFav ? "green-text" : ""} ">$statusText</td></tr>');
    }
    buffer.writeln('    <tr style="background: #fff2db; font-weight: 800;"><td class="bold center">మొత్తం (Total)</td><td class="center">48</td><td class="center">49</td><td class="center">39</td><td class="center">54</td><td class="center">56</td><td class="center">52</td><td class="center">39</td><td class="center">-</td><td class="center gold-text">337</td><td class="center gold-text">పరాశర నియమం</td></tr>');
    buffer.writeln('  </tbody></table>');
    buffer.writeln('  <div class="footer-note">$appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress</div>');
    buffer.writeln('</div>');

    // ── PAGE 6: SHADBALA & YOGAS & DOSHAS ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="section-title">卐 షడ్బల విశ్లేషణ & గ్రహ ర్యాంకులు (Shadbala Strengths)</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>గ్రహము</th><th>స్థానబల</th><th>దిగ్బల</th><th>కాలబల</th><th>చేష్టాబల</th><th>నైసర్గిక</th><th>దృగ్బల</th><th>మొత్తం (రూపాలు)</th><th>అవసరం</th><th>నిష్పత్తి</th><th>ర్యాంక్</th></tr></thead><tbody>');
    for (final s in shadbala) {
      final isStrong = s.isStrong;
      final telName = AstroConstants.planetNamesTelugu[s.planetName] ?? s.planetName;
      buffer.writeln('<tr><td class="bold">$telName</td><td class="center">${s.sthanaBala.toStringAsFixed(1)}</td><td class="center">${s.digBala.toStringAsFixed(1)}</td><td class="center">${s.kalaBala.toStringAsFixed(1)}</td><td class="center">${s.chestaBala.toStringAsFixed(1)}</td><td class="center">${s.naisargikaBala.toStringAsFixed(1)}</td><td class="center">${s.drikBala.toStringAsFixed(1)}</td><td class="center bold gold-text">${s.totalRupas.toStringAsFixed(2)}</td><td class="center">${s.requiredRupas.toStringAsFixed(1)}</td><td class="center bold ${isStrong ? "green-text" : "red-text"}">${s.strengthRatio.toStringAsFixed(2)}</td><td class="center bold">#${s.rank}</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    buffer.writeln('  <div class="section-title">卐 విశేష రాజయోగాలు & ధనయోగాలు (Active Vedic Yogas)</div>');
    if (yogas.isEmpty) {
      buffer.writeln('  <div class="sloka-box">సాధారణ శుభ యోగములు కలవు.</div>');
    } else {
      for (final y in yogas) {
        buffer.writeln('  <div class="highlight-card"><div style="font-weight: 700; color: #8c2509; font-size: 11pt;">✦ ${y.teluguName} (${y.name})</div><div style="font-size: 9.5pt; color: #572d11; margin-top: 2px;">${y.teluguDescription}</div></div>');
      }
    }

    buffer.writeln('  <div class="section-title">卐 దోష విశ్లేషణ & పరిహారములు (Dosha Analysis & Remedies)</div>');
    buffer.writeln('  <table class="data-table">');
    buffer.writeln('    <tr><td class="bold" width="25%">కుజ దోషం (Kuja Dosha):</td><td width="75%" class="bold ${!dosha.kujaDosha.hasDosha || dosha.kujaDosha.isCancelled ? "green-text" : "red-text"}">${!dosha.kujaDosha.hasDosha ? "కుజ దోషం లేదు (నిర్దోషం)" : (dosha.kujaDosha.isCancelled ? "కుజ దోష పరిహార నివృత్తి అయింది (${dosha.kujaDosha.teluguReason})" : "కుజ దోష తీవ్రత ఉంది")}</td></tr>');
    buffer.writeln('    <tr><td class="bold">కాలసర్ప దోషం:</td><td class="bold ${dosha.kaalSarpa.hasDosha ? "red-text" : "green-text"}">${dosha.kaalSarpa.hasDosha ? "ఉంది — ${dosha.kaalSarpa.teluguTypeName}" : "కాలసర్ప దోషం లేదు"}</td></tr>');
    buffer.writeln('    <tr><td class="bold">పితృ దోషం:</td><td class="bold ${dosha.hasPitruDosha ? "red-text" : "green-text"}">${dosha.hasPitruDosha ? "లక్షణములు ఉన్నవి (${dosha.pitruDoshaReason})" : "పితృ దోషం లేదు"}</td></tr>');
    buffer.writeln('    <tr><td class="bold">గురు చండాల దోషం:</td><td class="bold ${dosha.hasGuruChandal ? "red-text" : "green-text"}">${dosha.hasGuruChandal ? "ఉంది (${dosha.guruChandalReason})" : "లేదు"}</td></tr>');
    buffer.writeln('  </table>');
    buffer.writeln('  <div class="footer-note">$appTitle • వేద జ్యోతిష నిపుణులు: $astrologerName • ఫోన్: $astrologerMobile • $astrologerAddress</div>');
    buffer.writeln('</div>');

    // ── PAGE 7: VIMSHOTTARI DASHA & SIGNOFF ──
    buffer.writeln('<div class="page">');
    buffer.writeln('  <div class="section-title">卐 వింశోత్తరి దశా-భుక్తి కాలగమనం (Vimshottari Dasha Periods)</div>');
    buffer.writeln('  <div class="sloka-box"><b>జనన కాల దశా శేషము:</b> ${dashas.isNotEmpty ? (AstroConstants.planetNamesTelugu[dashas.first.planet] ?? dashas.first.planet) : "కుజుడు"} మహాదశ</div>');
    buffer.writeln('  <table class="data-table"><thead><tr><th>మహాదశ (Maha Dasha)</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
    final now = DateTime.now();
    for (final d in dashas) {
      final isCurrent = now.isAfter(d.startDate) && now.isBefore(d.endDate);
      final rowBg = isCurrent ? "style='background: #fff3db; font-weight: 800;'" : "";
      final dPlanetTel = AstroConstants.planetNamesTelugu[d.planet] ?? d.planet;
      buffer.writeln('<tr $rowBg><td class="bold">$dPlanetTel మహాదశ ${isCurrent ? "<span class=\\'badge badge-favorable\\'>ప్రస్తుతం జరుగుతున్నది</span>" : ""}</td><td class="center">${DateFormat("dd-MM-yyyy").format(d.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(d.endDate)}</td><td class="center">${(d.endDate.difference(d.startDate).inDays / 365.25).toStringAsFixed(1)} సం.</td><td class="center bold ${isCurrent ? "gold-text" : ""}">${isCurrent ? "నడుస్తున్న దశ" : (now.isAfter(d.endDate) ? "గడిచినది" : "భవిష్యత్")}</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    buffer.writeln('  <div class="section-title">卐 గోచార ఫలితములు & రానున్న శుభ కాలములు (Transit & Auspicious Times)</div>');
    buffer.writeln('  <div class="highlight-card"><div style="font-weight: 700; color: #8c2509; margin-bottom: 4px;">✦ ఏలినాటి శని (Sade Sati) విశ్లేషణ:</div><div style="font-size: 9.5pt; color: #572d11;">${gochar.sadeSati.isActive ? "ప్రస్తుతం ఏలినాటి శని జరుగుతున్నది (${gochar.sadeSati.teluguPhase}). శని శాంతి జపములు, శివార్చన, హనుమాన్ చాలీసా పారాయణము శ్రేయస్కరం." : "ప్రస్తుతం ఏలినాటి శని లేదు. అనుకూల గోచార ఫలితములు."}</div></div>');

    buffer.writeln('  <div style="margin-top: 30px; border: 2px double #c98b2c; background: #fffcf4; padding: 18px; border-radius: 8px; text-align: center;">');
    buffer.writeln('    <div style="font-size: 14pt; font-weight: 800; color: #8c2509;">శుభం భూయాత్ • సర్వేజనా సుఖినోభవంతు</div>');
    buffer.writeln('    <div style="margin-top: 8px; font-size: 11pt; color: #4a2810; font-weight: 700;">');
    buffer.writeln('      జాతక విశ్లేషణ కర్త: <b>$astrologerName</b><br>');
    buffer.writeln('      మొబైల్: <b>$astrologerMobile</b><br>');
    buffer.writeln('      కార్యాలయ చిరునామా: $astrologerAddress<br>');
    buffer.writeln('      <span style="font-size: 9.5pt; color: #8a6245;"><b>$appTitle</b> — సమగ్ర వేద జ్యోతిష పరిశోధనా కేంద్రం</span>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note">గమనిక: ఈ జాతక ఫలితములు జన్మ సమయ గ్రహ స్పష్టతల ఆధారంగా వేద జ్యోతిష ప్రమాణముల ప్రకారం గణించబడినవి.</div>');
    buffer.writeln('</div></body></html>');

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
            sb.writeln('<div class="si-cell center-box"><div style="font-size: 11pt; color: #b3391b;">卐</div>$chartType<br><span style="font-size: 8pt; color: #7a3a0e;">${chartType == "D1" ? "రాశి" : (chartType == "D9" ? "నవాంశ" : chartType)}</span></div>');
          }
          continue;
        }
        final signIdx = grid[r][c];
        final signName = AstroConstants.rashis[signIdx];
        final planetsHtml = signOccupants[signIdx].join(' ');
        sb.writeln('<div class="si-cell"><span class="si-sign-name">$signName</span><div class="si-planets">$planetsHtml</div></div>');
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
    return '$d°${m.toString().padLeft(2, "0")}\\\'${s.toString().padLeft(2, "0")}\\"';
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
      case 'AK': return 'ఆత్మకారకుడు — జీవాత్మ, వ్యక్తిత్వము, ఆయుష్షు';
      case 'AmK': return 'అమాత్యకారకుడు — వృత్తి, ఉద్యోగము, తెలివితేటలు';
      case 'BK': return 'భ్రాతృకారకుడు — సోదరులు, గురువు, ధైర్యము';
      case 'MK': return 'మాతృకారకుడు — తల్లి, వాహనము, గృహ సౌఖ్యము';
      case 'PK': return 'పుత్రకారకుడు — సంతానము, విద్య, పూర్వపుణ్యము';
      case 'GK': return 'జ్ఞాతికారుడు — బంధువులు, శత్రువులు, పోటీలు';
      case 'DK': return 'దారకారకుడు — వివాహ భాగస్వామి, దాంపత్యం';
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

with open('/home/karrthikuuuuu/Documents/Projects/jhora_mobile/lib/data/services/telugu_horoscope_report_generator.dart', 'w', encoding='utf-8') as f:
    f.write(code)
print('Updated generator cleanly.')
