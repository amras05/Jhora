import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../core/constants/astro_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/web_download_helper.dart';
import '../../data/models/chart_data.dart';
import '../../data/services/ashtakavarga_service.dart';
import '../../data/services/shadbala_service.dart';
import '../../data/services/yoga_service.dart';
import '../../data/services/dosha_service.dart';
import '../../data/services/dasha_service.dart';
import '../../data/services/transit_service.dart';
import '../../data/services/special_points_service.dart';
import '../../data/services/panchanga_service.dart';
import '../../data/services/telugu_horoscope_report_generator.dart';

class TeluguPdfReportScreen extends StatefulWidget {
  final ChartData chartData;
  final AshtakavargaData ashtakavarga;
  final List<PlanetShadbala> shadbala;
  final List<VedicYoga> yogas;
  final DoshaAnalysis dosha;
  final List<DashaPeriod> dashas;
  final GocharAnalysis gochar;

  const TeluguPdfReportScreen({
    super.key,
    required this.chartData,
    required this.ashtakavarga,
    required this.shadbala,
    required this.yogas,
    required this.dosha,
    required this.dashas,
    required this.gochar,
  });

  @override
  State<TeluguPdfReportScreen> createState() => _TeluguPdfReportScreenState();
}

class _TeluguPdfReportScreenState extends State<TeluguPdfReportScreen> {
  bool _isExporting = false;
  String _htmlReport = '';

  @override
  void initState() {
    super.initState();
    _htmlReport = TeluguHoroscopeReportGenerator.generateHtml(
      chartData: widget.chartData,
      ashtakavarga: widget.ashtakavarga,
      shadbala: widget.shadbala,
      yogas: widget.yogas,
      dosha: widget.dosha,
      dashas: widget.dashas,
      gochar: widget.gochar,
    );
  }

  /// Opens the HTML report in a new browser tab with auto-print dialog.
  /// Chrome will render Telugu correctly via HarfBuzz + Google Fonts,
  /// and the user can Save as PDF with perfect Indic typography.
  Future<void> _directDownloadPdf() async {
    setState(() => _isExporting = true);
    try {
      // Generate HTML with autoPrint=true so Chrome print dialog fires automatically
      final htmlWithAutoPrint = TeluguHoroscopeReportGenerator.generateHtml(
        chartData: widget.chartData,
        ashtakavarga: widget.ashtakavarga,
        shadbala: widget.shadbala,
        yogas: widget.yogas,
        dosha: widget.dosha,
        dashas: widget.dashas,
        gochar: widget.gochar,
        autoPrint: true,
      );

      if (kIsWeb) {
        openInNewTab(htmlWithAutoPrint);
      } else {
        // On mobile/desktop, use the printing package with HTML rendering
        await Printing.layoutPdf(
          name: 'జాతక_రిపోర్ట్',
          onLayout: (PdfPageFormat format) async {
            // ignore: deprecated_member_use
            return await Printing.convertHtml(
              format: format,
              html: htmlWithAutoPrint,
            );
          },
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.picture_as_pdf, color: Colors.greenAccent, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'కొత్త ట్యాబ్ తెరిచింది! Ctrl+P నొక్కి "Save as PDF" ఎంచుకోండి.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF1a472a),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ఎర్రర్: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _printOrSavePdf() async {
    setState(() => _isExporting = true);
    try {
      if (kIsWeb) {
        openInNewTab(_htmlReport);
      } else {
        await Printing.layoutPdf(
          name: 'సాయి_బాలా_త్రిపుర_సుందరీ_జ్యోతిషాలయం_జాతకం',
          onLayout: (PdfPageFormat format) async {
            // ignore: deprecated_member_use
            return await Printing.convertHtml(
              format: format,
              html: _htmlReport,
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ప్రింట్ ఎర్రర్: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final birth = widget.chartData.birthData;
    final special = SpecialPointsService.calculate(widget.chartData);
    final panchanga = PanchangaService.calculate(
      date: birth.dateTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      placeName: birth.placeName,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'తెలుగు జాతక చక్ర రిపోర్ట్',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.gold),
            tooltip: 'PDF నేరుగా డౌన్‌లోడ్ చేయండి',
            onPressed: _isExporting ? null : _directDownloadPdf,
          ),
          IconButton(
            icon: const Icon(Icons.print, color: AppColors.gold),
            tooltip: 'ప్రింట్ / ప్రివ్యూ',
            onPressed: _printOrSavePdf,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ACTION BAR
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.22),
                      AppColors.bgCardLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.bgDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: _isExporting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgDark))
                            : const Icon(Icons.download_for_offline, size: 22),
                        label: const Text('PDF గా సేవ్ చేయండి / Print PDF', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                        onPressed: _isExporting ? null : _printOrSavePdf,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.gold,
                          side: const BorderSide(color: AppColors.gold, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.print, size: 19),
                        label: const Text('డైరెక్ట్ PDF ఫైల్', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        onPressed: _isExporting ? null : _directDownloadPdf,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // PREVIEW REPORT HEADER CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
                ),
                child: Column(
                  children: [
                    const Text('卐 ${TeluguHoroscopeReportGenerator.appTitle} 卐', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 19), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    const Text('జ్యోతిష నిపుణులు: ${TeluguHoroscopeReportGenerator.astrologerName} • మొబైల్: ${TeluguHoroscopeReportGenerator.astrologerMobile}', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 12)),
                    const SizedBox(height: 2),
                    const Text(TeluguHoroscopeReportGenerator.astrologerAddress, style: TextStyle(color: AppColors.textMuted, fontSize: 10.5)),
                    const SizedBox(height: 8),
                    const Text('శుక్లాంబరధరం విష్ణుం శశివర్ణం చతుర్భుజం | ప్రసన్నవదనం ధ్యాయేత్ సర్వవిఘ్నోపశాంతయే ||', style: TextStyle(color: AppColors.gold, fontStyle: FontStyle.italic, fontSize: 10.5), textAlign: TextAlign.center),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── 1. PANCHANGAM & BIRTH DETAILS ──
              _buildSectionHeader('1. పంచాంగ వివరములు & జాతక వివరాలు'),
              const SizedBox(height: 8),
              _buildInfoTable([
                ('జాతకుని పేరు:', birth.name.isNotEmpty ? birth.name : 'శ్రీ / కుమారి'),
                ('జన్మ దినము & సమయం:', '${DateFormat("dd-MM-yyyy, EEEE").format(birth.dateTime)} • ${DateFormat("hh:mm a").format(birth.dateTime)}'),
                ('జన్మ స్థలము:', birth.placeName),
                ('అక్షాంశం / రేఖాంశం:', '${birth.latitude.toStringAsFixed(4)}° N, ${birth.longitude.toStringAsFixed(4)}° E'),
                ('ఆయనాంశము (లాహిరి):', _formatDms(widget.chartData.ayanamsa)),
                ('తిథి (Tithi):', '${panchanga.paksha} ${panchanga.tithi} (${panchanga.tithiProgress.toStringAsFixed(1)}%)'),
                ('వారం (Vara):', panchanga.vara),
                ('నక్షత్రం (Nakshatra):', '${panchanga.nakshatra} (${panchanga.nakshatraPada}వ పాదం)'),
                ('నిత్య యోగం & కరణం:', '${panchanga.yoga} • ${panchanga.karana}'),
                ('సూర్యోదయ / అస్తమయ:', '${DateFormat("hh:mm a").format(panchanga.sunrise)} / ${DateFormat("hh:mm a").format(panchanga.sunset)}'),
              ]),

              const SizedBox(height: 18),

              // ── 2. CHARTS & PLANETARY POSITIONS ──
              _buildSectionHeader('2. గ్రహ స్థానాలు (Planetary Positions)'),
              const SizedBox(height: 8),
              _buildInfoTable([
                ('లగ్నము (Ascendant):', '${AstroConstants.rashisTelugu[widget.chartData.ascendant.rashiIndex]} (${_formatDms(widget.chartData.ascendant.degreesInRashi)})'),
                ...widget.chartData.planets.map((p) => (
                  '${AstroConstants.planetNamesTelugu[p.name] ?? p.name}${p.isRetrograde ? " (వక్రం)" : ""}${p.isCombust ? " (మౌఢ్యం)" : ""}:',
                  '${AstroConstants.rashisTelugu[p.rashiIndex]} (${_formatDms(p.degreesInRashi)}) • ${AstroConstants.nakshatrasTelugu[p.nakshatraIndex]} ${p.pada}వ పాదం'
                )),
              ]),

              const SizedBox(height: 18),

              // ── 3. ASHTAKAVARGA ──
              _buildSectionHeader('3. సర్వాష్టకవర్గ బిందువులు (SAV 337)'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.chartBorder),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(12, (i) {
                    int b = widget.ashtakavarga.sav[i];
                    bool isFav = b >= 28;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFav ? Colors.green.withValues(alpha: 0.15) : AppColors.bgCardLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isFav ? Colors.green : AppColors.chartBorder),
                      ),
                      child: Text(
                        '${AstroConstants.rashisTelugu[i]}: $b',
                        style: TextStyle(
                          color: isFav ? Colors.greenAccent : AppColors.textSecondary,
                          fontWeight: isFav ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 18),

              // ── 4. VIMSHOTTARI DASHA ──
              _buildSectionHeader('4. వింశోత్తరి దశ - అంతర్దశలు'),
              const SizedBox(height: 8),
              _buildInfoTable(widget.dashas.take(5).map((d) => (
                '${AstroConstants.planetNamesTelugu[d.planet] ?? d.planet} మహాదశ:',
                '${DateFormat("dd-MM-yyyy").format(d.startDate)} నుండి ${DateFormat("dd-MM-yyyy").format(d.endDate)}'
              )).toList()),

              const SizedBox(height: 18),

              // ── 5. GOCHARA & SADE SATI ──
              _buildSectionHeader('5. గోచార ఫలితములు & ఏలినాటి శని'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.chartBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.gochar.sadeSati.isActive
                          ? 'ఏలినాటి శని: ప్రస్తుతం జరుగుతున్నది (${widget.gochar.sadeSati.teluguPhase})'
                          : 'ఏలినాటి శని: ప్రస్తుతం లేదు (అనుకూలం)',
                      style: TextStyle(
                        color: widget.gochar.sadeSati.isActive ? Colors.orangeAccent : Colors.greenAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── 6. SPECIAL POINTS, KARAKAS, YOGAS & DOSHAS ──
              _buildSectionHeader('6. భృగు బిందువు, యోగీ-అవయోగీ & జైమిని కారకాలు'),
              const SizedBox(height: 8),
              _buildInfoTable([
                ('భృగు బిందువు (Destiny Point):', '${special.bhriguBinduRashi} (${_formatDms(special.bhriguBinduRashiDeg)}) • ${special.bhriguBinduHouse}వ భావం'),
                ('యోగ గ్రహము (Yogi Planet):', '${special.yogiPlanet} (${special.yogiRashi} - ${special.yogiNakshatra})'),
                ('సహయోగి గ్రహము:', special.sahayogiPlanet),
                ('అవయోగ గ్రహము (Avayogi):', '${special.avayogiPlanet} (${special.avayogiRashi} - ${special.avayogiNakshatra})'),
                ...special.charaKarakas.map((k) => (
                  k.nameTelugu,
                  '${k.planetTelugu} (${k.rashiTelugu} ${_formatDms(k.degreeInRashi)})'
                )),
              ]),

              const SizedBox(height: 24),

              // FOOTER CONTACT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCardLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                ),
                child: const Column(
                  children: [
                    Text(
                      'జాతక పరిశీలన & వాస్తు సంప్రదింపులు',
                      style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      TeluguHoroscopeReportGenerator.astrologerName,
                      style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    Text(
                      TeluguHoroscopeReportGenerator.astrologerAddress,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
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

  static String _formatDms(double deg) {
    deg = deg % 360.0;
    int d = deg.floor();
    double mTotal = (deg - d) * 60.0;
    int m = mTotal.floor();
    int s = ((mTotal - m) * 60.0).round();
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    return "$d°$mStr'$sStr\"";
  }
}
