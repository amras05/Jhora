import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/services/dasha_service.dart';

/// Interactive 5-level Vimshottari Dasha browser (Maha, Antar, Pratyantar, Sookshma, Prana).
class DashaView extends StatelessWidget {
  final List<DashaPeriod> dashas;
  final LanguageProvider lang;

  const DashaView({
    super.key,
    required this.dashas,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    if (dashas.isEmpty) {
      return Center(
        child: Text(
          'No dasha data available',
          style: TextStyle(color: AppColors.getTextMuted(isDark)),
        ),
      );
    }

    final now = DateTime.now();
    final hierarchy = DashaService.findCurrentHierarchy(dashas, now);
    final activeMaha = hierarchy.maha ?? dashas.first;
    final activeAntar = hierarchy.antar;
    final activePratyantar = hierarchy.pratyantar;
    final activeSookshma = hierarchy.sookshma;
    final activePrana = hierarchy.prana;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── Current 5-Level Dasha Highlight Card (Up to Prana Dasha) ───
            if (activeMaha.containsDate(now))
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? const [Color(0xFF2E1A08), Color(0xFF1F1005)]
                        : const [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: goldAccent, width: 1.5),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: goldAccent.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'నడుస్తున్న దశలు (మహా / అంతర / ప్రత్యంతర / సూక్ష్మ / ప్రాణ)',
                          style: TextStyle(
                            color: goldAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.getElevatedColor(isDark),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isDark ? Colors.greenAccent : AppColors.accentGreen),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.fiber_manual_record, color: isDark ? Colors.greenAccent : AppColors.accentGreen, size: 8),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: isDark ? Colors.greenAccent : AppColors.accentGreen,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
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
                        _buildDashaBadge('MD', activeMaha.planet, lang, isDark ? Colors.amberAccent : const Color(0xFFB45309), isDark),
                        if (activeAntar != null) _buildDashaBadge('AD', activeAntar.planet, lang, isDark ? Colors.orangeAccent : const Color(0xFFC2410C), isDark),
                        if (activePratyantar != null) _buildDashaBadge('PD', activePratyantar.planet, lang, isDark ? Colors.lightGreenAccent : const Color(0xFF15803D), isDark),
                        if (activeSookshma != null) _buildDashaBadge('SD', activeSookshma.planet, lang, isDark ? Colors.cyanAccent : const Color(0xFF0369A1), isDark),
                        if (activePrana != null) _buildDashaBadge('PrD', activePrana.planet, lang, isDark ? Colors.pinkAccent : const Color(0xFFBE185D), isDark),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.bgDark.withValues(alpha: 0.6) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.getBorderColor(isDark).withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          _buildDashaInfoRow('మహాదశ (MD)', activeMaha.planet, '${DateFormat("dd MMM yyyy").format(activeMaha.startDate)} → ${DateFormat("dd MMM yyyy").format(activeMaha.endDate)}', lang, isDark, goldAccent),
                          if (activeAntar != null)
                            _buildDashaInfoRow('అంతర్దశ (AD)', activeAntar.planet, '${DateFormat("dd MMM yyyy").format(activeAntar.startDate)} → ${DateFormat("dd MMM yyyy").format(activeAntar.endDate)}', lang, isDark, goldAccent),
                          if (activePratyantar != null)
                            _buildDashaInfoRow('ప్రత్యంతర (PD)', activePratyantar.planet, '${DateFormat("dd MMM yyyy").format(activePratyantar.startDate)} → ${DateFormat("dd MMM yyyy").format(activePratyantar.endDate)}', lang, isDark, goldAccent),
                          if (activeSookshma != null)
                            _buildDashaInfoRow('సూక్ష్మ దశ (SD)', activeSookshma.planet, '${DateFormat("dd MMM, hh:mm a").format(sookshmaStartDate(activeSookshma))} → ${DateFormat("dd MMM, hh:mm a").format(activeSookshma.endDate)}', lang, isDark, goldAccent),
                          if (activePrana != null)
                            _buildDashaInfoRow('ప్రాణ దశ (PrD)', activePrana.planet, '${DateFormat("dd MMM, hh:mm a").format(activePrana.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(activePrana.endDate)} (${activePrana.durationString})', lang, isDark, goldAccent, isPrana: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // ─── 5-Level Expandable Vimshottari Tree (Down to Prana Dasha) ───
            ...dashas.map((maha) {
              final isMahaActive = maha.containsDate(now);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.getElevatedColor(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isMahaActive ? goldAccent : AppColors.getBorderColor(isDark),
                    width: isMahaActive ? 1.5 : 0.8,
                  ),
                ),
                child: ExpansionTile(
                  initiallyExpanded: isMahaActive,
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isMahaActive ? goldAccent.withValues(alpha: 0.2) : AppColors.getCardLightColor(isDark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        maha.planet.substring(0, 2),
                        style: TextStyle(
                          color: isMahaActive ? goldAccent : AppColors.getTextPrimary(isDark),
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
                          color: isMahaActive ? goldAccent : AppColors.getTextPrimary(isDark),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (isMahaActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: goldAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lang.l('active'),
                            style: TextStyle(color: goldAccent, fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    '${DateFormat("dd MMM yyyy").format(maha.startDate)} → ${DateFormat("dd MMM yyyy").format(maha.endDate)} (${maha.durationString})',
                    style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11),
                  ),
                  children: (maha.subPeriods ?? []).map((antar) {
                    final isAntarActive = antar.containsDate(now);

                    return Container(
                      color: isAntarActive ? goldAccent.withValues(alpha: 0.05) : Colors.transparent,
                      child: ExpansionTile(
                        initiallyExpanded: isAntarActive,
                        tilePadding: const EdgeInsets.only(left: 24, right: 16),
                        leading: Icon(
                          Icons.subdirectory_arrow_right,
                          size: 14,
                          color: isAntarActive ? goldAccent : AppColors.getTextMuted(isDark),
                        ),
                        title: Row(
                          children: [
                            Text(
                              '${lang.planet(antar.planet)} (అంతర్దశ)',
                              style: TextStyle(
                                color: isAntarActive ? goldAccent : AppColors.getTextSecondary(isDark),
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
                                child: Text('ACTIVE', style: TextStyle(color: isDark ? Colors.greenAccent : AppColors.accentGreen, fontSize: 8, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          '${DateFormat("dd MMM yyyy").format(antar.startDate)} → ${DateFormat("dd MMM yyyy").format(antar.endDate)}',
                          style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 10),
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
                                color: isPratActive ? (isDark ? Colors.lightGreenAccent : AppColors.accentGreen) : AppColors.getTextMuted(isDark),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    '${lang.planet(pratyantar.planet)} (ప్రత్యంతర)',
                                    style: TextStyle(
                                      color: isPratActive ? (isDark ? Colors.lightGreenAccent : AppColors.accentGreen) : AppColors.getTextPrimary(isDark),
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
                                      child: Text('PD', style: TextStyle(color: isDark ? Colors.lightGreenAccent : AppColors.accentGreen, fontSize: 7.5, fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                '${DateFormat("dd MMM yyyy").format(pratyantar.startDate)} → ${DateFormat("dd MMM yyyy").format(pratyantar.endDate)}',
                                style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 9.5),
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
                                      color: isSookshmaActive ? (isDark ? Colors.cyanAccent : AppColors.accentBlue) : AppColors.getTextMuted(isDark).withValues(alpha: 0.5),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          '${lang.planet(sookshma.planet)} (సూక్ష్మ)',
                                          style: TextStyle(
                                            color: isSookshmaActive ? (isDark ? Colors.cyanAccent : AppColors.accentBlue) : AppColors.getTextSecondary(isDark),
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
                                            child: Text('SD', style: TextStyle(color: isDark ? Colors.cyanAccent : AppColors.accentBlue, fontSize: 7.5, fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${DateFormat("dd MMM, hh:mm a").format(sookshma.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(sookshma.endDate)}',
                                      style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 9),
                                    ),
                                    children: (sookshma.subPeriods ?? []).map((prana) {
                                      final isPranaActive = prana.containsDate(now);

                                      return ListTile(
                                        dense: true,
                                        contentPadding: const EdgeInsets.only(left: 72, right: 16),
                                        leading: Icon(
                                          isPranaActive ? Icons.stars : Icons.trip_origin,
                                          size: 8,
                                          color: isPranaActive ? (isDark ? Colors.pinkAccent : AppColors.accentRed) : AppColors.getTextMuted(isDark).withValues(alpha: 0.4),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              '${lang.planet(prana.planet)} (ప్రాణ దశ)',
                                              style: TextStyle(
                                                color: isPranaActive ? (isDark ? Colors.pinkAccent : AppColors.accentRed) : AppColors.getTextPrimary(isDark),
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
                                                child: Text('PRANA', style: TextStyle(color: isDark ? Colors.pinkAccent : AppColors.accentRed, fontSize: 7, fontWeight: FontWeight.w800)),
                                              ),
                                            ],
                                          ],
                                        ),
                                        subtitle: Text(
                                          '${DateFormat("dd MMM, hh:mm a").format(prana.startDate)} → ${DateFormat("dd MMM, hh:mm a").format(prana.endDate)} (${prana.durationString})',
                                          style: TextStyle(
                                            color: isPranaActive ? (isDark ? Colors.pink.shade200 : AppColors.accentRed) : AppColors.getTextMuted(isDark),
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
        ),
      ),
    );
  }

  static DateTime sookshmaStartDate(DashaPeriod p) => p.startDate;

  Widget _buildDashaBadge(String tag, String planet, LanguageProvider lang, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.6 : 0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$tag: ', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10)),
          Text(lang.planet(planet), style: TextStyle(color: isDark ? Colors.white : AppColors.textLightPrimary, fontWeight: FontWeight.w700, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDashaInfoRow(String title, String planet, String range, LanguageProvider lang, bool isDark, Color goldAccent, {bool isPrana = false}) {
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
                color: isPrana ? (isDark ? Colors.pinkAccent : AppColors.accentRed) : goldAccent,
                fontSize: 10.5,
                fontWeight: isPrana ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${lang.planet(planet)}: ',
            style: TextStyle(
              color: isPrana ? (isDark ? Colors.pinkAccent : AppColors.accentRed) : (isDark ? Colors.white : AppColors.textLightPrimary),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              range,
              style: TextStyle(
                color: isPrana ? (isDark ? Colors.pink.shade200 : AppColors.accentRed) : AppColors.getTextSecondary(isDark),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

