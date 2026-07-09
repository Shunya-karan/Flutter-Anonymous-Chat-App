class UserModel{
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? gender;
  final String? profileImage;
  final List<String>interests;


  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.gender,
    this.profileImage,
    required this.interests,
});

  factory UserModel.fromJson(Map<String,dynamic>json){
    return UserModel(
      id: json["_id"],
      username: json["username"],
      email: json["email"],
      bio: json["bio"],
      gender: json["gender"],
      profileImage: json["profileImage"],
      interests: List<String>.from(json["interests"]??[]
      )
    );
  }
}