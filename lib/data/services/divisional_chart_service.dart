import '../../../core/constants/astro_constants.dart';
import '../models/chart_data.dart';
import '../models/planet_position.dart';

/// Supported Divisional Charts (Varga Charts)
enum DivisionalChartType {
  d1,
  d9,
  d10,
  d7,
  d3,
  d12,
}

/// Service providing calculation and metadata for Divisional Charts.
class DivisionalChartService {
  DivisionalChartService._();

  /// User-facing Telugu title for the divisional chart.
  static String getDivisionalTitle(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1:
        return 'D1 రాశి చక్రము';
      case DivisionalChartType.d9:
        return 'D9 నవాంశ చక్రము';
      case DivisionalChartType.d10:
        return 'D10 దశాంశ చక్రము';
      case DivisionalChartType.d7:
        return 'D7 సప్తాంశ చక్రము';
      case DivisionalChartType.d3:
        return 'D3 ద్రేక్కాణ చక్రము';
      case DivisionalChartType.d12:
        return 'D12 ద్వాదశాంశ చక్రము';
    }
  }

  /// Label for selection chips.
  static String getDivisionalChipLabel(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1:
        return 'D1 రాశి (Rasi)';
      case DivisionalChartType.d9:
        return 'D9 నవాంశ (Navamsa)';
      case DivisionalChartType.d10:
        return 'D10 దశాంశ (Career)';
      case DivisionalChartType.d7:
        return 'D7 సప్తాంశ (Children)';
      case DivisionalChartType.d3:
        return 'D3 ద్రేక్కాణ (Siblings)';
      case DivisionalChartType.d12:
        return 'D12 ద్వాదశాంశ (Parents)';
    }
  }

  /// Calculates the Ascendant (Lagna) sign index (0-11) for the given divisional chart.
  static int getLagnaForType(ChartData chartData, DivisionalChartType type) {
    final asc = chartData.ascendant;
    switch (type) {
      case DivisionalChartType.d1:
        return asc.rashiIndex;
      case DivisionalChartType.d9:
        int totalPada = (((asc.longitude % 360.0) / AstroConstants.padaSpan).floor()) % 108;
        return totalPada % 12;
      case DivisionalChartType.d10:
        int part = (asc.degreesInRashi / 3.0).floor().clamp(0, 9);
        return asc.rashiIndex % 2 == 0 ? (asc.rashiIndex + part) % 12 : ((asc.rashiIndex + 8) + part) % 12;
      case DivisionalChartType.d7:
        int part = (asc.degreesInRashi / (30.0 / 7.0)).floor().clamp(0, 6);
        return asc.rashiIndex % 2 == 0 ? (asc.rashiIndex + part) % 12 : ((asc.rashiIndex + 6) + part) % 12;
      case DivisionalChartType.d3:
        int part = (asc.degreesInRashi / 10.0).floor().clamp(0, 2);
        return (asc.rashiIndex + part * 4) % 12;
      case DivisionalChartType.d12:
        int part = (asc.degreesInRashi / 2.5).floor().clamp(0, 11);
        return (asc.rashiIndex + part) % 12;
    }
  }

  /// Maps planets into their respective sign positions (0-11) for the given divisional chart.
  static Map<int, List<PlanetPosition>> getPlacementsForType(
    ChartData chartData,
    DivisionalChartType type,
  ) {
    final map = <int, List<PlanetPosition>>{};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }

    for (final p in chartData.planets) {
      int targetSign = p.rashiIndex;
      switch (type) {
        case DivisionalChartType.d1:
          targetSign = p.rashiIndex;
          break;
        case DivisionalChartType.d9:
          targetSign = p.navamsaRashiIndex;
          break;
        case DivisionalChartType.d10:
          targetSign = p.dasamsaRashiIndex;
          break;
        case DivisionalChartType.d7:
          targetSign = p.saptamsaRashiIndex;
          break;
        case DivisionalChartType.d3:
          targetSign = p.drekkanaRashiIndex;
          break;
        case DivisionalChartType.d12:
          targetSign = p.dvadasamsaRashiIndex;
          break;
      }
      map[targetSign]?.add(p);
    }
    return map;
  }
}

