import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/language_provider.dart';
import '../../../data/services/kp_service.dart';

class KPView extends StatefulWidget {
  final KPAnalysis kpData;
  const KPView({super.key, required this.kpData});

  @override
  State<KPView> createState() => _KPViewState();
}

class _KPViewState extends State<KPView> {
  int _selectedSubTab = 0; // 0: Planets, 1: Cusps, 2: Significators

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldAccent = AppColors.getGold(isDark);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sub-Tab Switcher
              Row(
                children: [
                  _buildTabButton(0, 'Planets (గ్రహాలు)', isDark, goldAccent),
                  const SizedBox(width: 8),
                  _buildTabButton(1, 'Cusps (భావాలు)', isDark, goldAccent),
                  const SizedBox(width: 8),
                  _buildTabButton(2, 'Significators (కారకులు)', isDark, goldAccent),
                ],
              ),

              const SizedBox(height: 16),

              if (_selectedSubTab == 0) ...[
                _buildSubLordTable(widget.kpData.planetSubLords, lang, isDark, goldAccent),
              ] else if (_selectedSubTab == 1) ...[
                _buildSubLordTable(widget.kpData.cuspSubLords, lang, isDark, goldAccent),
              ] else ...[
                _buildSignificatorsTable(widget.kpData.significators, lang, isDark, goldAccent),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, bool isDark, Color goldAccent) {
    final isSelected = _selectedSubTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSubTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? goldAccent : AppColors.getElevatedColor(isDark),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? goldAccent : AppColors.getBorderColor(isDark),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? (isDark ? AppColors.bgDark : Colors.white) : AppColors.getTextSecondary(isDark),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubLordTable(List<KPSubLord> items, LanguageProvider lang, bool isDark, Color goldAccent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorderColor(isDark)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.all(goldAccent.withValues(alpha: 0.12)),
            columns: [
              DataColumn(label: Text('Entity', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Sign', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Sign Lord', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Star (Nak)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Star Lord', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Sub Lord (SL)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w800, fontSize: 11))),
              DataColumn(label: Text('Sub-Sub (SSL)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
            ],
            rows: items.map((item) {
              final isAsc = item.entityName == 'Ascendant';
              return DataRow(
                color: isAsc ? WidgetStateProperty.all(goldAccent.withValues(alpha: 0.05)) : null,
                cells: [
                  DataCell(Text(item.entityName, style: TextStyle(color: AppColors.getTextPrimary(isDark), fontWeight: FontWeight.w700, fontSize: 12))),
                  DataCell(Text(item.signName, style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11))),
                  DataCell(Text(item.signLord, style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11))),
                  DataCell(Text(item.starName, style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11))),
                  DataCell(Text(item.starLord, style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: goldAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item.subLord, style: TextStyle(color: goldAccent, fontWeight: FontWeight.w800, fontSize: 11)),
                    ),
                  ),
                  DataCell(Text(item.subSubLord, style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSignificatorsTable(List<KPHouseSignificator> significators, LanguageProvider lang, bool isDark, Color goldAccent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getElevatedColor(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.getBorderColor(isDark)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 18,
            headingRowColor: WidgetStateProperty.all(goldAccent.withValues(alpha: 0.12)),
            columns: [
              DataColumn(label: Text('House', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Level A (Star of Occ)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Level B (Occupant)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Level C (Star of Lord)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
              DataColumn(label: Text('Level D (House Lord)', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 11))),
            ],
            rows: significators.map((s) {
              return DataRow(
                cells: [
                  DataCell(Text('House ${s.houseNumber}', style: TextStyle(color: goldAccent, fontWeight: FontWeight.w700, fontSize: 12))),
                  DataCell(Text(s.levelA.isEmpty ? '-' : s.levelA.join(', '), style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 11))),
                  DataCell(Text(s.levelB.isEmpty ? '-' : s.levelB.join(', '), style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 11))),
                  DataCell(Text(s.levelC.isEmpty ? '-' : s.levelC.join(', '), style: TextStyle(color: AppColors.getTextMuted(isDark), fontSize: 11))),
                  DataCell(Text(s.levelD.join(', '), style: TextStyle(color: AppColors.getTextSecondary(isDark), fontWeight: FontWeight.w600, fontSize: 11))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
