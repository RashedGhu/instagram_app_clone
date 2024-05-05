import 'package:cloud_firestore/cloud_firestore.dart';

class UserCommentModel {
  String? uerName;
  String? userProfileImage;
  String? commentDes;
  String? postID;
  String? userID;
  String? commentID;
  Timestamp? commentPublishedDate;
  List? commentLikes;
  List? commentReplies;
  bool showMoreReplies = false;

  UserCommentModel({
    required this.commentID,
    required this.commentDes,
    required this.commentLikes,
    required this.commentPublishedDate,
    required this.commentReplies,
    required this.postID,
    required this.userID,
    required this.uerName,
    required this.userProfileImage,
    showMoreReplies,
  });

  UserCommentModel.getJson(Map<String, dynamic> data) {
    this.commentDes = data['commentDes'];
    this.commentID = data['commentID'];
    this.commentLikes = data['commentLikes'];
    this.commentPublishedDate = data['commentPublishedDate'];
    this.commentReplies = data['commentReplies'];
    this.postID = data['postID'];
    this.uerName = data['uerName'];
    this.userID = data['userID'];
    this.userProfileImage = data['userProfileImage'];
  }

  Map<String, dynamic> sendJson() {
    return {
      'commentDes': commentDes,
      'postID': postID,
      'userID': userID,
      'commentPublishedDate': commentPublishedDate,
      'commentLikes': commentLikes,
      'commentReplies': commentReplies,
      'commentID': commentID,
      'userProfileImage': userProfileImage,
      'uerName': uerName,
    };
  }
}
