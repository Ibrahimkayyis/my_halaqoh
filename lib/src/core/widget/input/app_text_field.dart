import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable Form Input Field conforming to MyHalaqoh Design System (MASTER.md).
///
/// Features:
/// - Standard OutlineInputBorder with `radius.sm` (8.r).
/// - Inline error text support with semantic styling.
/// - Built-in password visibility toggle if [isPassword] is true.
/// - Optional top label or decoration label with Poppins typography.
/// - Light/Dark theme compatibility via [AppColors].
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final IconData? prefixIconData;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final int maxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.prefixIconData,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword) {
      _obscureText = widget.isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    Widget? effectivePrefix;
    if (widget.prefixIcon != null) {
      effectivePrefix = widget.prefixIcon;
    } else if (widget.prefixIconData != null) {
      effectivePrefix = Icon(
        widget.prefixIconData,
        color: widget.errorText != null ? colors.error : colors.textSecondary,
        size: 20.sp,
      );
    }

    Widget? effectiveSuffix;
    if (widget.isPassword) {
      effectiveSuffix = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: colors.textSecondary,
          size: 20.sp,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      effectiveSuffix = widget.suffixIcon;
    }

    final borderRadius = BorderRadius.circular(8.r);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: textTheme.titleSmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  letterSpacing: 0.3,
                ) ??
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 0.3,
                  fontFamily: 'Poppins',
                ),
          ),
          SizedBox(height: 6.h),
        ],
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          style: textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
                fontSize: 14.sp,
              ) ??
              TextStyle(
                fontSize: 14.sp,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 13.sp,
                ) ??
                TextStyle(
                  fontSize: 13.sp,
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontFamily: 'Poppins',
                ),
            errorText: widget.errorText,
            errorMaxLines: 2,
            errorStyle: textTheme.bodySmall?.copyWith(
                  color: colors.error,
                  fontSize: 11.sp,
                ) ??
                TextStyle(
                  fontSize: 11.sp,
                  color: colors.error,
                  fontFamily: 'Poppins',
                ),
            prefixIcon: effectivePrefix,
            suffixIcon: effectiveSuffix,
            filled: true,
            fillColor: colors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: colors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: colors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: colors.border.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
