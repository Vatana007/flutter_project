class CampusEvent {
  final String id;
  final String title;
  final String category; // 'academic', 'sports', 'social', 'workshop'
  final String content;
  final String imageUrl;
  final String date;
  final int rsvpCount;
  final bool isRegistered;

  const CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.rsvpCount,
    this.isRegistered = false,
  });

  CampusEvent copyWith({
    String? id,
    String? title,
    String? category,
    String? content,
    String? imageUrl,
    String? date,
    int? rsvpCount,
    bool? isRegistered,
  }) {
    return CampusEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      rsvpCount: rsvpCount ?? this.rsvpCount,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }

  factory CampusEvent.fromJson(Map<String, dynamic> json) {
    return CampusEvent(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'academic',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400',
      date: json['date'] ?? '',
      rsvpCount: json['rsvpCount'] as int? ?? 0,
      isRegistered: json['isRegistered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'imageUrl': imageUrl,
      'date': date,
      'rsvpCount': rsvpCount,
      'isRegistered': isRegistered,
    };
  }
}
