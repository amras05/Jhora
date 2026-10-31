import 'package:intl/intl.dart';
import '../../core/constants/astro_constants.dart';
import '../models/chart_data.dart';
import '../models/planet_position.dart';
import '../services/ashtakavarga_service.dart';
import '../services/shadbala_service.dart';
import '../services/yoga_service.dart';
import '../services/dosha_service.dart';
import '../services/dasha_service.dart';
import '../services/transit_service.dart';
import '../services/special_points_service.dart';
import '../services/panchanga_service.dart';

/// Professional, complete Telugu Vedic Astrology Report Generator
/// (|| శ్రీ బాల జ్యోతిర్ వాస్తు || - సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)
/// Renders with 100% Flawless OpenType Indic Typography & HarfBuzz complex text shaping
class TeluguHoroscopeReportGenerator {
  TeluguHoroscopeReportGenerator._();

  static const String mainTitle = '|| శ్రీ బాల జ్యోతిర్ వాస్తు ||';
  static const String appTitle = 'సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం';
  static const String astrologerName = 'M B S Sastry';
  static const String astrologerMobile = '9030166610';
  static const String astrologerAddress = 'భవానీపురం, విజయవాడ - 12 (BHAVANIPURAM VIJAYAWADA 12)';
  static const String invocationShloka = 'శుక్లాంబరధరం విష్ణుం శశివర్ణం చతుర్భుజం | ప్రసన్నవదనం ధ్యాయేత్ సర్వవిఘ్నోపశాంతయే ||';

  static const List<String> weekdaysTelugu = [
    'ఆదివారం', 'సోమవారం', 'మంగళవారం', 'బుధవారం', 'గురువారం', 'శుక్రవారం', 'శనివారం'
  ];

  static const List<String> tithisTelugu = [
    'పాడ్యమి', 'విదియ', 'తదియ', 'చవితి', 'పంచమి',
    'షష్ఠి', 'సప్తమి', 'అష్టమి', 'నవమి', 'దశమి',
    'ఏకాదశి', 'ద్వాదశి', 'త్రయోదశి', 'చతుర్దశి', 'పూర్ణిమ',
    'పాడ్యమి', 'విదియ', 'తదియ', 'చవితి', 'పంచమి',
    'షష్ఠి', 'సప్తమి', 'అష్టమి', 'నవమి', 'దశమి',
    'ఏకాదశి', 'ద్వాదశి', 'త్రయోదశి', 'చతుర్దశి', 'అమావాస్య'
  ];

  static const List<String> yogasTelugu = [
    'విష్కంభం', 'ప్రీతి', 'ఆయుష్మాన్', 'సౌభాగ్యం', 'శోభనం',
    'అతిగండం', 'సుకర్మ', 'ధృతి', 'శూల', 'గండం',
    'వృద్ధి', 'ధ్రువం', 'వ్యాఘాతం', 'హర్షణ', 'వజ్రం',
    'సిద్ధి', 'వ్యతీపాతం', 'వరీయాన్', 'పరిఘ', 'శివ',
    'సిద్ధ', 'సాధ్య', 'శుభం', 'శుభ్రం', 'బ్రహ్మ',
    'ఐంద్రం', 'వైధృతి'
  ];

  static const Map<String, String> karanasTelugu = {
    'Bava': 'బవ',
    'Balava': 'బాలవ',
    'Kaulava': 'కౌలవ',
    'Taitila': 'తైతుల',
    'Gara': 'గరజ',
    'Vanija': 'వణిజ',
    'Vishti': 'విష్టి (భద్ర)',
    'Kimstughna': 'కింస్తుఘ్నం',
    'Shakuni': 'శకుని',
    'Chatushpada': 'చతుష్పాత్',
    'Naga': 'నాగవాని',
  };

  static String generateHtml({
    required ChartData chartData,
    required AshtakavargaData ashtakavarga,
    required List<PlanetShadbala> shadbala,
    required List<VedicYoga> yogas,
    required DoshaAnalysis dosha,
    required List<DashaPeriod> dashas,
    required GocharAnalysis gochar,
    bool autoPrint = false,
  }) {
    final birth = chartData.birthData;
    final moon = chartData.getPlanet('Moon')!;
    final special = SpecialPointsService.calculate(chartData);
    final panchanga = PanchangaService.calculate(
      date: birth.dateTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      placeName: birth.placeName,
    );

    final weekdayTel = weekdaysTelugu[birth.dateTime.weekday % 7];
    final tithiTel = '${panchanga.paksha == 'Shukla Paksha' ? 'శుక్ల పక్ష' : 'కృష్ణ పక్ష'} ${tithisTelugu[panchanga.tithiIndex % 30]}';
    final nakTel = '${AstroConstants.nakshatrasTelugu[moon.nakshatraIndex]} (${moon.pada}వ పాదం)';
    final yogaTel = yogasTelugu[panchanga.yogaIndex % 27];
    final karanaTel = karanasTelugu[panchanga.karana] ?? panchanga.karana;

    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="te">');
    buffer.writeln('<head>');
    buffer.writeln('<meta charset="UTF-8">');
    buffer.writeln('<title>$mainTitle $appTitle - ${birth.name.isEmpty ? "జాతక చక్రము" : birth.name}</title>');
    buffer.writeln('<style>');
    buffer.writeln('  @import url("https://fonts.googleapis.com/css2?family=Tiro+Telugu:ital@0;1&family=Ramabhadra&family=Noto+Sans+Telugu:wght@400;600;700;800&display=swap");');
    buffer.writeln('  @page { size: A4 portrait; margin: 8mm 8mm 10mm 8mm; }');
    buffer.writeln('  * { box-sizing: border-box; }');
    buffer.writeln('  body { font-family: "Tiro Telugu", "Noto Sans Telugu", "Ramabhadra", serif, "Arial Unicode MS"; color: #2b1d0c; background: #fdfbf7; margin: 0; padding: 12px; font-size: 10pt; line-height: 1.4; }');
    buffer.writeln('  .page-card { background: #ffffff; border: 2px solid #b8860b; border-radius: 8px; padding: 12px; margin-bottom: 20px; page-break-after: always; box-shadow: 0 4px 14px rgba(139,37,0,0.08); position: relative; }');
    buffer.writeln('  .page-card:last-child { page-break-after: auto; }');
    buffer.writeln('  .main-header { text-align: center; border: 2.5px solid #6b1111; background: linear-gradient(180deg, #fffbf0 0%, #ffeed0 100%); padding: 10px 14px; border-radius: 6px; margin-bottom: 12px; }');
    buffer.writeln('  .main-title-tag { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 14pt; font-weight: 800; color: #8b2500; margin: 0; }');
    buffer.writeln('  .app-title { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 19pt; font-weight: 800; color: #6b1111; margin: 2px 0 0 0; }');
    buffer.writeln('  .contact-bar { margin-top: 4px; font-size: 10.5pt; font-weight: 700; color: #3e1b00; }');
    buffer.writeln('  .contact-bar span { color: #8b2500; margin: 0 6px; }');
    buffer.writeln('  .sloka-box { margin-top: 4px; font-size: 9pt; font-weight: 600; color: #8b2500; border-top: 1px dashed #d4af37; padding-top: 3px; }');
    buffer.writeln('  .sub-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1.5px solid #d4af37; background: #fffbf0; padding: 4px 8px; margin-bottom: 10px; font-size: 8.5pt; font-weight: 700; color: #6b1111; }');
    buffer.writeln('  .section-title { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 11pt; font-weight: 700; color: #6b1111; background: #fdecc8; padding: 4px 10px; border-left: 5px solid #6b1111; border-radius: 3px; margin: 10px 0 6px 0; }');
    buffer.writeln('  .grid-2 { display: flex; gap: 10px; }');
    buffer.writeln('  .grid-2 > div { flex: 1; }');
    buffer.writeln('  table.data-table { width: 100%; border-collapse: collapse; margin: 4px 0 8px 0; font-size: 8.5pt; }');
    buffer.writeln('  table.data-table th { background: #6b1111; color: #ffffff; font-weight: 700; padding: 2.5px 5px; border: 1px solid #6b1111; text-align: center; font-size: 8.5pt; }');
    buffer.writeln('  table.data-table td { border: 1px solid #d4af37; padding: 2px 5px; color: #220f00; font-size: 8.5pt; }');
    buffer.writeln('  table.data-table tr:nth-child(even) { background: #fdfbf7; }');
    buffer.writeln('  .bold { font-weight: 700; }');
    buffer.writeln('  .center { text-align: center; }');
    buffer.writeln('  .gold-text { color: #8b2500; font-weight: 700; }');
    buffer.writeln('  .si-chart { display: grid; grid-template-columns: repeat(4, 1fr); grid-template-rows: repeat(4, 1fr); border: 2px solid #8b2500; width: 100%; max-width: 270px; height: 270px; margin: 0 auto; background: #ffffff; }');
    buffer.writeln('  .si-cell { border: 1px solid #d4af37; padding: 2px 3px; position: relative; font-size: 7.5pt; overflow: hidden; display: flex; flex-direction: column; justify-content: flex-start; }');
    buffer.writeln('  .si-cell.center-box { grid-column: 2 / span 2; grid-row: 2 / span 2; background: #fffbf0; display: flex; align-items: center; justify-content: center; text-align: center; font-family: "Ramabhadra", serif; font-weight: 800; font-size: 11pt; color: #6b1111; border: 1.5px solid #8b2500; }');
    buffer.writeln('  .si-sign-name { font-size: 6.5pt; color: #78350f; font-weight: 700; line-height: 1; }');
    buffer.writeln('  .si-planets { font-size: 8pt; font-weight: 700; color: #1e293b; margin-top: 2px; line-height: 1.25; text-align: center; }');
    buffer.writeln('  .lagna-badge { color: #b91c1c; font-weight: 800; }');
    buffer.writeln('  .highlight-card { background: #fffbf0; border: 1.2px solid #d4af37; border-radius: 5px; padding: 6px 10px; margin: 6px 0; }');
    buffer.writeln('  .footer-note { margin-top: 8px; display: flex; justify-content: space-between; font-size: 7.5pt; color: #78350f; border-top: 1px solid #d4af37; padding-top: 3px; }');
    buffer.writeln('  @media print {');
    buffer.writeln('    body { background: #fff; padding: 0; margin: 0; }');
    buffer.writeln('    .no-print { display: none !important; }');
    buffer.writeln('    .page-card { border: none !important; box-shadow: none !important; margin: 0 !important; padding: 0 !important; page-break-after: always !important; page-break-inside: avoid !important; break-after: page !important; break-inside: avoid !important; min-height: auto !important; }');
    buffer.writeln('    .page-card:last-child { page-break-after: auto !important; break-after: auto !important; }');
    buffer.writeln('  }');
    buffer.writeln('</style>');
    // Auto-print: when autoPrint=true, Chrome print dialog fires automatically
    if (autoPrint) {
      buffer.writeln('<script>');
      buffer.writeln('  window.addEventListener("load", function() {');
      buffer.writeln('    setTimeout(function() { window.print(); }, 800);');
      buffer.writeln('  });');
      buffer.writeln('</script>');
    }
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    // FLOATING ACTION BAR FOR DOWNLOAD / PRINT
    buffer.writeln('  <div class="no-print" style="position: sticky; top: 0; z-index: 99999; background: #6b1111; color: #fff; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 14px rgba(0,0,0,0.3); margin-bottom: 16px; border-radius: 6px;">');
    buffer.writeln('    <div style="font-weight: 800; font-size: 13pt;">卐 $mainTitle $appTitle</div>');
    buffer.writeln('    <div style="display: flex; gap: 12px;">');
    buffer.writeln('      <button onclick="window.print()" style="background: #f59e0b; color: #000; font-weight: 800; font-size: 11pt; padding: 9px 22px; border: none; border-radius: 6px; cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">🖨️ PDF గా సేవ్ చేయండి (Save as PDF / Print)</button>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 1: ప్రాథమిక వివరాలు, పంచాంగం, చక్రములు (D1, D9) & గ్రహ స్థానాలు ──
    // ══════════════════════════════════════════════════════════════════════
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="main-header">');
    buffer.writeln('    <div class="main-title-tag">$mainTitle</div>');
    buffer.writeln('    <h1 class="app-title">$appTitle</h1>');
    buffer.writeln('    <div class="contact-bar">జ్యోతిష నిపుణులు: <b>$astrologerName</b> <span>•</span> మొబైల్: <b>$astrologerMobile</b></div>');
    buffer.writeln('    <div style="font-size: 9pt; color: #5c2c00; margin-top: 1px;">$astrologerAddress</div>');
    buffer.writeln('    <div class="sloka-box">$invocationShloka</div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="grid-2">');
    buffer.writeln('    <div>');
    buffer.writeln('      <div class="section-title">1. జాతక ప్రాథమిక వివరాలు</div>');
    buffer.writeln('      <table class="data-table">');
    buffer.writeln('        <tr><td class="bold" style="width:38%;">పేరు:</td><td><b>${birth.name.isEmpty ? "శ్రీ / కుమారి" : birth.name}</b></td></tr>');
    buffer.writeln('        <tr><td class="bold">తేదీ / వారం:</td><td>${DateFormat("dd-MM-yyyy").format(birth.dateTime)}, $weekdayTel</td></tr>');
    buffer.writeln('        <tr><td class="bold">సమయము:</td><td>${DateFormat("hh:mm:ss a").format(birth.dateTime)}</td></tr>');
    buffer.writeln('        <tr><td class="bold">జన్మ స్థలము:</td><td>${birth.placeName}</td></tr>');
    buffer.writeln('        <tr><td class="bold">అక్షాంశ/రేఖాంశం:</td><td>${birth.latitude.toStringAsFixed(2)}° N, ${birth.longitude.toStringAsFixed(2)}° E</td></tr>');
    buffer.writeln('        <tr><td class="bold">ఆయనాంశము:</td><td>లాహిరి (${_formatDms(chartData.ayanamsa)})</td></tr>');
    buffer.writeln('      </table>');
    buffer.writeln('    </div>');
    buffer.writeln('    <div>');
    buffer.writeln('      <div class="section-title">2. జన్మ పంచాంగ వివరములు</div>');
    buffer.writeln('      <table class="data-table">');
    buffer.writeln('        <tr><td class="bold" style="width:38%;">తిథి:</td><td><b>$tithiTel</b></td></tr>');
    buffer.writeln('        <tr><td class="bold">జన్మ నక్షత్రం:</td><td><b>$nakTel</b></td></tr>');
    buffer.writeln('        <tr><td class="bold">నిత్య యోగం:</td><td>$yogaTel</td></tr>');
    buffer.writeln('        <tr><td class="bold">కరణం:</td><td>$karanaTel</td></tr>');
    buffer.writeln('        <tr><td class="bold">సూర్యోదయ/అస్తమయం:</td><td>${DateFormat("hh:mm a").format(panchanga.sunrise)} / ${DateFormat("hh:mm a").format(panchanga.sunset)}</td></tr>');
    buffer.writeln('        <tr><td class="bold">రాహు కాలం:</td><td>${DateFormat("hh:mm a").format(panchanga.rahuKalam.$1)} - ${DateFormat("hh:mm a").format(panchanga.rahuKalam.$2)}</td></tr>');
    buffer.writeln('      </table>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">3. జాతక చక్రములు (Horoscope Charts)</div>');
    buffer.writeln('  <div class="grid-2" style="margin: 6px 0;">');
    buffer.writeln('    <div>');
    buffer.writeln('      <div style="text-align:center; font-weight:700; color:#6b1111; font-size:9pt; margin-bottom:2px;">రాశి చక్రము (D1 Rasi)</div>');
    buffer.writeln(_buildSouthIndianChartHtml(chartData, chartType: 'D1'));
    buffer.writeln('    </div>');
    buffer.writeln('    <div>');
    buffer.writeln('      <div style="text-align:center; font-weight:700; color:#6b1111; font-size:9pt; margin-bottom:2px;">నవాంశ చక్రము (D9 Navamsa)</div>');
    buffer.writeln(_buildSouthIndianChartHtml(chartData, chartType: 'D9'));
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">4. నిరాయణ గ్రహ స్థితిగతుల పట్టిక (Planetary Positions)</div>');
    buffer.writeln('  <table class="data-table">');
    buffer.writeln('    <thead><tr><th>గ్రహము</th><th>రాశి</th><th>అంశలు (స్పష్టం)</th><th>నక్షత్రం</th><th>పాదం</th><th>నక్షత్రాధిపతి</th><th>స్థితి</th></tr></thead>');
    buffer.writeln('    <tbody>');
    buffer.writeln('      <tr style="background:#fff3e0; font-weight:700;"><td class="center gold-text">లగ్నము</td><td class="center">${AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}</td><td class="center">${_formatDms(chartData.ascendant.degreesInRashi)}</td><td class="center">${AstroConstants.nakshatrasTelugu[chartData.ascendant.nakshatraIndex]}</td><td class="center">${chartData.ascendant.pada}</td><td class="center">${AstroConstants.nakshatraLordsTelugu[chartData.ascendant.nakshatraIndex]}</td><td class="center gold-text">లగ్న కేంద్రం</td></tr>');
    for (final p in chartData.planets) {
      final pTel = AstroConstants.planetNamesTelugu[p.name] ?? p.name;
      final rTel = AstroConstants.rashisTelugu[p.rashiIndex];
      final nTel = AstroConstants.nakshatrasTelugu[p.nakshatraIndex];
      final lordTel = AstroConstants.nakshatraLordsTelugu[p.nakshatraIndex];
      final digTel = _getTeluguDignity(p);
      final retro = p.isRetrograde ? " <span style='color:#c2410c;'>(వ)</span>" : "";
      final combust = p.isCombust ? " <span style='color:#ea580c;'>(మౌ)</span>" : "";
      buffer.writeln('      <tr><td class="center bold">$pTel$retro$combust</td><td class="center">$rTel</td><td class="center">${_formatDms(p.degreesInRashi)}</td><td class="center">$nTel</td><td class="center">${p.pada}</td><td class="center">$lordTel</td><td class="center bold">$digTel</td></tr>');
    }
    buffer.writeln('    </tbody></table>');

    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerName ($astrologerMobile)</span><span>పుట 1 / 5</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 2: భావ స్పష్టము, అష్టకవర్గము & వింశోత్తరి దశలు ──
    // ══════════════════════════════════════════════════════════════════════
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="sub-header"><span>$mainTitle  -  $appTitle</span><span>జ్యోతిష నిపుణులు: $astrologerName (మొబైల్: $astrologerMobile)</span></div>');

    buffer.writeln('  <div class="section-title">5. ద్వాదశ భావ స్పష్ట పట్టిక (12 Houses Bhava Spashta & Lords)</div>');
    buffer.writeln('  <table class="data-table">');
    buffer.writeln('    <thead><tr><th>భావము</th><th>భావ ఆరంభము</th><th>భావ మధ్యము (స్పష్టం)</th><th>భావ అంత్యము</th><th>భావాధిపతి</th></tr></thead><tbody>');
    final lagnaLon = chartData.ascendant.longitude;
    for (int i = 0; i < 12; i++) {
      int h = i + 1;
      final midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
      final startLon = (midLon - 15.0 + 360.0) % 360.0;
      final endLon = (midLon + 15.0) % 360.0;
      final rIdx = (midLon / 30.0).floor() % 12;
      final lord = AstroConstants.rashiLordsTelugu[rIdx];
      buffer.writeln('      <tr><td class="center bold gold-text">$hవ భావము</td><td class="center">${_formatDms(startLon)}</td><td class="center bold">${_formatDms(midLon)}</td><td class="center">${_formatDms(endLon)}</td><td class="center bold">$lord</td></tr>');
    }
    buffer.writeln('    </tbody></table>');

    buffer.writeln('  <div class="section-title">6. సర్వాష్టకవర్గ చక్రము & 337 బిందువుల సమగ్ర పట్టిక (SAV 337)</div>');
    buffer.writeln('  <div class="grid-2" style="align-items:center;">');
    buffer.writeln('    <div>');
    buffer.writeln(_buildSavChartHtml(ashtakavarga));
    buffer.writeln('    </div>');
    buffer.writeln('    <div>');
    buffer.writeln('      <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('        <thead><tr><th>రాశి</th><th>రవి</th><th>చం</th><th>కు</th><th>బు</th><th>గు</th><th>శు</th><th>శని</th><th>SAV</th></tr></thead><tbody>');
    const planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    for (int rIdx = 0; rIdx < 12; rIdx++) {
      final savPts = ashtakavarga.sav[rIdx];
      final isHigh = savPts >= 28;
      buffer.write('        <tr style="${isHigh ? "background:#f0fdf4;" : ""}"><td class="bold">${AstroConstants.rashisTelugu[rIdx]}</td>');
      for (final p in planets) {
        final pts = ashtakavarga.bav[p]?[rIdx] ?? 0;
        buffer.write('<td class="center">$pts</td>');
      }
      buffer.writeln('<td class="center bold ${isHigh ? "gold-text" : ""}">$savPts</td></tr>');
    }
    buffer.writeln('      </tbody></table>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">7. వింశోత్తరి దశా - అంతర్దశల కాలగమనం (120-Year Vimshottari Mahadasha)</div>');
    buffer.writeln('  <table class="data-table">');
    buffer.writeln('    <thead><tr><th>మహాదశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>దశా కాల ప్రాముఖ్యత</th></tr></thead><tbody>');
    final now = DateTime.now();
    for (final d in dashas) {
      final pTel = AstroConstants.planetNamesTelugu[d.planet] ?? d.planet;
      final dur = (d.endDate.difference(d.startDate).inDays / 365.25).toStringAsFixed(1);
      final isCurrent = now.isAfter(d.startDate) && now.isBefore(d.endDate);
      buffer.writeln('      <tr style="${isCurrent ? "background:#fef3c7; font-weight:700;" : ""}"><td class="center bold">$pTel మహాదశ${isCurrent ? " (ప్రస్తుతం)" : ""}</td><td class="center">${DateFormat("dd-MM-yyyy").format(d.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(d.endDate)}</td><td class="center">$dur సం.</td><td class="center ${isCurrent ? "gold-text" : ""}">${isCurrent ? "ప్రస్తుతం చురుగ్గా జరుగుచున్నది" : "పూర్తి కాలపరిమితి"}</td></tr>');
    }
    buffer.writeln('    </tbody></table>');

    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerName ($astrologerMobile)</span><span>పుట 2 / 5</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 3: షడ్బలము, గోచారము, భృగు బిందువు, యోగాలు, దోషాలు & ఆశీర్వచనం ──
    // ══════════════════════════════════════════════════════════════════════
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="sub-header"><span>$mainTitle  -  $appTitle</span><span>జ్యోతిష నిపుణులు: $astrologerName (మొబైల్: $astrologerMobile)</span></div>');

    buffer.writeln('  <div class="grid-2">');
    buffer.writeln('    <div>');
    buffer.writeln('      <div class="section-title">8. షడ్బల బలాబలాల పట్టిక</div>');
    buffer.writeln('      <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('        <thead><tr><th>గ్రహము</th><th>స్థాన</th><th>దిగ్</th><th>కాల</th><th>చేష్ట</th><th>నైసర్గిక</th><th>దృగ్</th><th>మొత్తం</th><th>ర్యాంకు</th></tr></thead><tbody>');
    for (final sb in shadbala) {
      final pTel = AstroConstants.planetNamesTelugu[sb.planetName] ?? sb.planetName;
      buffer.writeln('        <tr><td class="bold">$pTel</td><td class="center">${sb.sthanaBala.toStringAsFixed(0)}</td><td class="center">${sb.digBala.toStringAsFixed(0)}</td><td class="center">${sb.kalaBala.toStringAsFixed(0)}</td><td class="center">${sb.chestaBala.toStringAsFixed(0)}</td><td class="center">${sb.naisargikaBala.toStringAsFixed(0)}</td><td class="center">${sb.drikBala.toStringAsFixed(0)}</td><td class="center bold">${sb.totalRupas.toStringAsFixed(1)}</td><td class="center bold gold-text">#${sb.rank}</td></tr>');
    }
    buffer.writeln('      </tbody></table>');
    buffer.writeln('    </div>');
    buffer.writeln('    <div>');
    buffer.writeln('      <div class="section-title">9. ప్రస్తుత గోచార ఫలితములు</div>');
    buffer.writeln('      <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('        <thead><tr><th>గ్రహము</th><th>గోచార రాశి</th><th>చంద్రుని నుండి</th><th>ఫలితము</th></tr></thead><tbody>');
    for (final tr in gochar.transits) {
      final pTel = AstroConstants.planetNamesTelugu[tr.planetName] ?? tr.planetName;
      final rTel = AstroConstants.rashisTelugu[tr.transitRashi];
      final isFav = tr.isFavorable;
      buffer.writeln('        <tr style="${isFav ? "background:#f0fdf4;" : ""}"><td class="bold">$pTel</td><td class="center">$rTel</td><td class="center">${tr.houseFromMoon}వ స్థానం</td><td class="center bold ${isFav ? "gold-text" : ""}">${isFav ? "శుభ ఫలితం" : "సామాన్యం"}</td></tr>');
    }
    buffer.writeln('      </tbody></table>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    // Sade Sati Box
    final sadeSatiText = gochar.sadeSati.isActive
        ? 'ప్రస్తుతం జాతకునికి ఏలినాటి శని జరుగుచున్నది (${gochar.sadeSati.teluguPhase}). శని శాంతి జపములు, తైలాభిషేకం శ్రేయస్కరం.'
        : 'ప్రస్తుతం జాతకునికి ఏలినాటి శని లేదు (అనుకూల గోచార సమయం).';

    buffer.writeln('  <div class="highlight-card" style="background:${gochar.sadeSati.isActive ? "#fff7ed" : "#f0fdf4"}; border-color:${gochar.sadeSati.isActive ? "#f97316" : "#22c55e"};">');
    buffer.writeln('    <b>ఏలినాటి శని విశ్లేషణ:</b> $sadeSatiText');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">10. భృగు బిందువు, యోగీ-అవయోగీ & జైమిని 7 చరకారకములు</div>');
    buffer.writeln('  <div class="grid-2">');
    buffer.writeln('    <div>');
    buffer.writeln('      <table class="data-table">');
    buffer.writeln('        <tr><td class="bold" style="width:40%;">భృగు బిందువు (BB):</td><td><b>${special.bhriguBinduRashi} (${_formatDms(special.bhriguBinduRashiDeg)})</b><br><span style="font-size:8pt; color:#8b2500;">${special.bhriguBinduHouse}వ భావం</span></td></tr>');
    buffer.writeln('        <tr><td class="bold">యోగ గ్రహము (Yogi):</td><td><b>${special.yogiPlanet}</b> (${special.yogiRashi} - ${special.yogiNakshatra})</td></tr>');
    buffer.writeln('        <tr><td class="bold">సహయోగి గ్రహము:</td><td><b>${special.sahayogiPlanet}</b></td></tr>');
    buffer.writeln('        <tr><td class="bold">అవయోగ గ్రహము:</td><td><b>${special.avayogiPlanet}</b> (${special.avayogiRashi} - ${special.avayogiNakshatra})</td></tr>');
    buffer.writeln('      </table>');
    buffer.writeln('    </div>');
    buffer.writeln('    <div>');
    buffer.writeln('      <table class="data-table">');
    buffer.writeln('        <thead><tr><th>చరకారకము</th><th>గ్రహము</th><th>రాశి స్థానం</th></tr></thead><tbody>');
    for (final k in special.charaKarakas) {
      buffer.writeln('        <tr><td class="bold gold-text">${k.nameTelugu}</td><td class="center bold">${k.planetTelugu}</td><td class="center">${k.rashiTelugu} (${_formatDms(k.degreeInRashi)})</td></tr>');
    }
    buffer.writeln('      </tbody></table>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="section-title">11. జాతక యోగములు, దోష విశ్లేషణ & పరిహారములు</div>');
    buffer.writeln('  <div class="highlight-card">');
    buffer.writeln('    <div style="font-weight:700; color:#6b1111; margin-bottom:3px;">✦ ప్రధాన జాతక యోగాలు: ${yogas.take(5).map((y) => y.teluguName).join(" • ")}</div>');
    buffer.writeln('    <div style="font-size:9pt; color:#3e1b00;">');
    buffer.writeln('      • <b>కుజ దోషం:</b> ${dosha.kujaDosha.hasDosha ? "లగ్నం/చంద్రుని నుండి కుజుని స్థితి వలన కుజ దోషం కలదు (సుబ్రహ్మణ్యేశ్వర స్వామి పూజ, కుజ శాంతి శ్రేయస్కరం)." : "కుజ దోషము లేదు (అనుకూలం)."}<br>');
    buffer.writeln('      • <b>కాలసర్ప దోషం:</b> ${dosha.kaalSarpa.hasDosha ? dosha.kaalSarpa.teluguTypeName : "కాలసర్ప దోషము లేదు (శుభప్రదం)."}');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div style="margin-top: 12px; border: 2px solid #6b1111; background: linear-gradient(180deg, #fffbf0 0%, #ffeed0 100%); padding: 10px; border-radius: 6px; text-align: center;">');
    buffer.writeln('    <div style="font-size: 12pt; font-weight: 800; color: #6b1111;">|| శుభం భూయాత్ • సర్వేజనాః సుఖినో భవంతు ||</div>');
    buffer.writeln('    <div style="margin-top: 4px; font-size: 10pt; color: #3e1b00; font-weight: 700;">');
    buffer.writeln('      జాతక పరిశీలన & సమగ్ర వాస్తు సంప్రదింపులకు: <b>$astrologerName</b> <span>•</span> మొబైల్: <b>$astrologerMobile</b><br>');
    buffer.writeln('      కార్యాలయ చిరునామా: $astrologerAddress<br>');
    buffer.writeln('      <span style="font-size: 8.5pt; color: #8b2500;"><b>$appTitle</b> — సంపూర్ణ వేద జ్యోతిష నిలయం</span>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerName ($astrologerMobile)</span><span>పుట 3 / 5</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 4: జన్మ నుండి 50 సంవత్సరాల మహా, అంతర & ప్రత్యంతర దశల పట్టిక ──
    // ══════════════════════════════════════════════════════════════════════
    final limit50 = birth.dateTime.add(Duration(days: (50 * 365.2425).round()));

    final antar50List = <({String mahaPlanet, DashaPeriod antar})>[];
    for (final m in dashas) {
      if (m.startDate.isAfter(limit50)) continue;
      for (final a in (m.subPeriods ?? [])) {
        if (a.startDate.isBefore(limit50)) {
          antar50List.add((mahaPlanet: m.planet, antar: a));
        }
      }
    }

    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="sub-header"><span>$mainTitle  -  $appTitle</span><span>జ్యోతిష నిపుణులు: $astrologerName (మొబైల్: $astrologerMobile)</span></div>');
    buffer.writeln('  <div class="section-title">10. జన్మ నుండి 50 సంవత్సరాల వింశోత్తరి మహా & అంతర్దశల సమగ్ర కాలచక్రం (Maha & Antar Dasha Timeline - 50 Years)</div>');
    buffer.writeln('  <div style="font-size:8pt; color:#6b1111; margin-bottom:5px; font-weight:600;">జాతకుని జన్మ తేదీ (${DateFormat("dd-MM-yyyy").format(birth.dateTime)}) నుండి 50 సంవత్సరాల వయస్సు వరకు (${DateFormat("dd-MM-yyyy").format(limit50)}) నడుచు మహా మరియు అంతర్దశల సమగ్ర కాలచక్రం:</div>');

    int half = (antar50List.length / 2).ceil();
    final col1 = antar50List.sublist(0, half);
    final col2 = antar50List.sublist(half);

    buffer.writeln('  <div class="grid-2">');
    for (final col in [col1, col2]) {
      buffer.writeln('    <div>');
      buffer.writeln('      <table class="data-table" style="font-size:7.5pt;">');
      buffer.writeln('        <thead><tr><th>మహా/అంతర దశ</th><th>ప్రారంభం</th><th>ముగింపు</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
      for (final item in col) {
        final a = item.antar;
        final mTel = AstroConstants.planetNamesTelugu[item.mahaPlanet] ?? item.mahaPlanet;
        final aTel = AstroConstants.planetNamesTelugu[a.planet] ?? a.planet;
        final isActive = now.isAfter(a.startDate) && now.isBefore(a.endDate);
        final isPast = a.endDate.isBefore(now);
        final statusText = isActive ? "ప్రస్తుతం" : (isPast ? "గతించినది" : "రాబోవునది");
        final rowStyle = isActive ? "background:#fef3c7; font-weight:700;" : (isPast ? "color:#6b7280;" : "");
        buffer.writeln('        <tr style="$rowStyle"><td class="bold">$mTel / $aTel</td><td class="center">${DateFormat("dd-MM-yy").format(a.startDate)}</td><td class="center">${DateFormat("dd-MM-yy").format(a.endDate)}</td><td class="center">${a.durationString}</td><td class="center ${isActive ? "gold-text" : ""}">${isActive ? "★ ప్రస్తుతం" : statusText}</td></tr>');
      }
      buffer.writeln('      </tbody></table>');
      buffer.writeln('    </div>');
    }
    buffer.writeln('  </div>');

    // Section 11: Pratyantar Dashas (Level 3)
    final currentOrFirstAntar = antar50List.firstWhere(
      (item) => item.antar.containsDate(now),
      orElse: () => antar50List.first,
    );
    final pdList = currentOrFirstAntar.antar.subPeriods ?? [];
    final activeMahaTel = AstroConstants.planetNamesTelugu[currentOrFirstAntar.mahaPlanet] ?? currentOrFirstAntar.mahaPlanet;
    final activeAntarTel = AstroConstants.planetNamesTelugu[currentOrFirstAntar.antar.planet] ?? currentOrFirstAntar.antar.planet;

    buffer.writeln('  <div class="section-title">11. ప్రత్యంతర దశల కాలగమనం (Level 3: Pratyantar Dashas in $activeMahaTel - $activeAntarTel)</div>');
    buffer.writeln('  <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('    <thead><tr><th>ప్రత్యంతర నాథుడు</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>ఫలిత స్థితి</th></tr></thead><tbody>');
    for (final pd in pdList) {
      final pTel = AstroConstants.planetNamesTelugu[pd.planet] ?? pd.planet;
      final isPdActive = pd.containsDate(now);
      final isPdPast = pd.endDate.isBefore(now);
      final pdStatus = isPdActive ? "★ నడుస్తున్న ప్రత్యంతర" : (isPdPast ? "పూర్తయినది" : "రాబోవు కాలం");
      buffer.writeln('    <tr style="${isPdActive ? "background:#ecfdf5; font-weight:700;" : ""}"><td class="center bold">$pTel ప్రత్యంతర</td><td class="center">${DateFormat("dd-MM-yyyy").format(pd.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(pd.endDate)}</td><td class="center">${pd.durationString}</td><td class="center ${isPdActive ? "gold-text" : ""}">$pdStatus</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerName ($astrologerMobile)</span><span>పుట 4 / 5</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 5: సమగ్ర సూక్ష్మ & ప్రాణ దశల విశ్లేషణ (Levels 4 & 5) ──
    // ══════════════════════════════════════════════════════════════════════
    final targetTime = (now.isAfter(birth.dateTime) && now.isBefore(limit50)) ? now : birth.dateTime;
    final hierarchy = DashaService.findCurrentHierarchy(dashas, targetTime);
    final curMaha = hierarchy.maha ?? dashas.first;
    final curAntar = hierarchy.antar ?? (curMaha.subPeriods?.first);
    final curPd = hierarchy.pratyantar ?? (curAntar?.subPeriods?.first);
    final curSd = hierarchy.sookshma ?? (curPd?.subPeriods?.first);
    final curPr = hierarchy.prana ?? (curSd?.subPeriods?.first);

    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="sub-header"><span>$mainTitle  -  $appTitle</span><span>జ్యోతిష నిపుణులు: $astrologerName (మొబైల్: $astrologerMobile)</span></div>');
    buffer.writeln('  <div class="section-title">12. ప్రస్తుత సమగ్ర పంచస్థాయి దశా స్థితి (Real-Time 5-Level Dasha Chain)</div>');

    final hmTel = AstroConstants.planetNamesTelugu[curMaha.planet] ?? curMaha.planet;
    final haTel = curAntar != null ? (AstroConstants.planetNamesTelugu[curAntar.planet] ?? curAntar.planet) : "";
    final hpTel = curPd != null ? (AstroConstants.planetNamesTelugu[curPd.planet] ?? curPd.planet) : "";
    final hsTel = curSd != null ? (AstroConstants.planetNamesTelugu[curSd.planet] ?? curSd.planet) : "";
    final hprTel = curPr != null ? (AstroConstants.planetNamesTelugu[curPr.planet] ?? curPr.planet) : "";

    buffer.writeln('  <div style="background: linear-gradient(135deg, #2b1104 0%, #4a1c06 100%); color: #fff; padding: 10px 14px; border-radius: 6px; border: 1.5px solid #d4af37; margin-bottom: 8px;">');
    buffer.writeln('    <div style="font-size: 10pt; font-weight: 800; color: #fde047; margin-bottom: 4px;">నడుస్తున్న పంచస్థాయి దశా క్రమం (MD → AD → PD → SD → PrD):</div>');
    buffer.writeln('    <div style="font-size: 12pt; font-weight: 800; color: #ffffff;">$hmTel (మహా) → $haTel (అంతర) → $hpTel (ప్రత్యంతర) → $hsTel (సూక్ష్మ) → <span style="color:#f472b6;">$hprTel (ప్రాణ)</span></div>');
    if (curPr != null) {
      buffer.writeln('    <div style="font-size: 8pt; color: #fef08a; margin-top: 4px;">ప్రాణ దశ ముగింపు సమయం: ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(curPr.endDate)} (${curPr.durationString})</div>');
    }
    buffer.writeln('  </div>');

    // Sookshma Dashas Table (Level 4):
    final sookshmaList = curPd?.subPeriods ?? [];
    buffer.writeln('  <div class="section-title">13. సూక్ష్మ దశల సమగ్ర పట్టిక (Level 4: Sookshma Dashas in $hpTel ప్రత్యంతర)</div>');
    buffer.writeln('  <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('    <thead><tr><th>సూక్ష్మ నాథుడు</th><th>ప్రారంభ సమయం</th><th>ముగింపు సమయం</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
    for (final sd in sookshmaList) {
      final sdTel = AstroConstants.planetNamesTelugu[sd.planet] ?? sd.planet;
      final isSdActive = sd.containsDate(targetTime);
      final isSdPast = sd.endDate.isBefore(targetTime);
      final sdStatus = isSdActive ? "★ నడుస్తున్న సూక్ష్మ" : (isSdPast ? "గతించినది" : "రాబోవునది");
      buffer.writeln('    <tr style="${isSdActive ? "background:#e0f2fe; font-weight:700;" : ""}"><td class="center bold">$sdTel సూక్ష్మ</td><td class="center">${DateFormat("dd-MM-yyyy hh:mm a").format(sd.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy hh:mm a").format(sd.endDate)}</td><td class="center">${sd.durationString}</td><td class="center ${isSdActive ? "gold-text" : ""}">$sdStatus</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    // Prana Dashas Table (Level 5):
    final pranaList = curSd?.subPeriods ?? [];
    buffer.writeln('  <div class="section-title">14. ప్రాణ దశల సమగ్ర పట్టిక (Level 5: Prana Dashas in $hsTel సూక్ష్మ దశ)</div>');
    buffer.writeln('  <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('    <thead><tr><th>ప్రాణ నాథుడు</th><th>ప్రారంభ సమయం</th><th>ముగింపు సమయం</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
    for (final pr in pranaList) {
      final prTel = AstroConstants.planetNamesTelugu[pr.planet] ?? pr.planet;
      final isPrActive = pr.containsDate(targetTime);
      final isPrPast = pr.endDate.isBefore(targetTime);
      final prStatus = isPrActive ? "★ ప్రత్యక్ష ప్రాణ దశ" : (isPrPast ? "గతించినది" : "రాబోవునది");
      buffer.writeln('    <tr style="${isPrActive ? "background:#fce7f3; font-weight:700;" : ""}"><td class="center bold" style="color:${isPrActive ? "#be185d" : "inherit"};">$prTel ప్రాణ</td><td class="center">${DateFormat("dd-MM-yyyy hh:mm:ss a").format(pr.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy hh:mm:ss a").format(pr.endDate)}</td><td class="center">${pr.durationString}</td><td class="center bold" style="color:${isPrActive ? "#be185d" : "inherit"};">$prStatus</td></tr>');
    }
    buffer.writeln('  </tbody></table>');

    // Guidelines Box:
    buffer.writeln('  <div style="margin-top: 8px; border: 1.5px solid #d4af37; background: #fffbf0; padding: 6px 10px; border-radius: 6px;">');
    buffer.writeln('    <div style="font-size: 9pt; font-weight: 800; color: #6b1111; margin-bottom: 2px;">పంచస్థాయి వింశోత్తరి దశా ఫలితాల సూత్రం (Sage Parashara Shastra):</div>');
    buffer.writeln('    <div style="font-size: 7.5pt; color: #3e1b00; line-height: 1.35;">');
    buffer.writeln('      • <b>మహాదశ (1st Level):</b> జీవితంలోని ప్రధాన దిశను మరియు ఆయుర్దాయ భాగ్యాలను సూచిస్తుంది.<br>');
    buffer.writeln('      • <b>అంతర్దశ (2nd Level):</b> ఆ కాలంలో ఫలితమిచ్చు నిర్దిష్ట భావాన్ని (వివాహం, ఉద్యోగం, విద్య) నడిపిస్తుంది.<br>');
    buffer.writeln('      • <b>ప్రత్యంతర దశ (3rd Level):</b> మాసాల వారీగా జరిగే శుభాశుభ మార్పులను నిర్ధారిస్తుంది.<br>');
    buffer.writeln('      • <b>సూక్ష్మ దశ (4th Level):</b> రోజుల వారీగా ఆరోగ్య, మానసిక, ధన లాభనష్ట కార్యసిద్ధిని వెల్లడిస్తుంది.<br>');
    buffer.writeln('      • <b>ప్రాణ దశ (5th Level):</b> ఘడియలు, గంటల వ్యవధిలో ఖచ్చితమైన శుభ ముహూర్త ఫలితాన్ని, సంఘటన జరిగే క్షణాన్ని నిర్ధారిస్తుంది.');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerName ($astrologerMobile)</span><span>పుట 5 / 5</span></div>');
    buffer.writeln('</div>');

    buffer.writeln('</body></html>');
    return buffer.toString();
  }

  static String _buildSouthIndianChartHtml(ChartData chart, {required String chartType}) {
    final signOccupants = List.generate(12, (_) => <String>[]);
    int lagnaIdx = chart.ascendant.rashiIndex;
    if (chartType == 'D9') {
      lagnaIdx = chart.ascendant.navamsaRashiIndex;
    }
    signOccupants[lagnaIdx].add('<span class="lagna-badge">ల</span>');

    for (final p in chart.planets) {
      int signIdx = chartType == 'D9' ? p.navamsaRashiIndex : p.rashiIndex;
      final abbr = AstroConstants.planetAbbrTelugu[p.name] ?? p.abbreviation;
      final retro = p.isRetrograde ? '(వ)' : '';
      final combust = p.isCombust ? '(మౌ)' : '';
      signOccupants[signIdx].add('$abbr$retro$combust');
    }

    final grid = AstroConstants.southIndianGrid;
    final sb = StringBuffer();
    sb.writeln('<div class="si-chart">');
    final lagnaName = AstroConstants.rashisTelugu[chart.ascendant.rashiIndex];
    final centerSub = chartType == "D1" ? "లగ్నం: $lagnaName" : "నవాంశ";
    final chartTitle = chartType == "D1" ? "రాశి (D1)" : "నవాంశ (D9)";

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if ((r == 1 || r == 2) && (c == 1 || c == 2)) {
          if (r == 1 && c == 1) {
            sb.writeln('<div class="si-cell center-box">卐<br>$chartTitle<br><span style="font-size: 7pt; color: #8b2500;">$centerSub</span></div>');
          }
          continue;
        }
        final signIdx = grid[r][c];
        final signName = AstroConstants.rashisTelugu[signIdx];
        final planetsHtml = signOccupants[signIdx].join(' ');
        sb.writeln('<div class="si-cell"><span class="si-sign-name">$signName</span><div class="si-planets">$planetsHtml</div></div>');
      }
    }
    sb.writeln('</div>');
    return sb.toString();
  }

  static String _buildSavChartHtml(AshtakavargaData av) {
    final grid = AstroConstants.southIndianGrid;
    final sb = StringBuffer();
    sb.writeln('<div class="si-chart" style="max-width:220px; height:220px;">');
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if ((r == 1 || r == 2) && (c == 1 || c == 2)) {
          if (r == 1 && c == 1) {
            sb.writeln('<div class="si-cell center-box" style="font-size:9pt;"><span style="color:#6b1111;">SAV</span><br><b style="font-size:12pt; color:#8b2500;">337</b></div>');
          }
          continue;
        }
        final signIdx = grid[r][c];
        final signName = AstroConstants.rashisTelugu[signIdx];
        final pts = av.sav[signIdx];
        final isHigh = pts >= 28;
        sb.writeln('<div class="si-cell" style="background:${isHigh ? "#f0fdf4" : "#ffffff"};"><span class="si-sign-name">$signName</span><div class="si-planets" style="color:${isHigh ? "#166534" : "#991b1b"}; font-size:10pt;">$pts</div></div>');
      }
    }
    sb.writeln('</div>');
    return sb.toString();
  }

  static String _formatDms(double deg) {
    deg = (deg % 360.0 + 360.0) % 360.0;
    int d = deg.floor();
    double mTotal = (deg - d) * 60.0;
    int m = mTotal.floor();
    int s = ((mTotal - m) * 60.0).round();
    if (s == 60) {
      s = 0;
      m += 1;
    }
    if (m == 60) {
      m = 0;
      d += 1;
    }
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    return "$d°$mStr'$sStr\"";
  }

  static String _getTeluguDignity(PlanetPosition p) {
    switch (p.dignity) {
      case 'Exalted': return '<span style="color:#166534;">ఉచ్ఛ</span>';
      case 'Moolatrikona': return '<span style="color:#15803d;">మూలత్రికోణం</span>';
      case 'Own Sign': return '<span style="color:#0369a1;">స్వక్షేత్రం</span>';
      case 'Friendly': return 'మిత్రుడు';
      case 'Neutral': return 'సమం';
      case 'Enemy': return '<span style="color:#b45309;">శత్రువు</span>';
      case 'Debilitated': return '<span style="color:#b91c1c;">నీచ</span>';
      default: return p.dignity;
    }
  }
}
