import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../data/models/birth_data.dart';
import '../../../data/services/city_database.dart';
import '../birth_chart/screens/chart_result_screen.dart';

class PrasnaScreen extends StatefulWidget {
  const PrasnaScreen({super.key});

  @override
  State<PrasnaScreen> createState() => _PrasnaScreenState();
}

class _PrasnaScreenState extends State<PrasnaScreen> {
  final _queryController = TextEditingController();
  int _kpNumber = 1;
  CityEntry _selectedCity = CityDatabase.cities.first;

  @override
  void initState() {
    super.initState();
    final matches = CityDatabase.search('Hyderabad');
    if (matches.isNotEmpty) _selectedCity = matches.first;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _generatePrasnaChart() {
    final now = DateTime.now();
    final queryText = _queryController.text.trim();
    final title = queryText.isNotEmpty ? 'Prasna: $queryText (#$_kpNumber)' : 'Prasna Chart #$_kpNumber';

    final birthData = BirthData(
      name: title,
      dateTime: now,
      latitude: _selectedCity.latitude,
      longitude: _selectedCity.longitude,
      timezone: _selectedCity.timezone,
      placeName: _selectedCity.displayName,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChartResultScreen(birthData: birthData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final goldAccent = AppColors.getGold(isDark);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.getBgGradient(isDark)),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final maxContentWidth = isWide ? 720.0 : double.infinity;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('✦', style: TextStyle(color: goldAccent, fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'Prasna / Horary Chart',
                              style: TextStyle(
                                color: AppColors.getTextPrimary(isDark),
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
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
                            tooltip: isDark ? 'Day Mode' : 'Night Mode',
                            onPressed: () => themeProvider.toggleTheme(),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Card
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: AppColors.getCardGradient(isDark),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Instant Vedic Horary Astrology',
                                      style: TextStyle(color: goldAccent, fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Cast an instant chart for the exact moment of question with classical KP 1-249 Sub-Lord seed alignment.',
                                      style: TextStyle(
                                        color: AppColors.getTextSecondary(isDark).withValues(alpha: 0.9),
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Current Time Indicator
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.getElevatedColor(isDark),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.getBorderColor(isDark)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time_filled, color: goldAccent, size: 20),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Prasna Time (Live Moment)', style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10)),
                                        Text(
                                          DateFormat('dd MMM yyyy, hh:mm:ss a').format(now),
                                          style: TextStyle(
                                            color: AppColors.getTextPrimary(isDark),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Question / Subject
                              TextFormField(
                                controller: _queryController,
                                style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14),
                                decoration: InputDecoration(
                                  labelText: 'Question / Subject (Optional)',
                                  hintText: 'e.g. Career decision, Real estate, Travel',
                                  prefixIcon: Icon(Icons.help_outline, color: goldAccent, size: 20),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // KP Horary Number Seed Slider (1 to 249)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'KP Horary Number (1–249)',
                                    style: TextStyle(color: goldAccent, fontSize: 14, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: goldAccent.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: goldAccent),
                                    ),
                                    child: Text(
                                      '#$_kpNumber',
                                      style: TextStyle(color: goldAccent, fontSize: 14, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _kpNumber.toDouble(),
                                min: 1,
                                max: 249,
                                divisions: 248,
                                activeColor: goldAccent,
                                inactiveColor: AppColors.getElevatedColor(isDark),
                                onChanged: (val) => setState(() => _kpNumber = val.round()),
                              ),

                              const SizedBox(height: 24),

                              // Generate Button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _generatePrasnaChart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: goldAccent,
                                    foregroundColor: isDark ? AppColors.bgDark : Colors.white,
                                    elevation: isDark ? 0 : 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.auto_awesome, size: 20),
                                      SizedBox(width: 8),
                                      Text('Generate Prasna Kundali', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
