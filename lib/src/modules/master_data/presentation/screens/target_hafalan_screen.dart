import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';
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

  final List<String> _kelasLevels = ['7', '8', '9', '10', '11', '12'];

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

  String _getKelasTitle(String kelas) {
    final jenjang = int.parse(kelas) <= 9 ? 'SMP' : 'SMA';
    return 'Kelas $kelas $jenjang';
  }

  TargetHafalanModel? _findTarget(
      List<TargetHafalanModel> targets, String kelas, String program) {
    try {
      return targets.firstWhere(
        (t) => t.kelas == kelas && t.program == program,
      );
    } catch (_) {
      return null;
    }
  }

  /// Format juz list into smart range groups: e.g. [1,2,3,29,30] → "Juz 1-3, 29-30"
  String _formatJuzRange(List<int> juzList) {
    if (juzList.isEmpty) return '-';
    final sorted = List<int>.from(juzList)..sort();

    final List<String> groups = [];
    int start = sorted.first;
    int end = sorted.first;

    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == end + 1) {
        end = sorted[i];
      } else {
        groups.add(start == end ? '$start' : '$start-$end');
        start = sorted[i];
        end = sorted[i];
      }
    }
    groups.add(start == end ? '$start' : '$start-$end');

    return 'Juz ${groups.join(', ')}';
  }

  void _showEditDialog(
      String kelas, String program, TargetHafalanModel? existing) {
    final programLabel = program == 'Reguler'
        ? t.targetHafalan.reguler
        : t.targetHafalan.takhassus;

    final initialJuz = existing != null ? existing.juzList.toSet() : <int>{};

    EditTargetDialog.show(
      context,
      kelasTitle: _getKelasTitle(kelas),
      programLabel: programLabel,
      initialSelectedJuz: initialJuz,
      initialTahunAjaran: existing?.tahunAjaran,
      onSave: (target, juzRange, tahunAjaran) {
        // Parse juz range string back to list of ints
        // Format from dialog: "Juz 1-3, 29-30" or "Juz 5" or "-" (reset)
        final List<int> juzList = [];
        if (target > 0 && juzRange != '-') {
          final cleaned = juzRange.replaceAll('Juz ', '');
          for (final part in cleaned.split(', ')) {
            if (part.contains('-')) {
              final rangeParts = part.split('-');
              final s = int.tryParse(rangeParts[0].trim()) ?? 0;
              final e = int.tryParse(rangeParts[1].trim()) ?? 0;
              if (s > 0 && e > 0) {
                for (int i = s; i <= e; i++) {
                  juzList.add(i);
                }
              }
            } else {
              final n = int.tryParse(part.trim());
              if (n != null && n > 0) juzList.add(n);
            }
          }
        }

        final now = DateTime.now();
        final model = TargetHafalanModel(
          id: '${kelas}_$program',
          kelas: kelas,
          program: program,
          targetJuz: target,
          juzList: juzList,
          tahunAjaran: tahunAjaran,
          createdAt: existing?.createdAt ?? now,
          updatedAt: now,
        );
        context.read<TargetHafalanCubit>().saveTarget(model);
      },
    );
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
      body: BlocBuilder<TargetHafalanCubit, TargetHafalanState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Text(message,
                  style: TextStyle(color: colors.error, fontFamily: 'Poppins')),
            ),
            loaded: (targetList) {
              return Column(
                children: [
                  SizedBox(height: 8.h),
                  AppTabSelector(
                    controller: _tabController,
                    tabs: [t.targetHafalan.reguler, t.targetHafalan.takhassus],
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoBanner(colors),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildClassList(targetList, 'Reguler'),
                        _buildClassList(targetList, 'Takhassus'),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
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

  Widget _buildClassList(
      List<TargetHafalanModel> allTargets, String program) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 80.h),
      itemCount: _kelasLevels.length,
      itemBuilder: (context, index) {
        final kelas = _kelasLevels[index];
        final target = _findTarget(allTargets, kelas, program);
        final targetCount = target?.targetJuz.toString() ?? '0';
        final isReset = target != null && target.targetJuz == 0;
        final juzRange = target != null && target.juzList.isNotEmpty
            ? _formatJuzRange(target.juzList)
            : isReset ? 'Belum ditetapkan' : '-';

        return TargetKelasCard(
          kelasNumber: kelas,
          kelasTitle: _getKelasTitle(kelas),
          targetInfo: t.targetHafalan.targetJuz(count: targetCount),
          juzRange: juzRange,
          tahunAjaran: target?.tahunAjaran,
          isReset: isReset,
          onDetailTap: () => _showEditDialog(kelas, program, target),
        );
      },
    );
  }
}