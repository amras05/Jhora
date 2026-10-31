import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/constants/astro_constants.dart';
import '../models/chart_data.dart';
import '../services/ashtakavarga_service.dart';
import '../services/shadbala_service.dart';
import '../services/yoga_service.dart';
import '../services/dosha_service.dart';
import '../services/dasha_service.dart';
import '../services/transit_service.dart';
import '../services/special_points_service.dart';
import '../services/panchanga_service.dart';
import '../services/divisional_chart_service.dart';

/// Professional, complete 25-Page Telugu Vedic Astrology Report Generator
/// (|| శ్రీరస్తు శుభమస్తు విజయోస్తు || - సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)
class TeluguPdfDocumentBuilder {
  TeluguPdfDocumentBuilder._();

  static const int totalReportPages = 25;
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

  static String getDignityTelugu(String dignity) {
    switch (dignity) {
      case 'Exalted':
        return 'ఉచ్ఛ';
      case 'Moolatrikona':
        return 'మూలత్రికోణం';
      case 'Own Sign':
        return 'స్వక్షేత్రం';
      case 'Friendly':
        return 'మిత్రుడు';
      case 'Neutral':
        return 'సమం';
      case 'Enemy':
        return 'శత్రువు';
      case 'Debilitated':
        return 'నీచ';
      default:
        return dignity;
    }
  }

  static const PdfColor colorPrimary = PdfColor.fromInt(0xFF6B1111); // Royal Maroon
  static const PdfColor colorSecondary = PdfColor.fromInt(0xFF8B2500); // Saffron Russet
  static const PdfColor colorGold = PdfColor.fromInt(0xFFB8860B); // Dark Gold
  static const PdfColor colorBgLight = PdfColor.fromInt(0xFFFFFBF0); // Warm Ivory
  static const PdfColor colorHeaderBg = PdfColor.fromInt(0xFFFDECC8); // Gold Header Bar
  static const PdfColor colorBorder = PdfColor.fromInt(0xFFD4AF37); // Gold Border
  static const PdfColor colorRowAlt = PdfColor.fromInt(0xFFFDFBF7);

  static const Map<int, (int, int)> southIndianGridCoords = {
    11: (0, 0), // Pisces
    0:  (1, 0), // Aries
    1:  (2, 0), // Taurus
    2:  (3, 0), // Gemini
    3:  (3, 1), // Cancer
    4:  (3, 2), // Leo
    5:  (3, 3), // Virgo
    6:  (2, 3), // Libra
    7:  (1, 3), // Scorpio
    8:  (0, 3), // Sagittarius
    9:  (0, 2), // Capricorn
    10: (0, 1), // Aquarius
  };

  static Future<Uint8List> generatePdfBytes({
    required ChartData chartData,
    required AshtakavargaData ashtakavarga,
    required List<PlanetShadbala> shadbala,
    required List<VedicYoga> yogas,
    required DoshaAnalysis dosha,
    required List<DashaPeriod> dashas,
    required GocharAnalysis gochar,
  }) async {
    final pdf = pw.Document();

    // Load fonts
    pw.Font fontRegular;
    pw.Font fontBold;
    try {
      final fontData = await rootBundle.load('assets/fonts/NotoSansTelugu.ttf');
      final fontBoldData = await rootBundle.load('assets/fonts/NotoSansTelugu-Bold.ttf');
      fontRegular = pw.Font.ttf(fontData);
      fontBold = pw.Font.ttf(fontBoldData);
    } catch (_) {
      try {
        fontRegular = await PdfGoogleFonts.notoSansTeluguRegular();
        fontBold = await PdfGoogleFonts.notoSansTeluguBold();
      } catch (_) {
        fontRegular = pw.Font.helvetica();
        fontBold = pw.Font.helveticaBold();
      }
    }

    final birth = chartData.birthData;
    final special = SpecialPointsService.calculate(chartData);
    final panchanga = PanchangaService.calculate(
      date: birth.dateTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      placeName: birth.placeName,
    );

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      fontFallback: [
        pw.Font.helvetica(),
        pw.Font.helveticaBold(),
      ],
    );

    final weekdayTel = weekdaysTelugu[birth.dateTime.weekday % 7];
    final tithiTel = '${panchanga.paksha == 'Shukla Paksha' ? 'శుక్ల పక్ష' : 'కృష్ణ పక్ష'} ${tithisTelugu[panchanga.tithiIndex % 30]}';
    final nakTel = '${AstroConstants.nakshatrasTelugu[chartData.getPlanet('Moon')!.nakshatraIndex]} (${chartData.getPlanet('Moon')!.pada}వ పాదం)';
    final yogaTel = yogasTelugu[panchanga.yogaIndex % 27];
    final karanaTel = karanasTelugu[panchanga.karana] ?? panchanga.karana;

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 1: ప్రాథమిక వివరాలు, పంచాంగం, చక్రములు (D1, D9) & గ్రహ స్థానాలు ──
    // ══════════════════════════════════════════════════════════════════════
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildMainHeader(fontBold),
              pw.SizedBox(height: 6),

              // 1. Birth Details & Panchangam Side-by-Side Tables
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSectionBar('1. జాతక ప్రాథమిక వివరాలు', fontBold),
                        pw.SizedBox(height: 3),
                        _buildCompactTable([
                          ['పేరు:', birth.name.isNotEmpty ? birth.name : 'శ్రీ / కుమారి'],
                          ['తేదీ/వారం:', '${DateFormat('dd-MM-yyyy').format(birth.dateTime)}, $weekdayTel'],
                          ['సమయం:', DateFormat('hh:mm:ss a').format(birth.dateTime)],
                          ['జన్మ స్థలం:', birth.placeName],
                          ['అక్షాంశం/రేఖాంశం:', '${birth.latitude.toStringAsFixed(2)}° N, ${birth.longitude.toStringAsFixed(2)}° E'],
                          ['ఆయనాంశము:', 'లాహిరి (${_formatDms(chartData.ayanamsa)})'],
                        ], fontBold),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSectionBar('2. జన్మ పంచాంగ వివరములు', fontBold),
                        pw.SizedBox(height: 3),
                        _buildCompactTable([
                          ['తిథి:', tithiTel],
                          ['నక్షత్రం:', nakTel],
                          ['నిత్య యోగం:', yogaTel],
                          ['కరణం:', karanaTel],
                          ['సూర్యోదయ/అస్తమయం:', '${DateFormat('hh:mm a').format(panchanga.sunrise)} / ${DateFormat('hh:mm a').format(panchanga.sunset)}'],
                          ['రాహు కాలం:', '${DateFormat("hh:mm a").format(panchanga.rahuKalam.$1)} - ${DateFormat("hh:mm a").format(panchanga.rahuKalam.$2)}'],
                        ], fontBold),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              // 2. Charts (D1 Rasi & D9 Navamsa) Side-by-Side
              _buildSectionBar('3. జాతక చక్రములు (Horoscope Charts)', fontBold),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSouthIndianChartPdf(
                    chart: chartData,
                    type: 'D1',
                    title: 'రాశి చక్రము (D1 Rasi)',
                    centerSub: 'లగ్నం: ${AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}',
                    fontBold: fontBold,
                  ),
                  _buildSouthIndianChartPdf(
                    chart: chartData,
                    type: 'D9',
                    title: 'నవాంశ చక్రము (D9 Navamsa)',
                    centerSub: 'నవాంశ చక్రం',
                    fontBold: fontBold,
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              // 3. Planetary Positions Table
              _buildSectionBar('4. నిరాయణ గ్రహ స్థితిగతుల పట్టిక (Planetary Positions)', fontBold),
              pw.SizedBox(height: 3),
              _buildPlanetaryTablePdf(chartData, fontBold),

              pw.Spacer(),
              _buildFooterBar('పుట 1 / $totalReportPages'),
            ],
          );
        },
      ),
    );

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGES 2 to 5: షోడశవర్గ చక్రములు (16 Parashara Shodashavarga Charts) ──
    // ══════════════════════════════════════════════════════════════════════
    final vargaGroups = [
      (
        'షోడశవర్గ చక్రములు (భాగము 1: D1, D2, D3, D4)',
        [DivisionalChartType.d1, DivisionalChartType.d2, DivisionalChartType.d3, DivisionalChartType.d4],
      ),
      (
        'షోడశవర్గ చక్రములు (భాగము 2: D7, D9, D10, D12)',
        [DivisionalChartType.d7, DivisionalChartType.d9, DivisionalChartType.d10, DivisionalChartType.d12],
      ),
      (
        'షోడశవర్గ చక్రములు (భాగము 3: D16, D20, D24, D27)',
        [DivisionalChartType.d16, DivisionalChartType.d20, DivisionalChartType.d24, DivisionalChartType.d27],
      ),
      (
        'షోడశవర్గ చక్రములు (భాగము 4: D30, D40, D45, D60)',
        [DivisionalChartType.d30, DivisionalChartType.d40, DivisionalChartType.d45, DivisionalChartType.d60],
      ),
    ];

    for (int gIdx = 0; gIdx < vargaGroups.length; gIdx++) {
      final grp = vargaGroups[gIdx];
      final pageNum = 2 + gIdx;
      final chartList = grp.$2;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          theme: theme,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _buildSubHeader(fontBold),
                pw.SizedBox(height: 4),
                _buildSectionBar(grp.$1, fontBold),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDivisionalChartPdf(chart: chartData, type: chartList[0], fontBold: fontBold, chartSize: 220),
                    _buildDivisionalChartPdf(chart: chartData, type: chartList[1], fontBold: fontBold, chartSize: 220),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDivisionalChartPdf(chart: chartData, type: chartList[2], fontBold: fontBold, chartSize: 220),
                    _buildDivisionalChartPdf(chart: chartData, type: chartList[3], fontBold: fontBold, chartSize: 220),
                  ],
                ),
                pw.Spacer(),
                _buildFooterBar('పుట $pageNum / $totalReportPages'),
              ],
            );
          },
        ),
      );
    }

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 6: ద్వాదశ భావ స్ఫుట పట్టిక & సర్వాష్టకవర్గము (SAV 337) ──
    // ══════════════════════════════════════════════════════════════════════
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildSubHeader(fontBold),
              pw.SizedBox(height: 4),
              _buildSectionBar('5. ద్వాదశ భావ స్ఫుట పట్టిక (12 Houses Bhava Sputa Patika & Lords)', fontBold),
              pw.SizedBox(height: 3),
              _buildBhavaSpashtaTablePdf(chartData.ascendant.longitude, fontBold),
              pw.SizedBox(height: 8),
              _buildSectionBar('6. సర్వాష్టకవర్గ చక్రము & 337 బిందువుల సమగ్ర పట్టిక (SAV 337)', fontBold),
              pw.SizedBox(height: 3),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildSavChartPdf(ashtakavarga, fontBold),
                  pw.SizedBox(width: 8),
                  pw.Expanded(child: _buildSavBavTablePdf(ashtakavarga, fontBold)),
                ],
              ),
              pw.Spacer(),
              _buildFooterBar('పుట 6 / $totalReportPages'),
            ],
          );
        },
      ),
    );

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 7: షడ్బలము, గ్రహ బలాబలాలు, భృగు బిందువు, యోగీ & దోషాలు ──
    // ══════════════════════════════════════════════════════════════════════
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildSubHeader(fontBold),
              pw.SizedBox(height: 4),
              _buildSectionBar('7. షడ్బల బలాబలాల సమగ్ర పట్టిక (Shadbala Strength Analysis)', fontBold),
              pw.SizedBox(height: 3),
              _buildShadbalaTablePdf(shadbala, fontBold),
              pw.SizedBox(height: 8),
              _buildSectionBar('8. భృగు బిందువు, యోగీ-అవయోగీ & జైమిని 7 చరకారకములు', fontBold),
              pw.SizedBox(height: 3),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _buildCompactTable([
                      ['భృగు బిందువు (Bhrigu Bindu):', '${special.bhriguBinduRashi} (${_formatDms(special.bhriguBinduRashiDeg)}) - ${special.bhriguBinduHouse}వ భావం'],
                      ['యోగ గ్రహము (Yogi):', '${special.yogiPlanet} (${special.yogiRashi} - ${special.yogiNakshatra})'],
                      ['సహయోగి గ్రహము:', special.sahayogiPlanet],
                      ['అవయోగ గ్రహము:', '${special.avayogiPlanet} (${special.avayogiRashi} - ${special.avayogiNakshatra})'],
                    ], fontBold),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(child: _buildJaiminiTablePdf(special, fontBold)),
                ],
              ),
              pw.SizedBox(height: 8),
              _buildSectionBar('9. దోష విశ్లేషణ & పరిహారములు (Doshas & Remedies)', fontBold),
              pw.SizedBox(height: 3),
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  color: colorBgLight,
                  border: pw.Border.all(color: colorBorder, width: 0.8),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'కుజ దోషం: ${dosha.kujaDosha.hasDosha ? "లగ్నం/చంద్రుని నుండి కుజ దోషం కలదు (సుబ్రహ్మణ్యేశ్వర స్వామి పూజ, కుజ శాంతి శ్రేయస్కరం)." : "కుజ దోషము లేదు (అనుకూలం)."}',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'కాలసర్ప దోషం: ${dosha.kaalSarpa.hasDosha ? dosha.kaalSarpa.teluguTypeName : "కాలసర్ప దోషము లేదు."}',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              _buildFooterBar('పుట 7 / $totalReportPages'),
            ],
          );
        },
      ),
    );

    // ══════════════════════════════════════════════════════════════════════
    // ── VIMSHOTTARI DASHA PREPARATION UP TO 80 YEARS ──
    // ══════════════════════════════════════════════════════════════════════
    final now = DateTime.now();
    final allAntars80 = <({String mahaPlanet, DashaPeriod antar, double startAge, double endAge})>[];
    for (final m in dashas) {
      for (final a in (m.subPeriods ?? [])) {
        final startAge = a.startDate.difference(birth.dateTime).inDays / 365.25;
        final endAge = a.endDate.difference(birth.dateTime).inDays / 365.25;
        if (startAge < 82.0) {
          allAntars80.add((mahaPlanet: m.planet, antar: a, startAge: startAge, endAge: endAge));
        }
      }
    }

    final antars0to40 = allAntars80.where((x) => x.startAge < 40.0).toList();
    final antars40to80 = allAntars80.where((x) => x.startAge >= 40.0).toList();

    // ── PAGE 8: వింశోత్తరి మహాదశ & అంతర్దశలు (జన్మ నుండి 40 సం.) ──
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildSubHeader(fontBold),
              pw.SizedBox(height: 4),
              _buildSectionBar('10. వింశోత్తరి మహాదశల సమగ్ర చక్రము (120-Year Vimshottari Mahadasha)', fontBold),
              pw.SizedBox(height: 3),
              _buildDashaTablePdf(dashas, fontBold),
              pw.SizedBox(height: 6),
              _buildSectionBar('11. అంతర్దశల సమగ్ర కాలచక్రం (జన్మ నుండి 40 సంవత్సరాల వయస్సు వరకు)', fontBold),
              pw.SizedBox(height: 3),
              _buildAntarTablePdf(antars0to40, now, fontBold),
              pw.Spacer(),
              _buildFooterBar('పుట 8 / $totalReportPages'),
            ],
          );
        },
      ),
    );

    // ── PAGE 9: అంతర్దశలు (40 నుండి 80+ సం.) ──
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildSubHeader(fontBold),
              pw.SizedBox(height: 4),
              _buildSectionBar('12. అంతర్దశల సమగ్ర కాలచక్రం (40 నుండి 80+ సంవత్సరాల వయస్సు వరకు)', fontBold),
              pw.SizedBox(height: 3),
              _buildAntarTablePdf(antars40to80, now, fontBold, startIndex: antars0to40.length + 1),
              pw.Spacer(),
              _buildFooterBar('పుట 9 / $totalReportPages'),
            ],
          );
        },
      ),
    );

    // ── PAGES 10 to 12: ప్రత్యంతర దశలు (Level 3 Pratyantar Dashas up to 80 Years) ──
    final pdChunkSize = (allAntars80.length / 3).ceil();
    for (int pIdx = 0; pIdx < 3; pIdx++) {
      int startIdx = pIdx * pdChunkSize;
      int endIdx = ((pIdx + 1) * pdChunkSize).clamp(0, allAntars80.length);
      final pageAntars = allAntars80.sublist(startIdx, endIdx);
      int pageNum = 10 + pIdx;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          theme: theme,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _buildSubHeader(fontBold),
                pw.SizedBox(height: 4),
                _buildSectionBar('13.${pIdx + 1} ప్రత్యంతర దశల సమగ్ర పట్టిక (Level 3 Pratyantar - భాగము ${pIdx + 1})', fontBold),
                pw.SizedBox(height: 3),
                ...pageAntars.map((aItem) => _buildPratyantarGroupPdf(aItem, now, fontBold)),
                pw.Spacer(),
                _buildFooterBar('పుట $pageNum / $totalReportPages'),
              ],
            );
          },
        ),
      );
    }

    // ── PAGES 13 & 14: సూక్ష్మ దశలు (Level 4 Sookshma Dashas up to 80 Years) ──
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

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          theme: theme,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _buildSubHeader(fontBold),
                pw.SizedBox(height: 4),
                _buildSectionBar('14.${sPage + 1} సూక్ష్మ దశల సమగ్ర పట్టిక (Level 4 Sookshma - భాగము ${sPage + 1})', fontBold),
                pw.SizedBox(height: 3),
                ...currentBatch.map((fItem) => _buildSookshmaGroupPdf(fItem, now, fontBold)),
                pw.Spacer(),
                _buildFooterBar('పుట $sPageNum / $totalReportPages'),
              ],
            );
          },
        ),
      );
    }

    // ── PAGES 15 to 24: ప్రాణ దశలు (Level 5 Prana Dashas for ALL 80 YEARS down to Seconds) ──
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

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          theme: theme,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _buildSubHeader(fontBold),
                pw.SizedBox(height: 4),
                _buildSectionBar('15.${pIndex + 1} ప్రాణ దశల సమగ్ర కాలచక్రం: వయస్సు $startYr నుండి $endYr సం. ($stageDesc)', fontBold),
                pw.SizedBox(height: 3),
                _buildPranaAnnualTablePdf(
                  startYr: startYr,
                  endYr: endYr,
                  birthDate: birth.dateTime,
                  dashas: dashas,
                  now: now,
                  fontBold: fontBold,
                ),
                pw.SizedBox(height: 6),
                _buildPranaFocalDetailPdf(
                  startYr: startYr,
                  endYr: endYr,
                  birthDate: birth.dateTime,
                  dashas: dashas,
                  now: now,
                  fontBold: fontBold,
                ),
                pw.Spacer(),
                _buildFooterBar('పుట $pageNum / $totalReportPages'),
              ],
            );
          },
        ),
      );
    }

    // ── PAGE 25: ఆశీర్వచన పత్రము & కార్యాలయ సంప్రదింపు సమాచారం ──
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildMainHeader(fontBold),
              pw.Spacer(),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: colorBgLight,
                  border: pw.Border.all(color: colorPrimary, width: 2),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text('|| శుభం భూయాత్ • సర్వేజనాః సుఖినో భవంతు ||', style: pw.TextStyle(font: fontBold, fontSize: 13, color: colorPrimary)),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'జాతక పరిశీలన, వివాహ పొంతనలు, వాస్తు నిర్ణయాలు & సంఖ్యాశాస్త్ర సంప్రదింపులకు:',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.brown900),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(astrologerTitleAndMobile, style: pw.TextStyle(font: fontBold, fontSize: 13, color: colorSecondary)),
                    pw.SizedBox(height: 4),
                    pw.Text('కార్యాలయ చిరునామా: $astrologerAddress', style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.black), textAlign: pw.TextAlign.center),
                    pw.SizedBox(height: 4),
                    pw.Text('$appTitle — సంపూర్ణ వేద జ్యోతిష సేవా నిలయం', style: pw.TextStyle(font: fontBold, fontSize: 10.5, color: colorPrimary)),
                  ],
                ),
              ),
              pw.Spacer(),
              _buildFooterBar('పుట 25 / $totalReportPages'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HEADER & SECTION BUILDERS
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildMainHeader(pw.Font fontBold) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: colorBgLight,
        border: pw.Border.all(color: colorPrimary, width: 2),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Text(blessingHeader, style: pw.TextStyle(font: fontBold, fontSize: 11, color: colorSecondary)),
          pw.SizedBox(height: 1),
          pw.Text(appTitle, style: pw.TextStyle(font: fontBold, fontSize: 14.5, color: colorPrimary)),
          pw.SizedBox(height: 1),
          pw.Text(expertiseLine, style: pw.TextStyle(font: fontBold, fontSize: 8.5, color: PdfColors.brown900)),
          pw.Text(astrologerTitleAndMobile, style: pw.TextStyle(font: fontBold, fontSize: 9.5, color: colorSecondary)),
          pw.Text(astrologerAddress, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800)),
          pw.SizedBox(height: 2),
          pw.Text(invocationShloka, style: pw.TextStyle(font: fontBold, fontSize: 7.5, color: colorPrimary), textAlign: pw.TextAlign.center),
        ],
      ),
    );
  }

  static pw.Widget _buildSubHeader(pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: const pw.BoxDecoration(
        color: colorBgLight,
        border: pw.Border(bottom: pw.BorderSide(color: colorBorder, width: 1.2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('$blessingHeader  -  $appTitle', style: pw.TextStyle(font: fontBold, fontSize: 8.5, color: colorPrimary)),
          pw.Text(astrologerTitleAndMobile, style: pw.TextStyle(font: fontBold, fontSize: 8, color: colorSecondary)),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionBar(String title, pw.Font fontBold) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: const pw.BoxDecoration(
        color: colorHeaderBg,
        border: pw.Border(left: pw.BorderSide(color: colorPrimary, width: 3.5)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(font: fontBold, fontSize: 8.5, color: colorPrimary),
      ),
    );
  }

  static pw.Widget _buildCompactTable(List<List<String>> rows, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: rows.map((r) {
        return pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorBgLight),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: pw.Text(r[0], style: pw.TextStyle(font: fontBold, fontSize: 7.5, color: colorPrimary)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: pw.Text(r[1], style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black)),
            ),
          ],
        );
      }).toList(),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // SOUTH INDIAN CHARTS (D1 & D9) using pixel-perfect pw.Stack
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildSouthIndianChartPdf({
    required ChartData chart,
    required String type,
    required String title,
    required String centerSub,
    required pw.Font fontBold,
  }) {
    final occupants = List.generate(12, (_) => <String>[]);
    int lagnaIdx = type == 'D9' ? chart.ascendant.navamsaRashiIndex : chart.ascendant.rashiIndex;
    occupants[lagnaIdx].add('ల');

    for (final p in chart.planets) {
      int signIdx = type == 'D9' ? p.navamsaRashiIndex : p.rashiIndex;
      final abbr = AstroConstants.planetAbbrTelugu[p.name] ?? p.abbreviation;
      final retro = p.isRetrograde ? '(వ)' : '';
      final combust = p.isCombust ? '(మౌ)' : '';
      occupants[signIdx].add('$abbr$retro$combust');
    }

    const double chartSize = 160;
    const double cellSize = chartSize / 4;

    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 8.5, color: colorPrimary)),
        pw.SizedBox(height: 3),
        pw.Container(
          width: chartSize,
          height: chartSize,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: colorSecondary, width: 1.5),
            color: PdfColors.white,
          ),
          child: pw.Stack(
            children: [
              // Center Box (2x2)
              pw.Positioned(
                left: cellSize,
                top: cellSize,
                child: pw.Container(
                  width: cellSize * 2,
                  height: cellSize * 2,
                  decoration: pw.BoxDecoration(
                    color: colorBgLight,
                    border: pw.Border.all(color: colorSecondary, width: 1),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(type == 'D1' ? 'రాశి చక్రం' : 'నవాంశ చక్రం', style: pw.TextStyle(font: fontBold, fontSize: 9.5, color: colorPrimary)),
                      pw.SizedBox(height: 2),
                      pw.Text(centerSub, style: const pw.TextStyle(fontSize: 7, color: PdfColors.brown800), textAlign: pw.TextAlign.center),
                    ],
                  ),
                ),
              ),
              // 12 Sign Cells
              ...southIndianGridCoords.entries.map((entry) {
                final signIdx = entry.key;
                final pos = entry.value;
                final signName = AstroConstants.rashisTelugu[signIdx];
                final plList = occupants[signIdx];
                final isLagna = plList.contains('ల');

                return pw.Positioned(
                  left: pos.$1 * cellSize,
                  top: pos.$2 * cellSize,
                  child: pw.Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: colorBorder, width: 0.5),
                      color: isLagna ? PdfColor.fromInt(0xFFFFF3E0) : plList.isNotEmpty ? PdfColor.fromInt(0xFFFFFDF5) : PdfColors.white,
                    ),
                    padding: const pw.EdgeInsets.all(1.5),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          signName,
                          style: const pw.TextStyle(fontSize: 5, color: PdfColors.grey700),
                        ),
                        pw.Spacer(),
                        if (plList.isNotEmpty)
                          pw.Center(
                            child: pw.Text(
                              plList.join(' '),
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: plList.length > 2 ? 5.5 : 6.5,
                                color: isLagna ? colorPrimary : PdfColors.brown900,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        pw.Spacer(),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PLANETARY POSITIONS TABLE
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildPlanetaryTablePdf(ChartData chart, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['గ్రహము', 'రాశి', 'అంశలు (స్పష్టం)', 'నక్షత్రం', 'పాదం', 'నక్షత్రాధిపతి', 'స్థితి (Dignity)'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 7, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        // Ascendant row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorHeaderBg),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('లగ్నము', style: pw.TextStyle(font: fontBold, fontSize: 7, color: colorPrimary), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(AstroConstants.rashisTelugu[chart.ascendant.rashiIndex], style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(_formatDms(chart.ascendant.degreesInRashi), style: pw.TextStyle(font: fontBold, fontSize: 7), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(AstroConstants.nakshatrasTelugu[chart.ascendant.nakshatraIndex], style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('${chart.ascendant.pada}', style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(AstroConstants.nakshatraLordsTelugu[chart.ascendant.nakshatraIndex], style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
            pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('లగ్న కేంద్రం', style: pw.TextStyle(font: fontBold, fontSize: 7, color: colorPrimary), textAlign: pw.TextAlign.center)),
          ],
        ),
        // 9 Planets
        ...chart.planets.map((p) {
          final pTel = AstroConstants.planetNamesTelugu[p.name] ?? p.name;
          final rTel = AstroConstants.rashisTelugu[p.rashiIndex];
          final nTel = AstroConstants.nakshatrasTelugu[p.nakshatraIndex];
          final lordTel = AstroConstants.nakshatraLordsTelugu[p.nakshatraIndex];
          final digTel = getDignityTelugu(p.dignity);

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: p.isRetrograde ? PdfColor.fromInt(0xFFFFF3E0) : PdfColors.white),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('$pTel${p.isRetrograde ? " (వ)" : ""}${p.isCombust ? " (మౌ)" : ""}', style: pw.TextStyle(font: fontBold, fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(rTel, style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(_formatDms(p.degreesInRashi), style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(nTel, style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('${p.pada}', style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(lordTel, style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(digTel, style: pw.TextStyle(font: fontBold, fontSize: 7, color: p.dignity == 'Exalted' ? PdfColors.green800 : p.dignity == 'Debilitated' ? PdfColors.red800 : PdfColors.black), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // BHAVA SPASHTA (12 HOUSES)
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildBhavaSpashtaTablePdf(double lagnaLon, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['భావము', 'భావ ఆరంభము', 'భావ మధ్యము (స్పష్టం)', 'భావ అంత్యము', 'భావాధిపతి'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 7, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...List.generate(12, (i) {
          int h = i + 1;
          final midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
          final startLon = (midLon - 15.0 + 360.0) % 360.0;
          final endLon = (midLon + 15.0) % 360.0;
          final rIdx = (midLon / 30.0).floor() % 12;
          final lord = AstroConstants.rashiLordsTelugu[rIdx];
          final bg = i % 2 == 1 ? colorRowAlt : PdfColors.white;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: bg),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('$hవ భావము', style: pw.TextStyle(font: fontBold, fontSize: 7, color: colorPrimary), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(_formatDms(startLon), style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(_formatDms(midLon), style: pw.TextStyle(font: fontBold, fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(_formatDms(endLon), style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(lord, style: pw.TextStyle(font: fontBold, fontSize: 7), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // ASHTAKAVARGA & SAV 337
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildSavChartPdf(AshtakavargaData av, pw.Font fontBold) {
    const double chartSize = 124;
    const double cellSize = chartSize / 4;

    return pw.Container(
      width: chartSize,
      height: chartSize,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: colorSecondary, width: 1.2),
        color: PdfColors.white,
      ),
      child: pw.Stack(
        children: [
          // Center Box (2x2)
          pw.Positioned(
            left: cellSize,
            top: cellSize,
            child: pw.Container(
              width: cellSize * 2,
              height: cellSize * 2,
              decoration: pw.BoxDecoration(
                color: colorBgLight,
                border: pw.Border.all(color: colorSecondary, width: 0.8),
              ),
              alignment: pw.Alignment.center,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('SAV', style: pw.TextStyle(font: fontBold, fontSize: 9.5, color: colorPrimary)),
                  pw.Text('337', style: pw.TextStyle(font: fontBold, fontSize: 11.5, color: colorSecondary)),
                ],
              ),
            ),
          ),
          // 12 Signs
          ...southIndianGridCoords.entries.map((entry) {
            final signIdx = entry.key;
            final pos = entry.value;
            final pts = av.sav[signIdx];
            final isHigh = pts >= 28;

            return pw.Positioned(
              left: pos.$1 * cellSize,
              top: pos.$2 * cellSize,
              child: pw.Container(
                width: cellSize,
                height: cellSize,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: colorBorder, width: 0.5),
                  color: isHigh ? PdfColor.fromInt(0xFFE8F5E9) : PdfColors.white,
                ),
                padding: const pw.EdgeInsets.all(1),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(AstroConstants.rashisTelugu[signIdx], style: const pw.TextStyle(fontSize: 5, color: PdfColors.grey700)),
                    pw.Text('$pts', style: pw.TextStyle(font: fontBold, fontSize: 8, color: isHigh ? PdfColors.green900 : PdfColors.red900)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  static pw.Widget _buildSavBavTablePdf(AshtakavargaData av, pw.Font fontBold) {
    const planets = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    const pHeaders = ['రాశి', 'రవి', 'చం', 'కు', 'బు', 'గు', 'శు', 'శని', 'SAV'];

    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: pHeaders.map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.5),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...List.generate(12, (rIdx) {
          final savPts = av.sav[rIdx];
          final bg = savPts >= 28 ? PdfColor.fromInt(0xFFF1F8E9) : rIdx % 2 == 1 ? colorRowAlt : PdfColors.white;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: bg),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(AstroConstants.rashisTelugu[rIdx], style: pw.TextStyle(font: fontBold, fontSize: 6.5))),
              ...planets.map((p) {
                final pts = av.bav[p]?[rIdx] ?? 0;
                return pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$pts', style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center));
              }),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$savPts', style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: savPts >= 28 ? PdfColors.green900 : PdfColors.red900), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // VIMSHOTTARI DASHA (120-YEARS)
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildDashaTablePdf(List<DashaPeriod> dashas, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['మహాదశ', 'ప్రారంభ తేదీ', 'ముగింపు తేదీ', 'వ్యవధి (సం.)', 'దశా కాల ప్రాముఖ్యత'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 7, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...dashas.map((d) {
          final pTel = AstroConstants.planetNamesTelugu[d.planet] ?? d.planet;
          final dur = (d.endDate.difference(d.startDate).inDays / 365.25).toStringAsFixed(1);
          final now = DateTime.now();
          final isCurrent = now.isAfter(d.startDate) && now.isBefore(d.endDate);

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: isCurrent ? PdfColor.fromInt(0xFFFFF9C4) : PdfColors.white),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('$pTel మహాదశ${isCurrent ? " (ప్రస్తుతం)" : ""}', style: pw.TextStyle(font: fontBold, fontSize: 7, color: isCurrent ? PdfColors.brown900 : PdfColors.black), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(DateFormat('dd-MM-yyyy').format(d.startDate), style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(DateFormat('dd-MM-yyyy').format(d.endDate), style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text('$dur సం.', style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1.5), child: pw.Text(isCurrent ? 'ప్రస్తుతం చురుగ్గా జరుగుచున్నది' : 'పూర్తి కాలపరిమితి', style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: isCurrent ? PdfColors.deepOrange900 : PdfColors.grey700), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // SHADBALA, GOCHARA & JAIMINI TABLES
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildShadbalaTablePdf(List<PlanetShadbala> sbList, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['గ్రహము', 'స్థాన', 'దిగ్', 'కాల', 'చేష్ట', 'నైసర్గిక', 'దృగ్', 'మొత్తం', 'ర్యాంకు'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(1.5),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...sbList.map((sb) {
          final pTel = AstroConstants.planetNamesTelugu[sb.planetName] ?? sb.planetName;
          return pw.TableRow(
            decoration: pw.BoxDecoration(color: sb.rank == 1 ? PdfColor.fromInt(0xFFE8F5E9) : PdfColors.white),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(pTel, style: pw.TextStyle(font: fontBold, fontSize: 6.5))),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.sthanaBala.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.digBala.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.kalaBala.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.chestaBala.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.naisargikaBala.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.drikBala.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sb.totalRupas.toStringAsFixed(1), style: pw.TextStyle(font: fontBold, fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('#${sb.rank}', style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: colorPrimary), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildGocharTablePdf(GocharAnalysis gochar, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['గ్రహము', 'గోచార రాశి', 'చంద్రుని నుండి', 'ఫలితము'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(1.5),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...gochar.transits.map((tr) {
          final pTel = AstroConstants.planetNamesTelugu[tr.planetName] ?? tr.planetName;
          final rTel = AstroConstants.rashisTelugu[tr.transitRashi];
          final isFavorable = tr.isFavorable;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: isFavorable ? PdfColor.fromInt(0xFFE8F5E9) : PdfColors.white),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(pTel, style: pw.TextStyle(font: fontBold, fontSize: 6.5))),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(rTel, style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('${tr.houseFromMoon}వ స్థానం', style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(isFavorable ? 'శుభ ఫలితం' : 'సామాన్యం', style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: isFavorable ? PdfColors.green900 : PdfColors.red900), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildJaiminiTablePdf(SpecialPointsResult sp, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['చరకారకము', 'గ్రహము', 'రాశి స్థానం'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(1.5),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...sp.charaKarakas.map((k) {
          return pw.TableRow(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(k.nameTelugu, style: pw.TextStyle(font: fontBold, fontSize: 6.5))),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(k.planetTelugu, style: pw.TextStyle(font: fontBold, fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('${k.rashiTelugu} (${_formatDms(k.degreeInRashi)})', style: const pw.TextStyle(fontSize: 6.5))),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildFooterBar(String pageNum) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(top: 3),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: colorBorder, width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '$appTitle  -  $astrologerName ($astrologerMobile)',
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey800),
          ),
          pw.Text(
            pageNum,
            style: pw.TextStyle(fontSize: 7, color: colorPrimary),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DIVISIONAL CHART BUILDER (PARASHARA SHODASHAVARGA)
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildDivisionalChartPdf({
    required ChartData chart,
    required DivisionalChartType type,
    required pw.Font fontBold,
    double chartSize = 220,
  }) {
    final placements = DivisionalChartService.getPlacementsForType(chart, type);
    final lagnaIdx = DivisionalChartService.getLagnaForType(chart, type);
    final title = DivisionalChartService.getDivisionalTitle(type);
    final centerCode = DivisionalChartService.getDivisionalCenterName(type);
    final centerSignif = DivisionalChartService.getDivisionalSignificance(type);
    final lagnaName = AstroConstants.rashisTelugu[lagnaIdx];

    final occupants = List.generate(12, (_) => <String>[]);
    occupants[lagnaIdx].add('ల');

    for (int sign = 0; sign < 12; sign++) {
      for (final p in placements[sign] ?? []) {
        final abbr = AstroConstants.planetAbbrTelugu[p.name] ?? p.abbreviation;
        final retro = p.isRetrograde ? '(వ)' : '';
        final combust = p.isCombust ? '(మౌ)' : '';
        occupants[sign].add('$abbr$retro$combust');
      }
    }

    final double cellSize = chartSize / 4;

    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 7, color: colorPrimary)),
        pw.SizedBox(height: 2),
        pw.Container(
          width: chartSize,
          height: chartSize,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: colorSecondary, width: 1.2),
            color: PdfColors.white,
          ),
          child: pw.Stack(
            children: [
              // Center Box (2x2)
              pw.Positioned(
                left: cellSize,
                top: cellSize,
                child: pw.Container(
                  width: cellSize * 2,
                  height: cellSize * 2,
                  decoration: pw.BoxDecoration(
                    color: colorBgLight,
                    border: pw.Border.all(color: colorSecondary, width: 0.8),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(centerCode, style: pw.TextStyle(font: fontBold, fontSize: 9, color: colorPrimary)),
                      pw.Text(centerSignif, style: const pw.TextStyle(fontSize: 6, color: colorSecondary), textAlign: pw.TextAlign.center),
                      pw.Text('లగ్నం: $lagnaName', style: const pw.TextStyle(fontSize: 6, color: PdfColors.green900)),
                    ],
                  ),
                ),
              ),
              // 12 Sign Cells
              ...southIndianGridCoords.entries.map((entry) {
                final signIdx = entry.key;
                final pos = entry.value;
                final signName = AstroConstants.rashisTelugu[signIdx];
                final plList = occupants[signIdx];
                final isLagna = signIdx == lagnaIdx;

                return pw.Positioned(
                  left: pos.$1 * cellSize,
                  top: pos.$2 * cellSize,
                  child: pw.Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: colorBorder, width: 0.5),
                      color: isLagna ? PdfColor.fromInt(0xFFFFF3E0) : (plList.isNotEmpty ? PdfColor.fromInt(0xFFFFFDF5) : PdfColors.white),
                    ),
                    padding: const pw.EdgeInsets.all(1.5),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          isLagna ? '★ $signName' : signName,
                          style: const pw.TextStyle(fontSize: 4.5, color: PdfColors.grey700),
                        ),
                        pw.Spacer(),
                        if (plList.isNotEmpty)
                          pw.Center(
                            child: pw.Text(
                              plList.join(' '),
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: plList.length > 2 ? 5 : 6,
                                color: isLagna ? colorPrimary : PdfColors.brown900,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        pw.Spacer(),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DASHA SUB-TABLES (ANTAR, PRATYANTAR, SOOKSHMA, PRANA)
  // ──────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildAntarTablePdf(
    List<({String mahaPlanet, DashaPeriod antar, double startAge, double endAge})> antars,
    DateTime now,
    pw.Font fontBold, {
    int startIndex = 1,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['క్రమ', 'మహా / అంతర దశ', 'ప్రారంభ తేదీ', 'ముగింపు తేదీ', 'వ్యవధి', 'వయస్సు', 'స్థితి'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...List.generate(antars.length, (i) {
          final item = antars[i];
          final mTel = AstroConstants.planetNamesTelugu[item.mahaPlanet] ?? item.mahaPlanet;
          final aTel = AstroConstants.planetNamesTelugu[item.antar.planet] ?? item.antar.planet;
          final isActive = now.isAfter(item.antar.startDate) && now.isBefore(item.antar.endDate);
          final isPast = item.antar.endDate.isBefore(now);
          final status = isActive ? "★ ప్రస్తుతం" : (isPast ? "గతించినది" : "రాబోవునది");

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: isActive ? PdfColor.fromInt(0xFFFFF9C4) : (isPast ? colorRowAlt : PdfColors.white)),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('${startIndex + i}', style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$mTel / $aTel', style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: isActive ? colorPrimary : PdfColors.black))),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy').format(item.antar.startDate), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy').format(item.antar.endDate), style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(item.antar.durationString, style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('${item.startAge.toStringAsFixed(1)} - ${item.endAge.toStringAsFixed(1)} సం.', style: const pw.TextStyle(fontSize: 6.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(status, style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: isActive ? PdfColors.deepOrange900 : (isPast ? PdfColors.grey700 : PdfColors.green900)), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildPratyantarGroupPdf(
    ({String mahaPlanet, DashaPeriod antar, double startAge, double endAge}) aItem,
    DateTime now,
    pw.Font fontBold,
  ) {
    final a = aItem.antar;
    final mTel = AstroConstants.planetNamesTelugu[aItem.mahaPlanet] ?? aItem.mahaPlanet;
    final aTel = AstroConstants.planetNamesTelugu[a.planet] ?? a.planet;
    final pdList = a.subPeriods ?? [];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
          color: colorHeaderBg,
          child: pw.Text(
            '✦ $mTel మహాదశ / $aTel అంతర (${DateFormat("dd-MM-yy").format(a.startDate)} నుండి ${DateFormat("dd-MM-yy").format(a.endDate)}):',
            style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: colorPrimary),
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: colorBorder, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: colorSecondary),
              children: ['ప్రత్యంతర నాథుడు', 'ప్రారంభ తేదీ', 'ముగింపు తేదీ', 'వ్యవధి', 'స్థితి'].map((h) => pw.Padding(
                padding: const pw.EdgeInsets.all(1),
                child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6, color: PdfColors.white), textAlign: pw.TextAlign.center),
              )).toList(),
            ),
            ...pdList.map((pd) {
              final pdTel = AstroConstants.planetNamesTelugu[pd.planet] ?? pd.planet;
              final isPdActive = pd.containsDate(now);
              return pw.TableRow(
                decoration: pw.BoxDecoration(color: isPdActive ? PdfColor.fromInt(0xFFE8F5E9) : PdfColors.white),
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$mTel/$aTel/$pdTel', style: pw.TextStyle(font: fontBold, fontSize: 6, color: isPdActive ? PdfColors.green900 : PdfColors.black), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy').format(pd.startDate), style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy').format(pd.endDate), style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(pd.durationString, style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(isPdActive ? '★ ప్రస్తుతం' : '', style: pw.TextStyle(font: fontBold, fontSize: 6, color: PdfColors.green900), textAlign: pw.TextAlign.center)),
                ],
              );
            }),
          ],
        ),
        pw.SizedBox(height: 3),
      ],
    );
  }

  static pw.Widget _buildSookshmaGroupPdf(
    ({String mTel, String aTel, String pdTel, DashaPeriod pd}) fItem,
    DateTime now,
    pw.Font fontBold,
  ) {
    final sdList = fItem.pd.subPeriods ?? [];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
          color: colorHeaderBg,
          child: pw.Text(
            '✦ ${fItem.mTel} / ${fItem.aTel} / ${fItem.pdTel} ప్రత్యంతర (${DateFormat("dd-MM-yy").format(fItem.pd.startDate)} నుండి ${DateFormat("dd-MM-yy").format(fItem.pd.endDate)}):',
            style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: colorPrimary),
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: colorBorder, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: colorPrimary),
              children: ['సూక్ష్మ నాథుడు', 'ప్రారంభ తేదీ & సమయం', 'ముగింపు తేదీ & సమయం', 'వ్యవధి', 'స్థితి'].map((h) => pw.Padding(
                padding: const pw.EdgeInsets.all(1),
                child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6, color: PdfColors.white), textAlign: pw.TextAlign.center),
              )).toList(),
            ),
            ...sdList.map((sd) {
              final sdTel = AstroConstants.planetNamesTelugu[sd.planet] ?? sd.planet;
              final isSdActive = sd.containsDate(now);
              return pw.TableRow(
                decoration: pw.BoxDecoration(color: isSdActive ? PdfColor.fromInt(0xFFE0F2FE) : PdfColors.white),
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$sdTel సూక్ష్మ', style: pw.TextStyle(font: fontBold, fontSize: 6, color: isSdActive ? colorSecondary : PdfColors.black), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy hh:mm a').format(sd.startDate), style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy hh:mm a').format(sd.endDate), style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(sd.durationString, style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(isSdActive ? '★ ప్రస్తుతం' : '', style: pw.TextStyle(font: fontBold, fontSize: 6, color: colorSecondary), textAlign: pw.TextAlign.center)),
                ],
              );
            }),
          ],
        ),
        pw.SizedBox(height: 3),
      ],
    );
  }

  static pw.Widget _buildPranaAnnualTablePdf({
    required int startYr,
    required int endYr,
    required DateTime birthDate,
    required List<DashaPeriod> dashas,
    required DateTime now,
    required pw.Font fontBold,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: colorBorder, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: colorPrimary),
          children: ['వయస్సు', 'సంవత్సర కాలం', 'మహా / అంతర / ప్రత్యంతర', 'సూక్ష్మ దశ', 'ప్రాణ నాథుడు', 'ప్రాణ ప్రారంభ సమయం', 'ప్రాణ ముగింపు సమయం', 'స్థితి'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1.5),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6, color: PdfColors.white), textAlign: pw.TextAlign.center),
          )).toList(),
        ),
        ...List.generate(endYr - startYr, (idx) {
          final y = startYr + idx;
          final yearStart = birthDate.add(Duration(days: (y * 365.2425).round()));
          final yearEnd = birthDate.add(Duration(days: ((y + 1) * 365.2425).round()));
          final midDate = birthDate.add(Duration(days: ((y + 0.5) * 365.2425).round()));

          final h = DashaService.findCurrentHierarchy(dashas, midDate);
          final mTel = h.maha != null ? (AstroConstants.planetNamesTelugu[h.maha!.planet] ?? h.maha!.planet) : "-";
          final aTel = h.antar != null ? (AstroConstants.planetNamesTelugu[h.antar!.planet] ?? h.antar!.planet) : "-";
          final pTel = h.pratyantar != null ? (AstroConstants.planetNamesTelugu[h.pratyantar!.planet] ?? h.pratyantar!.planet) : "-";
          final sTel = h.sookshma != null ? (AstroConstants.planetNamesTelugu[h.sookshma!.planet] ?? h.sookshma!.planet) : "-";
          final prTel = h.prana != null ? (AstroConstants.planetNamesTelugu[h.prana!.planet] ?? h.prana!.planet) : "-";

          final isYearActive = now.isAfter(yearStart) && now.isBefore(yearEnd);
          final isPastYear = yearEnd.isBefore(now);
          final statusStr = isYearActive ? "★ ప్రస్తుతం" : (isPastYear ? "గతించినది" : "రాబోవునది");

          final prStartStr = h.prana != null ? DateFormat("dd-MM-yy hh:mm a").format(h.prana!.startDate) : "-";
          final prEndStr = h.prana != null ? DateFormat("dd-MM-yy hh:mm a").format(h.prana!.endDate) : "-";

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: isYearActive ? PdfColor.fromInt(0xFFFFF9C4) : (isPastYear ? colorRowAlt : PdfColors.white)),
            children: [
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$y - ${y + 1} సం.', style: pw.TextStyle(font: fontBold, fontSize: 6, color: isYearActive ? colorPrimary : PdfColors.black), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('${DateFormat("dd/MM/yy").format(yearStart)} - ${DateFormat("dd/MM/yy").format(yearEnd)}', style: const pw.TextStyle(fontSize: 5.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$mTel / $aTel / $pTel', style: pw.TextStyle(font: fontBold, fontSize: 6))),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$sTel సూక్ష్మ', style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$prTel ప్రాణ', style: pw.TextStyle(font: fontBold, fontSize: 6, color: colorSecondary), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(prStartStr, style: const pw.TextStyle(fontSize: 5.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(prEndStr, style: const pw.TextStyle(fontSize: 5.5), textAlign: pw.TextAlign.center)),
              pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(statusStr, style: pw.TextStyle(font: fontBold, fontSize: 5.5, color: isYearActive ? PdfColors.deepOrange900 : (isPastYear ? PdfColors.grey700 : PdfColors.green900)), textAlign: pw.TextAlign.center)),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildPranaFocalDetailPdf({
    required int startYr,
    required int endYr,
    required DateTime birthDate,
    required List<DashaPeriod> dashas,
    required DateTime now,
    required pw.Font fontBold,
  }) {
    DashaPeriod? focalSd;
    for (int y = startYr; y < endYr; y++) {
      final midDate = birthDate.add(Duration(days: ((y + 0.5) * 365.2425).round()));
      final h = DashaService.findCurrentHierarchy(dashas, midDate);
      if (h.sookshma != null) {
        if (h.sookshma!.containsDate(now)) {
          focalSd = h.sookshma;
          break;
        } else if (focalSd == null && y >= startYr + 2) {
          focalSd = h.sookshma;
        }
      }
    }
    focalSd ??= DashaService.findCurrentHierarchy(dashas, birthDate.add(Duration(days: ((startYr + 1) * 365.2425).round()))).sookshma;

    if (focalSd == null) return pw.SizedBox();

    final dH = DashaService.findCurrentHierarchy(dashas, focalSd.startDate.add(const Duration(hours: 1)));
    final dM = dH.maha != null ? (AstroConstants.planetNamesTelugu[dH.maha!.planet] ?? dH.maha!.planet) : "";
    final dA = dH.antar != null ? (AstroConstants.planetNamesTelugu[dH.antar!.planet] ?? dH.antar!.planet) : "";
    final dP = dH.pratyantar != null ? (AstroConstants.planetNamesTelugu[dH.pratyantar!.planet] ?? dH.pratyantar!.planet) : "";
    final dS = AstroConstants.planetNamesTelugu[focalSd.planet] ?? focalSd.planet;
    final prList = focalSd.subPeriods ?? [];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          color: colorHeaderBg,
          child: pw.Text(
            '✦ సమగ్ర 9 ప్రాణ దశల పట్టిక: $dM (మహా) → $dA (అంతర) → $dP (ప్రత్యంతర) → $dS (సూక్ష్మ) [కాలపరిమితి: ${DateFormat("dd-MM-yyyy hh:mm a").format(focalSd.startDate)} నుండి ${DateFormat("dd-MM-yyyy hh:mm a").format(focalSd.endDate)}]:',
            style: pw.TextStyle(font: fontBold, fontSize: 6.5, color: colorPrimary),
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: colorBorder, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: colorSecondary),
              children: ['ప్రాణ నాథుడు', 'ప్రారంభ సమయం (సెకన్లతో)', 'ముగింపు సమయం (సెకన్లతో)', 'వ్యవధి', 'స్థితి'].map((h) => pw.Padding(
                padding: const pw.EdgeInsets.all(1.5),
                child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 6, color: PdfColors.white), textAlign: pw.TextAlign.center),
              )).toList(),
            ),
            ...prList.map((pr) {
              final prTel = AstroConstants.planetNamesTelugu[pr.planet] ?? pr.planet;
              final isPrActive = pr.containsDate(now);
              final isPrPast = pr.endDate.isBefore(now);
              return pw.TableRow(
                decoration: pw.BoxDecoration(color: isPrActive ? PdfColor.fromInt(0xFFFCE7F3) : (isPrPast ? colorRowAlt : PdfColors.white)),
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text('$prTel ప్రాణ', style: pw.TextStyle(font: fontBold, fontSize: 6, color: isPrActive ? colorSecondary : PdfColors.black), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy hh:mm:ss a').format(pr.startDate), style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(DateFormat('dd-MM-yyyy hh:mm:ss a').format(pr.endDate), style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(pr.durationString, style: const pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)),
                  pw.Padding(padding: const pw.EdgeInsets.all(1), child: pw.Text(isPrActive ? '★ ప్రస్తుతం' : (isPrPast ? 'గతించినది' : 'రాబోవునది'), style: pw.TextStyle(font: fontBold, fontSize: 6, color: isPrActive ? PdfColors.pink900 : (isPrPast ? PdfColors.grey700 : PdfColors.green900)), textAlign: pw.TextAlign.center)),
                ],
              );
            }),
          ],
        ),
      ],
    );
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
}
