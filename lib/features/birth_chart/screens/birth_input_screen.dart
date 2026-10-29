import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/models/birth_data.dart';
import '../../../data/services/city_database.dart';
import '../../../data/services/osm_service.dart';
import 'chart_result_screen.dart';

/// Birth data input screen with 100% Offline Worldwide City Search & Open-Meteo fallback.
class BirthInputScreen extends StatefulWidget {
  const BirthInputScreen({super.key});

  @override
  State<BirthInputScreen> createState() => _BirthInputScreenState();
}

class _BirthInputScreenState extends State<BirthInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController(text: 'Hyderabad');
  final _latController = TextEditingController(text: '17.3850');
  final _lonController = TextEditingController(text: '78.4867');
  final _tzController = TextEditingController(text: '5.5');

  DateTime _selectedDate = DateTime(1990, 1, 1);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 6, minute: 0);
  List<CityEntry> _cityResults = [];
  bool _showCityResults = false;
  bool _isSearching = false;
  Timer? _debounceTimer;

  static const List<String> _popularCityNames = [
    'Hyderabad', 'Bengaluru', 'Chennai', 'Mumbai', 'New Delhi',
    'Tirupati', 'Vijayawada', 'Visakhapatnam', 'Kolkata', 'London', 'New York'
  ];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nameController.dispose();
    _cityController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _tzController.dispose();
    super.dispose();
  }

  void _onCityChanged(String query) {
    _debounceTimer?.cancel();
    final clean = query.trim();
    if (clean.isEmpty) {
      setState(() {
        _cityResults = [];
        _showCityResults = false;
        _isSearching = false;
      });
      return;
    }

    // Instant offline local match (0ms latency)
    final instantMatches = CityDatabase.search(clean);
    setState(() {
      _cityResults = instantMatches;
      _showCityResults = instantMatches.isNotEmpty;
      _isSearching = false;
    });

    // If an exact or single strong local match is found, auto-sync coordinates
    if (instantMatches.isNotEmpty) {
      final qLower = clean.toLowerCase();
      final first = instantMatches.first;
      final exactMatch = first.name.toLowerCase() == qLower ||
          first.aliases.any((a) => a.toLowerCase() == qLower);
      if (exactMatch) {
        _latController.text = first.latitude.toStringAsFixed(4);
        _lonController.text = first.longitude.toStringAsFixed(4);
        _tzController.text = first.timezone.toString();
      }
    }

    // Optional background fallback only if local match has zero results
    if (instantMatches.isEmpty && clean.length >= 2) {
      setState(() => _isSearching = true);
      _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
        final results = await OsmLocationService.searchLocation(clean);
        if (!mounted) return;
        setState(() {
          _cityResults = results;
          _showCityResults = results.isNotEmpty;
          _isSearching = false;
        });
      });
    }
  }

  void _selectCity(CityEntry city) {
    setState(() {
      _cityController.text = city.displayName;
      _latController.text = city.latitude.toStringAsFixed(4);
      _lonController.text = city.longitude.toStringAsFixed(4);
      _tzController.text = city.timezone.toString();
      _showCityResults = false;
      _cityResults = [];
    });
    FocusScope.of(context).unfocus();
  }

  void _selectPopularCity(String cityName) {
    final matches = CityDatabase.search(cityName);
    if (matches.isNotEmpty) {
      _selectCity(matches.first);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
    if (time != null) setState(() => _selectedTime = time);
  }

  void _generateChart() {
    if (!_formKey.currentState!.validate()) return;

    final placeText = _cityController.text.trim();
    // If user typed a location and coordinates are still default Hyderabad, auto-fill from matched city
    if (placeText.isNotEmpty) {
      final matches = CityDatabase.search(placeText);
      if (matches.isNotEmpty) {
        final match = matches.first;
        if (_latController.text == '17.3850' && _lonController.text == '78.4867' && !placeText.toLowerCase().contains('hyderabad')) {
          _latController.text = match.latitude.toStringAsFixed(4);
          _lonController.text = match.longitude.toStringAsFixed(4);
          _tzController.text = match.timezone.toString();
        }
      }
    }

    double lat = double.tryParse(_latController.text) ?? 0.0;
    double lon = double.tryParse(_lonController.text) ?? 0.0;
    double tz = double.tryParse(_tzController.text) ?? 5.5;

    String placeName = placeText;
    if (placeName.isEmpty) {
      placeName = '${lat.toStringAsFixed(2)}°, ${lon.toStringAsFixed(2)}°';
    }

    final birthData = BirthData(
      name: _nameController.text.trim(),
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      latitude: lat,
      longitude: lon,
      timezone: tz,
      placeName: placeName,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChartResultScreen(birthData: birthData),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      lang.l('new_horoscope'),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Personal Details ───
                        _buildSectionHeader(lang.l('personal_details'), Icons.person_outline),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _nameController,
                          label: lang.l('full_name'),
                          hint: lang.l('enter_name'),
                          icon: Icons.person,
                          validator: (v) => v == null || v.trim().isEmpty ? lang.l('enter_name') : null,
                        ),

                        const SizedBox(height: 24),

                        // ─── Date & Time ───
                        _buildSectionHeader(lang.l('birth_date_time'), Icons.calendar_month),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildDatePicker(lang)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTimePicker(lang)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ─── Birth Place (Offline City Search) ───
                        _buildSectionHeader(lang.l('birth_place'), Icons.location_on_outlined),
                        const SizedBox(height: 8),

                        // Popular Quick City Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _popularCityNames.map((city) {
                              bool isSelected = _cityController.text.startsWith(city);
                              return Padding(
                                padding: const EdgeInsets.only(right: 6, bottom: 8),
                                child: ActionChip(
                                  label: Text(city),
                                  labelStyle: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? AppColors.gold : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  backgroundColor: isSelected
                                      ? AppColors.gold.withValues(alpha: 0.2)
                                      : AppColors.bgElevated,
                                  side: BorderSide(
                                    color: isSelected ? AppColors.gold : AppColors.chartBorder,
                                    width: 0.8,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                  onPressed: () => _selectPopularCity(city),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // City search input
                        TextFormField(
                          controller: _cityController,
                          onChanged: _onCityChanged,
                          onTap: () {
                            if (_cityController.text.isNotEmpty) {
                              _onCityChanged(_cityController.text);
                            }
                          },
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            labelText: lang.l('birth_city'),
                            hintText: lang.l('search_city'),
                            prefixIcon: const Icon(Icons.location_city, color: AppColors.gold, size: 20),
                            suffixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                                      ),
                                    ),
                                  )
                                : _cityController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                                        onPressed: () {
                                          _cityController.clear();
                                          setState(() {
                                            _showCityResults = false;
                                            _cityResults = [];
                                          });
                                        },
                                      )
                                    : null,
                          ),
                        ),

                        // City suggestions dropdown
                        if (_showCityResults && _cityResults.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            constraints: const BoxConstraints(maxHeight: 250),
                            decoration: BoxDecoration(
                              color: AppColors.bgElevated,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: _cityResults.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(color: AppColors.chartBorder, height: 1),
                              itemBuilder: (context, idx) {
                                final city = _cityResults[idx];
                                return ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                                  leading: const Icon(Icons.location_on, color: AppColors.gold, size: 20),
                                  title: Text(
                                    city.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${city.state.isNotEmpty ? "${city.state}, " : ""}${city.country} • ${city.latitude.toStringAsFixed(4)}°, ${city.longitude.toStringAsFixed(4)}° (UTC+${city.timezone})',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                  ),
                                  trailing: const Icon(Icons.chevron_right, color: AppColors.gold, size: 16),
                                  onTap: () => _selectCity(city),
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 24),

                        // ─── Coordinates ───
                        _buildSectionHeader(lang.l('coordinates'), Icons.my_location),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _latController,
                                label: lang.l('latitude'),
                                hint: '17.3850',
                                icon: Icons.north,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  double? val = double.tryParse(v);
                                  if (val == null || val < -90 || val > 90) return 'Invalid (-90 to 90)';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _lonController,
                                label: lang.l('longitude'),
                                hint: '78.4867',
                                icon: Icons.east,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  double? val = double.tryParse(v);
                                  if (val == null || val < -180 || val > 180) return 'Invalid (-180 to 180)';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _tzController,
                          label: lang.l('timezone'),
                          hint: '5.5',
                          icon: Icons.schedule,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            double? val = double.tryParse(v);
                            if (val == null || val < -12 || val > 14) return 'Invalid (-12 to 14)';
                            return null;
                          },
                        ),

                        const SizedBox(height: 36),

                        // ─── Generate Button ───
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _generateChart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.bgDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  lang.l('generate'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textMuted, size: 20) : null,
      ),
    );
  }

  Widget _buildDatePicker(LanguageProvider lang) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.chartBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.l('date'),
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(_selectedDate),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(LanguageProvider lang) {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.chartBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.l('time'),
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
