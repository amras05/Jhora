import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/astro_constants.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/ashtakavarga_service.dart';
import '../../../data/services/shadbala_service.dart';
import '../../../data/services/yoga_service.dart';
import '../../../data/services/dosha_service.dart';

class KundaliReportScreen extends StatelessWidget {
  final ChartData chartData;
  final AshtakavargaData ashtakavarga;
  final List<PlanetShadbala> shadbala;
  final List<VedicYoga> yogas;
  final DoshaAnalysis dosha;

  const KundaliReportScreen({
    super.key,
    required this.chartData,
    required this.ashtakavarga,
    required this.shadbala,
    required this.yogas,
    required this.dosha,
  });

  String _generateTextReport() {
    final bd = chartData.birthData;
    final sb = StringBuffer();

    sb.writeln('═══════════════════════════════════════════════');
    sb.writeln('🪐 JHORA MOBILE — COMPLETE VEDIC HOROSCOPE');
    sb.writeln('═══════════════════════════════════════════════');
    sb.writeln('Name: ${bd.name.isEmpty ? "Anonymous" : bd.name}');
    sb.writeln('Date & Time: ${DateFormat("dd MMMM yyyy, hh:mm a").format(bd.dateTime)}');
    sb.writeln('Place: ${bd.placeName}');
    sb.writeln('Coordinates: ${bd.latitude.toStringAsFixed(4)}° N, ${bd.longitude.toStringAsFixed(4)}° E (UTC+${bd.timezone})');
    sb.writeln('Ayanamsa: Lahiri (Chitra Paksha)');
    sb.writeln('');

    sb.writeln('─── 1. PLANETARY POSITIONS (NIRAYANA D1) ───');
    sb.writeln('Lagna (Ascendant): ${chartData.ascendant.rashi} ${(chartData.ascendant.longitude % 30).toStringAsFixed(2)}° (${chartData.ascendant.nakshatra} Pada ${chartData.ascendant.pada})');
    for (final p in chartData.planets) {
      sb.writeln('${p.name.padRight(9)}: ${p.rashi.padRight(12)} ${(p.longitude % 30).toStringAsFixed(2).padLeft(5)}° | ${p.nakshatra.padRight(16)} P${p.pada} | ${p.dignity}${p.isRetrograde ? " (R)" : ""}${p.isCombust ? " (c)" : ""}');
    }
    sb.writeln('');

    sb.writeln('─── 2. SARVASHTAKAVARGA (SAV BINDUS) ───');
    for (int i = 0; i < 12; i++) {
      sb.writeln('${AstroConstants.rashis[i].padRight(12)}: ${ashtakavarga.sav[i]} bindus');
    }
    sb.writeln('Total SAV: ${ashtakavarga.totalSAV} points');
    sb.writeln('');

    sb.writeln('─── 3. SHADBALA STRENGTH RANKING ───');
    for (final s in shadbala) {
      sb.writeln('#${s.rank} ${s.planetName.padRight(8)}: ${s.totalRupas.toStringAsFixed(2)} Rupas (${(s.strengthRatio * 100).toStringAsFixed(0)}% req) - ${s.isStrong ? "Strong" : "Moderate"}');
    }
    sb.writeln('');

    sb.writeln('─── 4. FORMED CLASSICAL YOGAS (${yogas.length}) ───');
    for (final y in yogas) {
      sb.writeln('• ${y.name}: ${y.description}');
    }
    sb.writeln('');

    sb.writeln('─── 5. DOSHA ANALYSIS ───');
    final kujaStr = !dosha.kujaDosha.hasDosha
        ? "No Dosha"
        : (dosha.kujaDosha.isCancelled
            ? "Cancelled (${dosha.kujaDosha.cancellationReason})"
            : "${dosha.kujaDosha.severity} Dosha");
    final ksStr = !dosha.kaalSarpa.hasDosha
        ? "Absent"
        : "${dosha.kaalSarpa.typeName} (${dosha.kaalSarpa.description})";
    sb.writeln('• Kuja Dosha: $kujaStr');
    sb.writeln('• Kaal Sarpa: $ksStr');
    sb.writeln('═══════════════════════════════════════════════');
    sb.writeln('Calculated with JHora Mobile Swiss Ephemeris Precision Engine');

    return sb.toString();
  }

  void _copyToClipboard(BuildContext context) {
    final text = _generateTextReport();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.gold, size: 18),
            SizedBox(width: 8),
            Text('Kundali report copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.bgCard,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bd = chartData.birthData;
    final reportText = _generateTextReport();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  bd.name.isEmpty ? 'Kundali Report' : '${bd.name} — Horoscope Report',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppColors.gold, size: 20),
                    tooltip: 'Copy Report',
                    onPressed: () => _copyToClipboard(context),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.chartBorder),
                    ),
                    child: SelectableText(
                      reportText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
