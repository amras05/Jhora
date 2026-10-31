import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/divisional_chart_service.dart';
import 'south_indian_chart.dart';

/// Interactive viewer for Vedic Divisional (Varga) charts.
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

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Divisional Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: DivisionalChartType.values.map((type) {
                return _buildDivChip(
                  type,
                  DivisionalChartService.getDivisionalChipLabel(type),
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
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(width: 4),
              Switch(
                value: _showDegreesOnChart,
                activeColor: AppColors.gold,
                activeTrackColor: AppColors.gold.withValues(alpha: 0.3),
                inactiveThumbColor: AppColors.textMuted,
                inactiveTrackColor: AppColors.bgElevated,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (val) => setState(() => _showDegreesOnChart = val),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Main South Indian Chart
          SouthIndianChart(
            planetsByRashi: activePlacements,
            lagnaRashi: activeLagna,
            title: DivisionalChartService.getDivisionalTitle(_selectedDivisional),
            showDegrees: _showDegreesOnChart,
            lang: widget.lang,
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 16),

          // Quick D9 / D1 Switcher if looking at D1
          if (_selectedDivisional == DivisionalChartType.d1) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.swap_horiz, color: AppColors.gold, size: 16),
                SizedBox(width: 6),
                Text(
                  'నవాంశ చక్రము (D9 Navamsa)',
                  style: TextStyle(
                    color: AppColors.gold,
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
              title: DivisionalChartService.getDivisionalTitle(DivisionalChartType.d9),
              showDegrees: false,
              lang: widget.lang,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivChip(DivisionalChartType type, String label) {
    final isSelected = _selectedDivisional == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.gold,
        backgroundColor: AppColors.bgElevated,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.bgDark : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 11,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.gold : AppColors.chartBorder,
        ),
        onSelected: (_) => setState(() => _selectedDivisional = type),
      ),
    );
  }
}

