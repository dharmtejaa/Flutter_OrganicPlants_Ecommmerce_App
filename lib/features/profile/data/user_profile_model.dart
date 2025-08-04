class UserProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String? fcmToken;
  final String profileImageUrl;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.fcmToken,
    required this.profileImageUrl,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfileModel(
      uid: uid,
      fullName: map['fullName'] ?? 'Plant Lover',
      email: map['email'] ?? '',
      fcmToken: map['fcmToken'],
      profileImageUrl:
          map['profileImageUrl'] ??
          'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753501304/Sprout_head_empty_pfp_eakz4j.jpg',
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'fcmToken': fcmToken,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  UserProfileModel copyWith({
    String? fullName,
    String? fcmToken,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserProfileModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email,
      fcmToken: fcmToken ?? this.fcmToken,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
    );
  }
}
