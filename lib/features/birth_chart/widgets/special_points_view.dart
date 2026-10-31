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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── BHRIGU BINDU (DESTINY POINT) CARD ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            goldAccent.withValues(alpha: 0.18),
                            AppColors.bgCardLight,
                          ]
                        : [
                            const Color(0xFFFFFBEB),
                            const Color(0xFFFEF3C7),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: goldAccent, width: 1.5),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: goldAccent.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: goldAccent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.auto_awesome, color: goldAccent, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'భృగు బిందువు (Bhrigu Bindu - Destiny Point)',
                                style: TextStyle(
                                  color: goldAccent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'రాహువు నుండి చంద్రుని మధ్యమ బిందువు (భాగ్య స్థానం)',
                                style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildInfoRow('రాశి (Rashi):', special.bhriguBinduRashi, goldAccent, isDark),
                    _buildInfoRow('అంశలు (Degree):', _formatDms(special.bhriguBinduRashiDeg), AppColors.getTextPrimary(isDark), isDark),
                    _buildInfoRow('నక్షత్రం & పాదం:', '${special.bhriguBinduNakshatra} (${special.bhriguBinduPada}వ పాదం)', AppColors.getTextPrimary(isDark), isDark),
                    _buildInfoRow('లగ్నం నుండి స్థానం:', '${special.bhriguBinduHouse}వ భావము', isDark ? Colors.greenAccent : AppColors.accentGreen, isDark),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.getElevatedColor(isDark),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '✦ తాత్పర్యము: గోచార గురుడు లేదా శుభ గ్రహాలు ఈ బిందువు మీదుగా సంచరించు కాలంలో జీవితంలో గొప్ప మలుపులు, ఉద్యోగ లాభం, వివాహం మరియు విశేష ధనలాభాలు కలుగును.',
                        style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11.5, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── YOGI, SAHAYOGI & AVAYOGI CARDS ──
              Row(
                children: [
                  Icon(Icons.stars, color: goldAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'యోగీ, సహయోగీ & అవయోగీ గ్రహాలు',
                    style: TextStyle(color: goldAccent, fontSize: 16, fontWeight: FontWeight.w700),
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
                        color: Colors.green.withValues(alpha: isDark ? 0.12 : 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('యోగ గ్రహము', style: TextStyle(color: isDark ? Colors.greenAccent : const Color(0xFF15803D), fontSize: 11, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(special.yogiPlanet, style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${special.yogiRashi}\n${special.yogiNakshatra} (${special.yogiPada}వ పాదం)', style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10)),
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
                        color: Colors.blue.withValues(alpha: isDark ? 0.12 : 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('సహయోగి గ్రహము', style: TextStyle(color: isDark ? Colors.lightBlueAccent : const Color(0xFF0369A1), fontSize: 11, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(special.sahayogiPlanet, style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('యోగ రాశ్యాధిపతి\n(సహాయకారి)', style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10)),
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
                        color: Colors.red.withValues(alpha: isDark ? 0.12 : 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('అవయోగి గ్రహము', style: TextStyle(color: isDark ? Colors.redAccent : const Color(0xFFB91C1C), fontSize: 11, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(special.avayogiPlanet, style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('${special.avayogiRashi}\n${special.avayogiNakshatra} (${special.avayogiPada}వ పాదం)', style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10)),
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
                  Icon(Icons.people_alt_outlined, color: goldAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'జైమిని 7 చర కారకములు (Jaimini Chara Karakas)',
                    style: TextStyle(color: goldAccent, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.getElevatedColor(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.getBorderColor(isDark)),
                ),
                child: Column(
                  children: special.charaKarakas.map((k) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.getBorderColor(isDark).withValues(alpha: 0.4), width: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              color: goldAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                k.abbreviation,
                                style: TextStyle(color: goldAccent, fontWeight: FontWeight.w800, fontSize: 12),
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
                                  style: TextStyle(color: AppColors.getTextPrimary(isDark), fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                Text(
                                  '${k.rashiTelugu} (${_formatDms(k.degreeInRashi)})',
                                  style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            k.planetTelugu,
                            style: TextStyle(color: goldAccent, fontWeight: FontWeight.w800, fontSize: 14),
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
                  Icon(Icons.grid_view_rounded, color: goldAccent, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'ఆరూఢ పదములు (Jaimini Arudha Padas)',
                    style: TextStyle(color: goldAccent, fontSize: 15, fontWeight: FontWeight.w700),
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
                      color: AppColors.getElevatedColor(isDark),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.getBorderColor(isDark)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p.code, style: TextStyle(color: goldAccent, fontWeight: FontWeight.w800, fontSize: 13)),
                            Text(p.rashiTelugu, style: TextStyle(color: AppColors.getTextPrimary(isDark), fontWeight: FontWeight.w700, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.teluguName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String val, Color valColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 12.5)),
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
