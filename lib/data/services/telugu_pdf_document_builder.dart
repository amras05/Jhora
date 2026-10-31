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

/// Professional, complete 3-Page Telugu Vedic Astrology Report Generator
/// (|| శ్రీ బాల జ్యోతిర్ వాస్తు || - సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)
class TeluguPdfDocumentBuilder {
  TeluguPdfDocumentBuilder._();

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
              _buildFooterBar('పుట 1 / 3'),
            ],
          );
        },
      ),
    );

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 2: భావ స్పష్టము, అష్టకవర్గము (SAV 337) & వింశోత్తరి దశలు ──
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
              _buildSubHeader(fontBold),
              pw.SizedBox(height: 6),

              // 5. Bhava Spashta Table (12 Houses)
              _buildSectionBar('5. ద్వాదశ భావ స్పష్ట పట్టిక (12 Houses Bhava Spashta & Lords)', fontBold),
              pw.SizedBox(height: 3),
              _buildBhavaSpashtaTablePdf(chartData.ascendant.longitude, fontBold),

              pw.SizedBox(height: 8),

              // 6. Ashtakavarga Chart & SAV 337 Table Side-by-Side
              _buildSectionBar('6. సర్వాష్టకవర్గ చక్రము & 337 బిందువుల పట్టిక (SAV 337)', fontBold),
              pw.SizedBox(height: 3),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildSavChartPdf(ashtakavarga, fontBold),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: _buildSavBavTablePdf(ashtakavarga, fontBold),
                  ),
                ],
              ),

              pw.SizedBox(height: 8),

              // 7. Vimshottari Mahadasha Table
              _buildSectionBar('7. వింశోత్తరి దశా - అంతర్దశల కాలగమనం (120-Year Vimshottari Mahadasha)', fontBold),
              pw.SizedBox(height: 3),
              _buildDashaTablePdf(dashas, fontBold),

              pw.Spacer(),
              _buildFooterBar('పుట 2 / 3'),
            ],
          );
        },
      ),
    );

    // ══════════════════════════════════════════════════════════════════════
    // ── PAGE 3: షడ్బలము, గోచారము, భృగు బిందువు, యోగాలు, దోషాలు & ఆశీర్వచనం ──
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
              _buildSubHeader(fontBold),
              pw.SizedBox(height: 5),

              // 8. Shadbala & Gochara in two side-by-side clean cards
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSectionBar('8. షడ్బల బలాబలాల పట్టిక', fontBold),
                        pw.SizedBox(height: 2),
                        _buildShadbalaTablePdf(shadbala, fontBold),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSectionBar('9. ప్రస్తుత గోచార ఫలితములు', fontBold),
                        pw.SizedBox(height: 2),
                        _buildGocharTablePdf(gochar, fontBold),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 6),

              // Sade Sati status banner
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: gochar.sadeSati.isActive ? PdfColor.fromInt(0xFFFFF3E0) : PdfColor.fromInt(0xFFE8F5E9),
                  border: pw.Border.all(color: gochar.sadeSati.isActive ? PdfColor.fromInt(0xFFFB8C00) : PdfColor.fromInt(0xFF43A047), width: 0.8),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  gochar.sadeSati.isActive
                      ? 'ఏలినాటి శని విశ్లేషణ: ప్రస్తుతం జాతకునికి ఏలినాటి శని జరుగుచున్నది (${gochar.sadeSati.teluguPhase}). శని శాంతి జపములు, తైలాభిషేకం శ్రేయస్కరం.'
                      : 'ఏలినాటి శని విశ్లేషణ: ప్రస్తుతం జాతకునికి ఏలినాటి శని లేదు (అనుకూల గోచార సమయం).',
                  style: pw.TextStyle(font: fontBold, fontSize: 7.5, color: gochar.sadeSati.isActive ? PdfColor.fromInt(0xFFB71C1C) : PdfColor.fromInt(0xFF1B5E20)),
                ),
              ),

              pw.SizedBox(height: 6),

              // 10. Bhrigu Bindu, Yogi/Avayogi & Jaimini Karakas
              _buildSectionBar('10. భృగు బిందువు, యోగీ-అవయోగీ & జైమిని 7 చరకారకములు', fontBold),
              pw.SizedBox(height: 3),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _buildCompactTable([
                      ['భృగు బిందువు (BB):', '${special.bhriguBinduRashi} (${_formatDms(special.bhriguBinduRashiDeg)}) - ${special.bhriguBinduHouse}వ భావం'],
                      ['యోగ గ్రహము (Yogi):', '${special.yogiPlanet} (${special.yogiRashi} - ${special.yogiNakshatra})'],
                      ['సహయోగి గ్రహము:', special.sahayogiPlanet],
                      ['అవయోగ గ్రహము:', '${special.avayogiPlanet} (${special.avayogiRashi} - ${special.avayogiNakshatra})'],
                    ], fontBold),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: _buildJaiminiTablePdf(special, fontBold),
                  ),
                ],
              ),

              pw.SizedBox(height: 6),

              // 11. Yogas, Doshas & Remedies
              _buildSectionBar('11. జాతక యోగములు, దోష విశ్లేషణ & పరిహారములు', fontBold),
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
                      'జాతక యోగాలు: ${yogas.take(5).map((y) => y.teluguName).join(' - ')}',
                      style: pw.TextStyle(font: fontBold, fontSize: 7.5, color: colorPrimary),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'కుజ దోషం: ${dosha.kujaDosha.hasDosha ? "లగ్నం/చంద్రుని నుండి కుజ దోషం కలదు (సుబ్రహ్మణ్యేశ్వర స్వామి పూజ, కుజ శాంతి శ్రేయస్కరం)." : "కుజ దోషము లేదు (అనుకూలం)."}',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
                    ),
                    pw.SizedBox(height: 1),
                    pw.Text(
                      'కాలసర్ప దోషం: ${dosha.kaalSarpa.hasDosha ? dosha.kaalSarpa.teluguTypeName : "కాలసర్ప దోషము లేదు."}',
                      style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 8),

              // 12. Final Blessing & Astrologer Contact Card
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  gradient: const pw.LinearGradient(
                    colors: [PdfColor.fromInt(0xFFFFF3E0), PdfColor.fromInt(0xFFFFE0B2)],
                  ),
                  border: pw.Border.all(color: colorPrimary, width: 1.5),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      '|| శుభం భూయాత్ - సర్వేజనాః సుఖినో భవంతు ||',
                      style: pw.TextStyle(font: fontBold, fontSize: 11, color: colorPrimary),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'జాతక పరిశీలన & సమగ్ర వాస్తు సంప్రదింపులకు: $astrologerName (ఫోన్: $astrologerMobile)',
                      style: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColors.brown900),
                    ),
                    pw.Text(
                      astrologerAddress,
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),
              _buildFooterBar('పుట 3 / 3'),
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
          pw.Text(mainTitle, style: pw.TextStyle(font: fontBold, fontSize: 13, color: colorSecondary)),
          pw.SizedBox(height: 1),
          pw.Text(appTitle, style: pw.TextStyle(font: fontBold, fontSize: 15, color: colorPrimary)),
          pw.SizedBox(height: 1),
          pw.Text('జ్యోతిష నిపుణులు: $astrologerName  -  మొబైల్: $astrologerMobile', style: pw.TextStyle(font: fontBold, fontSize: 9.5, color: PdfColors.brown900)),
          pw.Text(astrologerAddress, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
          pw.SizedBox(height: 2),
          pw.Text(invocationShloka, style: pw.TextStyle(font: fontBold, fontSize: 7.5, color: colorSecondary)),
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
          pw.Text('$mainTitle  -  $appTitle', style: pw.TextStyle(font: fontBold, fontSize: 8.5, color: colorPrimary)),
          pw.Text('జ్యోతిష నిపుణులు: $astrologerName (మొబైల్: $astrologerMobile)', style: pw.TextStyle(font: fontBold, fontSize: 8, color: colorSecondary)),
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
      decoration: const pw.BoxDecoration(
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
            style: const pw.TextStyle(fontSize: 7, color: colorPrimary),
          ),
        ],
      ),
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
