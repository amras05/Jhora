import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/language_provider.dart';
import '../../data/models/birth_data.dart';
import '../../data/services/saved_horoscope_service.dart';
import '../birth_chart/screens/chart_result_screen.dart';
import '../birth_chart/screens/birth_input_screen.dart';

class SavedHoroscopesScreen extends StatefulWidget {
  const SavedHoroscopesScreen({super.key});

  @override
  State<SavedHoroscopesScreen> createState() => _SavedHoroscopesScreenState();
}

class _SavedHoroscopesScreenState extends State<SavedHoroscopesScreen> {
  late Future<List<BirthData>> _profilesFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _profilesFuture = SavedHoroscopeService.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final goldAccent = AppColors.getGold(isDark);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.l('saved_charts')),
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
            icon: Icon(Icons.add, color: goldAccent),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BirthInputScreen()),
              );
              _reload();
            },
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
                  child: FutureBuilder<List<BirthData>>(
                    future: _profilesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: goldAccent));
                      }

                      final allProfiles = snapshot.data ?? [];
                      final profiles = _searchQuery.isEmpty
                          ? allProfiles
                          : allProfiles.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                      if (allProfiles.isEmpty) {
                        return _buildEmptyState(lang, isDark, goldAccent);
                      }

                      return Column(
                        children: [
                          if (allProfiles.length > 4)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: TextField(
                                style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Search saved profiles...',
                                  prefixIcon: Icon(Icons.search, color: goldAccent, size: 20),
                                  fillColor: AppColors.getCardColor(isDark),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.getBorderColor(isDark)),
                                  ),
                                ),
                                onChanged: (q) => setState(() => _searchQuery = q.trim()),
                              ),
                            ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: profiles.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final birth = profiles[index];
                                return _buildProfileCard(birth, lang, index, isDark, goldAccent);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(LanguageProvider lang, bool isDark, Color goldAccent) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: goldAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.bookmark_border, color: goldAccent, size: 38),
            ),
            const SizedBox(height: 20),
            Text(
              lang.l('saved_charts'),
              style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'No horoscopes saved yet. Create a birth chart and tap the save icon to access it anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BirthInputScreen()),
                );
                _reload();
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(lang.l('new_horoscope')),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldAccent,
                foregroundColor: isDark ? AppColors.bgDark : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProfileCard(BirthData birth, LanguageProvider lang, int index, bool isDark, Color goldAccent) {
    return Dismissible(
      key: ValueKey('${birth.name}_${birth.dateTime}_${birth.latitude}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.accentRed.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      onDismissed: (_) async {
        await SavedHoroscopeService.remove(birth);
        _reload();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${birth.name} deleted'),
            backgroundColor: AppColors.getCardColor(isDark),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChartResultScreen(birthData: birth),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.getCardColor(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.getBorderColor(isDark), width: 0.8),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      goldAccent.withValues(alpha: 0.25),
                      goldAccent.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
                ),
                child: Center(
                  child: Text(
                    birth.name.isNotEmpty ? birth.name.substring(0, 1).toUpperCase() : '☉',
                    style: TextStyle(
                      color: goldAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      birth.name.isEmpty ? 'Unnamed Horoscope' : birth.name,
                      style: TextStyle(
                        color: AppColors.getTextPrimary(isDark),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${DateFormat('dd MMM yyyy, hh:mm a').format(birth.dateTime)} • ${birth.placeName}',
                      style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: goldAccent, size: 20),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 40 * index));
  }
}
