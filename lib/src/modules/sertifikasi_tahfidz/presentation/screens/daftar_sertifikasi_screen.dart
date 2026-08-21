import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/helpers/sertifikasi_status_helper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/widgets/sertifikasi_card.dart';

/// Main screen for viewing Santri Tahfidz Certifications.
/// Refactored to a super clean list layout with TabSelector and uniform Top Bar.
@RoutePage()
class DaftarSertifikasiScreen extends StatefulWidget {
  const DaftarSertifikasiScreen({super.key});

  @override
  State<DaftarSertifikasiScreen> createState() => _DaftarSertifikasiScreenState();
}

class _DaftarSertifikasiScreenState extends State<DaftarSertifikasiScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Placeholder items for layout preview
  late List<SertifikasiModel> _items;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    _items = [
      SertifikasiModel(
        id: '1',
        santriId: 'santri_1',
        santriNama: 'Ahmad Rayhan Al-Fatih',
        nis: '2024001',
        kelas: '7',
        program: 'R',
        halaqohId: 'h1',
        halaqohNama: 'Halaqoh Abu Bakar Ash-Shiddiq',
        guruId: 'g1',
        guruNama: 'Ustadz Salman Al-Farisi',
        juz: 30,
        status: SertifikasiStatusHelper.statusScheduled,
        tanggalUjian: DateTime.now().add(const Duration(days: 2)),
        sesiUjian: 'Pagi (08:30 - 10:00 WIB)',
        pengujiNama: 'Ustadz Ahmad Dahlan, Lc.',
        catatanAdmin: 'Ujian dilaksanakan di Ruang Tahfidz Utama Lantai 2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      SertifikasiModel(
        id: '2',
        santriId: 'santri_2',
        santriNama: 'Muhammad Zaidan Akbar',
        nis: '2024002',
        kelas: '8',
        program: 'T',
        halaqohId: 'h1',
        halaqohNama: 'Halaqoh Abu Bakar Ash-Shiddiq',
        guruId: 'g1',
        guruNama: 'Ustadz Salman Al-Farisi',
        juz: 29,
        status: SertifikasiStatusHelper.statusPending,
        catatanGuru: 'Santri sudah menyetorkan seluruh surat dalam Juz 29 dengan lancar',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      SertifikasiModel(
        id: '3',
        santriId: 'santri_3',
        santriNama: 'Fathur Rahman Syah',
        nis: '2024003',
        kelas: '7',
        program: 'R',
        halaqohId: 'h1',
        halaqohNama: 'Halaqoh Abu Bakar Ash-Shiddiq',
        guruId: 'g1',
        guruNama: 'Ustadz Salman Al-Farisi',
        juz: 30,
        status: SertifikasiStatusHelper.statusPassed,
        tanggalUjian: DateTime.now().subtract(const Duration(days: 5)),
        sesiUjian: 'Siang (13:30 WIB)',
        pengujiNama: 'Ustadz Muhammad Ilham, M.Pd.',
        nilaiKelancaran: 92,
        nilaiTajwid: 88,
        nilaiMakhroj: 90,
        nilaiTotal: 90.0,
        predikat: 'Mumtaz (Istimewa)',
        catatanPenguji: 'Maa syaa Allah kelancaran dan tajwid sangat baik.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        completedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      SertifikasiModel(
        id: '4',
        santriId: 'santri_4',
        santriNama: 'Habibi Nur Ikhsan',
        nis: '2024004',
        kelas: '9',
        program: 'R',
        halaqohId: 'h1',
        halaqohNama: 'Halaqoh Abu Bakar Ash-Shiddiq',
        guruId: 'g1',
        guruNama: 'Ustadz Salman Al-Farisi',
        juz: 28,
        status: SertifikasiStatusHelper.statusRejected,
        alasanPenolakan: 'Setoran harian Juz 28 santri di sistem masih kurang 4 halaman terakhir.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    // Filter items based on active tab
    final activeItems = _items.where((item) {
      if (_tabController.index == 0) {
        // Tab 0: Sedang Berjalan (Pending & Scheduled)
        return item.status == SertifikasiStatusHelper.statusPending ||
            item.status == SertifikasiStatusHelper.statusScheduled;
      } else {
        // Tab 1: Riwayat Selesai (Passed, Failed, Rejected)
        return item.status == SertifikasiStatusHelper.statusPassed ||
            item.status == SertifikasiStatusHelper.statusFailed ||
            item.status == SertifikasiStatusHelper.statusRejected;
      }
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.router.push(FormPendaftaranSertifikasiRoute());
        },
        backgroundColor: colors.primary,
        foregroundColor: colors.textOnButton,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        icon: const Icon(Icons.add_task_rounded),
        label: Text(
          'Daftarkan Santri',
          style: textTheme.labelLarge?.copyWith(
            color: colors.textOnButton,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
                    'Sertifikasi Ujian Tahfidz',
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
            SizedBox(height: 8.h),

            // ── Tab Selector (Clean, No Counters) ─────────────────────
            Container(
              color: colors.surface,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: AppTabSelector(
                controller: _tabController,
                horizontalPadding: 0,
                tabs: const [
                  'Sedang Berjalan',
                  'Riwayat Selesai',
                ],
              ),
            ),

            // ── Clean List of Items ──────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: activeItems.isEmpty
                    ? _buildEmptyState(context, colors, textTheme)
                    : ListView.separated(
                        key: ValueKey<int>(_tabController.index),
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          top: 14.h,
                          bottom: 80.h,
                        ),
                        itemCount: activeItems.length,
                        separatorBuilder: (context, index) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final item = activeItems[index];
                          return SertifikasiCard(item: item);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty State strictly compliant with MASTER.md Section 5B
  Widget _buildEmptyState(
    BuildContext context,
    AppColorSet colors,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 32.sp,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Belum Ada Data Sertifikasi',
              style: textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Gunakan tombol "Daftarkan Santri" untuk mengajukan ujian.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
