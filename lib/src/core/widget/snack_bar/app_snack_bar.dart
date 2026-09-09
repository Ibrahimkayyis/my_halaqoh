import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Semantic types supported by [AppSnackBar].
enum AppSnackBarType {
  success,
  error,
  warning,
  info,
}

/// A modern, professional floating SnackBar component adhering to
/// MyHalaqoh design system (`design-system/myhalaqoh/MASTER.md`) and
/// `ui-ux-pro-max` guidelines.
///
/// Features:
/// - Floating elevated surface card with subtle accent glow and border
/// - Semantic left accent strip and tinted squircle icon badge
/// - Bundled Poppins typography with clear visual hierarchy
/// - Tactile haptic feedback on presentation
/// - Interactive dismiss button and horizontal swipe dismiss
/// - Theme-aware styling (light & dark mode)
class AppSnackBar {
  AppSnackBar._();

  /// Displays a floating [AppSnackBar] on the screen.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppSnackBarType type = AppSnackBarType.info,
    Duration? duration,
    ScaffoldMessengerState? messenger,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // ── Haptic Feedback ──────────────────────────────────────────────────────
    switch (type) {
      case AppSnackBarType.success:
      case AppSnackBarType.info:
        HapticFeedback.lightImpact();
        break;
      case AppSnackBarType.warning:
      case AppSnackBarType.error:
        HapticFeedback.mediumImpact();
        break;
    }

    final targetMessenger = messenger ?? ScaffoldMessenger.of(context);
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedDuration = duration ??
        (type == AppSnackBarType.error
            ? const Duration(seconds: 4)
            : const Duration(seconds: 3));

    // Clear any current snackbar to prevent sluggish stacking queues
    targetMessenger.hideCurrentSnackBar();

    targetMessenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
        ),
        duration: resolvedDuration,
        dismissDirection: DismissDirection.horizontal,
        content: _AppSnackBarCard(
          message: message,
          title: title,
          type: type,
          colors: colors,
          isDark: isDark,
          onDismiss: () => targetMessenger.hideCurrentSnackBar(),
          onAction: onAction,
          actionLabel: actionLabel,
        ),
      ),
    );
  }

  /// Convenience helper to display a success SnackBar.
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    ScaffoldMessengerState? messenger,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.success,
      duration: duration,
      messenger: messenger,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Convenience helper to display an error SnackBar.
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    ScaffoldMessengerState? messenger,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.error,
      duration: duration,
      messenger: messenger,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Convenience helper to display a warning SnackBar.
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    ScaffoldMessengerState? messenger,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.warning,
      duration: duration,
      messenger: messenger,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Convenience helper to display an info SnackBar.
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    ScaffoldMessengerState? messenger,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.info,
      duration: duration,
      messenger: messenger,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }
}

/// Visual card content for [AppSnackBar].
class _AppSnackBarCard extends StatelessWidget {
  const _AppSnackBarCard({
    required this.message,
    required this.type,
    required this.colors,
    required this.isDark,
    required this.onDismiss,
    this.title,
    this.onAction,
    this.actionLabel,
  });

  final String message;
  final String? title;
  final AppSnackBarType type;
  final AppColorSet colors;
  final bool isDark;
  final VoidCallback onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  Color _getAccentColor() {
    switch (type) {
      case AppSnackBarType.success:
        // Use brand primary color (#115D69) as defined in colors.xml & MASTER.md
        return colors.primary;
      case AppSnackBarType.error:
        return colors.red;
      case AppSnackBarType.warning:
        return colors.yellow;
      case AppSnackBarType.info:
        return colors.blue;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case AppSnackBarType.success:
        return Icons.check_circle_rounded;
      case AppSnackBarType.error:
        return Icons.error_rounded;
      case AppSnackBarType.warning:
        return Icons.warning_rounded;
      case AppSnackBarType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    final iconData = _getIcon();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        // MASTER.md token: radius.sm (8.r) for snackbar
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors.border,
          width: isDark ? 0.5 : 1,
        ),
        boxShadow: isDark
            ? null
            : [
                // MASTER.md token: shadow.md for elevated overlays
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left Accent Indicator Bar (4.w) ───────────────────────────
              Container(
                width: 4.w,
                color: accentColor,
              ),

              // ── Card Main Content ──────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      // ── Tinted Squircle Icon Badge ─────────────────────────
                      Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          iconData,
                          size: 18.sp,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // ── Text Column (Title + Message) ──────────────────────
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null) ...[
                              Text(
                                title!,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                            Text(
                              message,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                                fontWeight: title != null
                                    ? FontWeight.w400
                                    : FontWeight.w500,
                                color: title != null
                                    ? colors.textSecondary
                                    : colors.textPrimary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Optional Action Button or Dismiss Icon ─────────────
                      if (onAction != null && actionLabel != null) ...[
                        SizedBox(width: 8.w),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            minimumSize: Size(0, 32.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            onDismiss();
                            onAction!();
                          },
                          child: Text(
                            actionLabel!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(width: 8.w),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onDismiss,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.04),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16.sp,
                              color: colors.textSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
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
}
