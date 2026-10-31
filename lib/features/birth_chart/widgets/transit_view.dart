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
              // Transit Date Selector Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.getElevatedColor(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.getBorderColor(isDark)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sync_alt, color: goldAccent, size: 18),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Transit (Gochar) Date', style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10)),
                            Text(
                              DateFormat('dd MMMM yyyy').format(gochar.transitDate),
                              style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: onSelectDate,
                      icon: Icon(Icons.edit_calendar, size: 16, color: goldAccent),
                      label: Text('Change Date', style: TextStyle(color: goldAccent, fontSize: 12)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Sade Sati Status Card
              _buildSadeSatiCard(gochar.sadeSati, isTelugu, isDark),

              const SizedBox(height: 16),

              // Planetary Transits Table / Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Planetary Transits (${gochar.overallFavorableCount}/9 Favorable)',
                    style: TextStyle(color: goldAccent, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  Text('From Natal Moon', style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11)),
                ],
              ),
              const SizedBox(height: 10),

              ...gochar.transits.map((t) => _buildSingleTransitCard(t, lang, isTelugu, isDark)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSadeSatiCard(SadeSatiStatus ss, bool isTelugu, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.getCardGradient(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ss.isActive ? Colors.orange.withValues(alpha: 0.6) : Colors.green.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                    style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ss.isActive ? Colors.orange.withValues(alpha: isDark ? 0.15 : 0.12) : Colors.green.withValues(alpha: isDark ? 0.15 : 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ss.isActive ? (isTelugu ? ss.teluguPhase : ss.phase) : 'Inactive',
                  style: TextStyle(
                    color: ss.isActive ? (isDark ? const Color(0xFFFFB74D) : const Color(0xFFC2410C)) : (isDark ? const Color(0xFF81C784) : const Color(0xFF15803D)),
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
            style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleTransitCard(SinglePlanetTransit t, LanguageProvider lang, bool isTelugu, bool isDark) {
    final planetName = lang.planet(t.planetName);
    final signName = lang.rashi(t.transitRashi);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: t.isFavorable ? (isDark ? Colors.green.withValues(alpha: 0.4) : const Color(0xFF86EFAC)) : AppColors.getBorderColor(isDark),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: t.isFavorable ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.1) : (isDark ? AppColors.gold.withValues(alpha: 0.1) : AppColors.templeGold.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                t.isFavorable ? Icons.thumb_up_alt_outlined : Icons.remove_circle_outline,
                color: t.isFavorable ? (isDark ? const Color(0xFF81C784) : const Color(0xFF15803D)) : AppColors.getTextMuted(isDark),
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
                      style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'House ${t.houseFromMoon} (SAV: ${t.savPoints} pts)',
                      style: TextStyle(
                        color: t.isFavorable ? (isDark ? const Color(0xFF81C784) : const Color(0xFF15803D)) : AppColors.getTextMuted(isDark),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Transiting $signName (${(t.transitLongitude % 30).toStringAsFixed(1)}°)',
                  style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
