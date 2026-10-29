import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Prasna / Horary Chart', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  ],
                ),
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
                          gradient: AppColors.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instant Vedic Horary Astrology',
                              style: TextStyle(color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cast an instant chart for the exact moment of question with classical KP 1-249 Sub-Lord seed alignment.',
                              style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.9), fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Current Time Indicator
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.chartBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_filled, color: AppColors.gold, size: 20),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Prasna Time (Live Moment)', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm:ss a').format(now),
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
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
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: 'Question / Subject (Optional)',
                          hintText: 'e.g. Career decision, Real estate, Travel',
                          prefixIcon: Icon(Icons.help_outline, color: AppColors.gold, size: 20),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // KP Horary Number Seed Slider (1 to 249)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('KP Horary Number (1–249)', style: TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w700)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.gold),
                            ),
                            child: Text(
                              '#$_kpNumber',
                              style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _kpNumber.toDouble(),
                        min: 1,
                        max: 249,
                        divisions: 248,
                        activeColor: AppColors.gold,
                        inactiveColor: AppColors.bgElevated,
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
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.bgDark,
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
      ),
    );
  }
}
