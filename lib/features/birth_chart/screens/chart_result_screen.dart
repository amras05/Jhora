import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/language_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../data/models/birth_data.dart';
import '../../../data/models/chart_data.dart';
import '../../../data/services/astro_engine.dart';
import '../../../data/services/dasha_service.dart';
import '../../../data/services/ashtakavarga_service.dart';
import '../../../data/services/shadbala_service.dart';
import '../../../data/services/yoga_service.dart';
import '../../../data/services/dosha_service.dart';
import '../../../data/services/transit_service.dart';
import '../../../data/services/saved_horoscope_service.dart';

import '../widgets/chart_panchanga_view.dart';
import '../widgets/divisional_charts_view.dart';
import '../widgets/planet_table.dart';
import '../widgets/bhava_spashta_table.dart';
import '../widgets/shadbala_view.dart';
import '../widgets/ashtakavarga_view.dart';
import '../widgets/dasha_view.dart';
import '../widgets/transit_view.dart';
import '../widgets/yogas_doshas_view.dart';
import '../widgets/special_points_view.dart';
import '../../report/telugu_pdf_report_screen.dart';

/// Screen coordinating and presenting Vedic Horoscope analysis tabs with responsive and dual-theme layouts.
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

  Future<void> _pickTransitDate(bool isDark) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transitDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: isDark ? AppColors.gold : AppColors.templeGold,
              onPrimary: isDark ? AppColors.bgDark : Colors.white,
              surface: AppColors.getCardColor(isDark),
              onSurface: AppColors.getTextPrimary(isDark),
              secondary: AppColors.gold,
              onSecondary: Colors.white,
              error: AppColors.accentRed,
              onError: Colors.white,
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

  Future<void> _saveHoroscope(LanguageProvider lang, bool isDark) async {
    await SavedHoroscopeService.save(widget.birthData);
    if (!mounted) return;
    setState(() => _isSaved = true);
    final goldAccent = isDark ? AppColors.gold : AppColors.templeGold;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: goldAccent, size: 18),
            const SizedBox(width: 8),
            Text(lang.l('chart_saved')),
          ],
        ),
        backgroundColor: AppColors.getCardColor(isDark),
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
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final goldAccent = isDark ? AppColors.gold : AppColors.templeGold;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.getBgGradient(isDark)),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(color: goldAccent),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      toolbarHeight: 62,
                      backgroundColor: AppColors.getBackgroundColor(isDark).withValues(alpha: 0.95),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.birthData.name.isEmpty ? lang.l('birth_chart') : widget.birthData.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.getTextPrimary(isDark),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${DateFormat("dd MMM yyyy, hh:mm a").format(widget.birthData.dateTime)} • ${widget.birthData.placeName}',
                            style: TextStyle(
                              color: AppColors.getTextMuted(isDark),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            color: goldAccent,
                            size: 20,
                          ),
                          tooltip: isDark ? 'Day Mode (పగటి వేళ)' : 'Night Mode (రాత్రి వేళ)',
                          onPressed: () => themeProvider.toggleTheme(),
                        ),
                        IconButton(
                          icon: Icon(Icons.picture_as_pdf, color: goldAccent, size: 21),
                          tooltip: 'తెలుగు జాతక రిపోర్ట్ / PDF',
                          onPressed: _openReportScreen,
                        ),
                        IconButton(
                          icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: _isSaved ? goldAccent : AppColors.getTextMuted(isDark),
                            size: 20,
                          ),
                          tooltip: lang.l('save_chart'),
                          onPressed: () => _saveHoroscope(lang, isDark),
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorColor: goldAccent,
                          indicatorWeight: 2.5,
                          labelColor: goldAccent,
                          unselectedLabelColor: AppColors.getTextMuted(isDark),
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
                  body: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Tab 1: Panchangam
                          if (_chartData != null)
                            ChartPanchangaView(chartData: _chartData!)
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 2: Charts (16 Shodashavarga Charts)
                          if (_chartData != null)
                            DivisionalChartsView(chartData: _chartData!, lang: lang)
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 3: Planets & Bhavas Table
                          if (_chartData != null)
                            SingleChildScrollView(
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
                                  BhavaSpashtaTable(chartData: _chartData!),
                                  const SizedBox(height: 24),
                                  if (_shadbala.isNotEmpty) ShadbalaView(shadbalaList: _shadbala),
                                ],
                              ),
                            )
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 4: Ashtakavarga
                          if (_ashtakavarga != null)
                            AshtakavargaView(data: _ashtakavarga!)
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 5: Dasha View
                          if (_dashas.isNotEmpty)
                            DashaView(dashas: _dashas, lang: lang)
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 6: Gochar Transit
                          if (_gochar != null)
                            TransitView(gochar: _gochar!, onSelectDate: () => _pickTransitDate(isDark))
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 7: Yogas & Doshas
                          if (_dosha != null)
                            YogasDoshasView(yogas: _yogas, dosha: _dosha!)
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),

                          // Tab 8: Yogi, Avayogi & Bhrigu Bindu
                          if (_chartData != null)
                            SpecialPointsView(chartData: _chartData!)
                          else
                            Center(child: CircularProgressIndicator(color: goldAccent)),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
