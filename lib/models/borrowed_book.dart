class BorrowedBook {
  final String bookKey;
  final String title;
  final List<String> authors;
  final String borrowDate;
  final String dueDate;
  final String status; // 'active', 'returned', 'overdue'

  const BorrowedBook({
    required this.bookKey,
    required this.title,
    required this.authors,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
  });

  BorrowedBook copyWith({
    String? bookKey,
    String? title,
    List<String>? authors,
    String? borrowDate,
    String? dueDate,
    String? status,
  }) {
    return BorrowedBook(
      bookKey: bookKey ?? this.bookKey,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      borrowDate: borrowDate ?? this.borrowDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      bookKey: json['bookKey'] ?? '',
      title: json['title'] ?? '',
      authors: (json['authors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      borrowDate: json['borrowDate'] ?? '',
      dueDate: json['dueDate'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookKey': bookKey,
      'title': title,
      'authors': authors,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'status': status,
    };
  }
}
