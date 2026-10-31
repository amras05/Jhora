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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.table_chart_outlined, color: AppColors.gold, size: 18),
            SizedBox(width: 8),
            Text(
              'భావ స్పష్ట పట్టిక (12 Houses Bhava Spashta)',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.chartBorder),
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
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.chartBorder, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$hవ భావము',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${formatDms(startLon)} → ${formatDms(midLon)} → ${formatDms(endLon)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                    Text(
                      lord,
                      style: const TextStyle(
                        color: Colors.white,
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

