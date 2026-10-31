import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/services/shadbala_service.dart';

class ShadbalaView extends StatelessWidget {
  final List<PlanetShadbala> shadbalaList;
  final bool isStandalone;

  const ShadbalaView({super.key, required this.shadbalaList, this.isStandalone = false});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView.builder(
          padding: isStandalone ? const EdgeInsets.all(16) : EdgeInsets.zero,
          shrinkWrap: !isStandalone,
          physics: isStandalone ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          itemCount: shadbalaList.length,
          itemBuilder: (context, idx) {
            final item = shadbalaList[idx];
            final planetName = lang.planet(item.planetName);
            final isStrong = item.isStrong;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.getCardGradient(isDark),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isStrong ? goldAccent.withValues(alpha: 0.45) : AppColors.getBorderColor(isDark),
                  width: isStrong ? 1.2 : 0.8,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Planet Name, Rank, and Strength Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: goldAccent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: goldAccent, width: 0.8),
                            ),
                            child: Text(
                              'Rank #${item.rank}',
                              style: TextStyle(
                                color: goldAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            planetName,
                            style: TextStyle(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isStrong ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.12) : Colors.orange.withValues(alpha: isDark ? 0.15 : 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isStrong ? Colors.green : Colors.orange, width: 0.8),
                        ),
                        child: Text(
                          isStrong ? 'Strong (${(item.strengthRatio * 100).toStringAsFixed(0)}%)' : 'Moderate (${(item.strengthRatio * 100).toStringAsFixed(0)}%)',
                          style: TextStyle(
                            color: isStrong ? (isDark ? const Color(0xFF81C784) : const Color(0xFF15803D)) : (isDark ? const Color(0xFFFFB74D) : const Color(0xFFC2410C)),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Total Rupas & Virupas Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.totalRupas.toStringAsFixed(2)} Rupas (${item.totalVirupas.toStringAsFixed(0)} Virupas)',
                        style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Req: ${item.requiredRupas.toStringAsFixed(1)} Rupas',
                        style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (item.strengthRatio / 1.8).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: AppColors.getElevatedColor(isDark),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isStrong ? goldAccent : Colors.orangeAccent,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  Divider(color: AppColors.getBorderColor(isDark), height: 1),
                  const SizedBox(height: 10),

                  // 6 Balas Grid (Sthana, Dig, Kala, Chesta, Naisargika, Drik)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBalaMini('Sthana', item.sthanaBala, isDark),
                      _buildBalaMini('Dig', item.digBala, isDark),
                      _buildBalaMini('Kala', item.kalaBala, isDark),
                      _buildBalaMini('Chesta', item.chestaBala, isDark),
                      _buildBalaMini('Naisargika', item.naisargikaBala, isDark),
                      _buildBalaMini('Drik', item.drikBala, isDark),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalaMini(String label, double val, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 9),
        ),
        const SizedBox(height: 2),
        Text(
          val.toStringAsFixed(0),
          style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
