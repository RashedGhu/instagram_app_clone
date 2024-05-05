
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentReplyModel {
  String? commentID;
  List? likes;
  Timestamp? publishedDate;
  String? replyDes;
  String? replyID;
  String? userID;
  String? userName;
  String? userProfilePicture;
  String? commentUserName;
  String? postID;

  CommentReplyModel({
    required this.commentID,
    required this.likes,
    required this.publishedDate,
    required this.replyDes,
    required this.replyID,
    required this.userID,
    required this.userName,
    required this.userProfilePicture,
    required this.commentUserName,
    required this.postID,
  });

  CommentReplyModel.getJson(Map<String, dynamic>? data) {
    commentID = data!['commentID'];
    likes = data['likes'];
    publishedDate = data['publishedDate'];
    replyDes = data['replyDes'];
    replyID = data['replyID'];
    userID = data['userID'];
    userName = data['userName'];
    userProfilePicture = data['userProfilePicture'];
    commentUserName = data['commentUserName'];
    postID = data['postID'];
  }

  Map<String, dynamic> sendJson() {
    return {
      'commentID': commentID,
      'likes': likes,
      'publishedDate': publishedDate,
      'replyDes': replyDes,
      'replyID': replyID,
      'userID': userID,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'commentUserName': commentUserName,
      'postID': postID,
    };
  }
}
