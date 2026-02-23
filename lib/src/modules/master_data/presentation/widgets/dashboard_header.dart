import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable dashboard header with greeting and avatar
class DashboardHeader extends StatelessWidget {
  final String greeting;
  final String name;

  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 24.w,
        right: 24.w,
        bottom: 30.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textOnButton.withValues(alpha: 0.9),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textOnButton,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          // Avatar circle
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.textOnButton.withValues(alpha: 0.2),
              border: Border.all(
                color: colors.textOnButton.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              color: colors.textOnButton,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }
}
