import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../models/story_model.dart';
import '../../shared/shared_functions.dart';
import '../../state_management/user_bloc/user_cubit.dart';
import '../../state_management/user_bloc/user_cubit_states.dart';
import 'AnimatedBar.dart';

class StoriesScreen extends StatefulWidget {
  final String userID;
  StoriesScreen(this.userID);
  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  late List<QueryDocumentSnapshot<Object?>> stories = [];
  @override
  void initState() {
    super.initState();
    UserCubit.getUserCubit(context)
        .fetchStories(
      // userID: UserCubit.getUserCubit(context).currentUser.uID!,
      userID: widget.userID , 
    )
        .then((fetchedStories) {
      stories = fetchedStories;
      _pageController = PageController();
      _animationController = AnimationController(vsync: this);

      final StoryModel firstStory = StoryModel.getJson(
        stories.first.data() as Map<String, dynamic>,
      );
      _loadStory(story: firstStory, animateToPage: false);

      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.stop();
          _animationController.reset();
          setState(() {
            if (_currentIndex + 1 < stories.length) {
              _currentIndex += 1;
              _loadStory(
                  story: StoryModel.getJson(
                stories[_currentIndex].data() as Map<String, dynamic>,
              ));
            } else {
              _currentIndex = 0;
              _loadStory(
                  story: StoryModel.getJson(
                stories[_currentIndex].data() as Map<String, dynamic>,
              ));
            }
          });
        }
      });
    });
  }

  void _onTapDown(TapDownDetails deatils, StoryModel story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = deatils.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(
              story: StoryModel.getJson(
            stories[_currentIndex].data() as Map<String, dynamic>,
          ));
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < stories.length) {
          _currentIndex += 1;
          _loadStory(
              story: StoryModel.getJson(
            stories[_currentIndex].data() as Map<String, dynamic>,
          ));
        } else {
          _currentIndex = 0;
          _loadStory(
              story: StoryModel.getJson(
            stories[_currentIndex].data() as Map<String, dynamic>,
          ));
        }
      });
    } else {
      if (story.mediaType == MediaType.video) {
        _videoController!.pause();
        _animationController.stop();
      } else {
        _videoController!.play();
        _animationController.forward();
      }
    }
  }

  void _loadStory({required StoryModel story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    switch (story.mediaType) {
      case MediaType.image:
        _animationController.duration = story.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        _videoController = null;
        _videoController?.dispose();
        _videoController = VideoPlayerController.network(story.url.toString())
          ..initialize().then((_) {
            setState(() {});
            if (_videoController!.value.isInitialized) {
              _animationController.duration = _videoController!.value.duration;
              _videoController!.play();
              _animationController.forward();
            }
          });
        break;
      case null:
        // TODO: Handle this case.
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is FetchStoriesLoadingState
              ? customProgressIndecator()
              : GestureDetector(
                  onTapDown: (details) => _onTapDown(
                    details,
                    StoryModel.getJson(
                      stories[_currentIndex].data() as Map<String, dynamic>,
                    ),
                  ),
                  child: Stack(
                    children: [
                      PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          final StoryModel story = StoryModel.getJson(
                            stories[_currentIndex].data()
                                as Map<String, dynamic>,
                          );
                          switch (story.mediaType) {
                            case MediaType.image:
                              return CachedNetworkImage(
                                imageUrl: story.url!,
                                fit: BoxFit.cover,
                              );
                            case MediaType.video:
                              if (_videoController != null &&
                                  _videoController!.value.isInitialized) {
                                return FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _videoController!.value.size.width,
                                    height: _videoController!.value.size.height,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            default:
                              setState(() {});
                          }
                          return Container(
                            child: Text('hey there '),
                          );
                        },
                      ),
                      Positioned(
                        top: 40.0,
                        left: 10.0,
                        right: 10.0,
                        child: Column(
                          children: [
                            Row(
                              children: stories
                                  .asMap()
                                  .map((key, value) {
                                    return MapEntry(
                                      key,
                                      AnimatedBar(
                                        animController: _animationController,
                                        position: key,
                                        currentIndex: _currentIndex,
                                      ),
                                    );
                                  })
                                  .values
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
