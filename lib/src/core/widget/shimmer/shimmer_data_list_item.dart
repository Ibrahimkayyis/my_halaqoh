import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton yang merepresentasikan satu baris item di [DataListItem].
///
/// Layout:
/// ```
/// ┌────────────────────────────────────────────┐
/// │ [■■■■■■■■] ← NIS (pendek)      [■■■] [□□□]│
/// │ [■■■■■■■■■■■■■] ← Nama         icon icons  │
/// └────────────────────────────────────────────┘
/// ```
/// Kolom kiri: 2 baris (id pendek + nama lebih panjang)
/// Kolom tengah: badge kelas
/// Kolom kanan: 3 icon placeholder (edit, reset, delete)
///
/// Gunakan di dalam [ListView.builder] saat state loading:
/// ```dart
/// loading: () => ListView.builder(
///   itemCount: 7,
///   itemBuilder: (_, __) => const ShimmerDataListItem(),
/// ),
/// ```
class ShimmerDataListItem extends StatelessWidget {
  const ShimmerDataListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.12),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Kolom identitas (flex: 3 mengikuti DataListItem) ──────────
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NIS — pendek
                ShimmerBox(width: 80.w, height: 12.h, radius: 6.r),
                SizedBox(height: 6.h),
                // Nama — lebih panjang
                ShimmerBox(width: 130.w, height: 14.h, radius: 6.r),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // ── Badge kelas (kotak kecil) ─────────────────────────────────
          ShimmerBox(width: 38.w, height: 24.h, radius: 6.r),

          SizedBox(width: 12.w),

          // ── Icon edit ─────────────────────────────────────────────────
          ShimmerBox(width: 20.w, height: 20.h, radius: 4.r),
          SizedBox(width: 8.w),

          // ── Icon reset password ───────────────────────────────────────
          ShimmerBox(width: 20.w, height: 20.h, radius: 4.r),
          SizedBox(width: 8.w),

          // ── Icon delete ───────────────────────────────────────────────
          ShimmerBox(width: 20.w, height: 20.h, radius: 4.r),
        ],
      ),
    );
  }
}
