import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_cubit.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_state.dart';
import 'package:my_halaqoh/src/modules/notifications/domain/models/wali_santri_notification_item.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/data/datasources/remote/mapper/sertifikasi_mapper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/widgets/detail_sertifikasi_sheet.dart';

/// Notification list screen for Guru and Wali Santri.
/// Integrates real data from Firestore for Wali Santri (Absensi & Hafalan).
@RoutePage()
class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  String _selectedCategory = 'semua';
  List<WaliSantriNotificationItem> _notifications = [];
  bool _isLoading = true;
  StreamSubscription? _notificationSub;
  String? _currentUid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initNotifications());
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    super.dispose();
  }

  void _initNotifications() {
    if (!mounted) return;

    final authState = context.read<AuthCubit>().state;
    String uid = '';

    authState.maybeWhen(
      authenticated: (user) => uid = user.uid,
      orElse: () {},
    );

    _currentUid = uid;

    if (uid.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final badgeCubit = sl<NotificationBadgeCubit>();

    // Ensure the global pipeline runs even if the dashboard wrapper has not
    // started it yet (e.g., deep link straight into this screen).
    if (!badgeCubit.isRunning) {
      final linkedDocId =
          ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
      final role = ActiveSessionHelper.getActiveRole(context) ?? '';
      if (linkedDocId.isNotEmpty) {
        unawaited(badgeCubit.start(
          isWaliSantri: role == 'santri' || role == 'wali_santri',
          linkedDocId: linkedDocId,
          uid: uid,
        ));
      } else {
        // No linked document — nothing to stream. Show the empty state
        // instead of an endless spinner.
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // Single source of truth: consume the global badge cubit instead of
    // creating a second parallel Firestore subscription here.
    void applyBadgeState(NotificationBadgeState state) {
      state.maybeWhen(
        loaded: (items, _) {
          if (mounted) {
            setState(() {
              _notifications = items;
              _isLoading = false;
            });
          }
        },
        orElse: () {},
      );
    }

    _notificationSub?.cancel();
    _notificationSub = badgeCubit.stream.listen(applyBadgeState);

    // IMPORTANT: Cubit.stream does NOT replay the current state to late
    // subscribers — it only emits future changes. If the pipeline is already
    // running (started by the dashboard wrapper), the `loaded` emission
    // happened BEFORE this screen existed, so consume the current state
    // synchronously or _isLoading would never turn off.
    applyBadgeState(badgeCubit.state);
  }

  void _markAllAsRead() async {
    if (_currentUid == null || _currentUid!.isEmpty) return;

    // Mark all as read via the global badge cubit — the service fires a
    // reactive re-emission so every listening badge updates instantly.
    await sl<NotificationBadgeCubit>().markAllAsRead();

    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Semua pemberitahuan telah ditandai sebagai dibaca.'),
        backgroundColor: AppColors.of(context).primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleItemTap(WaliSantriNotificationItem item) async {
    if (_currentUid != null && _currentUid!.isNotEmpty) {
      await sl<NotificationBadgeCubit>().markAsRead(item);
      setState(() {
        item.isRead = true;
      });
    }

    if (!mounted) return;

    if (item.category == 'sertifikasi') {
      final cachedModel = item.metadata?['sertifikasiModel'] as SertifikasiModel?;
      if (cachedModel != null) {
        DetailSertifikasiSheet.show(context, cachedModel);
        return;
      }
      if (item.entityId != null && item.entityId!.isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('sertifikasi_tahfidz')
            .doc(item.entityId!)
            .get();
        if (doc.exists && mounted) {
          DetailSertifikasiSheet.show(
            context,
            SertifikasiMapper.fromFirestore(doc),
          );
        }
      }
      return;
    }

    // Resolve active santri info for navigation
    final santriState = context.read<SantriCubit>().state;
    final targetSantriId = ActiveSessionHelper.getActiveLinkedDocId(context);
    String santriName = 'Santri';
    String santriNis = '0';
    String programType = 'reguler';

    santriState.maybeWhen(
      loaded: (list) {
        final found = list.where((s) => s.id == targetSantriId).toList();
        if (found.isNotEmpty) {
          santriName = found.first.nama;
          santriNis = found.first.nis;
          programType = found.first.program == 'T' ? 'takhassus' : 'reguler';
        }
      },
      orElse: () {},
    );

    if (item.category == 'absensi') {
      context.router.push(
        WaliSantriRiwayatAbsensiRoute(
          name: santriName,
          nis: santriNis,
          programType: programType,
        ),
      );
    } else if (item.category == 'hafalan') {
      context.router.push(
        WaliSantriRiwayatHafalanRoute(
          name: santriName,
          nis: santriNis,
        ),
      );
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final authState = context.watch<AuthCubit>().state;
    final role = authState.maybeWhen(
      authenticated: (user) => user.role,
      orElse: () => 'guru',
    );
    final isWaliSantri = role == 'santri' || role == 'wali_santri';

    if (!isWaliSantri &&
        (_selectedCategory == 'absensi' || _selectedCategory == 'hafalan')) {
      _selectedCategory = 'semua';
    }

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    final filtered = _notifications.where((n) {
      if (_selectedCategory == 'semua') return true;
      if (_selectedCategory == 'belum_dibaca') return !n.isRead;
      return n.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar (Uniform with detail_santri_screen) ───────
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 16.w),
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
                    'Pemberitahuan',
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
                  const Spacer(),
                  if (unreadCount > 0)
                    InkWell(
                      onTap: _markAllAsRead,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.done_all_rounded,
                              size: 14.sp,
                              color: colors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Tandai Dibaca',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // ── Category Filter Chips Bar (Role-Based) ─────────────────
            Container(
              color: colors.surface,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Semua', 'semua', null, colors, textTheme),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('Belum Dibaca', 'belum_dibaca',
                        unreadCount, colors, textTheme),
                    if (isWaliSantri) ...[
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                          'Absensi', 'absensi', null, colors, textTheme),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                          'Hafalan', 'hafalan', null, colors, textTheme),
                    ],
                    SizedBox(width: 8.w),
                    _buildCategoryChip(
                        'Sertifikasi', 'sertifikasi', null, colors, textTheme),
                  ],
                ),
              ),
            ),

            // ── Notification Items List ──────────────────────────────
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colors.primary,
                      ),
                    )
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: filtered.isEmpty
                          ? _buildEmptyState(colors, textTheme)
                          : ListView.separated(
                              key: ValueKey<String>(_selectedCategory),
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 12.h),
                              itemCount: filtered.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return _buildNotificationCard(
                                    item, colors, textTheme, isDark);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorSet colors, TextTheme textTheme) {
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
                Icons.notifications_none_rounded,
                size: 32.sp,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Tidak Ada Pemberitahuan',
              style: textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Belum ada notifikasi baru pada kategori ini.',
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

  Widget _buildCategoryChip(
    String label,
    String value,
    int? count,
    AppColorSet colors,
    TextTheme textTheme,
  ) {
    final isSelected = _selectedCategory == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = value;
        });
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.background,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? colors.textOnButton : colors.textSecondary,
              ),
            ),
            if (count != null && count > 0) ...[
              SizedBox(width: 6.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$count',
                  style: textTheme.labelSmall?.copyWith(
                    color: isSelected ? colors.textOnButton : colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    WaliSantriNotificationItem item,
    AppColorSet colors,
    TextTheme textTheme,
    bool isDark,
  ) {
    IconData icon;
    Color iconColor;
    String categoryName;
    switch (item.category) {
      case 'absensi':
        icon = Icons.event_available_rounded;
        iconColor = colors.blue;
        categoryName = 'Absensi';
        break;
      case 'hafalan':
        icon = Icons.menu_book_rounded;
        iconColor = colors.success;
        categoryName = 'Hafalan';
        break;
      case 'sertifikasi':
        icon = Icons.workspace_premium_rounded;
        iconColor = colors.primary;
        categoryName = 'Sertifikasi';
        break;
      default:
        icon = Icons.notifications_rounded;
        iconColor = colors.warning;
        categoryName = 'Umum';
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.6),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => _handleItemTap(item),
          borderRadius: BorderRadius.circular(12.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Unread left accent indicator
                if (!item.isRead)
                  Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        bottomLeft: Radius.circular(12.r),
                      ),
                    ),
                  ),

                // Card Main Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag + Time + Unread Dot
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: iconColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(icon, size: 12.sp, color: iconColor),
                                  SizedBox(width: 4.w),
                                  Text(
                                    categoryName,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: iconColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 11.sp,
                                  color: colors.textSecondary
                                      .withValues(alpha: 0.7),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  _formatTimeAgo(item.timestamp),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colors.textSecondary
                                        .withValues(alpha: 0.8),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                            if (!item.isRead) ...[
                              SizedBox(width: 6.w),
                              Container(
                                width: 7.w,
                                height: 7.w,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 8.h),

                        // Title
                        Text(
                          item.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Message Body
                        Text(
                          item.message,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),

                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Text(
                              item.category == 'absensi'
                                  ? 'Ketuk untuk melihat riwayat absensi'
                                  : item.category == 'hafalan'
                                      ? 'Ketuk untuk melihat riwayat hafalan'
                                      : 'Ketuk untuk melihat detail sertifikasi',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12.sp,
                              color: colors.primary,
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
      ),
    );
  }
}

