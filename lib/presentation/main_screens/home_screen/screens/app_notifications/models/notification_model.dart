class MyNotificationModel {
  final String? image;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  final bool isRead;

  MyNotificationModel({
    this.image,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.isRead,
  });

  factory MyNotificationModel.fromMap(Map<String, dynamic> map) {
    return MyNotificationModel(
      image: map['image'],
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      isRead: map['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'subtitle': subtitle,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}
