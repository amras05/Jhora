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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── DOSHA ANALYSIS SECTION ───
          _buildSectionHeader('Dosha Analysis (దోష విశ్లేషణ)', Icons.shield_outlined),
          const SizedBox(height: 12),

          // Kuja Dosha (Manglik) Card
          _buildKujaDoshaCard(dosha.kujaDosha, isTelugu, lang),
          const SizedBox(height: 10),

          // Kaal Sarpa Dosha Card
          _buildKaalSarpaCard(dosha.kaalSarpa, isTelugu),
          const SizedBox(height: 10),

          // Pitru & Guru Chandal Card
          if (dosha.hasPitruDosha || dosha.hasGuruChandal) ...[
            _buildSpecialDoshaCard(dosha, isTelugu),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 20),

          // ─── VEDIC YOGAS SECTION ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Formed Classical Yogas (${yogas.length})', Icons.auto_awesome),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${yogas.length} Active',
                  style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (yogas.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.chartBorder),
              ),
              child: const Center(
                child: Text(
                  'Standard Planetary Combinations Present',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ...yogas.map((yoga) => _buildYogaCard(yoga, isTelugu, lang)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildKujaDoshaCard(KujaDoshaResult kuja, bool isTelugu, LanguageProvider lang) {
    bool isSafe = !kuja.hasDosha || kuja.isCancelled;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSafe ? Colors.green.withValues(alpha: 0.5) : Colors.orange.withValues(alpha: 0.6),
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
                    isSafe ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    color: isSafe ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTelugu ? 'కుజ దోషం (మంగళ దోషం)' : 'Kuja Dosha (Manglik)',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSafe ? Colors.green.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  !kuja.hasDosha ? 'No Dosha' : (kuja.isCancelled ? 'Cancelled (నివృత్తి)' : '${kuja.severity} Dosha'),
                  style: TextStyle(
                    color: isSafe ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
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
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildKaalSarpaCard(KaalSarpaResult ks, bool isTelugu) {
    bool has = ks.hasDosha;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: !has ? Colors.green.withValues(alpha: 0.4) : AppColors.gold.withValues(alpha: 0.5),
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
                    color: !has ? Colors.green : AppColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isTelugu ? 'కాలసర్ప యోగం / దోషం' : 'Kaal Sarpa Analysis',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: !has ? Colors.green.withValues(alpha: 0.15) : AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  !has ? 'Absent' : (ks.isPartial ? 'Partial (పాక్షిక)' : 'Full (పూర్ణ)'),
                  style: TextStyle(
                    color: !has ? const Color(0xFF81C784) : AppColors.gold,
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
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialDoshaCard(DoshaAnalysis dosha, bool isTelugu) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.chartBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dosha.hasPitruDosha) ...[
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 16),
                SizedBox(width: 6),
                Text('Pitru Dosha Note', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            Text(dosha.pitruDoshaReason, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 8),
          ],
          if (dosha.hasGuruChandal) ...[
            const Row(
              children: [
                Icon(Icons.auto_fix_high, color: AppColors.gold, size: 16),
                SizedBox(width: 6),
                Text('Guru Chandal Combination', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            Text(dosha.guruChandalReason, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _buildYogaCard(VedicYoga yoga, bool isTelugu, LanguageProvider lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
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
                  style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  yoga.category.name.toUpperCase(),
                  style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isTelugu ? yoga.teluguDescription : yoga.description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.35),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.stars, color: AppColors.gold, size: 12),
              const SizedBox(width: 4),
              Text(
                'Planets: ${yoga.planets.map((p) => lang.planet(p)).join(", ")}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
