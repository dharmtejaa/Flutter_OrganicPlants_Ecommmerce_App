class FeedbackModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String message;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.message,
    required this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String id) {
    return FeedbackModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      message: map['message'] ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? message,
    DateTime? createdAt,
    String? status,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
