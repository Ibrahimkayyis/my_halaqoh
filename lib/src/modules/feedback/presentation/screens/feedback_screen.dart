import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/button/primary_button.dart';
import 'package:my_halaqoh/src/core/widget/input/app_text_field.dart';
import '../cubits/feedback_cubit.dart';
import '../cubits/feedback_state.dart';
import '../widgets/feedback_attachment_picker.dart';
import '../widgets/feedback_category_selector.dart';
import '../widgets/feedback_success_sheet.dart';

/// Screen allowing users (Guru, Wali Santri, Admin) to submit feedback or bug reports.
///
/// Designed with strict adherence to MyHalaqoh Design System (MASTER.md)
/// and ui-ux-pro-max ergonomic patterns:
/// - `colors.primaryGradient` Hero header
/// - 4dp spacing multiplier (`8.w`, `12.h`, `16.h`, `20.w`)
/// - Adaptive `shadow.sm` in light mode and subtle border in dark mode
/// - Live character counting and inline error feedback
/// - Live dynamic device info detection badge
/// - Ergonomic bottom action bar for thumb-friendly submission
@RoutePage()
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'bug';
  List<String> _attachmentFilePaths = [];

  String? _titleError;
  String? _descError;

  String _deviceSummary = 'Memuat info perangkat...';

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String model = 'Perangkat Mobile';
      String os = 'Android';

      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        model = '${info.manufacturer} ${info.model}';
        os = 'Android ${info.version.release}';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        model = info.utsname.machine;
        os = '${info.systemName} ${info.systemVersion}';
      }

      String version = '1.0.0';
      try {
        final pkg = await PackageInfo.fromPlatform();
        version = 'v${pkg.version}+${pkg.buildNumber}';
      } catch (_) {}

      if (mounted) {
        setState(() {
          _deviceSummary = '$model • $os • $version';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _deviceSummary = 'Android • v1.0.0';
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(BuildContext context) {
    setState(() {
      _titleError = null;
      _descError = null;
    });

    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    bool isValid = true;

    if (title.isEmpty || title.length < 5) {
      _titleError = t.feedback.validasiJudul;
      isValid = false;
    }

    if (desc.isEmpty || desc.length < 10) {
      _descError = t.feedback.validasiDeskripsi;
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    context.read<FeedbackCubit>().submit(
          category: _selectedCategory,
          title: title,
          description: desc,
          attachmentFilePaths: _attachmentFilePaths,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fb = t.feedback;

    return BlocProvider(
      create: (_) => sl<FeedbackCubit>(),
      child: BlocConsumer<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              FeedbackSuccessSheet.show(context);
            },
            failure: (errorMsg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    fb.errorSubmit(error: errorMsg),
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  backgroundColor: colors.error,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          final isSubmitting = state.maybeWhen(
            submitting: (current, total) => true,
            orElse: () => false,
          );

          String buttonLabel = fb.kirimButton;
          state.whenOrNull(
            submitting: (current, total) {
              if (total > 0 && current > 0) {
                buttonLabel = fb.uploadingImages(
                  current: current.toString(),
                  total: total.toString(),
                );
              } else {
                buttonLabel = fb.submitting;
              }
            },
          );

          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(
              backgroundColor: colors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                fb.title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Subtitle Info Banner ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(
                        alpha: isDark ? 0.15 : 0.06,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: colors.primary.withValues(
                          alpha: isDark ? 0.3 : 0.15,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18.sp,
                          color: colors.primary,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            fb.subtitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── 1. Kategori Section (No card-in-card nesting) ──
                  Text(
                    fb.kategori,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  FeedbackCategorySelector(
                    selectedCategory: _selectedCategory,
                    onSelected: (cat) {
                      setState(() => _selectedCategory = cat);
                    },
                  ),
                  SizedBox(height: 16.h),

                  // ── 2. Detail Masukan Card ──
                  _buildCard(
                    colors: colors,
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              fb.judulLabel,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '${_titleController.text.length}/80',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        AppTextField(
                          controller: _titleController,
                          hintText: fb.judulHint,
                          errorText: _titleError,
                          prefixIconData: Icons.edit_note_rounded,
                          enabled: !isSubmitting,
                          onChanged: (_) => setState(() {
                            if (_titleError != null) {
                              _titleError = null;
                            }
                          }),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              fb.deskripsiLabel,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '${_descController.text.length}/1000',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        AppTextField(
                          controller: _descController,
                          hintText: fb.deskripsiHint,
                          errorText: _descError,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          enabled: !isSubmitting,
                          onChanged: (_) => setState(() {
                            if (_descError != null) {
                              _descError = null;
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── 3. Lampiran Card ──
                  _buildCard(
                    colors: colors,
                    isDark: isDark,
                    child: FeedbackAttachmentPicker(
                      filePaths: _attachmentFilePaths,
                      onChanged: (newPaths) {
                        setState(() => _attachmentFilePaths = newPaths);
                      },
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // ── 4. Device Info Notice Card ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isDark
                            ? colors.border
                            : colors.border.withValues(alpha: 0.7),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phonelink_setup_rounded,
                          color: colors.textSecondary,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _deviceSummary,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                fb.deviceInfoNotice,
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  top: BorderSide(
                    color: colors.border.withValues(alpha: 0.7),
                    width: 1,
                  ),
                ),
                boxShadow: !isDark
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ]
                    : null,
              ),
              child: SafeArea(
                child: PrimaryButton(
                  width: double.infinity,
                  height: 48.h,
                  label: buttonLabel,
                  isLoading: isSubmitting,
                  icon: Icons.send_rounded,
                  onPressed: isSubmitting
                      ? null
                      : () => _validateAndSubmit(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required AppColorSet colors,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.7),
          width: isDark ? 0.5 : 1.0,
        ),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
