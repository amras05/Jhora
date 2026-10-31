import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/language_provider.dart';
import '../../core/constants/language.dart';
import '../birth_chart/screens/birth_input_screen.dart';
import '../panchanga/panchanga_screen.dart';
import '../saved_horoscopes/saved_horoscopes_screen.dart';
import '../prasna/prasna_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final goldAccent = isDark ? AppColors.gold : AppColors.templeGold;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBgGradient(isDark),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                // Top Bar with Brand Badge, Theme Switcher & Language Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: goldAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: goldAccent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.stars, color: goldAccent, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'JAGANNATHA HORA MOBILE',
                            style: TextStyle(
                              color: goldAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        // Day / Night Theme Mode Switcher
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            color: goldAccent,
                            size: 20,
                          ),
                          tooltip: isDark ? 'Day Mode (పగటి వేళ)' : 'Night Mode (రాత్రి వేళ)',
                          onPressed: () => themeProvider.toggleTheme(),
                        ),

                        // Language Selector Dropdown
                        PopupMenuButton<AppLanguage>(
                          initialValue: lang.currentLanguage,
                          icon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.getElevatedColor(isDark),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.getBorderColor(isDark)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.language, color: goldAccent, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  lang.currentLanguage == AppLanguage.telugu ? 'తెలుగు' : 'EN',
                                  style: TextStyle(
                                    color: AppColors.getTextPrimary(isDark),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          color: AppColors.getElevatedColor(isDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.getBorderColor(isDark)),
                          ),
                          onSelected: (AppLanguage selected) {
                            lang.setLanguage(selected);
                          },
                          itemBuilder: (context) => [
                            for (final entry in AppStrings.languageNames.entries)
                              PopupMenuItem(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    if (lang.currentLanguage == entry.key)
                                      Icon(Icons.check, color: goldAccent, size: 16)
                                    else
                                      const SizedBox(width: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        color: lang.currentLanguage == entry.key
                                            ? goldAccent
                                            : AppColors.getTextPrimary(isDark),
                                        fontWeight: lang.currentLanguage == entry.key
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Hero Logo & Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              goldAccent.withValues(alpha: 0.25),
                              goldAccent.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: goldAccent.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text('☉', style: TextStyle(fontSize: 34, color: goldAccent)),
                        ),
                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                      const SizedBox(height: 12),
                      Text(
                        lang.l('app_name'),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.getTextPrimary(isDark),
                              letterSpacing: 2,
                              fontWeight: FontWeight.w800,
                            ),
                      ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                      const SizedBox(height: 2),
                      Text(
                        lang.l('vedic_astrology'),
                        style: TextStyle(
                          color: goldAccent.withValues(alpha: 0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Responsive Feature Cards (Adaptive Column on phones, Adaptive Grid on tablets/foldables)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isTablet = constraints.maxWidth >= 600;

                      final cards = [
                        _buildFeatureCard(
                          context,
                          lang,
                          isDark,
                          goldAccent,
                          icon: Icons.auto_awesome,
                          titleKey: 'birth_chart',
                          subtitleKey: 'birth_chart_desc',
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const BirthInputScreen(),
                              transitionsBuilder: (_, anim, __, child) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.03, 0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideX(begin: 0.05),

                        _buildFeatureCard(
                          context,
                          lang,
                          isDark,
                          goldAccent,
                          icon: Icons.calendar_month,
                          titleKey: 'panchanga',
                          subtitleKey: 'panchanga_desc',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PanchangaScreen()),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 600.ms).slideX(begin: 0.05),

                        _buildFeatureCard(
                          context,
                          lang,
                          isDark,
                          goldAccent,
                          icon: Icons.question_answer_outlined,
                          titleKey: 'Prasna / Horary Chart (ప్రశ్న శాస్త్రం)',
                          subtitleKey: 'Instant chart for current moment with 1–249 KP Seed',
                          isDirectString: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrasnaScreen()),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 700.ms).slideX(begin: 0.05),

                        _buildFeatureCard(
                          context,
                          lang,
                          isDark,
                          goldAccent,
                          icon: Icons.bookmarks,
                          titleKey: 'saved_charts',
                          subtitleKey: 'saved_charts_desc',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SavedHoroscopesScreen()),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 800.ms).slideX(begin: 0.05),
                      ];

                      if (isTablet) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 2.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: cards,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: cards.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) => cards[index],
                      );
                    },
                  ),
                ),

                Center(
                  child: Text(
                    'Swiss Ephemeris Precision • 16 Shodashavargas • v1.0.0',
                    style: TextStyle(
                      color: AppColors.getTextMuted(isDark).withValues(alpha: 0.5),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    LanguageProvider lang,
    bool isDark,
    Color goldAccent, {
    required IconData icon,
    required String titleKey,
    required String subtitleKey,
    required VoidCallback onTap,
    bool isDirectString = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.getCardGradient(isDark),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: goldAccent.withValues(alpha: isDark ? 0.25 : 0.35),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: goldAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: goldAccent,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isDirectString ? titleKey : lang.l(titleKey),
                    style: TextStyle(
                      color: AppColors.getTextPrimary(isDark),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDirectString ? subtitleKey : lang.l(subtitleKey),
                    style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: goldAccent,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
