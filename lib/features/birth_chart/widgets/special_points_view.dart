import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/special_points_service.dart';

class SpecialPointsView extends StatelessWidget {
  final ChartData chartData;

  const SpecialPointsView({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final special = SpecialPointsService.calculate(chartData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BHRIGU BINDU (DESTINY POINT) CARD ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.18),
                  AppColors.bgCardLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'భృగు బిందువు (Bhrigu Bindu - Destiny Point)',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'రాహువు నుండి చంద్రుని మధ్యమ బిందువు (భాగ్య స్థానం)',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildInfoRow('రాశి (Rashi):', special.bhriguBinduRashi, AppColors.gold),
                _buildInfoRow('అంశలు (Degree):', _formatDms(special.bhriguBinduRashiDeg), AppColors.textPrimary),
                _buildInfoRow('నక్షత్రం & పాదం:', '${special.bhriguBinduNakshatra} (${special.bhriguBinduPada}వ పాదం)', AppColors.textPrimary),
                _buildInfoRow('లగ్నం నుండి స్థానం:', '${special.bhriguBinduHouse}వ భావము', Colors.greenAccent),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✦ తాత్పర్యము: గోచార గురుడు లేదా శుభ గ్రహాలు ఈ బిందువు మీదుగా సంచరించు కాలంలో జీవితంలో గొప్ప మలుపులు, ఉద్యోగ లాభం, వివాహం మరియు విశేష ధనలాభాలు కలుగును.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── YOGI, SAHAYOGI & AVAYOGI CARDS ──
          Row(
            children: [
              const Icon(Icons.stars, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              const Text(
                'యోగీ, సహయోగీ & అవయోగీ గ్రహాలు',
                style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              // Yogi Planet
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('యోగ గ్రహము', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(special.yogiPlanet, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('${special.yogiRashi}\n${special.yogiNakshatra} (${special.yogiPada}వ పాదం)', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Sahayogi Planet
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('సహయోగి గ్రహము', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(special.sahayogiPlanet, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('యోగ రాశ్యాధిపతి\n(సహాయకారి)', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Avayogi Planet
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('అవయోగి గ్రహము', style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(special.avayogiPlanet, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('${special.avayogiRashi}\n${special.avayogiNakshatra} (${special.avayogiPada}వ పాదం)', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── JAIMINI 7 CHARA KARAKAS TABLE ──
          Row(
            children: [
              const Icon(Icons.people_alt_outlined, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              const Text(
                'జైమిని 7 చర కారకములు (Jaimini Chara Karakas)',
                style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.chartBorder),
            ),
            child: Column(
              children: special.charaKarakas.map((k) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.chartBorder, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            k.abbreviation,
                            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              k.nameTelugu,
                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            Text(
                              '${k.rashiTelugu} (${_formatDms(k.degreeInRashi)})',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        k.planetTelugu,
                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // ── JAIMINI ARUDHA PADAS ──
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              const Text(
                'ఆరూఢ పదములు (Jaimini Arudha Padas)',
                style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: special.arudhaPadas.map((p) {
              return Container(
                width: 165,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.chartBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p.code, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 13)),
                        Text(p.rashiTelugu, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.teluguName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String val, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
          Text(val, style: TextStyle(color: valColor, fontWeight: FontWeight.w700, fontSize: 12.5)),
        ],
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
    return '$d°$mStr\'$sStr"';
  }
}
