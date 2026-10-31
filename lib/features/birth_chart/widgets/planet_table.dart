import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/models/planet_position.dart';

/// Displays detailed planetary positions with language support.
class PlanetTable extends StatelessWidget {
  final List<PlanetPosition> planets;
  final PlanetPosition ascendant;
  final LanguageProvider lang;

  const PlanetTable({
    super.key,
    required this.planets,
    required this.ascendant,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBorderColor(isDark), width: 0.8),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        children: [
          _buildHeader(isDark, goldAccent),
          Divider(height: 0.5, color: AppColors.getBorderColor(isDark)),
          _buildRow(ascendant, isAscendant: true, isDark: isDark),
          ...planets.map((p) => _buildRow(p, isDark: isDark)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color goldAccent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(children: [
        _headerCell(lang.l('planet'), goldAccent, flex: 2),
        _headerCell(lang.l('rashi'), goldAccent, flex: 2),
        _headerCell(lang.l('degree'), goldAccent, flex: 2),
        _headerCell(lang.l('nak_pada'), goldAccent, flex: 3),
        _headerCell(lang.l('dignity'), goldAccent, flex: 2),
      ]),
    );
  }

  Widget _headerCell(String text, Color goldAccent, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: TextStyle(color: goldAccent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }

  Widget _buildRow(PlanetPosition planet, {bool isAscendant = false, required bool isDark}) {
    Color planetColor = _getPlanetColor(planet.name, isDark);
    String dignityText = _localizedDignity(planet.dignity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.getBorderColor(isDark).withValues(alpha: 0.35), width: 0.5)),
      ),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Row(children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: planetColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(lang.planet(planet.name),
                style: TextStyle(color: planetColor, fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (planet.isRetrograde) ...[
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.4), width: 0.5),
                ),
                child: Text('R', style: TextStyle(color: AppColors.accentRed, fontSize: 8.5, fontWeight: FontWeight.w800)),
              ),
            ],
            if (planet.isCombust) ...[
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C).withValues(alpha: isDark ? 0.2 : 0.14),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFFEA580C).withValues(alpha: 0.45), width: 0.5),
                ),
                child: const Text('c', style: TextStyle(color: Color(0xFFEA580C), fontSize: 8.5, fontWeight: FontWeight.w800)),
              ),
            ],
          ]),
        ),
        Expanded(flex: 2, child: Text(lang.rashi(planet.rashiIndex), style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 11))),
        Expanded(flex: 2, child: Text(planet.dmsInRashi, style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11, fontFamily: 'monospace'))),
        Expanded(flex: 3, child: Text('${lang.nakshatra(planet.nakshatraIndex)} P${planet.pada}',
          style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 10), overflow: TextOverflow.ellipsis)),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: _getDignityColor(planet.dignity).withValues(alpha: isDark ? 0.15 : 0.22),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(isAscendant ? '—' : (planet.isCombust ? '$dignityText (c)' : dignityText),
              style: TextStyle(color: _getDignityColor(planet.dignity), fontSize: 8.5, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ]),
    );
  }

  String _localizedDignity(String dignity) {
    switch (dignity) {
      case 'Exalted': return lang.l('exalted');
      case 'Debilitated': return lang.l('debilitated');
      case 'Own Sign': return lang.l('own_sign');
      case 'Friendly': return lang.l('friendly');
      case 'Enemy': return lang.l('enemy');
      case 'Neutral': return lang.l('neutral');
      default: return dignity;
    }
  }

  Color _getPlanetColor(String name, bool isDark) {
    switch (name) {
      case 'Sun': return isDark ? AppColors.sunColor : const Color(0xFFD97706);
      case 'Moon': return isDark ? AppColors.moonColor : const Color(0xFF4F46E5);
      case 'Mars': return AppColors.marsColor;
      case 'Mercury': return isDark ? AppColors.mercuryColor : const Color(0xFF059669);
      case 'Jupiter': return isDark ? AppColors.jupiterColor : const Color(0xFFB45309);
      case 'Venus': return isDark ? AppColors.venusColor : const Color(0xFFDB2777);
      case 'Saturn': return isDark ? AppColors.saturnColor : const Color(0xFF4338CA);
      case 'Rahu': return isDark ? AppColors.rahuColor : const Color(0xFF475569);
      case 'Ketu': return isDark ? AppColors.ketuColor : const Color(0xFF57534E);
      case 'Ascendant': return isDark ? AppColors.ascColor : AppColors.templeGold;
      default: return AppColors.getTextPrimary(isDark);
    }
  }

  Color _getDignityColor(String dignity) {
    switch (dignity) {
      case 'Exalted': return AppColors.accentGreen;
      case 'Own Sign': return AppColors.accentBlue;
      case 'Friendly': return AppColors.accentCyan;
      case 'Neutral': return AppColors.textMuted;
      case 'Enemy': return AppColors.accentOrange;
      case 'Debilitated': return AppColors.accentRed;
      default: return AppColors.textMuted;
    }
  }
}
