import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../core/constants/language.dart';
import '../../../data/services/yoga_service.dart';
import '../../../data/services/dosha_service.dart';

class YogasDoshasView extends StatelessWidget {
  final List<VedicYoga> yogas;
  final DoshaAnalysis dosha;

  const YogasDoshasView({
    super.key,
    required this.yogas,
    required this.dosha,
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
              // ─── DOSHA ANALYSIS SECTION ───
              _buildSectionHeader('Dosha Analysis (దోష విశ్లేషణ)', Icons.shield_outlined, goldAccent),
              const SizedBox(height: 12),

              // Kuja Dosha (Manglik) Card
              _buildKujaDoshaCard(dosha.kujaDosha, isTelugu, lang, isDark),
              const SizedBox(height: 10),

              // Kaal Sarpa Dosha Card
              _buildKaalSarpaCard(dosha.kaalSarpa, isTelugu, isDark, goldAccent),
              const SizedBox(height: 10),

              // Pitru & Guru Chandal Card
              if (dosha.hasPitruDosha || dosha.hasGuruChandal) ...[
                _buildSpecialDoshaCard(dosha, isTelugu, isDark, goldAccent),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 20),

              // ─── VEDIC YOGAS SECTION ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Formed Classical Yogas (${yogas.length})', Icons.auto_awesome, goldAccent),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: goldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${yogas.length} Active',
                      style: TextStyle(color: goldAccent, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (yogas.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.getElevatedColor(isDark),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.getBorderColor(isDark)),
                  ),
                  child: Center(
                    child: Text(
                      'Standard Planetary Combinations Present',
                      style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 13),
                    ),
                  ),
                )
              else
                ...yogas.map((yoga) => _buildYogaCard(yoga, isTelugu, lang, isDark, goldAccent)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color goldAccent) {
    return Row(
      children: [
        Icon(icon, color: goldAccent, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: goldAccent,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildKujaDoshaCard(KujaDoshaResult kuja, bool isTelugu, LanguageProvider lang, bool isDark) {
    bool isSafe = !kuja.hasDosha || kuja.isCancelled;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSafe ? Colors.green.withValues(alpha: 0.5) : Colors.orange.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
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
                    isSafe ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    color: isSafe ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTelugu ? 'కుజ దోషం (మంగళ దోషం)' : 'Kuja Dosha (Manglik)',
                    style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSafe ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.1) : Colors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  !kuja.hasDosha ? 'No Dosha' : (kuja.isCancelled ? 'Cancelled (నివృత్తి)' : '${kuja.severity} Dosha'),
                  style: TextStyle(
                    color: isSafe ? (isDark ? const Color(0xFF81C784) : const Color(0xFF15803D)) : (isDark ? const Color(0xFFFFB74D) : const Color(0xFFC2410C)),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            !kuja.hasDosha
                ? (isTelugu ? 'కుజుడు శుభ స్థానంలో ఉన్నారు. కుజ దోషం లేదు.' : 'Mars is favorably situated without any Kuja Dosha afflictions.')
                : (kuja.isCancelled
                    ? (isTelugu ? kuja.teluguReason : kuja.cancellationReason)
                    : (isTelugu
                        ? 'కుజుడు లగ్నం/చంద్రుడి నుండి ${kuja.affectedHouses.join(", ")}వ స్థానంలో ఉన్నారు.'
                        : 'Mars is placed in houses ${kuja.affectedHouses.join(", ")} from ${kuja.referencePoints.join(", ")}.')),
            style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildKaalSarpaCard(KaalSarpaResult ks, bool isTelugu, bool isDark, Color goldAccent) {
    bool has = ks.hasDosha;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: !has ? Colors.green.withValues(alpha: 0.4) : goldAccent.withValues(alpha: 0.5),
          width: 1.0,
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
                    !has ? Icons.check_circle_outline : Icons.all_inclusive,
                    color: !has ? Colors.green : goldAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTelugu ? 'కాలసర్ప యోగం / దోషం' : 'Kaal Sarpa Analysis',
                    style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: !has ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.1) : goldAccent.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  !has ? 'Absent' : (ks.isPartial ? 'Partial (పాక్షిక)' : 'Full (పూర్ణ)'),
                  style: TextStyle(
                    color: !has ? (isDark ? const Color(0xFF81C784) : const Color(0xFF15803D)) : goldAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            !has
                ? (isTelugu ? 'గ్రహాలు రాహు-కేతువుల మధ్య బంధించబడి లేవు. కాలసర్ప దోషం లేదు.' : 'Planets are freely distributed. No Kaal Sarpa Dosha present.')
                : (isTelugu ? '${ks.teluguTypeName}: ${ks.teluguDescription}' : '${ks.typeName}: ${ks.description}'),
            style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialDoshaCard(DoshaAnalysis dosha, bool isTelugu, bool isDark, Color goldAccent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorderColor(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dosha.hasPitruDosha) ...[
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                const SizedBox(width: 6),
                Text('Pitru Dosha Note', style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            Text(dosha.pitruDoshaReason, style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11)),
            const SizedBox(height: 8),
          ],
          if (dosha.hasGuruChandal) ...[
            Row(
              children: [
                Icon(Icons.auto_fix_high, color: goldAccent, size: 16),
                const SizedBox(width: 6),
                Text('Guru Chandal Combination', style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            Text(dosha.guruChandalReason, style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _buildYogaCard(VedicYoga yoga, bool isTelugu, LanguageProvider lang, bool isDark, Color goldAccent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.getCardGradient(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
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
              Expanded(
                child: Text(
                  isTelugu ? yoga.teluguName : yoga.name,
                  style: TextStyle(color: goldAccent, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: goldAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  yoga.category.name.toUpperCase(),
                  style: TextStyle(color: goldAccent, fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isTelugu ? yoga.teluguDescription : yoga.description,
            style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 12, height: 1.35),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.stars, color: goldAccent, size: 12),
              const SizedBox(width: 4),
              Text(
                'Planets: ${yoga.planets.map((p) => lang.planet(p)).join(", ")}',
                style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
