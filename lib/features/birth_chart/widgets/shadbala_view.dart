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

    return ListView.builder(
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
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isStrong ? AppColors.gold.withValues(alpha: 0.4) : AppColors.chartBorder,
              width: isStrong ? 1.2 : 0.8,
            ),
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
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.gold, width: 0.8),
                        ),
                        child: Text(
                          'Rank #${item.rank}',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        planetName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isStrong ? Colors.green.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isStrong ? Colors.green : Colors.orange, width: 0.8),
                    ),
                    child: Text(
                      isStrong ? 'Strong (${(item.strengthRatio * 100).toStringAsFixed(0)}%)' : 'Moderate (${(item.strengthRatio * 100).toStringAsFixed(0)}%)',
                      style: TextStyle(
                        color: isStrong ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
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
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Req: ${item.requiredRupas.toStringAsFixed(1)} Rupas',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (item.strengthRatio / 1.8).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: AppColors.bgElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isStrong ? AppColors.gold : Colors.orangeAccent,
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const Divider(color: AppColors.chartBorder, height: 1),
              const SizedBox(height: 10),

              // 6 Balas Grid (Sthana, Dig, Kala, Chesta, Naisargika, Drik)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalaMini('Sthana', item.sthanaBala),
                  _buildBalaMini('Dig', item.digBala),
                  _buildBalaMini('Kala', item.kalaBala),
                  _buildBalaMini('Chesta', item.chestaBala),
                  _buildBalaMini('Naisargika', item.naisargikaBala),
                  _buildBalaMini('Drik', item.drikBala),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalaMini(String label, double val) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
        ),
        const SizedBox(height: 2),
        Text(
          val.toStringAsFixed(0),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
