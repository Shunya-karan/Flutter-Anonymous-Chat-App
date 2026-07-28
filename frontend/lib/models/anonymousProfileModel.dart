class AnonymousProfileModel {
  final String displayName;
  final String avatar;

  const AnonymousProfileModel({
    required this.displayName,
    required this.avatar,
  });

  factory AnonymousProfileModel.fromJson(
      Map<String, dynamic> json) {
    return AnonymousProfileModel(
      displayName: json["displayName"],
      avatar: json["avatar"],
    );
  }
}