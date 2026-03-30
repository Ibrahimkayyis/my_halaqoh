import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/edit_target_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/target_kelas_card.dart';

/// Target Hafalan screen (Tab 4 & Menu Card)
class TargetHafalanScreen extends StatefulWidget {
  final bool showBackButton;

  const TargetHafalanScreen({super.key, this.showBackButton = false});

  @override
  State<TargetHafalanScreen> createState() => _TargetHafalanScreenState();
}

class _TargetHafalanScreenState extends State<TargetHafalanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data for reguler (kelas 7 SMP - 12 SMA)
  final List<Map<String, String>> _regulerData = [
    {'kelas': '7', 'title': 'Kelas 7 SMP', 'target': '2', 'juz': '30 - 29'},
    {'kelas': '8', 'title': 'Kelas 8 SMP', 'target': '2', 'juz': '1 - 2'},
    {'kelas': '9', 'title': 'Kelas 9 SMP', 'target': '2', 'juz': '3 - 4'},
    {'kelas': '10', 'title': 'Kelas 10 SMA', 'target': '2', 'juz': '5 - 6'},
    {'kelas': '11', 'title': 'Kelas 11 SMA', 'target': '2', 'juz': '7 - 8'},
    {'kelas': '12', 'title': 'Kelas 12 SMA', 'target': '2', 'juz': '9 - 10'},
  ];

  // Dummy data for takhassus (kelas 7 SMP - 12 SMA)
  final List<Map<String, String>> _takhassusData = [
    {'kelas': '7', 'title': 'Kelas 7 SMP', 'target': '5', 'juz': '1 - 5'},
    {'kelas': '8', 'title': 'Kelas 8 SMP', 'target': '5', 'juz': '6 - 10'},
    {'kelas': '9', 'title': 'Kelas 9 SMP', 'target': '5', 'juz': '11 - 15'},
    {'kelas': '10', 'title': 'Kelas 10 SMA', 'target': '5', 'juz': '16 - 20'},
    {'kelas': '11', 'title': 'Kelas 11 SMA', 'target': '5', 'juz': '21 - 25'},
    {'kelas': '12', 'title': 'Kelas 12 SMA', 'target': '5', 'juz': '26 - 30'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: widget.showBackButton,
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Text(
          t.targetHafalan.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),

          // Tab bar
          AppTabSelector(
            controller: _tabController,
            tabs: [t.targetHafalan.reguler, t.targetHafalan.takhassus],
          ),
          SizedBox(height: 16.h),

          // Info banner
          _buildInfoBanner(colors),
          SizedBox(height: 12.h),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildClassList(_regulerData),
                _buildClassList(_takhassusData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(AppColorSet colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 18.sp, color: colors.primary),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                t.targetHafalan.infoText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassList(List<Map<String, String>> data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 80.h),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return TargetKelasCard(
          kelasNumber: item['kelas']!,
          kelasTitle: item['title']!,
          targetInfo: t.targetHafalan.targetJuz(count: item['target']!),
          juzRange: t.targetHafalan.juzRange(range: item['juz']!),
          onDetailTap: () => _showEditDialog(item),
        );
      },
    );
  }

  void _showEditDialog(Map<String, String> item) {
    final juzStr = item['juz']!;
    final parts = juzStr.split(' - ');
    final Set<int> initialJuz = {};
    if (parts.length == 2) {
      final start = int.tryParse(parts[0].trim()) ?? 1;
      final end = int.tryParse(parts[1].trim()) ?? 1;
      if (start <= end) {
        for (int i = start; i <= end; i++) {
          initialJuz.add(i);
        }
      } else {
        for (int i = start; i <= 30; i++) {
          initialJuz.add(i);
        }
        for (int i = 1; i <= end; i++) {
          initialJuz.add(i);
        }
      }
    }

    final programLabel = _tabController.index == 0
        ? t.targetHafalan.reguler
        : t.targetHafalan.takhassus;

    EditTargetDialog.show(
      context,
      kelasTitle: item['title']!,
      programLabel: programLabel,
      initialSelectedJuz: initialJuz,
      onSave: (target, juzRange) {
        setState(() {
          item['target'] = target.toString();
          item['juz'] = juzRange;
        });
      },
    );
  }
}