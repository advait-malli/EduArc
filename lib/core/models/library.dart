class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final int totalCopies;
  final int availableCopies;

  LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.totalCopies,
    required this.availableCopies,
  });

  bool get isAvailable => availableCopies > 0;

  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    return LibraryBook(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      category: json['category'] ?? '',
      totalCopies: json['totalCopies'] ?? 0,
      availableCopies: json['availableCopies'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'category': category,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
    };
  }
}

class LibraryRecord {
  final String id;
  final String bookId;
  final String bookTitle;
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final String status;

  LibraryRecord({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.issueDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
  });

  bool get isOverdue => status == 'Overdue' || (status == 'Issued' && DateTime.now().isAfter(dueDate));
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;

  factory LibraryRecord.fromJson(Map<String, dynamic> json) {
    return LibraryRecord(
      id: json['id'] ?? '',
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      issueDate: DateTime.parse(json['issueDate']),
      dueDate: DateTime.parse(json['dueDate']),
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
      status: json['status'] ?? 'Issued',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'status': status,
    };
  }
}
