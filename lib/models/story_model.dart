
import 'package:cloud_firestore/cloud_firestore.dart';

enum MediaType {
  image,
  video,
}

class StoryModel {
  String? url;
  MediaType? mediaType;
  Duration? duration;
  String? storyID;
  String? userName;
  String? userID;
  Timestamp? storyPublishedDate;
  List<dynamic>? likes;

  StoryModel({
    required this.storyPublishedDate,
    required this.duration,
    required this.mediaType,
    required this.url,
    required this.userID,
    required this.storyID,
    required this.userName,
    required this.likes,
  });

  Map<String, dynamic> sendJson() {
    return {
      'url': url,
      'media': mediaType!.name,
      'duration': duration!.inSeconds,
      'storyID': storyID,
      'userName': userName,
      'userID': userID,
      'storyPublishedDate': storyPublishedDate,
      'likes': likes,
    };
  }

  StoryModel.getJson(Map<String, dynamic> jsonData) {
    // this.duration = jsonData['duration'] as Duration;
    // this.mediaType = jsonData['mediaType'] as MediaType;
    this.duration = Duration(seconds: 10);
    this.likes = jsonData['likes'];
    this.mediaType = MediaType.image;
    this.storyID = jsonData['storyID'];
    this.storyPublishedDate = jsonData['storyPublishedDate'];
    this.url = jsonData['url'];
    this.userName = jsonData['userName'];
    this.userID = jsonData['userID'];
  }
}
