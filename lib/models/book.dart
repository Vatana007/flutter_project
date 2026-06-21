class Book {
  final String key;
  final String title;
  final List<String> authors;
  final String? coverUrl;
  final int? publishYear;
  final List<String> subjects;

  const Book({
    required this.key,
    required this.title,
    required this.authors,
    this.coverUrl,
    this.publishYear,
    required this.subjects,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Extract authors safely
    final List<String> authorList = [];
    if (json['authors'] != null && json['authors'] is List) {
      for (var author in json['authors']) {
        if (author is Map && author['name'] != null) {
          authorList.add(author['name'] as String);
        }
      }
    }

    // Extract cover URL safely (using cover_id)
    String? coverImage;
    if (json['cover_id'] != null) {
      final coverId = json['cover_id'].toString();
      coverImage = 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    }

    // Extract subjects safely
    final List<String> subjectList = [];
    if (json['subject'] != null && json['subject'] is List) {
      for (var sub in json['subject']) {
        if (sub is String) {
          subjectList.add(sub);
        }
      }
    }

    return Book(
      key: json['key'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      authors: authorList.isNotEmpty ? authorList : ['Unknown Author'],
      coverUrl: coverImage,
      publishYear: json['first_publish_year'] as int?,
      subjects: subjectList,
    );
  }
}
