import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/constants/astro_constants.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/language_provider.dart';
import '../../data/models/panchanga_data.dart';
import '../../data/services/city_database.dart';
import '../../data/services/osm_service.dart';
import '../../data/services/panchanga_service.dart';

class PanchangaScreen extends StatefulWidget {
  const PanchangaScreen({super.key});

  @override
  State<PanchangaScreen> createState() => _PanchangaScreenState();
}

class _PanchangaScreenState extends State<PanchangaScreen> {
  DateTime _selectedDate = DateTime.now();
  String _placeName = 'Hyderabad';
  double _latitude = 17.3850;
  double _longitude = 78.4867;
  double _timezone = 5.5;

  void _previousDay() {
    setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));
  }

  void _nextDay() {
    setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
  }

  void _today() {
    setState(() => _selectedDate = DateTime.now());
  }

  Future<void> _pickDate(bool isDark) async {
    final goldAccent = AppColors.getGold(isDark);
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: goldAccent,
                  surface: AppColors.bgCard,
                  onSurface: AppColors.textPrimary,
                )
              : ColorScheme.light(
                  primary: goldAccent,
                  surface: AppColors.bgLightCard,
                  onSurface: AppColors.textLightPrimary,
                ),
        ),
        child: child!,
      ),
    );
    if (selected != null) {
      setState(() => _selectedDate = selected);
    }
  }

  void _showLocationDialog(LanguageProvider lang, bool isDark) {
    final textController = TextEditingController();
    List<CityEntry> searchResults = [];
    bool isSearching = false;
    final goldAccent = AppColors.getGold(isDark);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.getCardColor(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.l('change_location'),
                        style: TextStyle(
                          color: goldAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.getTextMuted(isDark)),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14),
                    decoration: InputDecoration(
                      hintText: lang.l('search_city'),
                      prefixIcon: Icon(Icons.search, color: goldAccent),
                      suffixIcon: isSearching
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: goldAccent,
                                ),
                              ),
                            )
                          : null,
                    ),
                    onChanged: (q) async {
                      if (q.trim().length < 2) return;
                      setModalState(() => isSearching = true);
                      final res = await OsmLocationService.searchLocation(q);
                      setModalState(() {
                        searchResults = res;
                        isSearching = false;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  if (searchResults.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        separatorBuilder: (_, __) => Divider(color: AppColors.getBorderColor(isDark), height: 1),
                        itemBuilder: (context, i) {
                          final c = searchResults[i];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            leading: Icon(Icons.location_on, color: goldAccent, size: 18),
                            title: Text(
                              c.displayName,
                              style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 13),
                            ),
                            subtitle: Text(
                              '${c.latitude.toStringAsFixed(2)}°, ${c.longitude.toStringAsFixed(2)}° (UTC+${c.timezone})',
                              style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                            ),
                            onTap: () {
                              setState(() {
                                _placeName = c.displayName.split(',').first;
                                _latitude = c.latitude;
                                _longitude = c.longitude;
                                _timezone = c.timezone;
                              });
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final goldAccent = AppColors.getGold(isDark);

    final data = PanchangaService.calculate(
      date: _selectedDate,
      latitude: _latitude,
      longitude: _longitude,
      timezone: _timezone,
      placeName: _placeName,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.l('panchanga')),
        backgroundColor: AppColors.getBackgroundColor(isDark).withValues(alpha: 0.95),
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
          IconButton(
            icon: Icon(Icons.calendar_month, color: goldAccent),
            onPressed: () => _pickDate(isDark),
          ),
          const SizedBox(width: 4),
        ],
      ),
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    children: [
                      // Date navigation header
                      _buildDateNavigator(lang, isDark, goldAccent),
                      const SizedBox(height: 12),

                      // Location chip
                      _buildLocationBar(lang, isDark, goldAccent),
                      const SizedBox(height: 16),

                      // Solar & Planetary summary card
                      _buildSolarCard(data, lang, isDark, goldAccent).animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 16),

                      // 5 Limbs (Pancha Anga)
                      Text(
                        'Pancha Anga (5 Limbs)',
                        style: TextStyle(
                          color: goldAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildLimbCard(
                        lang.l('tithi'),
                        '${data.tithi} (${data.paksha})',
                        '${data.tithiProgress.toStringAsFixed(1)}% completed',
                        Icons.brightness_3_outlined,
                        AppColors.moonColor,
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 50.ms),

                      _buildLimbCard(
                        lang.l('vara'),
                        data.vara,
                        'Solar Day',
                        Icons.wb_sunny_outlined,
                        AppColors.sunColor,
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 100.ms),

                      _buildLimbCard(
                        lang.l('nakshatra'),
                        '${data.nakshatra} (Pada ${data.nakshatraPada})',
                        'Moon in ${lang.rashi(AstroConstants.rashis.indexOf(data.moonSign))}',
                        Icons.stars_outlined,
                        AppColors.accentCyan,
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 150.ms),

                      _buildLimbCard(
                        lang.l('yoga'),
                        data.yoga,
                        '27 Solar-Lunar Yogas',
                        Icons.all_inclusive,
                        AppColors.accentPurple,
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 200.ms),

                      _buildLimbCard(
                        lang.l('karana'),
                        data.karana,
                        'Half-Tithi Period',
                        Icons.auto_awesome,
                        AppColors.accentBlue,
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 250.ms),

                      const SizedBox(height: 20),

                      // Auspicious Timings
                      Text(
                        lang.l('auspicious_timings'),
                        style: const TextStyle(
                          color: AppColors.accentGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildTimingCard(
                        lang.l('abhijit_muhurtham'),
                        data.abhijitMuhurtham,
                        Icons.check_circle_outline,
                        AppColors.accentGreen,
                        'Best period for starting all auspicious deeds',
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 300.ms),

                      _buildTimingCard(
                        lang.l('brahma_muhurtham'),
                        data.brahmaMuhurtham,
                        Icons.self_improvement,
                        AppColors.accentCyan,
                        'Ideal for meditation and spiritual practices',
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 350.ms),

                      const SizedBox(height: 20),

                      // Inauspicious Timings (Varjyam / Rahu Kalam)
                      Text(
                        lang.l('inauspicious_timings'),
                        style: const TextStyle(
                          color: AppColors.accentRed,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildTimingCard(
                        lang.l('rahu_kalam'),
                        data.rahuKalam,
                        Icons.warning_amber_rounded,
                        AppColors.accentRed,
                        'Inauspicious — avoid starting new ventures',
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 400.ms),

                      _buildTimingCard(
                        lang.l('yamagandam'),
                        data.yamagandam,
                        Icons.access_time_filled,
                        AppColors.accentOrange,
                        'Inauspicious for travel or financial deals',
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 450.ms),

                      _buildTimingCard(
                        lang.l('gulika_kalam'),
                        data.gulikaKalam,
                        Icons.hourglass_bottom,
                        goldAccent,
                        'Saturn period — suitable for repetitive works',
                        isDark,
                      ).animate().fadeIn(duration: 350.ms, delay: 500.ms),

                      const SizedBox(height: 40),
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

  Widget _buildDateNavigator(LanguageProvider lang, bool isDark, Color goldAccent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorderColor(isDark), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: goldAccent, size: 24),
            onPressed: _previousDay,
          ),
          GestureDetector(
            onTap: _today,
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                  style: TextStyle(
                    color: AppColors.getTextPrimary(isDark),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lang.l('today'),
                  style: TextStyle(
                    color: goldAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: goldAccent, size: 24),
            onPressed: _nextDay,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBar(LanguageProvider lang, bool isDark, Color goldAccent) {
    return GestureDetector(
      onTap: () => _showLocationDialog(lang, isDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.getElevatedColor(isDark),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: goldAccent.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(Icons.place, color: goldAccent, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$_placeName (${_latitude.toStringAsFixed(2)}°, ${_longitude.toStringAsFixed(2)}° • UTC+$_timezone)',
                style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.edit, color: goldAccent, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSolarCard(PanchangaData data, LanguageProvider lang, bool isDark, Color goldAccent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            goldAccent.withValues(alpha: 0.15),
            goldAccent.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _solarInfoCol(
            Icons.wb_twilight,
            lang.l('sunrise'),
            DateFormat('hh:mm a').format(data.sunrise),
            AppColors.sunColor,
            isDark,
          ),
          Container(height: 40, width: 1, color: goldAccent.withValues(alpha: 0.3)),
          _solarInfoCol(
            Icons.nightlight_round,
            lang.l('sunset'),
            DateFormat('hh:mm a').format(data.sunset),
            AppColors.moonColor,
            isDark,
          ),
          Container(height: 40, width: 1, color: goldAccent.withValues(alpha: 0.3)),
          _solarInfoCol(
            Icons.shield_moon_outlined,
            lang.l('moon_sign'),
            data.moonSign,
            AppColors.accentCyan,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _solarInfoCol(IconData icon, String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildLimbCard(
    String label,
    String value,
    String subtext,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorderColor(isDark), width: 0.6),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  subtext,
                  style: TextStyle(color: color.withValues(alpha: 0.9), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingCard(
    String title,
    (DateTime, DateTime) period,
    IconData icon,
    Color color,
    String description,
    bool isDark,
  ) {
    String startStr = DateFormat('hh:mm a').format(period.$1);
    String endStr = DateFormat('hh:mm a').format(period.$2);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.06 : 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.25 : 0.4), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Text(
                  description,
                  style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$startStr — $endStr',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
