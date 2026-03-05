import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Juz data model for the list
class _JuzInfo {
  final int juz;
  final int suratCount;

  const _JuzInfo({required this.juz, required this.suratCount});
}

/// Progress Hafalan Per Juz — shows juz-level progress cards for a santri
@RoutePage()
class ProgressHafalanPerJuzScreen extends StatefulWidget {
  final String name;
  final String nis;

  const ProgressHafalanPerJuzScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<ProgressHafalanPerJuzScreen> createState() =>
      _ProgressHafalanPerJuzScreenState();
}

class _ProgressHafalanPerJuzScreenState
    extends State<ProgressHafalanPerJuzScreen> {
  // Juz data: juz number, total surahs, completed surahs (dummy)
  final List<Map<String, dynamic>> _juzData = [
    {'juz': 30, 'total': 37, 'completed': 37},
    {'juz': 29, 'total': 11, 'completed': 11},
    {'juz': 28, 'total': 9, 'completed': 9},
  ];

  // All 30 juz with approximate surah counts
  static const List<_JuzInfo> _allJuz = [
    _JuzInfo(juz: 1, suratCount: 2),
    _JuzInfo(juz: 2, suratCount: 1),
    _JuzInfo(juz: 3, suratCount: 2),
    _JuzInfo(juz: 4, suratCount: 2),
    _JuzInfo(juz: 5, suratCount: 2),
    _JuzInfo(juz: 6, suratCount: 2),
    _JuzInfo(juz: 7, suratCount: 1),
    _JuzInfo(juz: 8, suratCount: 2),
    _JuzInfo(juz: 9, suratCount: 1),
    _JuzInfo(juz: 10, suratCount: 2),
    _JuzInfo(juz: 11, suratCount: 2),
    _JuzInfo(juz: 12, suratCount: 2),
    _JuzInfo(juz: 13, suratCount: 2),
    _JuzInfo(juz: 14, suratCount: 2),
    _JuzInfo(juz: 15, suratCount: 1),
    _JuzInfo(juz: 16, suratCount: 2),
    _JuzInfo(juz: 17, suratCount: 2),
    _JuzInfo(juz: 18, suratCount: 2),
    _JuzInfo(juz: 19, suratCount: 3),
    _JuzInfo(juz: 20, suratCount: 2),
    _JuzInfo(juz: 21, suratCount: 2),
    _JuzInfo(juz: 22, suratCount: 2),
    _JuzInfo(juz: 23, suratCount: 3),
    _JuzInfo(juz: 24, suratCount: 3),
    _JuzInfo(juz: 25, suratCount: 2),
    _JuzInfo(juz: 26, suratCount: 3),
    _JuzInfo(juz: 27, suratCount: 3),
    _JuzInfo(juz: 28, suratCount: 9),
    _JuzInfo(juz: 29, suratCount: 11),
    _JuzInfo(juz: 30, suratCount: 37),
  ];

  bool get _allTargetsCompleted {
    if (_juzData.isEmpty) return true;
    return _juzData.every((juz) {
      final total = juz['total'] as int;
      final completed = juz['completed'] as int;
      return total > 0 && completed >= total;
    });
  }

  void _showTambahTargetBottomSheet() {
    final colors = AppColors.of(context);
    final searchController = TextEditingController();
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            // Filter out already-targeted juz and apply search
            final available = _allJuz.where((j) {
              final isAlreadyTarget = _juzData.any((d) => d['juz'] == j.juz);
              if (isAlreadyTarget) return false;
              if (searchQuery.isEmpty) return true;
              return 'Juz ${j.juz}'.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tambah Target Hafalan',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Info banner
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18.sp,
                            color: const Color(0xFFE65100),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Penambahan target baru hanya dapat dilakukan jika semua target sebelumnya telah mencapai 100%',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFE65100),
                                fontFamily: 'Poppins',
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Search field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) => setSheetState(() => searchQuery = v),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari Juz (contoh: Juz 1)',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color: colors.textSecondary.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colors.textSecondary,
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Juz list
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: available.length,
                      itemBuilder: (_, idx) {
                        final juzInfo = available[idx];
                        final canAdd = _allTargetsCompleted;

                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.border.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Juz ${juzInfo.juz}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: colors.textPrimary,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      '${juzInfo.suratCount} Surat',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: colors.textSecondary,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: canAdd
                                    ? () {
                                        setState(() {
                                          _juzData.add({
                                            'juz': juzInfo.juz,
                                            'total': juzInfo.suratCount,
                                            'completed': 0,
                                          });
                                          // Sort by juz descending
                                          _juzData.sort(
                                            (a, b) => (b['juz'] as int)
                                                .compareTo(a['juz'] as int),
                                          );
                                        });
                                        setSheetState(() {});

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Juz ${juzInfo.juz} ditambahkan sebagai target',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            backgroundColor: colors.primary,
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width: 34.w,
                                  height: 34.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: canAdd
                                        ? colors.primary.withValues(alpha: 0.1)
                                        : colors.border.withValues(alpha: 0.3),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 20.sp,
                                    color: canAdd
                                        ? colors.primary
                                        : colors.textSecondary.withValues(
                                            alpha: 0.4,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Tutup button
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textPrimary,
                          side: BorderSide(color: colors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'Tutup',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahTargetBottomSheet,
        backgroundColor: colors.primary,
        child: Icon(Icons.add, color: colors.textOnButton),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 24.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    t.progressHafalanPerJuz.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Green gradient profile card
                    _buildProfileCard(colors),
                    SizedBox(height: 20.h),

                    // Target Hafalan header
                    Text(
                      t.progressHafalanPerJuz.targetHafalan,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      t.progressHafalanPerJuz.pilihJuz,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Juz cards
                    ..._juzData.map(
                      (juz) => _buildJuzCard(context, juz, colors),
                    ),
                    SizedBox(height: 80.h), // Extra space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(Icons.person, size: 26.sp, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'NIS: ${widget.nis}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                t.riwayatHafalanSantri.halaqohKelas(halaqoh: 'A', kelas: '7'),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJuzCard(
    BuildContext context,
    Map<String, dynamic> juz,
    AppColorSet colors,
  ) {
    final juzNum = juz['juz'] as int;
    final total = juz['total'] as int;
    final completed = juz['completed'] as int;
    final percent = total > 0 ? (completed / total * 100).round() : 0;
    final progress = total > 0 ? completed / total : 0.0;

    return GestureDetector(
      onTap: () {
        context.router.push(
          ProgressHafalanPerSuratRoute(
            name: widget.name,
            nis: widget.nis,
            juzNumber: juzNum,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Juz $juzNum',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      t.progressHafalanPerJuz.suratSelesai(
                        completed: '$completed',
                        total: '$total',
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                Text(
                  '$percent %',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6.h,
                      backgroundColor: colors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.chevron_right,
                  size: 22.sp,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
