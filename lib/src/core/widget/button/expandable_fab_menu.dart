import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Data model for an action item in the expandable FAB.
class ExpandableFabItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ExpandableFabItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// An expandable floating action button menu using `flutter_expandable_fab`.
class ExpandableFabMenu extends StatelessWidget {
  static FloatingActionButtonLocation get location => ExpandableFab.location;

  final GlobalKey<ExpandableFabState>? fabKey;
  final List<ExpandableFabItem> items;
  final EdgeInsets? margin;

  const ExpandableFabMenu({
    super.key,
    this.fabKey,
    required this.items,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ExpandableFab(
      key: fabKey,
      type: ExpandableFabType.up,
      distance: 60.h,
      pos: ExpandableFabPos.right,
      margin: margin ?? const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 250),
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 2.0,
        color: Colors.black.withValues(alpha: 0.35),
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.grid_view_rounded, color: Colors.white),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: colors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: Icon(Icons.close_rounded, color: colors.textPrimary),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: colors.textPrimary,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: colors.border.withValues(alpha: 0.8),
            width: 1.2,
          ),
        ),
      ),
      children: items.map((item) => _buildActionButton(context, colors, item)).toList(),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    AppColorSet colors,
    ExpandableFabItem item,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              fabKey?.currentState?.toggle();
              item.onTap();
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: colors.border.withValues(alpha: 0.6),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: colors.surface,
          foregroundColor: colors.primary,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: colors.border.withValues(alpha: 0.6),
              width: 0.8,
            ),
          ),
          onPressed: () {
            fabKey?.currentState?.toggle();
            item.onTap();
          },
          child: Icon(item.icon, size: 18.sp, color: colors.primary),
        ),
      ],
    );
  }
}
