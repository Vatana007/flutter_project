class AppNotification {
  final int id;
  final String title;
  final String message;
  final String timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? '',
      message: json['body'] ?? json['message'] ?? '',
      timestamp: json['timestamp'] ?? 'Just now',
      isRead: json['isRead'] ?? false,
    );
  }

  void markAsRead() {
    isRead = true;
  }
}
