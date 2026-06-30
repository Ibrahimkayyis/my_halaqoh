import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/activity_log/activity_log_cubit.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/activity_log/activity_log_state.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';

@RoutePage()
class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActivityLogCubit>()..watchRecent(),
      child: const _ActivityLogView(),
    );
  }
}

class _ActivityLogView extends StatefulWidget {
  const _ActivityLogView();

  @override
  State<_ActivityLogView> createState() => _ActivityLogViewState();
}

class _ActivityLogViewState extends State<_ActivityLogView> {
  String _selectedRoleDisplay = 'Semua Role';
  String _selectedTimeDisplay = 'Semua Waktu';
  String _selectedActionDisplay = 'Semua Aksi';

  DateTime? _filterFromDate;
  DateTime? _filterToDate;

  static const _rolesDisplay = ['Semua Role', 'Super Admin', 'Admin', 'Guru', 'Wali Santri'];
  
  static const _timeOptions = [
    'Semua Waktu',
    'Hari Ini',
    '7 Hari Terakhir',
    '30 Hari Terakhir',
    'Bulan Ini',
    'Pilih Tanggal...'
  ];

  static const _actionsDisplay = [
    'Semua Aksi',
    'Login',
    'Logout',
    'Simpan',
    'Ubah',
    'Hapus',
    'Simpan Absensi',
    'Sinkronisasi Absensi',
    'Tambah Hafalan',
    'Sinkronisasi Hafalan'
  ];

  List<String> get _timeDropdownItems {
    final list = List<String>.from(_timeOptions);
    if (_selectedTimeDisplay != 'Semua Waktu' && !_timeOptions.contains(_selectedTimeDisplay)) {
      // Insert the custom range format text before 'Pilih Tanggal...'
      list.insert(list.length - 1, _selectedTimeDisplay);
    }
    return list;
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: _filterFromDate ?? now.subtract(const Duration(days: 7)),
      end: _filterToDate ?? now,
    );
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.of(context).primary,
              onPrimary: Colors.white,
              onSurface: AppColors.of(context).textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      final start = pickedRange.start;
      final end = pickedRange.end.add(const Duration(hours: 23, minutes: 59, seconds: 59));
      setState(() {
        _filterFromDate = start;
        _filterToDate = end;
        _selectedTimeDisplay = '${DateFormat('dd/MM/yy').format(start)} - ${DateFormat('dd/MM/yy').format(end)}';
      });
    } else {
      if (_filterFromDate == null) {
        setState(() {
          _selectedTimeDisplay = 'Semua Waktu';
        });
      }
    }
  }

  Map<String, List<ActivityLogModel>> _groupLogs(List<ActivityLogModel> logs) {
    final groups = <String, List<ActivityLogModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final log in logs) {
      final logDate = DateTime(log.createdAt.year, log.createdAt.month, log.createdAt.day);
      String key;
      if (logDate == today) {
        key = 'Hari Ini';
      } else if (logDate == yesterday) {
        key = 'Kemarin';
      } else {
        key = 'Sebelumnya';
      }
      groups.putIfAbsent(key, () => []).add(log);
    }
    return groups;
  }

  void _applyFilter(BuildContext context) {
    final roleRaw = switch (_selectedRoleDisplay) {
      'Super Admin' => 'super_admin',
      'Admin' => 'admin',
      'Guru' => 'guru',
      'Wali Santri' => 'santri',
      _ => null,
    };

    final actionRaw = switch (_selectedActionDisplay) {
      'Login' => 'login',
      'Logout' => 'logout',
      'Simpan' => 'create',
      'Ubah' => 'update',
      'Hapus' => 'delete',
      'Simpan Absensi' => 'save_absensi',
      'Sinkronisasi Absensi' => 'sync_absensi',
      'Tambah Hafalan' => 'add_hafalan',
      'Sinkronisasi Hafalan' => 'sync_hafalan',
      _ => null,
    };

    DateTime? fromDate;
    DateTime? toDate;
    final now = DateTime.now();

    if (_selectedTimeDisplay == 'Hari Ini') {
      fromDate = DateTime(now.year, now.month, now.day);
      toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (_selectedTimeDisplay == '7 Hari Terakhir') {
      fromDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
      toDate = now;
    } else if (_selectedTimeDisplay == '30 Hari Terakhir') {
      fromDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));
      toDate = now;
    } else if (_selectedTimeDisplay == 'Bulan Ini') {
      fromDate = DateTime(now.year, now.month, 1);
      toDate = now;
    } else if (_selectedTimeDisplay == 'Semua Waktu') {
      fromDate = null;
      toDate = null;
    } else {
      fromDate = _filterFromDate;
      toDate = _filterToDate;
    }

    context.read<ActivityLogCubit>().getFiltered(
          filterRole: roleRaw,
          filterAction: actionRaw,
          fromDate: fromDate,
          toDate: toDate,
        );
  }

  void _resetFilter(BuildContext context) {
    setState(() {
      _selectedRoleDisplay = 'Semua Role';
      _selectedTimeDisplay = 'Semua Waktu';
      _selectedActionDisplay = 'Semua Aksi';
      _filterFromDate = null;
      _filterToDate = null;
    });
    context.read<ActivityLogCubit>().watchRecent();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          // ── Header (Dark Teal with Back Button & Title) ─────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => context.router.pop(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 48.w), // Balance the back button
                        child: Text(
                          'Log Aktivitas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable Body ──────────────────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Filter Card ────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.tune_rounded, size: 20.sp, color: colors.textPrimary),
                              SizedBox(width: 8.w),
                              Text(
                                'Filter Aktivitas',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          
                          // Dropdown Role
                          Text(
                            'Role',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 6.h),
                          CustomDropdown<String>(
                            items: _rolesDisplay,
                            initialItem: _selectedRoleDisplay,
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedRoleDisplay = value);
                            },
                            closedHeaderPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: _dropdownDecoration(colors),
                          ),
                          SizedBox(height: 14.h),

                          // Dropdown Waktu
                          Text(
                            'Waktu',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 6.h),
                          CustomDropdown<String>(
                            items: _timeDropdownItems,
                            initialItem: _selectedTimeDisplay,
                            onChanged: (value) {
                              if (value == null) return;
                              if (value == 'Pilih Tanggal...') {
                                _selectCustomDateRange(context);
                              } else {
                                setState(() {
                                  _selectedTimeDisplay = value;
                                  _filterFromDate = null;
                                  _filterToDate = null;
                                });
                              }
                            },
                            closedHeaderPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: _dropdownDecoration(colors),
                          ),
                          SizedBox(height: 14.h),

                          // Dropdown Aksi
                          Text(
                            'Aksi',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 6.h),
                          CustomDropdown<String>(
                            items: _actionsDisplay,
                            initialItem: _selectedActionDisplay,
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedActionDisplay = value);
                            },
                            closedHeaderPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: _dropdownDecoration(colors),
                          ),
                          SizedBox(height: 20.h),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFEE2E2), // Light red
                                    foregroundColor: const Color(0xFFEF4444), // Red
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  onPressed: () => _resetFilter(context),
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  onPressed: () => _applyFilter(context),
                                  child: Text(
                                    'Terapkan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Logs Timeline ─────────────────────────────────────────────
                BlocBuilder<ActivityLogCubit, ActivityLogState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      loading: () => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      loaded: (logs) {
                        if (logs.isEmpty) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history_rounded, size: 48.sp, color: colors.textSecondary),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'Belum ada log aktivitas',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: colors.textSecondary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Group logs
                        final groups = _groupLogs(logs);
                        final listItems = <dynamic>[];
                        
                        if (groups.containsKey('Hari Ini')) {
                          listItems.add('Hari Ini');
                          listItems.addAll(groups['Hari Ini']!);
                        }
                        if (groups.containsKey('Kemarin')) {
                          listItems.add('Kemarin');
                          listItems.addAll(groups['Kemarin']!);
                        }
                        if (groups.containsKey('Sebelumnya')) {
                          listItems.add('Sebelumnya');
                          listItems.addAll(groups['Sebelumnya']!);
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final item = listItems[i];
                              if (item is String) {
                                // Group Header
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 12.h),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: colors.textPrimary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                );
                              } else {
                                // Timeline item containing log card
                                final log = item as ActivityLogModel;
                                final logDate = DateTime(log.createdAt.year, log.createdAt.month, log.createdAt.day);
                                final now = DateTime.now();
                                final today = DateTime(now.year, now.month, now.day);
                                final isToday = logDate == today;

                                return IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Timeline Column
                                      SizedBox(
                                        width: 56.w,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            // Vertical Line
                                            Container(
                                              width: 1.5.w,
                                              color: colors.border.withValues(alpha: 0.6),
                                            ),
                                            // The Dot
                                            Positioned(
                                              top: 24.h,
                                              child: Container(
                                                width: 10.w,
                                                height: 10.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isToday ? colors.primary : colors.surface,
                                                  border: Border.all(
                                                    color: colors.primary,
                                                    width: isToday ? 0 : 2.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Card
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 12.h, right: 24.w),
                                          child: _buildLogCard(context, log, colors, isDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            childCount: listItems.length,
                          ),
                        );
                      },
                      error: (msg) => SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: Text(
                              'Terjadi kesalahan: $msg',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13.sp, color: colors.error, fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ── Bottom Spacing ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(height: 32.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomDropdownDecoration _dropdownDecoration(AppColorSet colors) {
    return CustomDropdownDecoration(
      closedBorderRadius: BorderRadius.circular(12.r),
      closedBorder: Border.all(color: Colors.transparent),
      closedFillColor: colors.borderLight,
      expandedBorderRadius: BorderRadius.circular(12.r),
      expandedBorder: Border.all(color: colors.primary.withValues(alpha: 0.4)),
      expandedFillColor: colors.surface,
      headerStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textPrimary,
        fontFamily: 'Poppins',
      ),
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textSecondary,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildLogCard(BuildContext context, ActivityLogModel log, AppColorSet colors, bool isDark) {
    final roleColor = _roleColor(log.userRole);
    final actionIcon = _actionIcon(log.action);
    final actionBg = roleColor.withValues(alpha: 0.08);
    final timeStr = _formatTime(log.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.router.push(ActivityLogDetailRoute(log: log));
          },
          child: Row(
            children: [
          // Left vertical strip
          Container(
            width: 4.w,
            height: double.infinity,
            color: colors.blue,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Role badge & Timestamp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          log.userRole.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: roleColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Bottom Row: Icon & Text Description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: actionBg,
                        ),
                        child: Icon(
                          actionIcon,
                          color: roleColor,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: log.userName,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                              TextSpan(
                                text: ' ${log.description ?? "${log.action} • ${log.module}"}',
                              ),
                            ],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }

  Color _roleColor(String role) {
    return switch (role) {
      'admin' => Colors.blue.shade700,
      'guru' => Colors.teal.shade700,
      'santri' => Colors.orange.shade700,
      'super_admin' => Colors.purple.shade700,
      _ => Colors.grey,
    };
  }

  IconData _actionIcon(String action) {
    return switch (action) {
      'login' => Icons.login_rounded,
      'logout' => Icons.logout_rounded,
      'create' => Icons.account_balance_wallet_outlined,
      'update' => Icons.checklist_rounded,
      'delete' => Icons.delete_forever_rounded,
      'save_absensi' => Icons.checklist_rounded,
      'sync_absensi' => Icons.checklist_rounded,
      'add_hafalan' => Icons.account_balance_wallet_outlined,
      'sync_hafalan' => Icons.checklist_rounded,
      _ => Icons.info_outline_rounded,
    };
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 2) {
      return 'Kemarin, ${DateFormat('HH:mm').format(dt)}';
    }
    return DateFormat('d MMM yyyy, HH:mm', 'id').format(dt);
  }
}
