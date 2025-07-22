class AppNewsModel {
  final DateTime createdAt;
  final String image;
  final String title;
  final String description;

  AppNewsModel({
    required this.createdAt,
    required this.image,
    required this.title,
    required this.description,
  });

  factory AppNewsModel.fromMap(Map<String, dynamic> map) {
    return AppNewsModel(
      createdAt: DateTime.parse(map['created_at']),
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt.toIso8601String(),
      'image': image,
      'title': title,
      'description': description,
    };
  }
}
