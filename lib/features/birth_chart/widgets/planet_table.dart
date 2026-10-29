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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.chartBorder, width: 0.5),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 0.5, color: AppColors.chartBorder),
          _buildRow(ascendant, isAscendant: true),
          ...planets.map((p) => _buildRow(p)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(children: [
        _headerCell(lang.l('planet'), flex: 2),
        _headerCell(lang.l('rashi'), flex: 2),
        _headerCell(lang.l('degree'), flex: 2),
        _headerCell(lang.l('nak_pada'), flex: 3),
        _headerCell(lang.l('dignity'), flex: 2),
      ]),
    );
  }

  Widget _headerCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }

  Widget _buildRow(PlanetPosition planet, {bool isAscendant = false}) {
    Color planetColor = _getPlanetColor(planet.name);
    String dignityText = _localizedDignity(planet.dignity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.chartBorder.withValues(alpha: 0.3), width: 0.5)),
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
              const SizedBox(width: 2),
              Text('R', style: TextStyle(color: AppColors.accentRed.withValues(alpha: 0.8), fontSize: 9, fontWeight: FontWeight.w700)),
            ],
          ]),
        ),
        Expanded(flex: 2, child: Text(lang.rashi(planet.rashiIndex), style: const TextStyle(color: AppColors.textPrimary, fontSize: 11))),
        Expanded(flex: 2, child: Text(planet.dmsInRashi, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'monospace'))),
        Expanded(flex: 3, child: Text('${lang.nakshatra(planet.nakshatraIndex)} P${planet.pada}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), overflow: TextOverflow.ellipsis)),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getDignityColor(planet.dignity).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(isAscendant ? '—' : dignityText,
              style: TextStyle(color: _getDignityColor(planet.dignity), fontSize: 9, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
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
