import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../core/constants/language.dart';
import '../../../data/services/transit_service.dart';

class TransitView extends StatelessWidget {
  final GocharAnalysis gochar;
  final VoidCallback onSelectDate;

  const TransitView({
    super.key,
    required this.gochar,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isTelugu = lang.currentLanguage == AppLanguage.telugu;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transit Date Selector Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.chartBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sync_alt, color: AppColors.gold, size: 18),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Transit (Gochar) Date', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                        Text(
                          DateFormat('dd MMMM yyyy').format(gochar.transitDate),
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onSelectDate,
                  icon: const Icon(Icons.edit_calendar, size: 16, color: AppColors.gold),
                  label: const Text('Change Date', style: TextStyle(color: AppColors.gold, fontSize: 12)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Sade Sati Status Card
          _buildSadeSatiCard(gochar.sadeSati, isTelugu),

          const SizedBox(height: 16),

          // Planetary Transits Table / Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Planetary Transits (${gochar.overallFavorableCount}/9 Favorable)',
                style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const Text('From Natal Moon', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),

          ...gochar.transits.map((t) => _buildSingleTransitCard(t, lang, isTelugu)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSadeSatiCard(SadeSatiStatus ss, bool isTelugu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ss.isActive ? Colors.orange.withValues(alpha: 0.6) : Colors.green.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    ss.isActive ? Icons.hourglass_top : Icons.check_circle_outline,
                    color: ss.isActive ? Colors.orange : Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTelugu ? 'ఏలినాటి శని స్థితి' : 'Sade Sati Status',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ss.isActive ? Colors.orange.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ss.isActive ? (isTelugu ? ss.teluguPhase : ss.phase) : 'Inactive',
                  style: TextStyle(
                    color: ss.isActive ? const Color(0xFFFFB74D) : const Color(0xFF81C784),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isTelugu ? ss.teluguDescription : ss.description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleTransitCard(SinglePlanetTransit t, LanguageProvider lang, bool isTelugu) {
    final planetName = lang.planet(t.planetName);
    final signName = lang.rashi(t.transitRashi);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: t.isFavorable ? Colors.green.withValues(alpha: 0.4) : AppColors.chartBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: t.isFavorable ? Colors.green.withValues(alpha: 0.15) : AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                t.isFavorable ? Icons.thumb_up_alt_outlined : Icons.remove_circle_outline,
                color: t.isFavorable ? const Color(0xFF81C784) : AppColors.textMuted,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      planetName,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'House ${t.houseFromMoon} (SAV: ${t.savPoints} pts)',
                      style: TextStyle(
                        color: t.isFavorable ? const Color(0xFF81C784) : AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Transiting $signName (${(t.transitLongitude % 30).toStringAsFixed(1)}°)',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
