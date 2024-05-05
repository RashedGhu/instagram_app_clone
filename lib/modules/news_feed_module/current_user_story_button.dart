import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:image_picker/image_picker.dart';
import '../../cash/cash_helper.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../../shared/custom_page_route.dart';
import '../../shared/custom_shimmer_effect.dart';
import '../../shared/shared_functions.dart';
import '../../state_management/user_bloc/user_cubit.dart';
import '../../state_management/user_bloc/user_cubit_states.dart';
import '../stories_module/stories_screen.dart';

class CurrentUserStoryButton extends StatefulWidget {
  UserModel user ; 
  CurrentUserStoryButton({required this.user}) ;  
  @override
  State<CurrentUserStoryButton> createState() => _CurrentUserStoryButtonState();
}

class _CurrentUserStoryButtonState extends State<CurrentUserStoryButton> {
  Uint8List? _storyUrl;
  late CountdownTimerController timeController;
  int endTime = DateTime.now().minute + 1;
  
  @override
  void initState() {
    

    timeController = CountdownTimerController(
      endTime: endTime,
      onEnd: () {
        print('countdown is here ');
        _storyUrl = null;
      },
    );

    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              radius: 50,
              onTap: () async {
                if (_storyUrl != null) {
                  await Navigator.push(
                    context,
                    CustomPageRoute(
                      child: StoriesScreen(
                        UserCubit.getUserCubit(context).currentUser.uID! , 
                      ),
                      direction: AxisDirection.right,
                    ),
                  ).then((value) {
                    UserCubit.getUserCubit(context).hidePersistentTabView();
                  });
                } else {
                  Uint8List file = await pickImage(source: ImageSource.gallery);
                  setState(() {
                    _storyUrl = file;
                  });
                  UserCubit.getUserCubit(context).addNewStory(
                    userID: widget.user!.uID!,
                    userName:widget.user!.userName!,
                    mediaType: MediaType.image,
                    storyUrl: _storyUrl!,
                  );
                }
              },
              child: Conditional.single(
                  context: context,
                  conditionBuilder: (context) => _storyUrl == null,
                  widgetBuilder: (context) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _storyUrl != null
                                  ? Image(
                                      image: MemoryImage(_storyUrl!),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.user!.profileImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, image) {
                                        return customCircularShimmerEffect(
                                          context: context,
                                          width: 65,
                                          height: 65,
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          left: 50,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  fallbackBuilder: (context) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF9B2282),
                            Color(0xFFEEA863),
                          ],
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(3.0),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: _storyUrl != null
                                ? Image(
                                    image: MemoryImage(_storyUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: widget.user!.profileImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, image) {
                                      return customCircularShimmerEffect(
                                        context: context,
                                        width: 65,
                                        height: 65,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 5),
              child: Text(
                'your story',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
