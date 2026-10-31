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
import '../services/divisional_chart_service.dart';

/// Professional, complete 20-Page Telugu Vedic Astrology Report Generator
/// (|| శ్రీరస్తు శుభమస్తు విజయోస్తు || - సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)
/// Renders with 100% Flawless OpenType Indic Typography & HarfBuzz complex text shaping
class TeluguHoroscopeReportGenerator {
  TeluguHoroscopeReportGenerator._();

  static const String blessingHeader = 'శ్రీరస్తు శుభమస్తు విజయోస్తు';
  static const String guruBlessing = 'మా గురు,పితృదేవతల ఆశీర్వాదముతో';
  static const String appTitle = 'సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం';
  static const String expertiseLine = 'జ్యోతిష,వాస్తు,సంఖ్యాశాస్త్ర, ఆరాస్కానర్ నిపుణులు.';
  static const String astrologerTitleAndMobile = 'జ్యోతిష విద్యాభూషణ-M.B.S.Sastry-9030166610';
  static const String astrologerName = 'M.B.S.Sastry';
  static const String astrologerMobile = '9030166610';
  static const String astrologerAddress = 'భవానీపురం, విజయవాడ - 12 (BHAVANIPURAM VIJAYAWADA 12)';
  static const String invocationShloka = 'జననీ జన్మ సౌఖ్యానాం,వర్ధనీ కుల సంపదాం!\nపదవీ పూర్వ పుణ్యానాం, లిఖ్యతే జన్మపత్రికా!!';

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

    final now = DateTime.now();
    final limit80 = birth.dateTime.add(Duration(days: (80 * 365.2425).round()));

    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="te">');
    buffer.writeln('<head>');
    buffer.writeln('<meta charset="UTF-8">');
    buffer.writeln('<title>$blessingHeader • $appTitle - ${birth.name.isEmpty ? "జాతక చక్రము" : birth.name}</title>');
    buffer.writeln('<style>');
    buffer.writeln('  @import url("https://fonts.googleapis.com/css2?family=Tiro+Telugu:ital@0;1&family=Ramabhadra&family=Noto+Sans+Telugu:wght@400;600;700;800&display=swap");');
    buffer.writeln('  @page { size: A4 portrait; margin: 8mm 8mm 10mm 8mm; }');
    buffer.writeln('  * { box-sizing: border-box; }');
    buffer.writeln('  body { font-family: "Tiro Telugu", "Noto Sans Telugu", "Ramabhadra", serif, "Arial Unicode MS"; color: #2b1d0c; background: #fdfbf7; margin: 0; padding: 12px; font-size: 9.5pt; line-height: 1.35; }');
    buffer.writeln('  .page-card { background: #ffffff; border: 2px solid #b8860b; border-radius: 8px; padding: 12px; margin-bottom: 20px; page-break-after: always; break-after: page; box-shadow: 0 4px 14px rgba(139,37,0,0.08); position: relative; min-height: 268mm; display: flex; flex-direction: column; justify-content: space-between; }');
    buffer.writeln('  .page-card:last-child { page-break-after: auto; break-after: auto; }');
    buffer.writeln('  .page-content { flex: 1; }');
    buffer.writeln('  .main-header { text-align: center; border: 2px solid #8b2500; outline: 1.5px solid #d4af37; outline-offset: -4px; background: radial-gradient(circle at 50% 20%, #ffffff 0%, #fffcf2 45%, #faedd7 100%); padding: 12px 16px 10px 16px; border-radius: 8px; margin-bottom: 12px; box-shadow: 0 4px 12px rgba(107, 17, 17, 0.08); }');
    buffer.writeln('  .top-blessing-row { display: flex; justify-content: center; align-items: center; gap: 8px; margin-bottom: 2px; }');
    buffer.writeln('  .top-blessing { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 13pt; font-weight: 800; color: #8b2500; margin: 0; letter-spacing: 0.6px; }');
    buffer.writeln('  .guru-blessing { font-family: "Tiro Telugu", "Noto Sans Telugu", serif; font-size: 10.5pt; font-weight: 700; color: #92400e; font-style: italic; margin: 2px 0 4px 0; letter-spacing: 0.3px; }');
    buffer.writeln('  .title-ornament { color: #d4af37; font-size: 11pt; }');
    buffer.writeln('  .app-title { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 19pt; font-weight: 800; color: #6b1111; margin: 3px 0 2px 0; letter-spacing: 0.5px; }');
    buffer.writeln('  .title-divider { display: flex; align-items: center; justify-content: center; gap: 10px; margin: 4px 0; }');
    buffer.writeln('  .title-divider-line { flex: 1; max-width: 90px; height: 1.2px; background: linear-gradient(90deg, transparent, #d4af37, #8b2500, #d4af37, transparent); }');
    buffer.writeln('  .expertise-bar { font-size: 10.5pt; font-weight: 700; color: #78350f; margin-top: 2px; }');
    buffer.writeln('  .scholar-pill { display: inline-block; background: #6b1111; color: #ffffff; padding: 3px 14px; border-radius: 14px; font-size: 10.5pt; font-weight: 800; margin-top: 5px; letter-spacing: 0.3px; box-shadow: 0 2px 5px rgba(107, 17, 17, 0.2); }');
    buffer.writeln('  .sloka-box { margin-top: 8px; font-size: 9.5pt; font-weight: 700; color: #6b1111; border-top: 1.5px dashed #d4af37; padding-top: 6px; line-height: 1.4; font-style: normal; }');
    buffer.writeln('  .sub-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1.5px solid #d4af37; background: #fffbf0; padding: 4px 8px; margin-bottom: 8px; font-size: 8.5pt; font-weight: 700; color: #6b1111; }');
    buffer.writeln('  .section-title { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 10.5pt; font-weight: 700; color: #6b1111; background: #fdecc8; padding: 3px 8px; border-left: 5px solid #6b1111; border-radius: 3px; margin: 8px 0 5px 0; }');
    buffer.writeln('  .grid-2 { display: flex; gap: 10px; }');
    buffer.writeln('  .grid-2 > div { flex: 1; }');
    buffer.writeln('  table.data-table { width: 100%; border-collapse: collapse; margin: 3px 0 6px 0; font-size: 8.5pt; }');
    buffer.writeln('  table.data-table th { background: #6b1111; color: #ffffff; font-weight: 700; padding: 3px 5px; border: 1px solid #6b1111; text-align: center; font-size: 8.5pt; }');
    buffer.writeln('  table.data-table td { border: 1px solid #d4af37; padding: 2.5px 5px; color: #220f00; font-size: 8.5pt; }');
    buffer.writeln('  table.data-table tr:nth-child(even) { background: #fdfbf7; }');
    buffer.writeln('  .bold { font-weight: 700; }');
    buffer.writeln('  .center { text-align: center; }');
    buffer.writeln('  .gold-text { color: #8b2500; font-weight: 700; }');
    buffer.writeln('  .chart-header-title { text-align: center; font-weight: 700; color: #6b1111; font-size: 8.5pt; margin-bottom: 3px; background: #fffbf0; padding: 2px 4px; border-radius: 4px; border: 1px solid #d4af37; }');
    buffer.writeln('  .si-chart { display: grid; grid-template-columns: repeat(4, 1fr); grid-template-rows: repeat(4, 1fr); border: 1.5px solid #8b2500; width: 100%; max-width: 255px; height: 232px; margin: 0 auto; background: #ffffff; }');
    buffer.writeln('  .si-cell { border: 1px solid #d4af37; padding: 1.5px 2px; position: relative; font-size: 7.5pt; overflow: hidden; display: flex; flex-direction: column; justify-content: flex-start; }');
    buffer.writeln('  .si-cell.lagna-cell { background: #fff8eb; }');
    buffer.writeln('  .si-cell.center-box { grid-column: 2 / span 2; grid-row: 2 / span 2; background: #fffbf0; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; font-family: "Ramabhadra", serif; font-weight: 800; font-size: 10pt; color: #6b1111; border: 1.5px solid #8b2500; padding: 2px; line-height: 1.25; }');
    buffer.writeln('  .si-sign-name { font-size: 6.5pt; color: #78350f; font-weight: 700; line-height: 1; }');
    buffer.writeln('  .si-planets { font-size: 7.5pt; font-weight: 700; color: #1e293b; margin-top: 1.5px; line-height: 1.25; text-align: center; }');
    buffer.writeln('  .lagna-badge { color: #b91c1c; font-weight: 800; }');
    buffer.writeln('  .highlight-card { background: #fffbf0; border: 1.2px solid #d4af37; border-radius: 5px; padding: 6px 10px; margin: 6px 0; }');
    buffer.writeln('  .footer-note { margin-top: 8px; display: flex; justify-content: space-between; font-size: 7.5pt; color: #78350f; border-top: 1px solid #d4af37; padding-top: 3px; }');
    buffer.writeln('  @media print {');
    buffer.writeln('    body { background: #fff; padding: 0; margin: 0; }');
    buffer.writeln('    .no-print { display: none !important; }');
    buffer.writeln('    .page-card { border: 1px solid #d4af37 !important; box-shadow: none !important; margin: 0 !important; padding: 6mm !important; page-break-after: always !important; page-break-inside: avoid !important; break-after: page !important; break-inside: avoid !important; min-height: 280mm !important; }');
    buffer.writeln('    .page-card:last-child { page-break-after: auto !important; break-after: auto !important; }');
    buffer.writeln('  }');
    buffer.writeln('</style>');

    if (autoPrint) {
      buffer.writeln('<script>');
      buffer.writeln('  window.addEventListener("load", function() {');
      buffer.writeln('    if (document.fonts) {');
      buffer.writeln('      document.fonts.ready.then(function() {');
      buffer.writeln('        setTimeout(function() { window.print(); }, 400);');
      buffer.writeln('      });');
      buffer.writeln('    } else {');
      buffer.writeln('      setTimeout(function() { window.print(); }, 800);');
      buffer.writeln('    }');
      buffer.writeln('  });');
      buffer.writeln('</script>');
    }
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    // FLOATING ACTION BAR FOR DOWNLOAD / PRINT
    buffer.writeln('  <div class="no-print" style="position: sticky; top: 0; z-index: 99999; background: #6b1111; color: #fff; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 14px rgba(0,0,0,0.3); margin-bottom: 16px; border-radius: 6px;">');
    buffer.writeln('    <div style="font-weight: 800; font-size: 12pt;">卐 $blessingHeader • $appTitle</div>');
    buffer.writeln('    <div style="display: flex; gap: 12px;">');
    buffer.writeln('      <button onclick="window.print()" style="background: #f59e0b; color: #000; font-weight: 800; font-size: 11pt; padding: 8px 22px; border: none; border-radius: 6px; cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">🖨️ సంపూర్ణ 25 పుటల PDF గా సేవ్ చేయండి (Save as PDF - 25 Pages)</button>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');

    const totalReportPages = 25;

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 1: ప్రాథమిక వివరాలు, పంచాంగం & నిరాయణ గ్రహ స్థానాలు ──
    // ══════════════════════════════════════════════════════════════════════
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="page-content">');
    buffer.writeln('    <div class="main-header">');
    buffer.writeln('      <div class="top-blessing-row">');
    buffer.writeln('        <span class="title-ornament">卐</span>');
    buffer.writeln('        <span class="top-blessing">|| $blessingHeader ||</span>');
    buffer.writeln('        <span class="title-ornament">卐</span>');
    buffer.writeln('      </div>');
    buffer.writeln('      <div class="guru-blessing">❖ $guruBlessing ❖</div>');
    buffer.writeln('      <div class="title-divider">');
    buffer.writeln('        <div class="title-divider-line"></div>');
    buffer.writeln('        <span class="title-ornament">🪔</span>');
    buffer.writeln('        <div class="title-divider-line"></div>');
    buffer.writeln('      </div>');
    buffer.writeln('      <h1 class="app-title">$appTitle</h1>');
    buffer.writeln('      <div class="expertise-bar">$expertiseLine</div>');
    buffer.writeln('      <div class="scholar-pill">$astrologerTitleAndMobile</div>');
    buffer.writeln('      <div class="sloka-box">${invocationShloka.replaceAll("\n", "<br>")}</div>');
    buffer.writeln('    </div>');

    buffer.writeln('    <div class="grid-2">');
    buffer.writeln('      <div>');
    buffer.writeln('        <div class="section-title">1. జాతక ప్రాథమిక వివరాలు</div>');
    buffer.writeln('        <table class="data-table">');
    buffer.writeln('          <tr><td class="bold" style="width:38%;">పేరు:</td><td><b>${birth.name.isEmpty ? "శ్రీ / కుమారి" : birth.name}</b></td></tr>');
    buffer.writeln('          <tr><td class="bold">తేదీ / వారం:</td><td>${DateFormat("dd-MM-yyyy").format(birth.dateTime)}, $weekdayTel</td></tr>');
    buffer.writeln('          <tr><td class="bold">సమయము:</td><td>${DateFormat("hh:mm:ss a").format(birth.dateTime)}</td></tr>');
    buffer.writeln('          <tr><td class="bold">జన్మ స్థలము:</td><td>${birth.placeName}</td></tr>');
    buffer.writeln('          <tr><td class="bold">అక్షాంశ/రేఖాంశం:</td><td>${birth.latitude.toStringAsFixed(2)}° N, ${birth.longitude.toStringAsFixed(2)}° E</td></tr>');
    buffer.writeln('          <tr><td class="bold">ఆయనాంశము:</td><td>లాహిరి (${_formatDms(chartData.ayanamsa)})</td></tr>');
    buffer.writeln('        </table>');
    buffer.writeln('      </div>');
    buffer.writeln('      <div>');
    buffer.writeln('        <div class="section-title">2. జన్మ పంచాంగ వివరములు</div>');
    buffer.writeln('        <table class="data-table">');
    buffer.writeln('          <tr><td class="bold" style="width:38%;">తిథి:</td><td><b>$tithiTel</b></td></tr>');
    buffer.writeln('          <tr><td class="bold">జన్మ నక్షత్రం:</td><td><b>$nakTel</b></td></tr>');
    buffer.writeln('          <tr><td class="bold">నిత్య యోగం:</td><td>$yogaTel</td></tr>');
    buffer.writeln('          <tr><td class="bold">కరణం:</td><td>$karanaTel</td></tr>');
    buffer.writeln('          <tr><td class="bold">సూర్యోదయ/అస్తమయం:</td><td>${DateFormat("hh:mm a").format(panchanga.sunrise)} / ${DateFormat("hh:mm a").format(panchanga.sunset)}</td></tr>');
    buffer.writeln('          <tr><td class="bold">రాహు కాలం:</td><td>${DateFormat("hh:mm a").format(panchanga.rahuKalam.$1)} - ${DateFormat("hh:mm a").format(panchanga.rahuKalam.$2)}</td></tr>');
    buffer.writeln('        </table>');
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');

    buffer.writeln('    <div class="section-title">3. నిరాయణ గ్రహ స్థితిగతుల సమగ్ర పట్టిక (Planetary Positions & Dignities)</div>');
    buffer.writeln('    <table class="data-table">');
    buffer.writeln('      <thead><tr><th>గ్రహము</th><th>రాశి</th><th>అంశలు (స్పష్టం)</th><th>నక్షత్రం</th><th>పాదం</th><th>నక్షత్రాధిపతి</th><th>స్థితి</th></tr></thead>');
    buffer.writeln('      <tbody>');
    buffer.writeln('        <tr style="background:#fff3e0; font-weight:700;"><td class="center gold-text">లగ్నము</td><td class="center">${AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}</td><td class="center">${_formatDms(chartData.ascendant.degreesInRashi)}</td><td class="center">${AstroConstants.nakshatrasTelugu[chartData.ascendant.nakshatraIndex]}</td><td class="center">${chartData.ascendant.pada}</td><td class="center">${AstroConstants.nakshatraLordsTelugu[chartData.ascendant.nakshatraIndex]}</td><td class="center gold-text">లగ్న కేంద్రం</td></tr>');
    for (final p in chartData.planets) {
      final pTel = AstroConstants.planetNamesTelugu[p.name] ?? p.name;
      final rTel = AstroConstants.rashisTelugu[p.rashiIndex];
      final nTel = AstroConstants.nakshatrasTelugu[p.nakshatraIndex];
      final lordTel = AstroConstants.nakshatraLordsTelugu[p.nakshatraIndex];
      final digTel = _getTeluguDignity(p);
      final retro = p.isRetrograde ? " <span style='color:#c2410c;'>(వ)</span>" : "";
      final combust = p.isCombust ? " <span style='color:#ea580c;'>(మౌ)</span>" : "";
      buffer.writeln('        <tr><td class="center bold">$pTel$retro$combust</td><td class="center">$rTel</td><td class="center">${_formatDms(p.degreesInRashi)}</td><td class="center">$nTel</td><td class="center">${p.pada}</td><td class="center">$lordTel</td><td class="center bold">$digTel</td></tr>');
    }
    buffer.writeln('      </tbody></table>');

    buffer.writeln('    <div style="font-size:8pt; color:#6b1111; margin-top:4px;">సూచన: <span style="color:#c2410c; font-weight:700;">(వ)</span> = వక్ర గ్రహము (Retrograde) • <span style="color:#ea580c; font-weight:700;">(మౌ)</span> = మౌఢ్య / అస్తంగత గ్రహము (Combust by Sun).</div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట 1 / $totalReportPages</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGES 2 to 5: సమగ్ర షోడశవర్గ చక్రములు (16 Shodashavarga Charts) ──
    // ══════════════════════════════════════════════════════════════════════
    final vargaPages = [
      (
        pageNum: 2,
        title: 'షోడశవర్గ చక్రములు - భాగము 1 (D1, D9, D2, D3)',
        charts: [
          DivisionalChartType.d1,
          DivisionalChartType.d9,
          DivisionalChartType.d2,
          DivisionalChartType.d3,
        ]
      ),
      (
        pageNum: 3,
        title: 'షోడశవర్గ చక్రములు - భాగము 2 (D4, D7, D10, D12)',
        charts: [
          DivisionalChartType.d4,
          DivisionalChartType.d7,
          DivisionalChartType.d10,
          DivisionalChartType.d12,
        ]
      ),
      (
        pageNum: 4,
        title: 'షోడశవర్గ చక్రములు - భాగము 3 (D16, D20, D24, D27)',
        charts: [
          DivisionalChartType.d16,
          DivisionalChartType.d20,
          DivisionalChartType.d24,
          DivisionalChartType.d27,
        ]
      ),
      (
        pageNum: 5,
        title: 'షోడశవర్గ చక్రములు - భాగము 4 (D30, D40, D45, D60)',
        charts: [
          DivisionalChartType.d30,
          DivisionalChartType.d40,
          DivisionalChartType.d45,
          DivisionalChartType.d60,
        ]
      ),
    ];

    for (final vp in vargaPages) {
      buffer.writeln('<div class="page-card">');
      buffer.writeln('  <div class="page-content">');
      buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');
      buffer.writeln('    <div class="section-title">${vp.title}</div>');

      buffer.writeln('    <div class="grid-2" style="margin-bottom: 8px;">');
      buffer.writeln('      <div>');
      buffer.writeln('        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[0])}</div>');
      buffer.writeln(_buildDivisionalChartHtml(chartData, vp.charts[0]));
      buffer.writeln('      </div>');
      buffer.writeln('      <div>');
      buffer.writeln('        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[1])}</div>');
      buffer.writeln(_buildDivisionalChartHtml(chartData, vp.charts[1]));
      buffer.writeln('      </div>');
      buffer.writeln('    </div>');

      buffer.writeln('    <div class="grid-2">');
      buffer.writeln('      <div>');
      buffer.writeln('        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[2])}</div>');
      buffer.writeln(_buildDivisionalChartHtml(chartData, vp.charts[2]));
      buffer.writeln('      </div>');
      buffer.writeln('      <div>');
      buffer.writeln('        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[3])}</div>');
      buffer.writeln(_buildDivisionalChartHtml(chartData, vp.charts[3]));
      buffer.writeln('      </div>');
      buffer.writeln('    </div>');
      buffer.writeln('  </div>');
      buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట ${vp.pageNum} / $totalReportPages</span></div>');
      buffer.writeln('</div>');
    }

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 6: ద్వాదశ భావ స్ఫుట పట్టిక & సర్వాష్టకవర్గము ──
    // ══════════════════════════════════════════════════════════════════════
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="page-content">');
    buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');

    buffer.writeln('    <div class="section-title">4. ద్వాదశ భావ స్ఫుట పట్టిక (12 Houses Bhava Sputa Patika & Lords)</div>');
    buffer.writeln('    <table class="data-table">');
    buffer.writeln('      <thead><tr><th>భావము</th><th>భావ ఆరంభము</th><th>భావ మధ్యము (స్ఫుటం)</th><th>భావ అంత్యము</th><th>భావాధిపతి</th></tr></thead><tbody>');
    final lagnaLon = chartData.ascendant.longitude;
    for (int i = 0; i < 12; i++) {
      int h = i + 1;
      final midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
      final startLon = (midLon - 15.0 + 360.0) % 360.0;
      final endLon = (midLon + 15.0) % 360.0;
      final rIdx = (midLon / 30.0).floor() % 12;
      final lord = AstroConstants.rashiLordsTelugu[rIdx];
      buffer.writeln('        <tr><td class="center bold gold-text">$hవ భావము</td><td class="center">${_formatDms(startLon)}</td><td class="center bold">${_formatDms(midLon)}</td><td class="center">${_formatDms(endLon)}</td><td class="center bold">$lord</td></tr>');
    }
    buffer.writeln('      </tbody></table>');

    buffer.writeln('    <div class="section-title">5. సర్వాష్టకవర్గ చక్రము & 337 బిందువుల సమగ్ర పట్టిక (SAV 337)</div>');
    buffer.writeln('    <div class="grid-2" style="align-items:center;">');
    buffer.writeln('      <div>');
    buffer.writeln(_buildSavChartHtml(ashtakavarga));
    buffer.writeln('      </div>');
    buffer.writeln('      <div>');
    buffer.writeln('        <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('          <thead><tr><th>రాశి</th><th>రవి</th><th>చం</th><th>కు</th><th>బు</th><th>గు</th><th>శు</th><th>శని</th><th>SAV</th></tr></thead><tbody>');
    const planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    for (int rIdx = 0; rIdx < 12; rIdx++) {
      final savPts = ashtakavarga.sav[rIdx];
      final isHigh = savPts >= 28;
      buffer.write('          <tr style="${isHigh ? "background:#f0fdf4;" : ""}"><td class="bold">${AstroConstants.rashisTelugu[rIdx]}</td>');
      for (final p in planets) {
        final pts = ashtakavarga.bav[p]?[rIdx] ?? 0;
        buffer.write('<td class="center">$pts</td>');
      }
      buffer.writeln('<td class="center bold ${isHigh ? "gold-text" : ""}">$savPts</td></tr>');
    }
    buffer.writeln('        </tbody></table>');
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట 6 / $totalReportPages</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 7: షడ్బల బలాబలాలు, భృగు బిందువు, యోగీ-అవయోగీ & చరకారకములు ──
    // ══════════════════════════════════════════════════════════════════════
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="page-content">');
    buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');

    buffer.writeln('    <div class="section-title">6. షడ్బల బలాబలాల సమగ్ర పట్టిక (Shadbala Strength Analysis)</div>');
    buffer.writeln('    <table class="data-table" style="font-size:8pt;">');
    buffer.writeln('      <thead><tr><th>గ్రహము</th><th>స్థాన</th><th>దిగ్</th><th>కాల</th><th>చేష్ట</th><th>నైసర్గిక</th><th>దృగ్</th><th>మొత్తం రూపాలు</th><th>ర్యాంకు</th></tr></thead><tbody>');
    for (final sb in shadbala) {
      final pTel = AstroConstants.planetNamesTelugu[sb.planetName] ?? sb.planetName;
      buffer.writeln('      <tr><td class="bold">$pTel</td><td class="center">${sb.sthanaBala.toStringAsFixed(0)}</td><td class="center">${sb.digBala.toStringAsFixed(0)}</td><td class="center">${sb.kalaBala.toStringAsFixed(0)}</td><td class="center">${sb.chestaBala.toStringAsFixed(0)}</td><td class="center">${sb.naisargikaBala.toStringAsFixed(0)}</td><td class="center">${sb.drikBala.toStringAsFixed(0)}</td><td class="center bold">${sb.totalRupas.toStringAsFixed(1)}</td><td class="center bold gold-text">#${sb.rank}</td></tr>');
    }
    buffer.writeln('    </tbody></table>');

    buffer.writeln('    <div class="section-title">7. భృగు బిందువు, యోగీ-అవయోగీ & జైమిని 7 చరకారకములు</div>');
    buffer.writeln('    <div class="grid-2">');
    buffer.writeln('      <div>');
    buffer.writeln('        <table class="data-table">');
    buffer.writeln('          <tr><td class="bold" style="width:42%;">భృగు బిందువు (Bhrigu Bindu):</td><td><b>${special.bhriguBinduRashi} (${_formatDms(special.bhriguBinduRashiDeg)})</b><br><span style="font-size:8pt; color:#8b2500;">భాగ్య బిందువు (${special.bhriguBinduHouse}వ భావం)</span></td></tr>');
    buffer.writeln('          <tr><td class="bold">యోగ గ్రహము (Yogi):</td><td><b>${special.yogiPlanet}</b> (${special.yogiRashi} - ${special.yogiNakshatra})</td></tr>');
    buffer.writeln('          <tr><td class="bold">సహయోగి గ్రహము:</td><td><b>${special.sahayogiPlanet}</b></td></tr>');
    buffer.writeln('          <tr><td class="bold">అవయోగ గ్రహము:</td><td><b>${special.avayogiPlanet}</b> (${special.avayogiRashi} - ${special.avayogiNakshatra})</td></tr>');
    buffer.writeln('        </table>');
    buffer.writeln('      </div>');
    buffer.writeln('      <div>');
    buffer.writeln('        <table class="data-table">');
    buffer.writeln('          <thead><tr><th>చరకారకము</th><th>గ్రహము</th><th>రాశి స్థానం</th></tr></thead><tbody>');
    for (final k in special.charaKarakas) {
      buffer.writeln('          <tr><td class="bold gold-text">${k.nameTelugu}</td><td class="center bold">${k.planetTelugu}</td><td class="center">${k.rashiTelugu} (${_formatDms(k.degreeInRashi)})</td></tr>');
    }
    buffer.writeln('        </tbody></table>');
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');

    buffer.writeln('    <div class="highlight-card" style="margin-top: 8px;">');
    buffer.writeln('      <div style="font-weight:700; color:#6b1111; font-size:9pt; margin-bottom:2px;">✦ భృగు బిందువు విశేష ఫలితము:</div>');
    buffer.writeln('      <div style="font-size:8pt; color:#3e1b00; line-height:1.35;">రాహువు నుండి చంద్రుని వరకు గల దూరపు ఖచ్చితమైన మధ్య బిందువునే "భృగు బిందువు" (Destiny Point) అంటారు. గోచార గురుడు లేదా శుభ గ్రహములు ఈ బిందువును సంధించిన కాలంలో భాగ్యోదయము, వివాహము, ఉద్యోగ ప్రాప్తి మరియు విశేష ధనలాభములు సిద్ధించును.</div>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట 7 / $totalReportPages</span></div>');
    buffer.writeln('</div>');

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGES 8 to 20: సంపూర్ణ వింశోత్తరి దశా మహాపట్టిక (80 Years - 5 Levels) ──
    // ══════════════════════════════════════════════════════════════════════

    // Collect all Antar Dashas from birth up to 80 years
    final allAntars80 = <({String mahaPlanet, DashaPeriod antar, double startAge, double endAge})>[];
    for (final m in dashas) {
      if (m.startDate.isAfter(limit80)) continue;
      for (final a in (m.subPeriods ?? [])) {
        if (a.startDate.isBefore(limit80)) {
          final sAge = a.startDate.difference(birth.dateTime).inDays / 365.2425;
          final eAge = a.endDate.difference(birth.dateTime).inDays / 365.2425;
          allAntars80.add((
            mahaPlanet: m.planet,
            antar: a,
            startAge: sAge < 0 ? 0 : sAge,
            endAge: eAge,
          ));
        }
      }
    }

    // ── PAGE 8: మహాదశల సమగ్ర పట్టిక & అంతర్దశలు (0 - 40 సంవత్సరాలు) ──
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="page-content">');
    buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');

    buffer.writeln('    <div class="section-title">8. వింశోత్తరి మహాదశల సమగ్ర కాలపరిమితి పట్టిక (120-Year Mahadasha Overview)</div>');
    buffer.writeln('    <table class="data-table">');
    buffer.writeln('      <thead><tr><th>మహాదశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>వయస్సు కాలపరిమితి</th><th>స్థితి</th></tr></thead><tbody>');
    for (final d in dashas) {
      final pTel = AstroConstants.planetNamesTelugu[d.planet] ?? d.planet;
      final dur = (d.endDate.difference(d.startDate).inDays / 365.25).toStringAsFixed(1);
      final isCurrent = now.isAfter(d.startDate) && now.isBefore(d.endDate);
      final startAge = (d.startDate.difference(birth.dateTime).inDays / 365.25).clamp(0, 120).toStringAsFixed(1);
      final endAge = (d.endDate.difference(birth.dateTime).inDays / 365.25).clamp(0, 120).toStringAsFixed(1);
      buffer.writeln('      <tr style="${isCurrent ? "background:#fef3c7; font-weight:700;" : ""}"><td class="center bold">$pTel మహాదశ</td><td class="center">${DateFormat("dd-MM-yyyy").format(d.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(d.endDate)}</td><td class="center">$dur సం.</td><td class="center">$startAge నుండి $endAge సం.</td><td class="center ${isCurrent ? "gold-text" : ""}">${isCurrent ? "★ ప్రస్తుతం" : "పూర్తి కాలం"}</td></tr>');
    }
    buffer.writeln('    </tbody></table>');

    final antars0to40 = allAntars80.where((x) => x.startAge < 40.0).toList();
    buffer.writeln('    <div class="section-title">9. అంతర్దశల సమగ్ర కాలచక్రం (జన్మ నుండి 40 సంవత్సరాల వయస్సు వరకు)</div>');
    buffer.writeln('    <table class="data-table" style="font-size:7.5pt;">');
    buffer.writeln('      <thead><tr><th>క్రమ</th><th>మహా / అంతర దశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>వయస్సు</th><th>స్థితి</th></tr></thead><tbody>');
    for (int i = 0; i < antars0to40.length; i++) {
      final item = antars0to40[i];
      final mTel = AstroConstants.planetNamesTelugu[item.mahaPlanet] ?? item.mahaPlanet;
      final aTel = AstroConstants.planetNamesTelugu[item.antar.planet] ?? item.antar.planet;
      final isActive = now.isAfter(item.antar.startDate) && now.isBefore(item.antar.endDate);
      final isPast = item.antar.endDate.isBefore(now);
      final status = isActive ? "★ ప్రస్తుతం" : (isPast ? "గతించినది" : "రాబోవునది");
      buffer.writeln('      <tr style="${isActive ? "background:#fef3c7; font-weight:700;" : (isPast ? "color:#6b7280;" : "")}"><td class="center">${i + 1}</td><td class="bold">$mTel / $aTel</td><td class="center">${DateFormat("dd-MM-yyyy").format(item.antar.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(item.antar.endDate)}</td><td class="center">${item.antar.durationString}</td><td class="center">${item.startAge.toStringAsFixed(1)} - ${item.endAge.toStringAsFixed(1)} సం.</td><td class="center ${isActive ? "gold-text" : ""}">$status</td></tr>');
    }
    buffer.writeln('    </tbody></table>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట 8 / $totalReportPages</span></div>');
    buffer.writeln('</div>');

    // ── PAGE 9: అంతర్దశల సమగ్ర పట్టిక (40 నుండి 80+ సంవత్సరాలు) ──
    final antars40to80 = allAntars80.where((x) => x.startAge >= 40.0).toList();
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="page-content">');
    buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');
    buffer.writeln('    <div class="section-title">10. అంతర్దశల సమగ్ర కాలచక్రం (40 నుండి 80+ సంవత్సరాల వయస్సు వరకు)</div>');
    buffer.writeln('    <table class="data-table" style="font-size:7.5pt;">');
    buffer.writeln('      <thead><tr><th>క్రమ</th><th>మహా / అంతర దశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>వయస్సు</th><th>స్థితి</th></tr></thead><tbody>');
    for (int i = 0; i < antars40to80.length; i++) {
      final item = antars40to80[i];
      final mTel = AstroConstants.planetNamesTelugu[item.mahaPlanet] ?? item.mahaPlanet;
      final aTel = AstroConstants.planetNamesTelugu[item.antar.planet] ?? item.antar.planet;
      final isActive = now.isAfter(item.antar.startDate) && now.isBefore(item.antar.endDate);
      final isPast = item.antar.endDate.isBefore(now);
      final status = isActive ? "★ ప్రస్తుతం" : (isPast ? "గతించినది" : "రాబోవునది");
      buffer.writeln('      <tr style="${isActive ? "background:#fef3c7; font-weight:700;" : (isPast ? "color:#6b7280;" : "")}"><td class="center">${antars0to40.length + i + 1}</td><td class="bold">$mTel / $aTel</td><td class="center">${DateFormat("dd-MM-yyyy").format(item.antar.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(item.antar.endDate)}</td><td class="center">${item.antar.durationString}</td><td class="center">${item.startAge.toStringAsFixed(1)} - ${item.endAge.toStringAsFixed(1)} సం.</td><td class="center ${isActive ? "gold-text" : ""}">$status</td></tr>');
    }
    buffer.writeln('    </tbody></table>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట 9 / $totalReportPages</span></div>');
    buffer.writeln('</div>');

    // ── PAGES 10 to 12: ప్రత్యంతర దశల సమగ్ర కాలచక్రం (Level 3 Pratyantar Dashas up to 80 Years) ──
    final pdChunkSize = (allAntars80.length / 3).ceil();
    for (int pIdx = 0; pIdx < 3; pIdx++) {
      int startIdx = pIdx * pdChunkSize;
      int endIdx = ((pIdx + 1) * pdChunkSize).clamp(0, allAntars80.length);
      final pageAntars = allAntars80.sublist(startIdx, endIdx);
      int pageNum = 10 + pIdx;

      buffer.writeln('<div class="page-card">');
      buffer.writeln('  <div class="page-content">');
      buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');
      buffer.writeln('    <div class="section-title">11.${pIdx + 1} ప్రత్యంతర దశల సమగ్ర పట్టిక (Level 3: Pratyantar Dashas - భాగము ${pIdx + 1})</div>');

      for (final aItem in pageAntars) {
        final a = aItem.antar;
        final mTel = AstroConstants.planetNamesTelugu[aItem.mahaPlanet] ?? aItem.mahaPlanet;
        final aTel = AstroConstants.planetNamesTelugu[a.planet] ?? a.planet;
        final pdList = a.subPeriods ?? [];

        buffer.writeln('    <div style="font-size:8pt; font-weight:700; color:#6b1111; margin-top:3px; background:#fff7ed; padding:2px 6px; border-left:3px solid #8b2500;">✦ $mTel మహాదశ / $aTel అంతర (${DateFormat("dd-MM-yy").format(a.startDate)} నుండి ${DateFormat("dd-MM-yy").format(a.endDate)}):</div>');
        buffer.writeln('    <table class="data-table" style="font-size:7pt; margin-bottom:3px;">');
        buffer.writeln('      <thead><tr><th>ప్రత్యంతర నాథుడు</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
        for (final pd in pdList) {
          final pdTel = AstroConstants.planetNamesTelugu[pd.planet] ?? pd.planet;
          final isPdActive = pd.containsDate(now);
          buffer.writeln('      <tr style="${isPdActive ? "background:#ecfdf5; font-weight:700;" : ""}"><td class="center bold">$mTel/$aTel/$pdTel</td><td class="center">${DateFormat("dd-MM-yyyy").format(pd.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy").format(pd.endDate)}</td><td class="center">${pd.durationString}</td><td class="center ${isPdActive ? "gold-text" : ""}">${isPdActive ? "★ ప్రస్తుతం" : ""}</td></tr>');
        }
        buffer.writeln('      </tbody></table>');
      }

      buffer.writeln('  </div>');
      buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట $pageNum / $totalReportPages</span></div>');
      buffer.writeln('</div>');
    }

    // ── PAGES 13 & 14: సూక్ష్మ దశల సమగ్ర విశ్లేషణ (Level 4: Sookshma Dashas up to 80 Years) ──
    final focalPds = <({String mTel, String aTel, String pdTel, DashaPeriod pd})>[];
    for (final aItem in allAntars80) {
      final a = aItem.antar;
      for (final pd in (a.subPeriods ?? [])) {
        if (pd.containsDate(now) || focalPds.length < 12) {
          final mTel = AstroConstants.planetNamesTelugu[aItem.mahaPlanet] ?? aItem.mahaPlanet;
          final aTel = AstroConstants.planetNamesTelugu[a.planet] ?? a.planet;
          final pdTel = AstroConstants.planetNamesTelugu[pd.planet] ?? pd.planet;
          focalPds.add((mTel: mTel, aTel: aTel, pdTel: pdTel, pd: pd));
        }
      }
    }

    for (int sPage = 0; sPage < 2; sPage++) {
      int sPageNum = 13 + sPage;
      int sStart = sPage * 6;
      int sEnd = ((sPage + 1) * 6).clamp(0, focalPds.length);
      final currentBatch = focalPds.sublist(sStart, sEnd);

      buffer.writeln('<div class="page-card">');
      buffer.writeln('  <div class="page-content">');
      buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');
      buffer.writeln('    <div class="section-title">12.${sPage + 1} సూక్ష్మ దశల సమగ్ర పట్టిక (Level 4: Sookshma Dashas - భాగము ${sPage + 1})</div>');

      for (final fItem in currentBatch) {
        final sdList = fItem.pd.subPeriods ?? [];
        buffer.writeln('    <div style="font-size:7.5pt; font-weight:700; color:#6b1111; margin-top:3px; background:#eff6ff; padding:2px 6px; border-left:3px solid #1e40af;">✦ ${fItem.mTel} / ${fItem.aTel} / ${fItem.pdTel} ప్రత్యంతర (${DateFormat("dd-MM-yy").format(fItem.pd.startDate)} నుండి ${DateFormat("dd-MM-yy").format(fItem.pd.endDate)}):</div>');
        buffer.writeln('    <table class="data-table" style="font-size:6.5pt; margin-bottom:3px;">');
        buffer.writeln('      <thead><tr><th>సూక్ష్మ నాథుడు</th><th>ప్రారంభ తేదీ & సమయం</th><th>ముగింపు తేదీ & సమయం</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
        for (final sd in sdList) {
          final sdTel = AstroConstants.planetNamesTelugu[sd.planet] ?? sd.planet;
          final isSdActive = sd.containsDate(now);
          buffer.writeln('      <tr style="${isSdActive ? "background:#e0f2fe; font-weight:700;" : ""}"><td class="center bold">$sdTel సూక్ష్మ</td><td class="center">${DateFormat("dd-MM-yyyy hh:mm a").format(sd.startDate)}</td><td class="center">${DateFormat("dd-MM-yyyy hh:mm a").format(sd.endDate)}</td><td class="center">${sd.durationString}</td><td class="center ${isSdActive ? "gold-text" : ""}">${isSdActive ? "★ ప్రస్తుతం" : ""}</td></tr>');
        }
        buffer.writeln('      </tbody></table>');
      }

      buffer.writeln('  </div>');
      buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట $sPageNum / $totalReportPages</span></div>');
      buffer.writeln('</div>');
    }

    // ── PAGES 15 to 24: ప్రాణ దశల సమగ్ర విశ్లేషణ (Level 5: Prana Dashas for ALL 80 YEARS down to Seconds) ──
    final pranaStages = [
      (0, 8, 'బాల్య కాలం & ప్రాథమిక వికాసం (Childhood 0-8 yrs)'),
      (8, 16, 'విద్యాభ్యాస కాలం & కౌమార దశ (Education & Growth 8-16 yrs)'),
      (16, 24, 'ఉన్నత విద్యాభ్యాసం & యవ్వన ప్రవేశం (Higher Studies & Youth 16-24 yrs)'),
      (24, 32, 'ఉద్యోగ ప్రాప్తి, వివాహం & జీవిత స్థిరత్వం (Career Launch & Marriage 24-32 yrs)'),
      (32, 40, 'కుటుంబ సౌభాగ్యం & వృత్తిపర పురోగతి (Family Settlement & Growth 32-40 yrs)'),
      (40, 48, 'ఆర్థిక పురోభివృద్ధి & సామాజిక గౌరవం (Mid-Career & Prosperity 40-48 yrs)'),
      (48, 56, 'పరిపక్వత, ఉన్నత విజయాలు & స్థిరసంపద (Peak Achievements 48-56 yrs)'),
      (56, 64, 'కీర్తి ప్రతిష్టలు, సంతాన సౌఖ్యం (Senior Leadership & Honours 56-64 yrs)'),
      (64, 72, 'విశ్రాంతి, దైవచింతన & ఆధ్యాత్మికోన్నతి (Retirement & Spirituality 64-72 yrs)'),
      (72, 80, 'పూర్ణాయుర్దాయం, ఆత్మశాంతి & మోక్ష సాధన (Longevity & Final Destiny 72-80+ yrs)'),
    ];

    for (int pIndex = 0; pIndex < pranaStages.length; pIndex++) {
      final stage = pranaStages[pIndex];
      final startYr = stage.$1;
      final endYr = stage.$2;
      final stageDesc = stage.$3;
      final pageNum = 15 + pIndex;

      buffer.writeln('<div class="page-card">');
      buffer.writeln('  <div class="page-content">');
      buffer.writeln('    <div class="sub-header"><span>$blessingHeader • $appTitle</span><span>$astrologerTitleAndMobile</span></div>');
      buffer.writeln('    <div class="section-title">13.${pIndex + 1} ప్రాణ దశల సమగ్ర కాలచక్రం: వయస్సు $startYr నుండి $endYr సం. ($stageDesc)</div>');

      buffer.writeln('    <div style="background: linear-gradient(135deg, #2b1104 0%, #4a1c06 100%); color: #fff; padding: 6px 12px; border-radius: 6px; border: 1.5px solid #d4af37; margin-bottom: 6px; font-size: 8.5pt;">');
      buffer.writeln('      <span style="color: #fde047; font-weight: 800;">వయస్సు దశ:</span> <b>$startYr నుండి $endYr సంవత్సరములు</b> • <span style="color:#f472b6; font-weight:700;">ప్రతి సంవత్సరం సమగ్ర దశ & సూక్ష్మ/ప్రాణ క్రమము (Level 5 down to Seconds)</span>');
      buffer.writeln('    </div>');

      // 1. All 8 years comprehensive Annual Prana Dasha table
      buffer.writeln('    <div style="font-size:7.5pt; font-weight:700; color:#8b2500; margin: 3px 0 2px 0;">❖ వయస్సు $startYr నుండి $endYr సం. వరకు ప్రతి సంవత్సరం నడుచు సమగ్ర దశ & ప్రాణ నాథుడు:</div>');
      buffer.writeln('    <table class="data-table" style="font-size:6.8pt; margin-bottom:5px;">');
      buffer.writeln('      <thead><tr><th>వయస్సు</th><th>సంవత్సర కాలం</th><th>మహా / అంతర / ప్రత్యంతర</th><th>సూక్ష్మ దశ</th><th>ప్రాణ నాథుడు</th><th>ప్రాణ ప్రారంభ సమయం</th><th>ప్రాణ ముగింపు సమయం</th><th>స్థితి</th></tr></thead><tbody>');

      DashaPeriod? currentStageActiveSd;
      DashaPeriod? stageMilestoneSd;

      for (int y = startYr; y < endYr; y++) {
        final yearStart = birth.dateTime.add(Duration(days: (y * 365.2425).round()));
        final yearEnd = birth.dateTime.add(Duration(days: ((y + 1) * 365.2425).round()));
        final midDate = birth.dateTime.add(Duration(days: ((y + 0.5) * 365.2425).round()));

        final h = DashaService.findCurrentHierarchy(dashas, midDate);
        final mTel = h.maha != null ? (AstroConstants.planetNamesTelugu[h.maha!.planet] ?? h.maha!.planet) : "-";
        final aTel = h.antar != null ? (AstroConstants.planetNamesTelugu[h.antar!.planet] ?? h.antar!.planet) : "-";
        final pTel = h.pratyantar != null ? (AstroConstants.planetNamesTelugu[h.pratyantar!.planet] ?? h.pratyantar!.planet) : "-";
        final sTel = h.sookshma != null ? (AstroConstants.planetNamesTelugu[h.sookshma!.planet] ?? h.sookshma!.planet) : "-";
        final prTel = h.prana != null ? (AstroConstants.planetNamesTelugu[h.prana!.planet] ?? h.prana!.planet) : "-";

        final isYearActive = now.isAfter(yearStart) && now.isBefore(yearEnd);
        final isPastYear = yearEnd.isBefore(now);
        final statusStr = isYearActive ? "★ ప్రస్తుత వయస్సు" : (isPastYear ? "గతించినది" : "రాబోవునది");

        final prStartStr = h.prana != null ? DateFormat("dd-MM-yy hh:mm a").format(h.prana!.startDate) : "-";
        final prEndStr = h.prana != null ? DateFormat("dd-MM-yy hh:mm a").format(h.prana!.endDate) : "-";

        if (isYearActive && h.sookshma != null) {
          currentStageActiveSd = h.sookshma;
        }
        if (y == startYr + 3 && h.sookshma != null) {
          stageMilestoneSd = h.sookshma;
        }

        buffer.writeln('      <tr style="${isYearActive ? "background:#fef3c7; font-weight:700;" : (isPastYear ? "color:#6b7280;" : "")}">'
          '<td class="center bold" style="color:${isYearActive ? "#8b2500" : "inherit"};">$y - ${y + 1} సం.</td>'
          '<td class="center">${DateFormat("dd/MM/yy").format(yearStart)} - ${DateFormat("dd/MM/yy").format(yearEnd)}</td>'
          '<td class="bold">$mTel / $aTel / $pTel</td>'
          '<td class="center">$sTel సూక్ష్మ</td>'
          '<td class="center bold" style="color:#b91c1c;">$prTel ప్రాణ</td>'
          '<td class="center">$prStartStr</td>'
          '<td class="center">$prEndStr</td>'
          '<td class="center bold" style="color:${isYearActive ? "#166534" : (isPastYear ? "#6b7280" : "#8b2500")};">$statusStr</td>'
        '</tr>');
      }
      buffer.writeln('      </tbody></table>');

      // 2. Full 9 Prana Dashas sequence down to seconds for key focal period of this stage
      final detailedSd = currentStageActiveSd ?? stageMilestoneSd ?? (DashaService.findCurrentHierarchy(dashas, birth.dateTime.add(Duration(days: ((startYr + 1) * 365.2425).round()))).sookshma);

      if (detailedSd != null) {
        final dHierarchy = DashaService.findCurrentHierarchy(dashas, detailedSd.startDate.add(const Duration(hours: 1)));
        final dM = dHierarchy.maha != null ? (AstroConstants.planetNamesTelugu[dHierarchy.maha!.planet] ?? dHierarchy.maha!.planet) : "";
        final dA = dHierarchy.antar != null ? (AstroConstants.planetNamesTelugu[dHierarchy.antar!.planet] ?? dHierarchy.antar!.planet) : "";
        final dP = dHierarchy.pratyantar != null ? (AstroConstants.planetNamesTelugu[dHierarchy.pratyantar!.planet] ?? dHierarchy.pratyantar!.planet) : "";
        final dS = AstroConstants.planetNamesTelugu[detailedSd.planet] ?? detailedSd.planet;

        final prList = detailedSd.subPeriods ?? [];

        buffer.writeln('    <div style="font-size:7.5pt; font-weight:700; color:#6b1111; margin-top:4px; background:#fdf2f8; padding:3px 6px; border-left:3px solid #be185d;">');
        buffer.writeln('      ✦ సమగ్ర 9 ప్రాణ దశల పట్టిక: $dM (మహా) → $dA (అంతర) → $dP (ప్రత్యంతర) → $dS (సూక్ష్మ)<br>');
        buffer.writeln('      <span style="color:#78350f; font-weight:600;">కాలపరిమితి: ${DateFormat("dd-MM-yyyy hh:mm a").format(detailedSd.startDate)} నుండి ${DateFormat("dd-MM-yyyy hh:mm a").format(detailedSd.endDate)} (${detailedSd.durationString}) ${detailedSd.containsDate(now) ? "★ [ప్రస్తుతం నడుస్తున్న సూక్ష్మ దశ]" : ""}</span>');
        buffer.writeln('    </div>');

        buffer.writeln('    <table class="data-table" style="font-size:6.5pt; margin-bottom:3px;">');
        buffer.writeln('      <thead><tr><th>ప్రాణ నాథుడు</th><th>ప్రారంభ సమయం (సెకన్లతో)</th><th>ముగింపు సమయం (సెకన్లతో)</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
        for (final pr in prList) {
          final prTel = AstroConstants.planetNamesTelugu[pr.planet] ?? pr.planet;
          final isPrActive = pr.containsDate(now);
          final isPrPast = pr.endDate.isBefore(now);
          buffer.writeln('      <tr style="${isPrActive ? "background:#fce7f3; font-weight:700;" : (isPrPast ? "color:#6b7280;" : "")}">'
            '<td class="center bold" style="color:${isPrActive ? "#be185d" : "inherit"};">$prTel ప్రాణ</td>'
            '<td class="center">${DateFormat("dd-MM-yyyy hh:mm:ss a").format(pr.startDate)}</td>'
            '<td class="center">${DateFormat("dd-MM-yyyy hh:mm:ss a").format(pr.endDate)}</td>'
            '<td class="center">${pr.durationString}</td>'
            '<td class="center bold" style="color:${isPrActive ? "#be185d" : (isPrPast ? "#6b7280" : "#8b2500")};">${isPrActive ? "★ ప్రస్తుతం" : (isPrPast ? "గతించినది" : "రాబోవునది")}</td>'
          '</tr>');
        }
        buffer.writeln('      </tbody></table>');
      }

      buffer.writeln('  </div>');
      buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట $pageNum / $totalReportPages</span></div>');
      buffer.writeln('</div>');
    }

    // ── PAGE 25: ఆశీర్వచన పత్రము & కార్యాలయ సంప్రదింపు సమాచారం ──
    buffer.writeln('<div class="page-card">');
    buffer.writeln('  <div class="page-content">');
    buffer.writeln('    <div class="main-header" style="margin-top:20px;">');
    buffer.writeln('      <div class="top-blessing-row">');
    buffer.writeln('        <span class="title-ornament">卐</span>');
    buffer.writeln('        <span class="top-blessing">|| $blessingHeader ||</span>');
    buffer.writeln('        <span class="title-ornament">卐</span>');
    buffer.writeln('      </div>');
    buffer.writeln('      <div class="guru-blessing">❖ $guruBlessing ❖</div>');
    buffer.writeln('      <div class="title-divider">');
    buffer.writeln('        <div class="title-divider-line"></div>');
    buffer.writeln('        <span class="title-ornament">🪔</span>');
    buffer.writeln('        <div class="title-divider-line"></div>');
    buffer.writeln('      </div>');
    buffer.writeln('      <h1 class="app-title">$appTitle</h1>');
    buffer.writeln('      <div class="expertise-bar">$expertiseLine</div>');
    buffer.writeln('      <div class="scholar-pill">$astrologerTitleAndMobile</div>');
    buffer.writeln('      <div class="sloka-box">${invocationShloka.replaceAll("\n", "<br>")}</div>');
    buffer.writeln('    </div>');

    buffer.writeln('    <div style="margin-top: 24px; border: 2px solid #6b1111; background: linear-gradient(180deg, #fffbf0 0%, #ffeed0 100%); padding: 18px; border-radius: 8px; text-align: center;">');
    buffer.writeln('      <div style="font-size: 14pt; font-weight: 800; color: #6b1111;">|| శుభం భూయాత్ • సర్వేజనాః సుఖినో భవంతు ||</div>');
    buffer.writeln('      <div style="margin-top: 10px; font-size: 11pt; color: #3e1b00; font-weight: 700; line-height: 1.6;">');
    buffer.writeln('        జాతక పరిశీలన, వివాహ పొంతనలు, వాస్తు నిర్ణయాలు & సంఖ్యాశాస్త్ర సంప్రదింపులకు:<br>');
    buffer.writeln('        <b style="font-size:13pt; color:#8b2500;">$astrologerTitleAndMobile</b><br>');
    buffer.writeln('        కార్యాలయ చిరునామా: <b>$astrologerAddress</b><br>');
    buffer.writeln('        <span style="font-size: 9.5pt; color: #6b1111;"><b>$appTitle</b> — సంపూర్ణ వేద జ్యోతిష సేవా నిలయం</span>');
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');
    buffer.writeln('  <div class="footer-note"><span>$appTitle • $astrologerTitleAndMobile</span><span>పుట 25 / $totalReportPages</span></div>');
    buffer.writeln('</div>');

    buffer.writeln('</body></html>');
    return buffer.toString();
  }

  /// Builds a South Indian 4x4 chart for any of the 16 Classical Parashara Shodashavargas.
  static String _buildDivisionalChartHtml(
    ChartData chart,
    DivisionalChartType type,
  ) {
    final placements = DivisionalChartService.getPlacementsForType(chart, type);
    final lagnaIdx = DivisionalChartService.getLagnaForType(chart, type);

    final signOccupants = List.generate(12, (_) => <String>[]);
    signOccupants[lagnaIdx].add('<span class="lagna-badge">ల</span>');

    for (int sign = 0; sign < 12; sign++) {
      for (final p in placements[sign] ?? []) {
        final abbr = AstroConstants.planetAbbrTelugu[p.name] ?? p.abbreviation;
        final retro = p.isRetrograde ? '(వ)' : '';
        final combust = p.isCombust ? '(మౌ)' : '';
        signOccupants[sign].add('$abbr$retro$combust');
      }
    }

    final grid = AstroConstants.southIndianGrid;
    final sb = StringBuffer();
    sb.writeln('<div class="si-chart">');
    final lagnaName = AstroConstants.rashisTelugu[lagnaIdx];
    final centerCode = DivisionalChartService.getDivisionalCenterName(type);
    final centerSignif = DivisionalChartService.getDivisionalSignificance(type);

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if ((r == 1 || r == 2) && (c == 1 || c == 2)) {
          if (r == 1 && c == 1) {
            sb.writeln('<div class="si-cell center-box">卐<br><span style="font-size:8.5pt; font-weight:800; color:#6b1111;">$centerCode</span><br><span style="font-size:6.5pt; color:#8b2500;">$centerSignif</span><br><span style="font-size:6.5pt; color:#166534; font-weight:700;">లగ్నం: $lagnaName</span></div>');
          }
          continue;
        }
        final signIdx = grid[r][c];
        final signName = AstroConstants.rashisTelugu[signIdx];
        final isLagna = signIdx == lagnaIdx;
        final planetsHtml = signOccupants[signIdx].join(' ');
        sb.writeln('<div class="si-cell ${isLagna ? "lagna-cell" : ""}"><span class="si-sign-name">${isLagna ? "★ $signName" : signName}</span><div class="si-planets">$planetsHtml</div></div>');
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
