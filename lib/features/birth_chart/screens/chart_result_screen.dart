import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/astro_constants.dart';
import '../../../core/constants/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/birth_data.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/models/planet_position.dart';
import '../../../data/services/astro_engine.dart';
import '../../../data/services/dasha_service.dart';
import '../../../data/services/ashtakavarga_service.dart';
import '../../../data/services/shadbala_service.dart';
import '../../../data/services/yoga_service.dart';
import '../../../data/services/dosha_service.dart';
import '../../../data/services/transit_service.dart';
import '../../../data/services/saved_horoscope_service.dart';

import '../widgets/south_indian_chart.dart';
import '../widgets/planet_table.dart';
import '../widgets/ashtakavarga_view.dart';
import '../widgets/shadbala_view.dart';
import '../widgets/yogas_doshas_view.dart';
import '../widgets/transit_view.dart';
import '../widgets/special_points_view.dart';
import '../widgets/chart_panchanga_view.dart';
import '../../report/telugu_pdf_report_screen.dart';

enum DivisionalChartType {
  d1,
  d9,
  d10,
  d7,
  d3,
  d12,
}

class ChartResultScreen extends StatefulWidget {
  final BirthData birthData;
  const ChartResultScreen({super.key, required this.birthData});

  @override
  State<ChartResultScreen> createState() => _ChartResultScreenState();
}

class _ChartResultScreenState extends State<ChartResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ChartData? _chartData;
  List<DashaPeriod> _dashas = [];
  AshtakavargaData? _ashtakavarga;
  List<PlanetShadbala> _shadbala = [];
  List<VedicYoga> _yogas = [];
  DoshaAnalysis? _dosha;
  GocharAnalysis? _gochar;
  DateTime _transitDate = DateTime.now();

  bool _isLoading = true;
  DivisionalChartType _selectedDivisional = DivisionalChartType.d1;
  bool _showDegreesOnChart = true;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final data = await AstroEngine.calculateChartAsync(widget.birthData);
    if (!mounted) return;

    List<DashaPeriod> dashaList = DashaService.calculateMahaDasha(
      data.getPlanet('Moon')!,
      widget.birthData.dateTime,
    );

    final av = AshtakavargaService.calculate(data);
    final sb = ShadbalaService.calculate(data);
    final yg = YogaService.detectYogas(data);
    final ds = DoshaService.analyze(data);
    final gc = TransitService.calculateGochar(
      natalChart: data,
      transitDate: _transitDate,
      ashtakavarga: av,
    );

    setState(() {
      _chartData = data;
      _dashas = dashaList;
      _ashtakavarga = av;
      _shadbala = sb;
      _yogas = yg;
      _dosha = ds;
      _gochar = gc;
      _isLoading = false;
    });
  }

  Future<void> _pickTransitDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transitDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              onPrimary: AppColors.bgDark,
              surface: AppColors.bgCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && _chartData != null && _ashtakavarga != null) {
      setState(() {
        _transitDate = picked;
        _gochar = TransitService.calculateGochar(
          natalChart: _chartData!,
          transitDate: picked,
          ashtakavarga: _ashtakavarga!,
        );
      });
    }
  }

  Future<void> _saveHoroscope(LanguageProvider lang) async {
    await SavedHoroscopeService.save(widget.birthData);
    if (!mounted) return;
    setState(() => _isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Text(lang.l('chart_saved')),
          ],
        ),
        backgroundColor: AppColors.bgCard,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openReportScreen() {
    if (_chartData == null || _ashtakavarga == null || _dosha == null || _gochar == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeluguPdfReportScreen(
          chartData: _chartData!,
          ashtakavarga: _ashtakavarga!,
          shadbala: _shadbala,
          yogas: _yogas,
          dosha: _dosha!,
          dashas: _dashas,
          gochar: _gochar!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: AppColors.bgDark.withValues(alpha: 0.95),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.birthData.name.isEmpty ? lang.l('birth_chart') : widget.birthData.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            '${DateFormat("dd MMM yyyy, hh:mm a").format(widget.birthData.dateTime)} • ${widget.birthData.placeName}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf, color: AppColors.gold, size: 22),
                          tooltip: 'తెలుగు జాతక రిపోర్ట్ / PDF',
                          onPressed: _openReportScreen,
                        ),
                        IconButton(
                          icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: _isSaved ? AppColors.gold : AppColors.textMuted,
                            size: 20,
                          ),
                          tooltip: lang.l('save_chart'),
                          onPressed: () => _saveHoroscope(lang),
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorColor: AppColors.gold,
                          indicatorWeight: 2.5,
                          labelColor: AppColors.gold,
                          unselectedLabelColor: AppColors.textMuted,
                          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          tabs: const [
                            Tab(text: 'పంచాంగం (Panchangam)'),
                            Tab(text: 'చక్రాలు (Charts)'),
                            Tab(text: 'గ్రహాలు & భావాలు (Planets)'),
                            Tab(text: 'అష్టకవర్గ (Ashtakavarga)'),
                            Tab(text: 'దశలు (Dasha)'),
                            Tab(text: 'గోచారం (Transit)'),
                            Tab(text: 'యోగాలు & దోషాలు (Yogas)'),
                            Tab(text: 'యోగీ & భృగు బిందువు (Yogi & Destiny)'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Panchangam
                      if (_chartData != null)
                        ChartPanchangaView(chartData: _chartData!)
                      else
                        const Center(child: CircularProgressIndicator(color: AppColors.gold)),

                      // Tab 2: Charts
                      _buildChartsTab(lang),

                      // Tab 3: Planets & Bhavas Table
                      _buildPlanetsTab(lang),

                      // Tab 4: Ashtakavarga
                      if (_ashtakavarga != null)
                        AshtakavargaView(data: _ashtakavarga!)
                      else
                        const Center(child: CircularProgressIndicator(color: AppColors.gold)),

                      // Tab 5: Dasha View
                      _buildDashaTab(lang),

                      // Tab 6: Gochar Transit
                      if (_gochar != null)
                        TransitView(gochar: _gochar!, onSelectDate: _pickTransitDate)
                      else
                        const Center(child: CircularProgressIndicator(color: AppColors.gold)),

                      // Tab 7: Yogas & Doshas
                      if (_dosha != null)
                        YogasDoshasView(yogas: _yogas, dosha: _dosha!)
                      else
                        const Center(child: CircularProgressIndicator(color: AppColors.gold)),

                      // Tab 8: Yogi, Avayogi & Bhrigu Bindu
                      if (_chartData != null)
                        SpecialPointsView(chartData: _chartData!)
                      else
                        const Center(child: CircularProgressIndicator(color: AppColors.gold)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildChartsTab(LanguageProvider lang) {
    if (_chartData == null) return const SizedBox.shrink();

    final activePlacements = _getPlacementsForType(_selectedDivisional);
    final activeLagna = _getLagnaForType(_selectedDivisional);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Divisional Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDivChip(DivisionalChartType.d1, 'D1 రాశి (Rasi)'),
                _buildDivChip(DivisionalChartType.d9, 'D9 నవాంశ (Navamsa)'),
                _buildDivChip(DivisionalChartType.d10, 'D10 దశాంశ (Career)'),
                _buildDivChip(DivisionalChartType.d7, 'D7 సప్తాంశ (Children)'),
                _buildDivChip(DivisionalChartType.d3, 'D3 ద్రేక్కాణ (Siblings)'),
                _buildDivChip(DivisionalChartType.d12, 'D12 ద్వాదశాంశ (Parents)'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Degree toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                lang.l('show_degrees'),
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
            title: _getDivisionalTitle(_selectedDivisional),
            showDegrees: _showDegreesOnChart,
            lang: lang,
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
                  style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SouthIndianChart(
              planetsByRashi: _getPlacementsForType(DivisionalChartType.d9),
              lagnaRashi: _getLagnaForType(DivisionalChartType.d9),
              title: 'D9 నవాంశ చక్రము',
              showDegrees: false,
              lang: lang,
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

  String _getDivisionalTitle(DivisionalChartType type) {
    switch (type) {
      case DivisionalChartType.d1: return 'D1 రాశి చక్రము';
      case DivisionalChartType.d9: return 'D9 నవాంశ చక్రము';
      case DivisionalChartType.d10: return 'D10 దశాంశ చక్రము';
      case DivisionalChartType.d7: return 'D7 సప్తాంశ చక్రము';
      case DivisionalChartType.d3: return 'D3 ద్రేక్కాణ చక్రము';
      case DivisionalChartType.d12: return 'D12 ద్వాదశాంశ చక్రము';
    }
  }

  int _getLagnaForType(DivisionalChartType type) {
    if (_chartData == null) return 0;
    final asc = _chartData!.ascendant;
    switch (type) {
      case DivisionalChartType.d1: return asc.rashiIndex;
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

  Map<int, List<PlanetPosition>> _getPlacementsForType(DivisionalChartType type) {
    if (_chartData == null) return {};
    final map = <int, List<PlanetPosition>>{};
    for (int i = 0; i < 12; i++) {
      map[i] = [];
    }

    for (final p in _chartData!.planets) {
      int targetSign = p.rashiIndex;
      switch (type) {
        case DivisionalChartType.d1: targetSign = p.rashiIndex; break;
        case DivisionalChartType.d9: targetSign = p.navamsaRashiIndex; break;
        case DivisionalChartType.d10: targetSign = p.dasamsaRashiIndex; break;
        case DivisionalChartType.d7: targetSign = p.saptamsaRashiIndex; break;
        case DivisionalChartType.d3: targetSign = p.drekkanaRashiIndex; break;
        case DivisionalChartType.d12: targetSign = p.dvadasamsaRashiIndex; break;
      }
      map[targetSign]?.add(p);
    }
    return map;
  }

  Widget _buildPlanetsTab(LanguageProvider lang) {
    if (_chartData == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlanetTable(
            planets: _chartData!.planets,
            ascendant: _chartData!.ascendant,
            lang: lang,
          ),
          const SizedBox(height: 24),
          _buildBhavaSpashtaTable(),
          const SizedBox(height: 24),
          if (_shadbala.isNotEmpty) ShadbalaView(shadbalaList: _shadbala),
        ],
      ),
    );
  }

  Widget _buildBhavaSpashtaTable() {
    if (_chartData == null) return const SizedBox.shrink();
    final lagnaLon = _chartData!.ascendant.longitude;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.table_chart_outlined, color: AppColors.gold, size: 18),
            SizedBox(width: 8),
            Text(
              'భావ స్పష్ట పట్టిక (12 Houses Bhava Spashta)',
              style: TextStyle(color: AppColors.gold, fontSize: 15, fontWeight: FontWeight.w700),
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
                    Text('$hవ భావము', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('${_formatDms(startLon)} → ${_formatDms(midLon)} → ${_formatDms(endLon)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5)),
                    Text(lord, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDashaTab(LanguageProvider lang) {
    if (_dashas.isEmpty) {
      return const Center(child: Text('No dasha data available', style: TextStyle(color: AppColors.textMuted)));
    }

    final now = DateTime.now();
    final hierarchy = DashaService.findCurrentHierarchy(_dashas, now);
    final activeMaha = hierarchy.maha ?? _dashas.first;
    final activeAntar = hierarchy.antar;
    final activePratyantar = hierarchy.pratyantar;
    final activeSookshma = hierarchy.sookshma;
    final activePrana = hierarchy.prana;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ─── Current 5-Level Dasha Highlight Card (Up to Prana Dasha) ───
        if (activeMaha.containsDate(now))
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E1A08), Color(0xFF1F1005)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'నడుస్తున్న దశలు (మహా / అంతర / ప్రత్యంతర / సూక్ష్మ / ప్రాణ)',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.greenAccent),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.fiber_manual_record, color: Colors.greenAccent, size: 8),
                          SizedBox(width: 4),
                          Text('LIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildDashaBadge('MD', activeMaha.planet, lang, Colors.amberAccent),
                    if (activeAntar != null) _buildDashaBadge('AD', activeAntar.planet, lang, Colors.orangeAccent),
                    if (activePratyantar != null) _buildDashaBadge('PD', activePratyantar.planet, lang, Colors.lightGreenAccent),
                    if (activeSookshma != null) _buildDashaBadge('SD', activeSookshma.planet, lang, Colors.cyanAccent),
                    if (activePrana != null) _buildDashaBadge('PrD', activePrana.planet, lang, Colors.pinkAccent),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.bgDark.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.chartBorder.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      _buildDashaInfoRow('మహాదశ (MD)', activeMaha.planet, '${DateFormat("dd MMM yyyy").format(activeMaha.startDate)} → ${DateFormat("dd MMM yyyy").format(activeMaha.endDate)}', lang),
                      if (activeAntar != null)
                        _buildDashaInfoRow('అంతర్దశ (AD)', activeAntar.planet, '${DateFormat("dd MMM yyyy").format(activeAntar.startDate)} → ${DateFormat("dd MMM yyyy").format(activeAntar.endDate)}', lang),
                      if (activePratyantar != null)
                        _buildDashaInfoRow('ప్రత్యంతర (PD)', activePratyantar.planet, '${DateFormat("dd MMM yyyy").format(activePratyantar.startDate)} → ${DateFormat("dd MMM yyyy").format(activePratyantar.endDate)}', lang),
                      if (activeSookshma != null)
                        _buildDashaInfoRow('సూక్ష్మ దశ (SD)', activeSookshma.planet, '${DateFormat("dd MMM, hh:mm a").format(activeSookshma.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(activeSookshma.endDate)}', lang),
                      if (activePrana != null)
                        _buildDashaInfoRow('ప్రాణ దశ (PrD)', activePrana.planet, '${DateFormat("dd MMM, hh:mm a").format(activePrana.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(activePrana.endDate)} (${activePrana.durationString})', lang, isPrana: true),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 16),

        // ─── 5-Level Expandable Vimshottari Tree (Down to Prana Dasha) ───
        ..._dashas.map((maha) {
          final isMahaActive = maha.containsDate(now);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isMahaActive ? AppColors.gold : AppColors.chartBorder,
                width: isMahaActive ? 1.5 : 0.8,
              ),
            ),
            child: ExpansionTile(
              initiallyExpanded: isMahaActive,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isMahaActive ? AppColors.gold.withValues(alpha: 0.2) : AppColors.bgCardLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    maha.planet.substring(0, 2),
                    style: TextStyle(
                      color: isMahaActive ? AppColors.gold : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    '${lang.planet(maha.planet)} (మహాదశ)',
                    style: TextStyle(
                      color: isMahaActive ? AppColors.gold : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (isMahaActive) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        lang.l('active'),
                        style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Text(
                '${DateFormat("dd MMM yyyy").format(maha.startDate)} → ${DateFormat("dd MMM yyyy").format(maha.endDate)} (${maha.durationString})',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              children: (maha.subPeriods ?? []).map((antar) {
                final isAntarActive = antar.containsDate(now);

                return Container(
                  color: isAntarActive ? AppColors.gold.withValues(alpha: 0.05) : Colors.transparent,
                  child: ExpansionTile(
                    initiallyExpanded: isAntarActive,
                    tilePadding: const EdgeInsets.only(left: 24, right: 16),
                    leading: Icon(
                      Icons.subdirectory_arrow_right,
                      size: 14,
                      color: isAntarActive ? AppColors.gold : AppColors.textMuted,
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${lang.planet(antar.planet)} (అంతర్దశ)',
                          style: TextStyle(
                            color: isAntarActive ? AppColors.gold : AppColors.textSecondary,
                            fontWeight: isAntarActive ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12.5,
                          ),
                        ),
                        if (isAntarActive) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('ACTIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      '${DateFormat("dd MMM yyyy").format(antar.startDate)} → ${DateFormat("dd MMM yyyy").format(antar.endDate)}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                    ),
                    children: (antar.subPeriods ?? []).map((pratyantar) {
                      final isPratActive = pratyantar.containsDate(now);

                      return Container(
                        color: isPratActive ? Colors.green.withValues(alpha: 0.03) : Colors.transparent,
                        child: ExpansionTile(
                          initiallyExpanded: isPratActive,
                          tilePadding: const EdgeInsets.only(left: 40, right: 16),
                          leading: Icon(
                            Icons.circle,
                            size: 7,
                            color: isPratActive ? Colors.lightGreenAccent : AppColors.textMuted,
                          ),
                          title: Row(
                            children: [
                              Text(
                                '${lang.planet(pratyantar.planet)} (ప్రత్యంతర)',
                                style: TextStyle(
                                  color: isPratActive ? Colors.lightGreenAccent : AppColors.textPrimary,
                                  fontWeight: isPratActive ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 11.5,
                                ),
                              ),
                              if (isPratActive) ...[
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreen.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text('PD', style: TextStyle(color: Colors.lightGreenAccent, fontSize: 7.5, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            '${DateFormat("dd MMM yyyy").format(pratyantar.startDate)} → ${DateFormat("dd MMM yyyy").format(pratyantar.endDate)}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 9.5),
                          ),
                          children: (pratyantar.subPeriods ?? []).map((sookshma) {
                            final isSookshmaActive = sookshma.containsDate(now);

                            return Container(
                              color: isSookshmaActive ? Colors.cyan.withValues(alpha: 0.04) : Colors.transparent,
                              child: ExpansionTile(
                                initiallyExpanded: isSookshmaActive,
                                tilePadding: const EdgeInsets.only(left: 56, right: 16),
                                leading: Icon(
                                  Icons.radio_button_checked,
                                  size: 8,
                                  color: isSookshmaActive ? Colors.cyanAccent : AppColors.textMuted.withValues(alpha: 0.5),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      '${lang.planet(sookshma.planet)} (సూక్ష్మ)',
                                      style: TextStyle(
                                        color: isSookshmaActive ? Colors.cyanAccent : AppColors.textSecondary,
                                        fontWeight: isSookshmaActive ? FontWeight.w700 : FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                    if (isSookshmaActive) ...[
                                      const SizedBox(width: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                                        decoration: BoxDecoration(
                                          color: Colors.cyan.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: const Text('SD', style: TextStyle(color: Colors.cyanAccent, fontSize: 7.5, fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ],
                                ),
                                subtitle: Text(
                                  '${DateFormat("dd MMM, hh:mm a").format(sookshma.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(sookshma.endDate)}',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                                ),
                                children: (sookshma.subPeriods ?? []).map((prana) {
                                  final isPranaActive = prana.containsDate(now);

                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.only(left: 72, right: 16),
                                    leading: Icon(
                                      isPranaActive ? Icons.stars : Icons.trip_origin,
                                      size: 8,
                                      color: isPranaActive ? Colors.pinkAccent : AppColors.textMuted.withValues(alpha: 0.4),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          '${lang.planet(prana.planet)} (ప్రాణ దశ)',
                                          style: TextStyle(
                                            color: isPranaActive ? Colors.pinkAccent : AppColors.textPrimary,
                                            fontWeight: isPranaActive ? FontWeight.w800 : FontWeight.w400,
                                            fontSize: 10.5,
                                          ),
                                        ),
                                        if (isPranaActive) ...[
                                          const SizedBox(width: 5),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                                            decoration: BoxDecoration(
                                              color: Colors.pink.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: const Text('PRANA', style: TextStyle(color: Colors.pinkAccent, fontSize: 7, fontWeight: FontWeight.w800)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${DateFormat("dd MMM, hh:mm a").format(prana.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(prana.endDate)} (${prana.durationString})',
                                      style: TextStyle(
                                        color: isPranaActive ? Colors.pink.shade200 : AppColors.textMuted,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDashaBadge(String tag, String planet, LanguageProvider lang, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$tag: ', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10)),
          Text(lang.planet(planet), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDashaInfoRow(String title, String planet, String range, LanguageProvider lang, {bool isPrana = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                color: isPrana ? Colors.pinkAccent : AppColors.gold,
                fontSize: 10.5,
                fontWeight: isPrana ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${lang.planet(planet)}: ',
            style: TextStyle(
              color: isPrana ? Colors.pinkAccent : Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              range,
              style: TextStyle(
                color: isPrana ? Colors.pink.shade200 : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDms(double deg) {
    deg = deg % 360.0;
    int d = deg.floor();
    double mTotal = (deg - d) * 60.0;
    int m = mTotal.floor();
    int s = ((mTotal - m) * 60.0).round();
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    return '$d°$mStr\'$sStr"';
  }
}
