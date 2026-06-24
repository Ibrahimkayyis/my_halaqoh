import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';

/// Bottom sheet untuk memproses kenaikan kelas seluruh santri aktif.
/// Menggabungkan kenaikan kelas + pembaruan target hafalan dalam satu alur.
class KenaikanKelasBottomSheet extends StatefulWidget {
  final List<SantriModel> aktivSantri;

  const KenaikanKelasBottomSheet({
    super.key,
    required this.aktivSantri,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SantriModel> aktivSantri,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KenaikanKelasBottomSheet(aktivSantri: aktivSantri),
    );
  }

  @override
  State<KenaikanKelasBottomSheet> createState() =>
      _KenaikanKelasBottomSheetState();
}

class _KenaikanKelasBottomSheetState extends State<KenaikanKelasBottomSheet> {
  int _semesterAktif = 1;
  bool _isLoading = false;

  // Tahun awal dipilih via stepper; tahun akhir otomatis = _tahunMulai + 1
  late int _tahunMulai;

  // Statistik santri
  late final int _totalNaik;
  late final int _totalAlumni;

  static const int _minTahun = 2020;
  static const int _maxTahun = 2040;

  String get _tahunAjaranString => '$_tahunMulai / ${_tahunMulai + 1}';

  @override
  void initState() {
    super.initState();
    _totalAlumni = widget.aktivSantri.where((s) => s.kelas == '12').length;
    _totalNaik = widget.aktivSantri.length - _totalAlumni;

    // Default: tahun ajaran mendatang
    final now = DateTime.now();
    _tahunMulai = now.month >= 7 ? now.year + 1 : now.year;
  }

  Future<void> _onProses(
      BuildContext ctx, List<TargetHafalanModel> currentTargets) async {
    // Capture all context-dependent values BEFORE any async gap
    final messenger = ScaffoldMessenger.of(ctx);
    final navigator = Navigator.of(ctx);
    final cubit = ctx.read<SantriCubit>();
    final colors = AppColors.of(ctx);

    // Konfirmasi ke-2
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) {
        final dColors = AppColors.of(dialogCtx);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
          backgroundColor: dColors.surface,
          title: Row(
            children: [
              Icon(Icons.upgrade_rounded,
                  color: dColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                t.general.confirmation,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: dColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            t.santri.upgradeClassConfirmMessage(
              naikCount: _totalNaik,
              alumniCount: _totalAlumni,
              tahunAjaran: _tahunAjaranString,
            ),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              color: dColors.textSecondary,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(
                t.dialogs.batal,
                style: TextStyle(
                    fontFamily: 'Poppins', color: dColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              child: Text(
                t.general.yesProcess,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: dColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    final error = await cubit.promoteAll(
      tahunAjaran: _tahunAjaranString,
      semesterAktif: _semesterAktif,
      aktivSantri: widget.aktivSantri,
      currentTargets: currentTargets,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    navigator.pop(); // tutup bottom sheet

    if (error == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            t.santri.upgradeClassSuccessMessage(
              naikCount: _totalNaik,
              alumniCount: _totalAlumni,
            ),
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: colors.success,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content:
              Text(error, style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: colors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<TargetHafalanCubit, TargetHafalanState>(
      builder: (ctx, targetState) {
        final currentTargets = targetState.maybeWhen(
          loaded: (list) => list,
          orElse: () => <TargetHafalanModel>[],
        );

        return Container(
          padding: EdgeInsets.only(
            top: 24.h,
            left: 24.w,
            right: 24.w,
            bottom: bottomInset + 24.h,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.upgrade_rounded,
                        color: colors.primary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.santri.upgradeClassProcessTitle,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            t.santri.upgradeClassProcessSubtitle,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close,
                          color: colors.textSecondary, size: 22.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // ── Ringkasan ──────────────────────────────────────────────
                _buildSummaryCard(colors),
                SizedBox(height: 20.h),

                // ── Tahun Ajaran Picker ────────────────────────────────────
                Text(
                  t.santri.newSchoolYear,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10.h),
                _buildTahunAjaranPicker(colors),
                SizedBox(height: 20.h),

                // ── Semester Aktif ─────────────────────────────────────────
                Text(
                  t.targetHafalan.semesterAktif,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _buildSemesterChip(colors, 1, t.targetHafalan.semester1),
                    SizedBox(width: 12.w),
                    _buildSemesterChip(colors, 2, t.targetHafalan.semester2),
                  ],
                ),
                SizedBox(height: 20.h),

                // ── Warning ────────────────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: colors.error.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16.sp, color: colors.error),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          t.santri.upgradeClassWarning,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.error,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Tombol ─────────────────────────────────────────────────
                if (_isLoading)
                  Center(
                      child: CircularProgressIndicator(color: colors.primary))
                else
                  PrimaryButton(
                    width: double.infinity,
                    label: 'Proses Kenaikan Kelas',
                    icon: Icons.upgrade_rounded,
                    borderRadius: 25.r,
                    onPressed: () => _onProses(ctx, currentTargets),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Tahun Ajaran Stepper ─────────────────────────────────────────────────

  Widget _buildTahunAjaranPicker(AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol kurang
          _buildStepperButton(
            icon: Icons.remove_rounded,
            colors: colors,
            enabled: _tahunMulai > _minTahun,
            onTap: () {
              if (_tahunMulai > _minTahun) {
                setState(() => _tahunMulai--);
              }
            },
          ),

          // Tampilan tahun ajaran
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$_tahunMulai',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    ' / ',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '${_tahunMulai + 1}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                t.editTarget.tahunAjaran,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),

          // Tombol tambah
          _buildStepperButton(
            icon: Icons.add_rounded,
            colors: colors,
            enabled: _tahunMulai < _maxTahun,
            onTap: () {
              if (_tahunMulai < _maxTahun) {
                setState(() => _tahunMulai++);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required AppColorSet colors,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: enabled
              ? colors.primary
              : colors.border.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: enabled ? colors.textOnButton : colors.textSecondary,
          size: 20.sp,
        ),
      ),
    );
  }

  // ── Summary Card ─────────────────────────────────────────────────────────

  Widget _buildSummaryCard(AppColorSet colors) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.santri.upgradeClassEffectsTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: colors.primary,
              fontFamily: 'Poppins',
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            colors,
            icon: Icons.arrow_circle_up_rounded,
            iconColor: colors.primary,
            text: t.santri.upgradeClassEffectNaik(count: _totalNaik),
          ),
          if (_totalAlumni > 0) ...[
            SizedBox(height: 8.h),
            _buildSummaryRow(
              colors,
              icon: Icons.archive_outlined,
              iconColor: colors.primary,
              text:
                  t.santri.upgradeClassEffectAlumni(count: _totalAlumni),
            ),
          ],
          SizedBox(height: 8.h),
          _buildSummaryRow(
            colors,
            icon: Icons.flag_rounded,
            iconColor: colors.primary,
            text: t.santri.upgradeClassEffectTarget,
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            colors,
            icon: Icons.lock_outline_rounded,
            iconColor: Colors.green,
            text: t.santri.upgradeClassEffectDataSafe,
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            colors,
            icon: Icons.lock_outline_rounded,
            iconColor: Colors.green,
            text: t.santri.upgradeClassEffectAttendanceSafe,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    AppColorSet colors, {
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15.sp, color: iconColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ── Semester Chip ─────────────────────────────────────────────────────────

  Widget _buildSemesterChip(AppColorSet colors, int value, String label) {
    final selected = _semesterAktif == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _semesterAktif = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? colors.primary : colors.background,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                value == 1
                    ? Icons.looks_one_rounded
                    : Icons.looks_two_rounded,
                size: 16.sp,
                color: selected ? colors.textOnButton : colors.textSecondary,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? colors.textOnButton : colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
