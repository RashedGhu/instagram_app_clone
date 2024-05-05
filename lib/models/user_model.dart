class UserModel {
  String? userName;
  String? email;
  String? bio;
  String? uID;
  String? profileImage;
  List? followers;
  List? following;

  UserModel({
    required this.bio,
    required this.email,
    required this.profileImage,
    required this.userName,
    required this.followers,
    required this.following,
    required this.uID,
  });

  UserModel.getJson(Map<String, dynamic> jsonData) {
    userName = jsonData['userName'];
    email = jsonData['email'];
    bio = jsonData['bio'];
    uID = jsonData['uID'];
    profileImage = jsonData['profileImage'];
    followers = jsonData['followers'];
    following = jsonData['following'];
  }

  Map<String, dynamic> sendJson() {
    return {
      'userName': userName,
      'email': email,
      'bio': bio,
      'uID': uID,
      'profileImage': profileImage,
      'followers': followers,
      'following': following,
    };
  }
}
