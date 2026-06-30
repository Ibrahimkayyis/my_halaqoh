import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

/// Tile widget for a single [ActivityLogModel] entry in [ActivityLogScreen].
///
/// Shows: colored avatar with initials | user name + description | relative timestamp | role badge.
class ActivityLogTile extends StatelessWidget {
  const ActivityLogTile({super.key, required this.log});

  final ActivityLogModel log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleColor = _roleColor(log.userRole);
    final actionIcon = _actionIcon(log.action);
    final initials = _initials(log.userName);
    final timeStr = _formatTime(log.createdAt);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18.r,
            backgroundColor: roleColor.withValues(alpha: 0.15),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: roleColor,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        log.userName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    // Role badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                        border:
                            Border.all(color: roleColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        log.userRole,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: roleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(actionIcon, size: 12.r,
                        color: theme.textTheme.bodySmall?.color),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        log.description ??
                            '${log.action} • ${log.module}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: theme.textTheme.bodyMedium?.color,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
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
      'create' => Icons.add_circle_outline_rounded,
      'update' => Icons.edit_outlined,
      'delete' => Icons.delete_outline_rounded,
      'save_absensi' => Icons.check_circle_outline_rounded,
      'sync_absensi' => Icons.sync_rounded,
      'add_hafalan' => Icons.menu_book_outlined,
      'sync_hafalan' => Icons.sync_rounded,
      _ => Icons.info_outline_rounded,
    };
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('d MMM yyyy, HH:mm', 'id').format(dt);
  }
}
