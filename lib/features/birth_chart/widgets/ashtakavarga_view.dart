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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    final isSAV = _selectedPlanet == 'SAV';
    final points = isSAV ? widget.data.sav : widget.data.bav[_selectedPlanet] ?? List.filled(12, 0);
    final totalPoints = points.fold(0, (sum, val) => sum + val);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
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
                        selectedColor: goldAccent,
                        backgroundColor: AppColors.getElevatedColor(isDark),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? (isDark ? AppColors.bgDark : Colors.white) : AppColors.getTextSecondary(isDark),
                        ),
                        side: BorderSide(
                          color: isSelected ? goldAccent : AppColors.getBorderColor(isDark),
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
                  gradient: AppColors.getCardGradient(isDark),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSAV ? 'Sarvashtakavarga Total Bindus' : '${lang.planet(_selectedPlanet)} BAV Total',
                          style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$totalPoints Bindus / Rekhas',
                          style: TextStyle(color: goldAccent, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSAV
                            ? (totalPoints >= 337 ? Colors.green.withValues(alpha: 0.2) : goldAccent.withValues(alpha: 0.15))
                            : goldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isSAV ? (totalPoints == 337 ? 'Standard (337)' : '$totalPoints pts') : 'Parashari',
                        style: TextStyle(color: goldAccent, fontSize: 11, fontWeight: FontWeight.w700),
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

                  Color badgeColor = AppColors.getElevatedColor(isDark);
                  Color borderCol = AppColors.getBorderColor(isDark);
                  Color textCol = AppColors.getTextPrimary(isDark);

                  if (isSAV) {
                    if (val >= 28) {
                      badgeColor = Colors.green.withValues(alpha: isDark ? 0.18 : 0.12);
                      borderCol = Colors.green.withValues(alpha: 0.6);
                      textCol = isDark ? const Color(0xFF66BB6A) : const Color(0xFF15803D);
                    } else if (val < 25) {
                      badgeColor = Colors.red.withValues(alpha: isDark ? 0.15 : 0.1);
                      borderCol = Colors.red.withValues(alpha: 0.4);
                      textCol = isDark ? const Color(0xFFEF5350) : const Color(0xFFB91C1C);
                    } else {
                      badgeColor = goldAccent.withValues(alpha: isDark ? 0.1 : 0.08);
                      borderCol = goldAccent.withValues(alpha: 0.3);
                      textCol = goldAccent;
                    }
                  } else {
                    if (val >= 5) {
                      badgeColor = Colors.green.withValues(alpha: isDark ? 0.18 : 0.12);
                      borderCol = Colors.green.withValues(alpha: 0.5);
                      textCol = isDark ? const Color(0xFF66BB6A) : const Color(0xFF15803D);
                    } else if (val <= 3) {
                      badgeColor = Colors.red.withValues(alpha: isDark ? 0.15 : 0.1);
                      borderCol = Colors.red.withValues(alpha: 0.4);
                      textCol = isDark ? const Color(0xFFEF5350) : const Color(0xFFB91C1C);
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
                          style: TextStyle(
                            color: AppColors.getTextPrimary(isDark),
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
                          style: TextStyle(color: textCol.withValues(alpha: 0.9), fontSize: 9),
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
                  color: AppColors.getElevatedColor(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.getBorderColor(isDark)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kakshya Divisions (3°45\' Order)',
                      style: TextStyle(color: goldAccent, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1. Saturn (0°-3°45\') • 2. Jupiter (3°45\'-7°30\') • 3. Mars (7°30\'-11°15\') • 4. Sun (11°15\'-15°00\') • 5. Venus (15°00\'-18°45\') • 6. Mercury (18°45\'-22°30\') • 7. Moon (22°30\'-26°15\') • 8. Lagna (26°15\'-30°00\')',
                      style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
