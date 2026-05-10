import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ForgotPasswordBottomSheet(),
    );
  }

  @override
  State<ForgotPasswordBottomSheet> createState() => _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final _nipController = TextEditingController();

  @override
  void dispose() {
    _nipController.dispose();
    super.dispose();
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final nip = _nipController.text.trim();
    if (nip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Harap isi NIP/NIS Anda terlebih dahulu.',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColors.of(context).error,
        ),
      );
      return;
    }

    final String message = "Assalamu'alaikum Admin, saya memohon bantuan untuk mereset password akun MyHalaqoh saya. NIP/NIS: $nip";

    final Uri whatsappUri;
    if (Platform.isAndroid) {
      whatsappUri = Uri.parse("whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
    } else {
      whatsappUri = Uri.parse("https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
    }

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        if (mounted) {
          Navigator.pop(context); // Close the bottom sheet on success
        }
      } else {
        // Fallback to web link if WhatsApp app is not installed
        final Uri webUri = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          throw 'Could not launch WhatsApp';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Gagal membuka WhatsApp. Pastikan WhatsApp terinstal di perangkat Anda.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: AppColors.of(context).error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h + bottomInsets),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lupa Password?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: colors.textSecondary, size: 24.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Untuk keamanan, fitur reset password hanya dapat dilakukan oleh Administrator. Masukkan NIP/NIS Anda dan hubungi Admin via WhatsApp.',
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'NIP / NIS',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _nipController,
            decoration: InputDecoration(
              hintText: 'Masukkan NIP/NIS Anda...',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary.withValues(alpha: 0.5),
                fontFamily: 'Poppins',
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: colors.textSecondary,
                size: 20.sp,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.border),
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.primary),
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 32.h),
          PrimaryButton(
            width: double.infinity,
            height: 50.h,
            onPressed: () => _openWhatsApp("+6285850132215"),
            label: 'HUBUNGI ADMIN 1',
            borderRadius: 14.r,
          ),
          SizedBox(height: 12.h),
          CustomOutlinedButton(
            width: double.infinity,
            height: 50.h,
            onPressed: () => _openWhatsApp("+6281334885528"),
            label: 'HUBUNGI ADMIN 2',
            borderRadius: 14.r,
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
