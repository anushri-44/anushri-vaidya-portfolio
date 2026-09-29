class Message {
  final String id;
  final String name;
  final String email;
  final String message;
  final String createdAt;

  Message({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}