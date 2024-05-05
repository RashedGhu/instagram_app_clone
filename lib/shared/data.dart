import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';

final List<StoryModel> dummyStories = [
  StoryModel(
    likes: [],
    storyPublishedDate: Timestamp.now(),
    storyID: '',
    userName: 'rashed',
    url:
        'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    mediaType: MediaType.image,
    duration: const Duration(seconds: 10),
    userID: '',
   
  ),
  StoryModel(
    likes: [],
    storyPublishedDate: Timestamp.now(),
    storyID: '',
    userName: 'rashed',
    url: 'https://media.giphy.com/media/moyzrwjUIkdNe/giphy.gif',
    mediaType: MediaType.image,
    userID: '',
    duration: const Duration(seconds: 7),
  ),
  StoryModel(
    likes: [],
    storyPublishedDate: Timestamp.now(),
    storyID: '',
    userName: 'rashed',
    url:
        'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
    mediaType: MediaType.video,
    duration: const Duration(seconds: 0),
    userID: '',
  ),
  StoryModel(
    likes: [],
    storyPublishedDate: Timestamp.now(),
    storyID: '',
    userName: 'rashed',
    url:
        'https://images.unsplash.com/photo-1531694611353-d4758f86fa6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
    mediaType: MediaType.image,
    duration: const Duration(seconds: 5),
    userID: '',
  ),
  StoryModel(
    likes: [],
    storyPublishedDate: Timestamp.now(),
    storyID: '',
    userName: 'rashed',
    url:
        'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
    mediaType: MediaType.video,
    duration: const Duration(seconds: 0),
    userID: '',
  ),
  StoryModel(
    likes: [],
    storyPublishedDate: Timestamp.now(),
    storyID: '',
    userName: 'rashed',
    url: 'https://media2.giphy.com/media/M8PxVICV5KlezP1pGE/giphy.gif',
    mediaType: MediaType.image,
    duration: const Duration(seconds: 8),
    userID: '',
  ),
];
