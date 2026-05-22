import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/curriculum_data.dart';
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

  void _showEditDialog(
      String kelas, String program, TargetHafalanModel? existing) {
    final programLabel = program == 'Reguler'
        ? t.targetHafalan.reguler
        : t.targetHafalan.takhassus;

    EditTargetDialog.show(
      context,
      kelasTitle: _getKelasTitle(kelas),
      programLabel: programLabel,
      initialSemesterAktif: existing?.semesterAktif,
      initialTahunAjaran: existing?.tahunAjaran,
      onSave: (semesterAktif, tahunAjaran) {
        final now = DateTime.now();
        final model = TargetHafalanModel(
          id: '${kelas}_$program',
          kelas: kelas,
          program: program,
          tahunAjaran: tahunAjaran,
          semesterAktif: semesterAktif,
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
              return NestedScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: 8.h),
                          AppTabSelector(
                            controller: _tabController,
                            tabs: [t.targetHafalan.reguler, t.targetHafalan.takhassus],
                          ),
                          SizedBox(height: 16.h),
                          _buildInfoBanner(colors),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildClassList(targetList, 'Reguler'),
                    _buildClassList(targetList, 'Takhassus'),
                  ],
                ),
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
                t.targetHafalan.infoTextNew,
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
        final kurikulum = CurriculumData.getKurikulum(kelas, program);
        if (kurikulum == null) return const SizedBox.shrink();

        final config = _findTarget(allTargets, kelas, program);

        return TargetKelasCard(
          kurikulum: kurikulum,
          config: config,
          onEditTap: () => _showEditDialog(kelas, program, config),
        );
      },
    );
  }
}