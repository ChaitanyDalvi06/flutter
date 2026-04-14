class Book {
  String id;
  String title;
  String authorName;
  String genre;
  String price;
  String publishedYear;
  String createdDate;

  Book({
    required this.id,
    required this.title,
    required this.authorName,
    required this.genre,
    required this.price,
    required this.publishedYear,
    required this.createdDate,
  });

  factory Book.fromJson(Map<String, dynamic> map) {
    return Book(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      authorName: map['authorName']?.toString() ?? '',
      genre: map['genre']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      publishedYear: map['publishedYear']?.toString() ?? '',
      createdDate: map['createdDate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'title': title,
      'authorName': authorName,
      'genre': genre,
      'price': price,
      'publishedYear': publishedYear,
      'createdDate': createdDate,
    };
    if (id.isNotEmpty) {
      json['_id'] = id;
    }
    return json;
  }
}
