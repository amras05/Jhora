import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/divisional_chart_service.dart';
import 'south_indian_chart.dart';

/// Interactive viewer for the Classical Parashara 16 Shodashavarga Divisional Charts.
class DivisionalChartsView extends StatefulWidget {
  final ChartData chartData;
  final LanguageProvider lang;

  const DivisionalChartsView({
    super.key,
    required this.chartData,
    required this.lang,
  });

  @override
  State<DivisionalChartsView> createState() => _DivisionalChartsViewState();
}

class _DivisionalChartsViewState extends State<DivisionalChartsView> {
  DivisionalChartType _selectedDivisional = DivisionalChartType.d1;
  bool _showDegreesOnChart = true;

  static const List<DivisionalChartType> _shodashavargaOrder = [
    DivisionalChartType.d1,
    DivisionalChartType.d9,
    DivisionalChartType.d2,
    DivisionalChartType.d3,
    DivisionalChartType.d4,
    DivisionalChartType.d7,
    DivisionalChartType.d10,
    DivisionalChartType.d12,
    DivisionalChartType.d16,
    DivisionalChartType.d20,
    DivisionalChartType.d24,
    DivisionalChartType.d27,
    DivisionalChartType.d30,
    DivisionalChartType.d40,
    DivisionalChartType.d45,
    DivisionalChartType.d60,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    final activePlacements = DivisionalChartService.getPlacementsForType(
      widget.chartData,
      _selectedDivisional,
    );
    final activeLagna = DivisionalChartService.getLagnaForType(
      widget.chartData,
      _selectedDivisional,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header showing 16 Shodashavargas Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: goldAccent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'షోడశవర్గ చక్రాలు (16 Shodashavargas)',
                        style: TextStyle(
                          color: goldAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: goldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: goldAccent.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '16 VARGAS',
                      style: TextStyle(
                        color: goldAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Horizontal scrolling selector chips for all 16 Varga charts
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _shodashavargaOrder.map((type) {
                    return _buildDivChip(
                      type,
                      DivisionalChartService.getDivisionalChipLabel(type),
                      isDark,
                      goldAccent,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // Degree toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.lang.l('show_degrees'),
                    style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: _showDegreesOnChart,
                    activeThumbColor: goldAccent,
                    activeTrackColor: goldAccent.withValues(alpha: 0.3),
                    inactiveThumbColor: AppColors.getTextMuted(isDark),
                    inactiveTrackColor: AppColors.getElevatedColor(isDark),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (val) => setState(() => _showDegreesOnChart = val),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Descriptive Title Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.getCardColor(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: goldAccent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.stars_rounded, color: goldAccent, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DivisionalChartService.getDivisionalTitle(_selectedDivisional),
                            style: TextStyle(
                              color: goldAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'లగ్నం (Lagna): ${widget.lang.rashi(activeLagna)}',
                            style: TextStyle(
                              color: AppColors.getTextSecondary(isDark),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Main South Indian Chart with clean, non-overlapping center title
              SouthIndianChart(
                planetsByRashi: activePlacements,
                lagnaRashi: activeLagna,
                title: DivisionalChartService.getDivisionalCenterName(_selectedDivisional),
                subtitle: DivisionalChartService.getDivisionalSignificance(_selectedDivisional),
                showDegrees: _showDegreesOnChart,
                lang: widget.lang,
              ).animate(key: ValueKey(_selectedDivisional)).fadeIn(duration: 250.ms),

              const SizedBox(height: 16),

              // Quick D9 comparison if viewing D1
              if (_selectedDivisional == DivisionalChartType.d1) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.swap_horiz, color: goldAccent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'నవాంశ చక్రము (D9 Navamsa)',
                      style: TextStyle(
                        color: goldAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SouthIndianChart(
                  planetsByRashi: DivisionalChartService.getPlacementsForType(
                    widget.chartData,
                    DivisionalChartType.d9,
                  ),
                  lagnaRashi: DivisionalChartService.getLagnaForType(
                    widget.chartData,
                    DivisionalChartType.d9,
                  ),
                  title: DivisionalChartService.getDivisionalCenterName(DivisionalChartType.d9),
                  subtitle: DivisionalChartService.getDivisionalSignificance(DivisionalChartType.d9),
                  showDegrees: false,
                  lang: widget.lang,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivChip(DivisionalChartType type, String label, bool isDark, Color goldAccent) {
    final isSelected = _selectedDivisional == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: goldAccent,
        backgroundColor: AppColors.getElevatedColor(isDark),
        labelStyle: TextStyle(
          color: isSelected ? (isDark ? AppColors.bgDark : Colors.white) : AppColors.getTextSecondary(isDark),
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 11,
        ),
        side: BorderSide(
          color: isSelected ? goldAccent : AppColors.getBorderColor(isDark),
        ),
        onSelected: (_) => setState(() => _selectedDivisional = type),
      ),
    );
  }
}
