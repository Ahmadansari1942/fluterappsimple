class Article {
  final int id;
  final String title;
  final String category;
  final String content;
  final String author;
  final String? imageUrl;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.author,
    this.imageUrl,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      content: json['content'],
      author: json['author'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'author': author,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
