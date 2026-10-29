import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/services/ashtakavarga_service.dart';

class AshtakavargaView extends StatefulWidget {
  final AshtakavargaData data;
  const AshtakavargaView({super.key, required this.data});

  @override
  State<AshtakavargaView> createState() => _AshtakavargaViewState();
}

class _AshtakavargaViewState extends State<AshtakavargaView> {
  String _selectedPlanet = 'SAV'; // SAV or Sun, Moon, Mars, etc.

  static const List<String> _planets = [
    'SAV', 'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    final isSAV = _selectedPlanet == 'SAV';
    final points = isSAV ? widget.data.sav : widget.data.bav[_selectedPlanet] ?? List.filled(12, 0);
    final totalPoints = points.fold(0, (sum, val) => sum + val);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector chips for SAV & BAV
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _planets.map((planet) {
                final isSelected = _selectedPlanet == planet;
                String label = planet == 'SAV' ? 'Sarvashtakavarga (SAV)' : lang.planet(planet);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    selectedColor: AppColors.gold,
                    backgroundColor: AppColors.bgCardLight,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.bgDark : AppColors.textSecondary,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.gold : AppColors.chartBorder,
                      width: 0.8,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedPlanet = planet);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSAV ? 'Sarvashtakavarga Total Bindus' : '${lang.planet(_selectedPlanet)} BAV Total',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalPoints Bindus / Rekhas',
                      style: const TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSAV
                        ? (totalPoints >= 337 ? Colors.green.withValues(alpha: 0.2) : AppColors.gold.withValues(alpha: 0.15))
                        : AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isSAV ? (totalPoints == 337 ? 'Standard (337)' : '$totalPoints pts') : 'Parashari',
                    style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 12 Signs Heatmap Grid (3 columns x 4 rows)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.15,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 12,
            itemBuilder: (context, idx) {
              final val = points[idx];
              final rashiName = lang.rashi(idx);

              // Color coding for SAV (Standard: >=28 is strong, 25-27 neutral, <25 weak)
              Color badgeColor = AppColors.bgElevated;
              Color borderCol = AppColors.chartBorder;
              Color textCol = AppColors.textPrimary;

              if (isSAV) {
                if (val >= 28) {
                  badgeColor = Colors.green.withValues(alpha: 0.18);
                  borderCol = Colors.green.withValues(alpha: 0.6);
                  textCol = const Color(0xFF66BB6A);
                } else if (val < 25) {
                  badgeColor = Colors.red.withValues(alpha: 0.15);
                  borderCol = Colors.red.withValues(alpha: 0.4);
                  textCol = const Color(0xFFEF5350);
                } else {
                  badgeColor = AppColors.gold.withValues(alpha: 0.1);
                  borderCol = AppColors.gold.withValues(alpha: 0.3);
                  textCol = AppColors.gold;
                }
              } else {
                if (val >= 5) {
                  badgeColor = Colors.green.withValues(alpha: 0.18);
                  borderCol = Colors.green.withValues(alpha: 0.5);
                  textCol = const Color(0xFF66BB6A);
                } else if (val <= 3) {
                  badgeColor = Colors.red.withValues(alpha: 0.15);
                  borderCol = Colors.red.withValues(alpha: 0.4);
                  textCol = const Color(0xFFEF5350);
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rashiName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$val',
                      style: TextStyle(
                        color: textCol,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSAV ? (val >= 28 ? 'Auspicious' : (val < 25 ? 'Low' : 'Average')) : '$val bindus',
                      style: TextStyle(color: textCol.withValues(alpha: 0.8), fontSize: 9),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Kakshya Division Legend Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.chartBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kakshya Divisions (3°45\' Order)',
                  style: TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  '1. Saturn (0°-3°45\') • 2. Jupiter (3°45\'-7°30\') • 3. Mars (7°30\'-11°15\') • 4. Sun (11°15\'-15°00\') • 5. Venus (15°00\'-18°45\') • 6. Mercury (18°45\'-22°30\') • 7. Moon (22°30\'-26°15\') • 8. Lagna (26°15\'-30°00\')',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
