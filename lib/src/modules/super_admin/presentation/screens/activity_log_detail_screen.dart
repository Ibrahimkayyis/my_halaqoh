import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

@RoutePage()
class ActivityLogDetailScreen extends StatelessWidget {
  const ActivityLogDetailScreen({
    super.key,
    required this.log,
  });

  final ActivityLogModel log;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final roleColor = _roleColor(log.userRole);
    final actionIcon = _actionIcon(log.action);
    final actionBg = roleColor.withValues(alpha: 0.08);
    final timeStr = DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id').format(log.createdAt);

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
                          'Detail Aktivitas',
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

          // ── Detail Cards List ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
              child: Column(
                children: [
                  // Card 1: Ringkasan Aktivitas (Activity Summary)
                  _buildSectionCard(
                    colors: colors,
                    isDark: isDark,
                    child: Column(
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: actionBg,
                          ),
                          child: Icon(
                            actionIcon,
                            color: roleColor,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          log.description ?? '${log.action.toUpperCase()} • ${log.module.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          timeStr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Card 2: Detail Pelaku (Actor Details)
                  _buildSectionCard(
                    colors: colors,
                    isDark: isDark,
                    title: 'Pelaku Aktivitas',
                    icon: Icons.person_outline_rounded,
                    child: Column(
                      children: [
                        _buildDetailRow(colors, 'Nama', log.userName),
                        _buildDetailRow(colors, 'Role', log.userRole.toUpperCase(), isBadge: true, badgeColor: roleColor),
                        _buildDetailRow(colors, 'User ID', log.userId, isCopyable: true, context: context),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Card 3: Detail Objek Terkait (Target Entity Details) - Only show if present
                  if (log.entityId != null || log.entityName != null) ...[
                    _buildSectionCard(
                      colors: colors,
                      isDark: isDark,
                      title: 'Objek Terkait',
                      icon: Icons.layers_outlined,
                      child: Column(
                        children: [
                          if (log.entityName != null)
                            _buildDetailRow(colors, 'Nama Objek', log.entityName!),
                          _buildDetailRow(colors, 'Modul', log.module.toUpperCase()),
                          if (log.entityId != null)
                            _buildDetailRow(colors, 'ID Objek', log.entityId!, isCopyable: true, context: context),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // Card 4: Metadata Tambahan (Additional Context / Payload) - Only show if present
                  if (log.metadata.isNotEmpty) ...[
                    _buildSectionCard(
                      colors: colors,
                      isDark: isDark,
                      title: 'Metadata Tambahan',
                      icon: Icons.data_object_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: log.metadata.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: colors.textSecondary,
                                    fontFamily: 'Poppins',
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${entry.value}',
                                    style: TextStyle(
                                      color: colors.textPrimary,
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required AppColorSet colors,
    required bool isDark,
    String? title,
    IconData? icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && icon != null) ...[
            Row(
              children: [
                Icon(icon, size: 20.sp, color: colors.primary),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
            SizedBox(height: 16.h),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    AppColorSet colors,
    String label,
    String value, {
    bool isBadge = false,
    Color? badgeColor,
    bool isCopyable = false,
    BuildContext? context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: isBadge && badgeColor != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
          ),
          if (isCopyable && context != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label berhasil disalin ke clipboard'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Icon(
                Icons.copy_rounded,
                size: 16.sp,
                color: colors.primary,
              ),
            ),
          ],
        ],
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
}
