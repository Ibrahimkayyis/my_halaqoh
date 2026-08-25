import 'dart:async';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/repositories/hafalan_santri_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Form screen for Teacher to register a santri for Tahfidz Certification Exam.
/// Features real santri dropdown, dynamic 100% completed Juz calculation from Firestore, and clean UI.
@RoutePage()
class FormPendaftaranSertifikasiScreen extends StatefulWidget {
  final SantriModel? preselectedSantri;
  final int? preselectedJuz;

  const FormPendaftaranSertifikasiScreen({
    super.key,
    this.preselectedSantri,
    this.preselectedJuz,
  });

  @override
  State<FormPendaftaranSertifikasiScreen> createState() =>
      _FormPendaftaranSertifikasiScreenState();
}

class _FormPendaftaranSertifikasiScreenState
    extends State<FormPendaftaranSertifikasiScreen> {
  final _formKey = GlobalKey<FormState>();
  SantriModel? _selectedSantri;
  int? _selectedJuz;
  bool _isSubmitting = false;

  String? _santriError;
  String? _juzError;

  // Real completed juz state
  List<int> _completedJuz = [];
  bool _isLoadingCompletedJuz = false;
  StreamSubscription? _ziyadahSubscription;

  @override
  void initState() {
    super.initState();
    _selectedSantri = widget.preselectedSantri;
    _selectedJuz = widget.preselectedJuz;

    if (_selectedSantri != null) {
      _loadCompletedJuzForSantri(_selectedSantri!.id);
    }
  }

  @override
  void dispose() {
    _ziyadahSubscription?.cancel();
    super.dispose();
  }

  void _loadCompletedJuzForSantri(String santriId) {
    setState(() {
      _isLoadingCompletedJuz = true;
      _completedJuz = [];
    });

    _ziyadahSubscription?.cancel();
    _ziyadahSubscription = sl<HafalanSantriRepository>()
        .watchAllZiyadahBySantriId(santriId)
        .listen(
      (ziyadahList) {
        final segments = ziyadahList.map((item) {
          return {
            'surah_id': item.surahId,
            'ayat_start': item.ayatMulai,
            'ayat_end': item.ayatSelesai,
          };
        }).toList();

        final progress = QuranService.instance.calculateProgress(segments);
        final completed = progress.juzProgressList
            .where((j) => j.percentage >= 100 || j.memorizedAyat >= j.totalAyat)
            .map((j) => j.juzNumber)
            .toList()
          ..sort();

        if (mounted) {
          setState(() {
            _completedJuz = completed;
            _isLoadingCompletedJuz = false;

            if (_selectedJuz != null && !completed.contains(_selectedJuz)) {
              _selectedJuz = completed.isNotEmpty ? completed.first : null;
            } else if (_selectedJuz == null && completed.isNotEmpty) {
              _selectedJuz = completed.first;
            }
          });
        }
      },
      onError: (e) {
        if (mounted) {
          setState(() {
            _isLoadingCompletedJuz = false;
            _completedJuz = [];
          });
        }
      },
    );

    sl<HafalanSantriRepository>().seedFromRemoteIfEmpty(santriId);
  }

  void _handleSubmit() async {
    setState(() {
      _santriError =
          _selectedSantri == null ? 'Silakan pilih santri yang akan diuji' : null;
      _juzError =
          _selectedJuz == null ? 'Silakan pilih juz yang akan diujikan' : null;
    });

    if (_selectedSantri == null || _selectedJuz == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate registration submission
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pendaftaran Sertifikasi Juz $_selectedJuz untuk ${_selectedSantri!.nama} berhasil diajukan.',
        ),
        backgroundColor: AppColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    context.router.maybePop();
  }

  CustomDropdownDecoration _dropdownDecoration(AppColorSet colors) {
    return CustomDropdownDecoration(
      closedBorderRadius: BorderRadius.circular(8.r),
      closedBorder: Border.all(
        color: _santriError != null ? colors.error : colors.border,
        width: 0.8,
      ),
      closedFillColor: colors.surface,
      expandedBorderRadius: BorderRadius.circular(8.r),
      expandedBorder: Border.all(color: colors.primary, width: 1.0),
      expandedFillColor: colors.surface,
      headerStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: colors.textPrimary,
        fontFamily: 'Poppins',
      ),
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textSecondary.withValues(alpha: 0.6),
        fontFamily: 'Poppins',
      ),
      listItemStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textPrimary,
        fontFamily: 'Poppins',
      ),
      searchFieldDecoration: SearchFieldDecoration(
        fillColor: colors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.border, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.primary, width: 1.0),
        ),
        hintStyle: TextStyle(
          fontSize: 12.5.sp,
          color: colors.textSecondary.withValues(alpha: 0.6),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final authState = context.watch<AuthCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;

    final currentGuruId = ActiveSessionHelper.getActiveLinkedDocId(context);

    String guruName = 'Ustadz Pengampu';
    String halaqohName = 'Halaqoh Utama';
    HalaqohModel? myHalaqoh;

    authState.maybeWhen(
      authenticated: (user) {
        guruName = user.displayName;
      },
      orElse: () {},
    );

    halaqohState.maybeWhen(
      loaded: (list) {
        if (currentGuruId != null && currentGuruId.isNotEmpty) {
          final found = list.where((h) => h.guruId == currentGuruId).toList();
          if (found.isNotEmpty) {
            myHalaqoh = found.first;
            halaqohName = myHalaqoh!.nama;
            if (myHalaqoh!.guruNama.isNotEmpty) {
              guruName = myHalaqoh!.guruNama;
            }
          } else if (list.isNotEmpty) {
            myHalaqoh = list.first;
            halaqohName = myHalaqoh!.nama;
          }
        } else if (list.isNotEmpty) {
          myHalaqoh = list.first;
          halaqohName = myHalaqoh!.nama;
        }
      },
      orElse: () {},
    );

    List<SantriModel> santriList = [];
    santriState.maybeWhen(
      loaded: (list) {
        if (myHalaqoh != null) {
          santriList = list
              .where((s) =>
                  s.halaqohId == myHalaqoh!.id ||
                  myHalaqoh!.santriIds.contains(s.id))
              .toList();
        } else {
          santriList = list;
        }
      },
      orElse: () {},
    );

    if (widget.preselectedSantri != null &&
        !santriList.any((s) => s.id == widget.preselectedSantri!.id)) {
      santriList = [widget.preselectedSantri!, ...santriList];
    }

    final santriNames = santriList.map((s) => '${s.nama} (${s.nis})').toList();
    final currentSantriDisplay = _selectedSantri != null
        ? '${_selectedSantri!.nama} (${_selectedSantri!.nis})'
        : null;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar (Uniform with detail_santri_screen) ───────
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 20.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: colors.textPrimary,
                    ),
                    onPressed: () => context.router.maybePop(),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Pendaftaran Sertifikasi',
                    style: textTheme.titleLarge?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ) ??
                        TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Form Body ─────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Field 1: Nama Santri (Searchable CustomDropdown) ──
                      _buildFieldLabel('Nama Santri', colors, textTheme),
                      SizedBox(height: 8.h),
                      if (santriList.isEmpty && widget.preselectedSantri == null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isDark ? colors.border : colors.border.withValues(alpha: 0.6),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            'Memuat data santri halaqoh...',
                            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                          ),
                        )
                      else
                        CustomDropdown<String>.search(
                          key: ValueKey(santriNames),
                          hintText: 'Cari & pilih nama santri...',
                          items: santriNames,
                          initialItem: currentSantriDisplay,
                          excludeSelected: false,
                          onChanged: (display) {
                            setState(() {
                              try {
                                _selectedSantri = santriList.firstWhere(
                                  (s) => '${s.nama} (${s.nis})' == display,
                                );
                                _santriError = null;
                                _selectedJuz = null;
                                _juzError = null;
                              } catch (_) {
                                _selectedSantri = null;
                                _selectedJuz = null;
                                _completedJuz = [];
                              }
                            });
                            if (_selectedSantri != null) {
                              _loadCompletedJuzForSantri(_selectedSantri!.id);
                            }
                          },
                          closedHeaderPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: _dropdownDecoration(colors),
                        ),

                      if (_selectedSantri != null) ...[
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'NIS: ${_selectedSantri!.nis}  •  Kelas ${_selectedSantri!.kelas} (${_selectedSantri!.program == "T" ? "Takhassus" : "Reguler"})',
                            style: textTheme.labelMedium?.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],

                      if (_santriError != null) ...[
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            _santriError!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 20.h),

                      // ── Field 2: Juz yang Diujikan (Dynamic State) ────────
                      _buildFieldLabel('Juz yang Diujikan', colors, textTheme),
                      SizedBox(height: 4.h),
                      Text(
                        'Hanya Juz yang telah 100% selesai disetorkan santri yang dapat diajukan.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildJuzSelector(colors, textTheme, isDark),

                      if (_juzError != null) ...[
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            _juzError!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 20.h),

                      // ── Field 3: Pengampu Halaqoh (Text only) ──────────────
                      _buildFieldLabel('Pengampu Halaqoh', colors, textTheme),
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Text(
                          '$guruName  •  $halaqohName',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ── Info: Prosedur Waka Tahfidz ───────────────────────
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: colors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: colors.blue.withValues(alpha: 0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 16.sp, color: colors.blue),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Pengajuan pendaftaran akan diverifikasi oleh Waka Tahfidz untuk penentuan jadwal ujian dan Ustadz Penguji.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // ── Submit Button ─────────────────────────────────────
                      PrimaryButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        isLoading: _isSubmitting,
                        label: 'Kirim Pendaftaran Sertifikasi',
                        icon: Icons.send_rounded,
                        width: double.infinity,
                        height: 46.h,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String title, AppColorSet colors, TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.titleSmall?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildJuzSelector(
    AppColorSet colors,
    TextTheme textTheme,
    bool isDark,
  ) {
    if (_selectedSantri == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDark ? colors.border : colors.border.withValues(alpha: 0.6),
            width: 0.8,
          ),
        ),
        child: Text(
          'Pilih santri terlebih dahulu untuk menampilkan daftar juz yang siap diujikan.',
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    if (_isLoadingCompletedJuz) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDark ? colors.border : colors.border.withValues(alpha: 0.6),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.primary,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Menghitung progres hafalan santri...',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_completedJuz.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: colors.warning.withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16.sp,
              color: colors.warning,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Santri ini belum memiliki riwayat juz yang terselesaikan 100%.',
                style: textTheme.bodySmall?.copyWith(color: colors.warning),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _completedJuz.map((juz) {
        final isSelected = _selectedJuz == juz;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedJuz = juz;
              _juzError = null;
            });
          },
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected ? colors.primary : colors.border,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  size: 14.sp,
                  color: isSelected ? colors.textOnButton : colors.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Juz $juz',
                  style: textTheme.titleSmall?.copyWith(
                    color: isSelected ? colors.textOnButton : colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '100%',
                    style: textTheme.labelSmall?.copyWith(
                      color: isSelected ? colors.textOnButton : colors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
