import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/astro_constants.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/models/planet_position.dart';

/// South Indian style birth chart rendered with precision CustomPainter.
class SouthIndianChart extends StatelessWidget {
  final Map<int, List<PlanetPosition>> planetsByRashi;
  final int lagnaRashi;
  final String title;
  final double size;
  final LanguageProvider lang;
  final bool showDegrees;

  const SouthIndianChart({
    super.key,
    required this.planetsByRashi,
    required this.lagnaRashi,
    this.title = 'RASI',
    this.size = 340,
    required this.lang,
    this.showDegrees = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.chartBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: Size(size, size),
          painter: _SouthIndianChartPainter(
            planetsByRashi: planetsByRashi,
            lagnaRashi: lagnaRashi,
            title: title,
            lang: lang,
            showDegrees: showDegrees,
          ),
        ),
      ),
    );
  }
}

class _SouthIndianChartPainter extends CustomPainter {
  final Map<int, List<PlanetPosition>> planetsByRashi;
  final int lagnaRashi;
  final String title;
  final LanguageProvider lang;
  final bool showDegrees;

  _SouthIndianChartPainter({
    required this.planetsByRashi,
    required this.lagnaRashi,
    required this.title,
    required this.lang,
    required this.showDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellW = size.width / 4;
    final double cellH = size.height / 4;

    // Outer border
    final borderPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)),
      borderPaint,
    );

    // Inner Grid lines
    final gridPaint = Paint()
      ..color = AppColors.chartLine.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(cellW * i, 0), Offset(cellW * i, size.height), gridPaint);
      canvas.drawLine(Offset(0, cellH * i), Offset(size.width, cellH * i), gridPaint);
    }

    // Diagonal lines in center
    final diagPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(cellW, cellH), Offset(cellW * 3, cellH * 3), diagPaint);
    canvas.drawLine(Offset(cellW * 3, cellH), Offset(cellW, cellH * 3), diagPaint);

    _drawCenterTitle(canvas, size, cellW, cellH);

    // Render each rashi cell
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        int rashiIdx = AstroConstants.southIndianGrid[row][col];
        if (rashiIdx == -1) continue;

        double x = col * cellW;
        double y = row * cellH;

        bool isLagna = rashiIdx == lagnaRashi;

        if (isLagna) {
          // Highlight lagna house
          final highlightPaint = Paint()
            ..color = AppColors.gold.withValues(alpha: 0.12)
            ..style = PaintingStyle.fill;
          canvas.drawRect(Rect.fromLTWH(x + 1, y + 1, cellW - 2, cellH - 2), highlightPaint);

          // Classical South Indian double diagonal slash "//" across top-left corner
          final slashPaint = Paint()
            ..color = AppColors.gold.withValues(alpha: 0.75)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
          canvas.drawLine(Offset(x, y + 14), Offset(x + 14, y), slashPaint);
          canvas.drawLine(Offset(x, y + 20), Offset(x + 20, y), slashPaint);
        }

        _drawSignLabel(canvas, rashiIdx, x, y, isLagna);
        List<PlanetPosition> cellPlanets = planetsByRashi[rashiIdx] ?? [];
        _drawPlanets(canvas, cellPlanets, x, y, cellW, cellH);
      }
    }
  }

  void _drawCenterTitle(Canvas canvas, Size size, double cellW, double cellH) {
    final centerRect = Rect.fromLTWH(cellW, cellH, cellW * 2, cellH * 2);
    final fillPaint = Paint()
      ..color = AppColors.bgDark.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(centerRect, fillPaint);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: AppColors.gold,
          fontSize: cellW * 0.26,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset((size.width - titlePainter.width) / 2, (size.height - titlePainter.height) / 2),
    );
  }

  void _drawSignLabel(Canvas canvas, int rashiIdx, double x, double y, bool isLagna) {
    String rashiName = lang.rashi(rashiIdx);
    String display = rashiName.length > 5 ? rashiName.substring(0, 5) : rashiName;

    final labelPainter = TextPainter(
      text: TextSpan(
        text: display,
        style: TextStyle(
          color: isLagna ? AppColors.gold : AppColors.textMuted.withValues(alpha: 0.6),
          fontSize: 8.5,
          fontWeight: isLagna ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(x + 4, y + 3));
  }

  void _drawPlanets(Canvas canvas, List<PlanetPosition> planets, double x, double y, double cellW, double cellH) {
    if (planets.isEmpty) return;

    double startY = y + 16;
    int count = planets.length;
    double lineHeight = min((cellH - 20) / max(count, 1), 16.0);

    for (int i = 0; i < count && i < 6; i++) {
      PlanetPosition p = planets[i];
      Color planetColor = _getPlanetColor(p.name);
      String abbr = lang.chartAbbr(p.name);
      String label = p.isRetrograde ? '$abbr(R)' : abbr;

      String textToDraw = showDegrees ? '$label ${p.shortDegInRashi}' : label;

      final planetPainter = TextPainter(
        text: TextSpan(
          text: textToDraw,
          style: TextStyle(
            color: planetColor,
            fontSize: showDegrees ? 9.5 : 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      planetPainter.layout(maxWidth: cellW - 6);
      planetPainter.paint(
        canvas,
        Offset(x + (cellW - planetPainter.width) / 2, startY + i * lineHeight),
      );
    }
  }

  Color _getPlanetColor(String name) {
    switch (name) {
      case 'Sun': return AppColors.sunColor;
      case 'Moon': return AppColors.moonColor;
      case 'Mars': return AppColors.marsColor;
      case 'Mercury': return AppColors.mercuryColor;
      case 'Jupiter': return AppColors.jupiterColor;
      case 'Venus': return AppColors.venusColor;
      case 'Saturn': return AppColors.saturnColor;
      case 'Rahu': return AppColors.rahuColor;
      case 'Ketu': return AppColors.ketuColor;
      case 'Ascendant': return AppColors.ascColor;
      default: return AppColors.textPrimary;
    }
  }

  @override
  bool shouldRepaint(covariant _SouthIndianChartPainter oldDelegate) => true;
}
