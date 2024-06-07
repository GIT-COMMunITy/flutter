class Post {
  final String id;
  final String title;
  final String content;
  final String username;
  final String imageUrl;
  final DateTime date;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.username,
    required this.imageUrl,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      username: json['username'],
      imageUrl: json['imageUrl'],
      date: DateTime.parse(json['date']),
    );
  }
}
