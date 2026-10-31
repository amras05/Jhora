import 'package:flutter/material.dart';

import '../../../core/constants/astro_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/chart_data.dart';

/// 12 Houses Bhava Spashta Table view with start, mid, and end longitudes and lords.
class BhavaSpashtaTable extends StatelessWidget {
  final ChartData chartData;

  const BhavaSpashtaTable({
    super.key,
    required this.chartData,
  });

  static String formatDms(double deg) {
    deg = deg % 360.0;
    int d = deg.floor();
    double mTotal = (deg - d) * 60.0;
    int m = mTotal.floor();
    int s = ((mTotal - m) * 60.0).round();
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    return '$d°$mStr\'$sStr"';
  }

  @override
  Widget build(BuildContext context) {
    final lagnaLon = chartData.ascendant.longitude;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.table_chart_outlined, color: goldAccent, size: 18),
            const SizedBox(width: 8),
            Text(
              'భావ స్పష్ట పట్టిక (12 Houses Bhava Spashta)',
              style: TextStyle(
                color: goldAccent,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.getElevatedColor(isDark),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.getBorderColor(isDark)),
          ),
          child: Column(
            children: List.generate(12, (i) {
              int h = i + 1;
              final midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
              final startLon = (midLon - 15.0 + 360.0) % 360.0;
              final endLon = (midLon + 15.0) % 360.0;
              final rIdx = (midLon / 30.0).floor() % 12;
              final lord = AstroConstants.rashiLordsTelugu[rIdx];

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.getBorderColor(isDark).withValues(alpha: 0.4), width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$hవ భావము',
                      style: TextStyle(
                        color: goldAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${formatDms(startLon)} → ${formatDms(midLon)} → ${formatDms(endLon)}',
                      style: TextStyle(
                        color: AppColors.getTextSecondary(isDark),
                        fontSize: 10.5,
                      ),
                    ),
                    Text(
                      lord,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(isDark),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

