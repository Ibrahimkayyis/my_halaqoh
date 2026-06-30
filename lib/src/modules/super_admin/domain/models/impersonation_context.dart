/// Holds the active impersonation context when a super admin is operating
/// as another role.
///
/// This is a plain Dart class — intentionally NOT @freezed and NOT Hive-cached.
/// It only lives in memory for the duration of the impersonation session.
class ImpersonationContext {
  const ImpersonationContext({
    required this.targetRole,
    this.linkedDocId,
    this.displayName,
    this.programType,
  });

  /// The role being impersonated: `'admin'` | `'guru'` | `'santri'`
  final String targetRole;

  /// Firestore doc ID in `/guru` or `/santri` collection.
  /// `null` when impersonating admin.
  final String? linkedDocId;

  /// Human-readable name of the guru / santri being impersonated.
  /// `null` when impersonating admin.
  final String? displayName;

  /// Program type code (`'R'` or `'T'`).
  /// `null` when impersonating admin.
  final String? programType;
}
