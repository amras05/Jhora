import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/astro_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/panchanga_service.dart';

class ChartPanchangaView extends StatelessWidget {
  final ChartData chartData;

  const ChartPanchangaView({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final birth = chartData.birthData;
    final sun = chartData.getPlanet('Sun')!;
    final moon = chartData.getPlanet('Moon')!;
    final panchanga = PanchangaService.calculate(
      date: birth.dateTime,
      latitude: birth.latitude,
      longitude: birth.longitude,
      timezone: birth.timezone,
      placeName: birth.placeName,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A1608), Color(0xFF1A0E05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      panchanga.vara,
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.gold),
                      ),
                      child: Text(
                        'ఆయనాంశ: ${_formatDms(chartData.ayanamsa)}',
                        style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${DateFormat("dd MMMM yyyy, hh:mm:ss a").format(birth.dateTime)} • ${birth.placeName}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 5 Limbs of Panchanga Grid
          const Row(
            children: [
              Icon(Icons.auto_stories, color: AppColors.gold, size: 18),
              SizedBox(width: 8),
              Text(
                'పంచాంగ పంచాంగాలు (5 Vedic Limbs)',
                style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _buildLimbCard(
            title: 'తిథి (Tithi)',
            value: '${panchanga.paksha} ${panchanga.tithi}',
            subtitle: 'పూర్తయినది: ${panchanga.tithiProgress.toStringAsFixed(1)}%',
            icon: Icons.brightness_6,
            color: Colors.amber,
          ),
          const SizedBox(height: 8),
          _buildLimbCard(
            title: 'వారం (Vara)',
            value: panchanga.vara,
            subtitle: 'అధిపతి: ${_getVaraLord(panchanga.varaIndex)}',
            icon: Icons.calendar_today,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildLimbCard(
            title: 'నక్షత్రం (Nakshatra)',
            value: '${panchanga.nakshatra} (${panchanga.nakshatraPada}వ పాదం)',
            subtitle: 'నక్షత్రాధిపతి: ${AstroConstants.nakshatraLordsTelugu[panchanga.nakshatraIndex]}',
            icon: Icons.star,
            color: Colors.lightGreenAccent,
          ),
          const SizedBox(height: 8),
          _buildLimbCard(
            title: 'నిత్య యోగం (Yoga)',
            value: panchanga.yoga,
            subtitle: 'సూర్య-చంద్రుల మొత్తం స్పష్టత ఆధారితం',
            icon: Icons.all_inclusive,
            color: Colors.cyanAccent,
          ),
          const SizedBox(height: 8),
          _buildLimbCard(
            title: 'కరణం (Karana)',
            value: panchanga.karana,
            subtitle: 'తిథి యొక్క అర్ధభాగము',
            icon: Icons.hourglass_bottom,
            color: Colors.purpleAccent,
          ),

          const SizedBox(height: 20),

          // Celestial Placements at Birth
          const Row(
            children: [
              Icon(Icons.explore, color: AppColors.gold, size: 18),
              SizedBox(width: 8),
              Text(
                'జన్మ రాశి & లగ్న వివరాలు',
                style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.chartBorder),
            ),
            child: Column(
              children: [
                _buildKeyValueRow('జన్మ లగ్నము (Ascendant):', '${AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]} (${_formatDms(chartData.ascendant.degreesInRashi)})'),
                _buildKeyValueRow('జన్మ రాశి (Moon Sign):', '${AstroConstants.rashisTelugu[moon.rashiIndex]} (${_formatDms(moon.degreesInRashi)})'),
                _buildKeyValueRow('సూర్య రాశి (Sun Sign):', '${AstroConstants.rashisTelugu[sun.rashiIndex]} (${_formatDms(sun.degreesInRashi)})'),
                _buildKeyValueRow('సూర్యోదయము (Sunrise):', DateFormat("hh:mm a").format(panchanga.sunrise)),
                _buildKeyValueRow('సూర్యాస్తమయము (Sunset):', DateFormat("hh:mm a").format(panchanga.sunset)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Timings & Muhurthams
          const Row(
            children: [
              Icon(Icons.timer, color: AppColors.gold, size: 18),
              SizedBox(width: 8),
              Text(
                'ముహూర్తములు & కాలాలు (Muhurthams)',
                style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.chartBorder),
            ),
            child: Column(
              children: [
                _buildKeyValueRow('అభిజిత్ ముహూర్తం (శుభం):', '${DateFormat("hh:mm a").format(panchanga.abhijitMuhurtham.$1)} - ${DateFormat("hh:mm a").format(panchanga.abhijitMuhurtham.$2)}', valColor: Colors.greenAccent),
                _buildKeyValueRow('బ్రహ్మ ముహూర్తం (శుభం):', '${DateFormat("hh:mm a").format(panchanga.brahmaMuhurtham.$1)} - ${DateFormat("hh:mm a").format(panchanga.brahmaMuhurtham.$2)}', valColor: Colors.greenAccent),
                _buildKeyValueRow('రాహు కాలం (వర్జ్యం):', '${DateFormat("hh:mm a").format(panchanga.rahuKalam.$1)} - ${DateFormat("hh:mm a").format(panchanga.rahuKalam.$2)}', valColor: Colors.redAccent),
                _buildKeyValueRow('యమగండం (వర్జ్యం):', '${DateFormat("hh:mm a").format(panchanga.yamagandam.$1)} - ${DateFormat("hh:mm a").format(panchanga.yamagandam.$2)}', valColor: Colors.orangeAccent),
                _buildKeyValueRow('గుళిక కాలం:', '${DateFormat("hh:mm a").format(panchanga.gulikaKalam.$1)} - ${DateFormat("hh:mm a").format(panchanga.gulikaKalam.$2)}', valColor: AppColors.textPrimary),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLimbCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.chartBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13.5)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String val, {Color? valColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(val, style: TextStyle(color: valColor ?? AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }

  static String _getVaraLord(int idx) {
    const lords = ['రవి', 'చంద్రుడు', 'కుజుడు', 'బుధుడు', 'గురువు', 'శుక్రుడు', 'శని'];
    return lords[idx % 7];
  }

  static String _formatDms(double deg) {
    deg = deg % 360.0;
    int d = deg.floor();
    double mTotal = (deg - d) * 60.0;
    int m = mTotal.floor();
    int s = ((mTotal - m) * 60.0).round();
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    return '$d°$mStr\'$sStr"';
  }
}
