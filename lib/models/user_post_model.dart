import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostModel {
  String? userName;
  String? uID;
  String? postID;
  String? description;
  Timestamp? publishedDate;
  String? postPhotoUrl;
  String? profileImage;
  List? likes;
  int? commentsCount;
  bool isLiked = false; 

  UserPostModel({
    required this.description,
    required this.likes,
    required this.postPhotoUrl,
    required this.profileImage,
    required this.publishedDate,
    required this.uID,
    required this.userName,
    required this.postID,
    required this.commentsCount,
    this.isLiked = false  , 
  });

  UserPostModel.getJson(Map<String, dynamic> jsonData) {
    userName = jsonData['userName'];
    uID = jsonData['uID'];
    postID = jsonData['postID'];
    uID = jsonData['uID'];
    description = jsonData['description'];
    publishedDate = jsonData['publishedDate'];
    profileImage = jsonData['profileImage'];
    postPhotoUrl = jsonData['postPhotoUrl'];
    likes = jsonData['likes'];
    commentsCount = jsonData['commentsCount'];
  }

  Map<String, dynamic> sendJson() {
    return {
      'userName': userName,
      'uID': uID,
      'description': description,
      'postID': postID,
      'publishedDate': publishedDate,
      'postPhotoUrl': postPhotoUrl,
      'profileImage': profileImage,
      'likes': likes,
      'commentsCount': commentsCount,
    };
  }
}
