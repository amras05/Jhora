import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/astro_constants.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/models/planet_position.dart';

/// Responsive South Indian style birth chart rendered with precision CustomPainter.
/// Adapts dynamically to any phone, tablet, or desktop screen size with Light & Dark theme support.
class SouthIndianChart extends StatelessWidget {
  final Map<int, List<PlanetPosition>> planetsByRashi;
  final int lagnaRashi;
  final String title;
  final String? subtitle;
  final double? size;
  final LanguageProvider lang;
  final bool showDegrees;

  const SouthIndianChart({
    super.key,
    required this.planetsByRashi,
    required this.lagnaRashi,
    this.title = 'RASI',
    this.subtitle,
    this.size,
    required this.lang,
    this.showDegrees = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 340.0;
        final effectiveSize = size ?? min(availableWidth, 420.0);

        return Center(
          child: Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              color: AppColors.getCardColor(isDark),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? AppColors.gold : AppColors.templeGold).withValues(alpha: 0.5),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppColors.gold : Colors.black).withValues(alpha: isDark ? 0.08 : 0.06),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                size: Size(effectiveSize, effectiveSize),
                painter: _SouthIndianChartPainter(
                  planetsByRashi: planetsByRashi,
                  lagnaRashi: lagnaRashi,
                  title: title,
                  subtitle: subtitle,
                  lang: lang,
                  showDegrees: showDegrees,
                  isDark: isDark,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SouthIndianChartPainter extends CustomPainter {
  final Map<int, List<PlanetPosition>> planetsByRashi;
  final int lagnaRashi;
  final String title;
  final String? subtitle;
  final LanguageProvider lang;
  final bool showDegrees;
  final bool isDark;

  _SouthIndianChartPainter({
    required this.planetsByRashi,
    required this.lagnaRashi,
    required this.title,
    this.subtitle,
    required this.lang,
    required this.showDegrees,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellW = size.width / 4;
    final double cellH = size.height / 4;
    final Color goldAccent = isDark ? AppColors.gold : AppColors.templeGold;

    // Outer border
    final borderPaint = Paint()
      ..color = goldAccent.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)),
      borderPaint,
    );

    // Inner Grid lines
    final gridPaint = Paint()
      ..color = AppColors.getLineColor(isDark).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(cellW * i, 0), Offset(cellW * i, size.height), gridPaint);
      canvas.drawLine(Offset(0, cellH * i), Offset(size.width, cellH * i), gridPaint);
    }

    // Draw center 2x2 box (title, subtitle, and lagna indicator)
    _drawCenterTitle(canvas, size, cellW, cellH, goldAccent);

    // Render each of the 12 peripheral rashi cells
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        int rashiIdx = AstroConstants.southIndianGrid[row][col];
        if (rashiIdx == -1) continue;

        double x = col * cellW;
        double y = row * cellH;
        bool isLagna = rashiIdx == lagnaRashi;

        // Clip each cell strictly to its bounding rect so text NEVER bleeds outside
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(x + 1, y + 1, cellW - 2, cellH - 2));

        if (isLagna) {
          // Highlight lagna house
          final highlightPaint = Paint()
            ..color = goldAccent.withValues(alpha: isDark ? 0.12 : 0.08)
            ..style = PaintingStyle.fill;
          canvas.drawRect(Rect.fromLTWH(x + 1, y + 1, cellW - 2, cellH - 2), highlightPaint);

          // Classical South Indian double diagonal slash "//" across top-left corner
          final slashPaint = Paint()
            ..color = goldAccent.withValues(alpha: 0.85)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
          canvas.drawLine(Offset(x + 1, y + 10), Offset(x + 10, y + 1), slashPaint);
          canvas.drawLine(Offset(x + 1, y + 15), Offset(x + 15, y + 1), slashPaint);

          // Lagna indicator badge at top-right
          final lgBadgePainter = TextPainter(
            text: TextSpan(
              text: 'Lg',
              style: TextStyle(
                color: goldAccent,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          lgBadgePainter.layout();
          lgBadgePainter.paint(canvas, Offset(x + cellW - lgBadgePainter.width - 3, y + 2));
        }

        // Draw Rashi Name Label safely
        _drawSignLabel(canvas, rashiIdx, x, y, isLagna, goldAccent, cellW);

        // Draw Planets inside cell
        List<PlanetPosition> cellPlanets = planetsByRashi[rashiIdx] ?? [];
        _drawPlanets(canvas, cellPlanets, x, y, cellW, cellH);

        canvas.restore();
      }
    }
  }

  void _drawCenterTitle(Canvas canvas, Size size, double cellW, double cellH, Color goldAccent) {
    final centerRect = Rect.fromLTWH(cellW + 1, cellH + 1, cellW * 2 - 2, cellH * 2 - 2);

    canvas.save();
    canvas.clipRect(centerRect);

    // Center background fill
    final fillPaint = Paint()
      ..color = AppColors.getBackgroundColor(isDark).withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;
    canvas.drawRect(centerRect, fillPaint);

    // Subtle diagonal lines in center
    final diagPaint = Paint()
      ..color = goldAccent.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(cellW, cellH), Offset(cellW * 3, cellH * 3), diagPaint);
    canvas.drawLine(Offset(cellW * 3, cellH), Offset(cellW, cellH * 3), diagPaint);

    // Format title and subtitle
    String mainTitle = title;
    String sub = subtitle ?? '';

    if (sub.isEmpty && title.contains('(')) {
      final parts = title.split('(');
      mainTitle = parts[0].trim();
      sub = parts[1].replaceAll(')', '').trim();
    }

    final double maxTextWidth = (cellW * 2) - 20;

    // 1. Main Title Painter
    final titlePainter = TextPainter(
      text: TextSpan(
        text: mainTitle,
        style: TextStyle(
          color: goldAccent,
          fontSize: (cellW * 0.15).clamp(10.5, 13.5),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout(maxWidth: maxTextWidth);

    // 2. Subtitle Painter
    TextPainter? subPainter;
    if (sub.isNotEmpty) {
      subPainter = TextPainter(
        text: TextSpan(
          text: sub,
          style: TextStyle(
            color: AppColors.getTextSecondary(isDark),
            fontSize: (cellW * 0.10).clamp(8.0, 10.0),
            fontWeight: FontWeight.w500,
          ),
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        ellipsis: '...',
        textDirection: TextDirection.ltr,
      );
      subPainter.layout(maxWidth: maxTextWidth);
    }

    // 3. Lagna Info Badge
    final String lagnaName = lang.rashi(lagnaRashi);
    final lagnaPainter = TextPainter(
      text: TextSpan(
        text: 'లగ్నం: $lagnaName',
        style: TextStyle(
          color: goldAccent,
          fontSize: (cellW * 0.10).clamp(8.0, 9.5),
          fontWeight: FontWeight.w700,
        ),
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
    );
    lagnaPainter.layout(maxWidth: maxTextWidth);

    // Calculate vertical centering
    double totalH = titlePainter.height + 4;
    if (subPainter != null) {
      totalH += subPainter.height + 6;
    }
    totalH += lagnaPainter.height + 8;

    double currentY = cellH + ((cellH * 2) - totalH) / 2;

    // Paint Title
    titlePainter.paint(
      canvas,
      Offset(cellW + ((cellW * 2) - titlePainter.width) / 2, currentY),
    );
    currentY += titlePainter.height + 4;

    // Paint Subtitle
    if (subPainter != null) {
      subPainter.paint(
        canvas,
        Offset(cellW + ((cellW * 2) - subPainter.width) / 2, currentY),
      );
      currentY += subPainter.height + 6;
    }

    // Paint Lagna Pill
    final double pillW = lagnaPainter.width + 14;
    final double pillH = lagnaPainter.height + 4;
    final double pillX = cellW + ((cellW * 2) - pillW) / 2;
    final pillRect = Rect.fromLTWH(pillX, currentY - 1, pillW, pillH);

    final pillBgPaint = Paint()
      ..color = goldAccent.withValues(alpha: isDark ? 0.15 : 0.1)
      ..style = PaintingStyle.fill;
    final pillBorderPaint = Paint()
      ..color = goldAccent.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawRRect(RRect.fromRectAndRadius(pillRect, const Radius.circular(8)), pillBgPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(pillRect, const Radius.circular(8)), pillBorderPaint);

    lagnaPainter.paint(
      canvas,
      Offset(cellW + ((cellW * 2) - lagnaPainter.width) / 2, currentY + 1),
    );

    canvas.restore();
  }

  void _drawSignLabel(Canvas canvas, int rashiIdx, double x, double y, bool isLagna, Color goldAccent, double cellW) {
    String rashiName = lang.rashi(rashiIdx);

    final labelPainter = TextPainter(
      text: TextSpan(
        text: rashiName,
        style: TextStyle(
          color: isLagna ? goldAccent : AppColors.getTextMuted(isDark).withValues(alpha: 0.8),
          fontSize: 8.5,
          fontWeight: isLagna ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
      maxLines: 1,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout(maxWidth: isLagna ? (cellW - 32) : (cellW - 8));

    // If Lagna, indent by 17px to keep top-left "//" slashes completely free
    double drawX = isLagna ? (x + 17) : (x + 4);
    labelPainter.paint(canvas, Offset(drawX, y + 2));
  }

  void _drawPlanets(Canvas canvas, List<PlanetPosition> planets, double x, double y, double cellW, double cellH) {
    if (planets.isEmpty) return;

    double startY = y + 14.5;
    int count = planets.length;
    double availH = cellH - 17.0;
    double lineHeight = (availH / max(count, 1)).clamp(9.5, 14.0);

    double fontSize;
    if (showDegrees) {
      fontSize = count >= 4 ? 7.2 : (count == 3 ? 8.0 : 8.6);
    } else {
      fontSize = count >= 4 ? 8.4 : 9.6;
    }

    for (int i = 0; i < count && i < 6; i++) {
      PlanetPosition p = planets[i];
      Color planetColor = _getPlanetColor(p.name);
      String abbr = lang.chartAbbr(p.name);
      String retro = p.isRetrograde ? '(R)' : '';
      String combust = p.isCombust ? '(c)' : '';

      String textToDraw = showDegrees ? '$abbr$retro$combust ${p.shortDegInRashi}' : '$abbr$retro$combust';

      final planetPainter = TextPainter(
        text: TextSpan(
          text: textToDraw,
          style: TextStyle(
            color: planetColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
        maxLines: 1, // CRITICAL: Never soft-wrap to 2 lines
        ellipsis: '...',
        textDirection: TextDirection.ltr,
      );
      planetPainter.layout(maxWidth: cellW - 4);
      planetPainter.paint(
        canvas,
        Offset(x + (cellW - planetPainter.width) / 2, startY + (i * lineHeight)),
      );
    }
  }

  Color _getPlanetColor(String name) {
    if (!isDark) {
      // High contrast colors for day/light mode
      switch (name) {
        case 'Sun': return const Color(0xFFB45309);
        case 'Moon': return const Color(0xFF3730A3);
        case 'Mars': return const Color(0xFFDC2626);
        case 'Mercury': return const Color(0xFF047857);
        case 'Jupiter': return const Color(0xFFB45309);
        case 'Venus': return const Color(0xFFBE185D);
        case 'Saturn': return const Color(0xFF4338CA);
        case 'Rahu': return const Color(0xFF475569);
        case 'Ketu': return const Color(0xFF57534E);
        case 'Ascendant': return AppColors.templeGold;
        default: return AppColors.textLightPrimary;
      }
    }
    // Luminous colors for night/dark mode
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
