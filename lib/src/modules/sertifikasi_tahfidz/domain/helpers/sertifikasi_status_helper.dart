import 'package:flutter/material.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Helper for Sertifikasi Tahfidz status, badges, predicates, and styling.
class SertifikasiStatusHelper {
  const SertifikasiStatusHelper._();

  static const String statusPending = 'pending';
  static const String statusScheduled = 'scheduled';
  static const String statusRejected = 'rejected';
  static const String statusPassed = 'passed';
  static const String statusFailed = 'failed';

  /// Returns localized/Indonesian human-readable status label.
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case statusPending:
        return 'Menunggu Persetujuan';
      case statusScheduled:
        return 'Terjadwal';
      case statusRejected:
        return 'Ditolak';
      case statusPassed:
        return 'Lulus Sertifikasi';
      case statusFailed:
        return 'Perlu Mengulang';
      default:
        return status;
    }
  }

  /// Returns background color for status pill/chip.
  static Color getStatusBgColor(String status, BuildContext context) {
    final colors = AppColors.of(context);
    switch (status.toLowerCase()) {
      case statusPending:
        return colors.warning.withValues(alpha: 0.12);
      case statusScheduled:
        return colors.blue.withValues(alpha: 0.12);
      case statusPassed:
        return colors.success.withValues(alpha: 0.12);
      case statusRejected:
      case statusFailed:
        return colors.error.withValues(alpha: 0.12);
      default:
        return colors.border.withValues(alpha: 0.2);
    }
  }

  /// Returns text & icon color for status pill/chip.
  static Color getStatusFgColor(String status, BuildContext context) {
    final colors = AppColors.of(context);
    switch (status.toLowerCase()) {
      case statusPending:
        return colors.warning;
      case statusScheduled:
        return colors.blue;
      case statusPassed:
        return colors.success;
      case statusRejected:
      case statusFailed:
        return colors.error;
      default:
        return colors.textSecondary;
    }
  }

  /// Returns associated icon for the status.
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case statusPending:
        return Icons.hourglass_top_rounded;
      case statusScheduled:
        return Icons.event_available_rounded;
      case statusPassed:
        return Icons.verified_rounded;
      case statusRejected:
        return Icons.cancel_outlined;
      case statusFailed:
        return Icons.replay_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  /// Determines predicate based on total score (0 - 100 scale).
  static String calculatePredikat(double score) {
    if (score >= 90.0) return 'Mumtaz (Istimewa)';
    if (score >= 80.0) return 'Jayyid Jiddan (Sangat Baik)';
    if (score >= 70.0) return 'Jayyid (Baik)';
    if (score >= 60.0) return 'Maqbul (Cukup)';
    return 'Rasib (Kurang)';
  }
}
