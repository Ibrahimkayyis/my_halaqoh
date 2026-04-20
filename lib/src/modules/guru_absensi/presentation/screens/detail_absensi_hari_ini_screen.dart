import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_record_entry.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Detail Absensi Hari Ini.
///
/// Receives [scannedNisList] from [BarcodeScannerScreen].
/// Santri whose NIS is in the list start with status "hadir".
/// Santri not yet scanned start with status "belum" and can be changed
/// via dropdown.
@RoutePage()
class DetailAbsensiHariIniScreen extends StatefulWidget {
  final List<String> scannedNisList;
  final DateTime selectedDate;
  final String selectedSesi;

  const DetailAbsensiHariIniScreen({
    super.key,
    this.scannedNisList = const [],
    required this.selectedDate,
    required this.selectedSesi,
  });

  @override
  State<DetailAbsensiHariIniScreen> createState() =>
      _DetailAbsensiHariIniScreenState();
}

class _DetailAbsensiHariIniScreenState extends State<DetailAbsensiHariIniScreen>
    with SingleTickerProviderStateMixin {
  Map<int, String> _santriStatuses = {};
  List<SantriModel> _mySantriList = [];
  HalaqohModel? _myHalaqoh;
  String _guruId = '';
  late AbsensiCubit _absensiCubit;

  bool _isLoading = true;
  bool _isEditing = false;
  AbsensiModel? _existingSession;
  late TabController _tabController;
  late String _currentSesi;
  List<String> _sessionKeys = [];
  List<String> _sessionLabels = [];

  final List<String> _statusOptions = [
    'belum',
    'hadir',
    'sakit',
    'izin',
    'alfa',
  ];

  @override
  void initState() {
    super.initState();
    _absensiCubit = sl<AbsensiCubit>();
    _currentSesi = widget.selectedSesi;

    final authState = context.read<AuthCubit>().state;
    final halaqohState = context.read<HalaqohCubit>().state;

    authState.maybeWhen(
      authenticated: (userMeta) => _guruId = userMeta.linkedDocId,
      orElse: () {},
    );

    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          _myHalaqoh = list.firstWhere((h) => h.guruId == _guruId);
        } catch (_) {}
      },
      orElse: () {},
    );

    if (_myHalaqoh?.program == 'T') {
      _sessionKeys = ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'];
      _sessionLabels = ['Pagi', 'Dhuha', 'Siang', 'Sore', 'Malam'];
    } else {
      _sessionKeys = ['shubuh', 'maghrib'];
      _sessionLabels = ['Pagi', 'Malam'];
    }

    int initialIndex = _sessionKeys.indexOf(_currentSesi);
    if (initialIndex == -1) initialIndex = 0;

    _tabController = TabController(
      length: _sessionKeys.length,
      initialIndex: initialIndex,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final newSesi = _sessionKeys[_tabController.index];
        if (newSesi != _currentSesi) {
          _currentSesi = newSesi;
          _fetchSessionData();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _fetchSessionData() async {
    setState(() => _isLoading = true);

    if (_myHalaqoh == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    _existingSession = await _absensiCubit.findExisting(
      _myHalaqoh!.id,
      widget.selectedDate,
      _currentSesi,
    );

    _isEditing = _existingSession != null;

    if (_isEditing) {
      final existingMap = {
        for (var r in _existingSession!.records) r.nis: r.status,
      };
      _santriStatuses = {
        for (int i = 0; i < _mySantriList.length; i++)
          i:
              widget.selectedSesi == _currentSesi &&
                  widget.scannedNisList.contains(_mySantriList[i].nis)
              ? 'hadir'
              : existingMap[_mySantriList[i].nis] ?? 'belum',
      };
    } else {
      _santriStatuses = {
        for (int i = 0; i < _mySantriList.length; i++)
          i:
              widget.selectedSesi == _currentSesi &&
                  widget.scannedNisList.contains(_mySantriList[i].nis)
              ? 'hadir'
              : 'belum',
      };
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _loadData() async {
    final santriState = context.read<SantriCubit>().state;
    if (_myHalaqoh != null) {
      santriState.maybeWhen(
        loaded: (sList) {
          _mySantriList = sList
              .where((s) => _myHalaqoh!.santriIds.contains(s.id))
              .toList();
        },
        orElse: () {},
      );
      _absensiCubit.watchByHalaqoh(_myHalaqoh!.id);
    }

    await _fetchSessionData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _absensiCubit.close();
    super.dispose();
  }

  // ── Stats ──────────────────────────────────────────────────────────────────
  Map<String, int> get _stats {
    int hadir = 0, sakit = 0, izin = 0, alfa = 0, belum = 0;
    for (final status in _santriStatuses.values) {
      switch (status) {
        case 'hadir':
          hadir++;
          break;
        case 'sakit':
          sakit++;
          break;
        case 'izin':
          izin++;
          break;
        case 'alfa':
          alfa++;
          break;
        default:
          belum++;
          break;
      }
    }
    return {
      'hadir': hadir,
      'sakit': sakit,
      'izin': izin,
      'alfa': alfa,
      'belum': belum,
    };
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'hadir':
        return t.detailAbsensiHariIni.hadir;
      case 'sakit':
        return t.detailAbsensiHariIni.sakit;
      case 'izin':
        return t.detailAbsensiHariIni.izin;
      case 'alfa':
        return t.detailAbsensiHariIni.alfa;
      default:
        return t.detailAbsensiHariIni.belumDiabsen;
    }
  }

  String _getSessionLabel(String sesi) {
    switch (sesi) {
      case 'shubuh':
        return 'Pagi';
      case 'dhuha':
        return 'Dhuha';
      case 'siang':
        return 'Siang';
      case 'ashar':
        return 'Ashar';
      case 'maghrib':
        return 'Malam';
      default:
        return sesi;
    }
  }

  // ── Save handler ──────────────────────────────────────────────────────────
  Future<void> _onSave() async {
    if (_myHalaqoh == null) return;

    // Check for duplicates only if not editing an existing session intentionally
    if (!_isEditing) {
      final existing = await _absensiCubit.findExisting(
        _myHalaqoh!.id,
        widget.selectedDate,
        _currentSesi,
      );

      if (existing != null && mounted) {
        // Show duplicate warning dialog
        final shouldOverwrite = await _showDuplicateWarning();
        if (!shouldOverwrite) return;
      }
    }

    // Confirm save
    if (!mounted) return;
    final confirmed = await ConfirmSaveDialog.show(context);
    if (!confirmed || !mounted) return;

    // Build records
    final records = <AbsensiRecordEntry>[];
    for (int i = 0; i < _mySantriList.length; i++) {
      final santri = _mySantriList[i];
      final status = _santriStatuses[i] ?? 'belum';
      if (status == 'belum') continue; // skip unresolved
      records.add(
        AbsensiRecordEntry(
          santriId: santri.id,
          nis: santri.nis,
          nama: santri.nama,
          status: status,
        ),
      );
    }

    final now = DateTime.now();
    final dateOnly = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    final model = AbsensiModel(
      id: _isEditing
          ? _existingSession!.id
          : 'local_${now.millisecondsSinceEpoch}',
      halaqohId: _myHalaqoh!.id,
      guruId: _guruId,
      tanggal: dateOnly,
      sesi: _currentSesi,
      records: records,
      isSynced: false,
      createdAt: _isEditing ? _existingSession!.createdAt : now,
      updatedAt: now,
    );

    final success = await _absensiCubit.saveSession(model);

    if (mounted) {
      if (success) {
        final colors = AppColors.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Absensi berhasil disimpan!',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: colors.primary,
          ),
        );
        context.router.maybePop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Gagal menyimpan absensi',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showDuplicateWarning() async {
    final colors = AppColors.of(context);
    final dateStr = DateFormat('d MMMM yyyy', 'id').format(widget.selectedDate);
    final sessionLabel = _getSessionLabel(_currentSesi);

    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: colors.yellow,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Data Sudah Ada',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'Data absensi untuk sesi $sessionLabel pada tanggal $dateStr sudah ada. Apakah Anda ingin menimpa data tersebut?',
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Timpa',
                  style: TextStyle(
                    color: colors.red,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stats = _stats;
    final dayName = DateFormat('EEEE', 'id').format(widget.selectedDate);
    final dateStr = DateFormat('d MMMM yyyy', 'id').format(widget.selectedDate);

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSave,
        backgroundColor: colors.primary,
        icon: Icon(Icons.save, color: colors.textOnButton),
        label: Text(
          t.absensi.simpan,
          style: TextStyle(
            color: colors.textOnButton,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back button ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: colors.primary),
                ),
              )
            else ...[
              // ── Header card ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.detailAbsensiHariIni.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14.sp,
                            color: colors.textSecondary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '$dayName, $dateStr',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 14.sp,
                            color: colors.primary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${widget.scannedNisList.length} santri berhasil di-scan',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          _buildStatChip(
                            '${t.detailAbsensiHariIni.hadir} (${stats['hadir']})',
                            colors.primary,
                          ),
                          _buildStatChip(
                            '${t.detailAbsensiHariIni.sakit} (${stats['sakit']})',
                            colors.yellow,
                          ),
                          _buildStatChip(
                            '${t.detailAbsensiHariIni.izin} (${stats['izin']})',
                            colors.blue,
                          ),
                          _buildStatChip(
                            '${t.detailAbsensiHariIni.alfa} (${stats['alfa']})',
                            colors.red,
                          ),
                          _buildStatChip(
                            '${t.detailAbsensiHariIni.belumAbsen} (${stats['belum']})',
                            colors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ── Tab Selector ───────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _myHalaqoh?.program == 'T'
                    ? _buildTakhassusSelector(colors)
                    : AppTabSelector(
                        controller: _tabController,
                        tabs: _sessionLabels,
                      ),
              ),
              SizedBox(height: 20.h),

              // ── List header ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  t.detailAbsensiHariIni.daftarKehadiranSantri,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // ── Santri list ────────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
                  itemCount: _mySantriList.length,
                  itemBuilder: (context, index) {
                    final santri = _mySantriList[index];
                    final wasScanned = widget.scannedNisList.contains(
                      santri.nis,
                    );
                    return _buildSantriCard(
                      index,
                      santri.nama,
                      santri.nis,
                      wasScanned,
                      colors,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTakhassusSelector(AppColorSet colors) {
    if (_sessionLabels.length < 5) return const SizedBox();
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCustomTab(0, _sessionLabels[0], colors)),
            SizedBox(width: 8.w),
            Expanded(child: _buildCustomTab(1, _sessionLabels[1], colors)),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(child: _buildCustomTab(2, _sessionLabels[2], colors)),
            SizedBox(width: 8.w),
            Expanded(child: _buildCustomTab(3, _sessionLabels[3], colors)),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160.w,
              child: _buildCustomTab(4, _sessionLabels[4], colors),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomTab(int index, String label, AppColorSet colors) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        final isSelected = _tabController.index == index;
        return GestureDetector(
          onTap: () {
            if (!isSelected) {
              _tabController.animateTo(index);
            }
          },
          child: Container(
            height: 42.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.surface
                  : colors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? colors.primary : colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Stat chip ──────────────────────────────────────────────────────────────
  Widget _buildStatChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  // ── Santri card ────────────────────────────────────────────────────────────
  Widget _buildSantriCard(
    int index,
    String name,
    String nis,
    bool wasScanned,
    AppColorSet colors,
  ) {
    final currentStatus = _santriStatuses[index] ?? 'belum';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: wasScanned
            ? Border.all(
                color: colors.primary.withValues(alpha: 0.3),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Bagian Atas: Avatar, Nama, dan NIS ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: wasScanned
                      ? colors.primary.withValues(alpha: 0.1)
                      : colors.border.withValues(alpha: 0.3),
                  border: Border.all(
                    color: wasScanned
                        ? colors.primary.withValues(alpha: 0.2)
                        : colors.border,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 20.sp,
                  color: wasScanned ? colors.primary : colors.textSecondary,
                ),
              ),
              SizedBox(width: 12.w),

              // Nama dan NIS (Bisa memanjang ke bawah)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            // maxLines dan ellipsis dihapus agar teks nama bisa tampil penuh
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: wasScanned
                                  ? colors.primary
                                  : colors.textPrimary,
                              fontFamily: 'Poppins',
                              height:
                                  1.3, // Jarak antar baris teks jika nama panjang
                            ),
                          ),
                        ),
                        if (wasScanned) ...[
                          SizedBox(width: 8.w),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Icon(
                              Icons.qr_code_rounded,
                              size: 16.sp,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      nis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Bagian Bawah: Dropdown Status (Full Width) ──
          SizedBox(height: 14.h), // Jarak antara profil santri dan dropdown
          SizedBox(
            width: double.infinity, // Membuat dropdown memanjang penuh
            child: _buildStatusDropdown(index, currentStatus, colors),
          ),
        ],
      ),
    );
  }

  // ── Status dropdown ────────────────────────────────────────────────────────
  Widget _buildStatusDropdown(
    int index,
    String currentStatus,
    AppColorSet colors,
  ) {
    return CustomDropdown<String>(
      items: _statusOptions,
      initialItem: currentStatus,
      onChanged: (value) {
        if (value != null) setState(() => _santriStatuses[index] = value);
      },
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            _getStatusLabel(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: _getStatusTextColor(item, colors),
            ),
          ),
        );
      },
      headerBuilder: (context, selectedItem, enabled) {
        return Text(
          _getStatusLabel(selectedItem),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: _getStatusTextColor(selectedItem, colors),
          ),
        );
      },
      closedHeaderPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 8.h,
      ),
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(
          color: _getStatusBorderColor(currentStatus, colors),
          width: 1,
        ),
        closedBorderRadius: BorderRadius.circular(10.r),
        closedFillColor: _getStatusBgColor(currentStatus, colors),
        expandedBorderRadius: BorderRadius.circular(10.r),
        expandedFillColor: colors.surface,
        expandedBorder: Border.all(color: colors.border, width: 1),
        closedSuffixIcon: Icon(
          Icons.keyboard_arrow_down,
          size: 16.sp,
          color: _getStatusTextColor(currentStatus, colors),
        ),
        expandedSuffixIcon: Icon(
          Icons.keyboard_arrow_up,
          size: 16.sp,
          color: colors.primary,
        ),
      ),
    );
  }

  // ── Color helpers ──────────────────────────────────────────────────────────
  Color _getStatusBgColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir':
        return colors.primary.withValues(alpha: 0.1);
      case 'sakit':
        return colors.yellow.withValues(alpha: 0.1);
      case 'izin':
        return colors.blue.withValues(alpha: 0.1);
      case 'alfa':
        return colors.red.withValues(alpha: 0.1);
      default:
        return colors.border.withValues(alpha: 0.2);
    }
  }

  Color _getStatusBorderColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir':
        return colors.primary.withValues(alpha: 0.3);
      case 'sakit':
        return colors.yellow.withValues(alpha: 0.3);
      case 'izin':
        return colors.blue.withValues(alpha: 0.3);
      case 'alfa':
        return colors.red.withValues(alpha: 0.3);
      default:
        return colors.border;
    }
  }

  Color _getStatusTextColor(String status, AppColorSet colors) {
    switch (status) {
      case 'hadir':
        return colors.primary;
      case 'sakit':
        return colors.yellow;
      case 'izin':
        return colors.blue;
      case 'alfa':
        return colors.red;
      default:
        return colors.textSecondary;
    }
  }
}
