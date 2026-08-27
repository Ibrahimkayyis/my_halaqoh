class WaliSantriNotificationItem {
  final String id;
  final String title;
  final String message;
  final String category; // 'absensi' | 'hafalan'
  final DateTime timestamp;
  bool isRead;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? metadata;

  WaliSantriNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timestamp,
    this.isRead = false,
    this.entityType,
    this.entityId,
    this.metadata,
  });

  WaliSantriNotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? category,
    DateTime? timestamp,
    bool? isRead,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? metadata,
  }) {
    return WaliSantriNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      metadata: metadata ?? this.metadata,
    );
  }
}
