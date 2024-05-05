import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inst_clone_app/state_management/user_bloc/user_cubit.dart';
import 'package:inst_clone_app/state_management/user_bloc/user_cubit_states.dart';
import '../../cash/cash_helper.dart';
import '../../models/user_post_model.dart';
import '../../shared/custom_page_route.dart';
import '../../shared/custom_shimmer_effect.dart';
import '../../shared/shared_functions.dart';
import '../comments_module/comments_screen.dart';
import '../user_profile_module/user_profile_screen.dart';
import 'like_animation.dart';
import 'post_footer.dart';
import 'post_header.dart';

class UserPostItem extends StatefulWidget {
  final Map<String, dynamic> snap;
  UserPostItem(this.snap);

  @override
  State<UserPostItem> createState() => _UserPostItemState();
}

class _UserPostItemState extends State<UserPostItem>
    with SingleTickerProviderStateMixin {
  var tranController = TransformationController();
  late AnimationController animaionController;
  Animation<Matrix4>? animation;
  OverlayEntry? entry;
  bool isHeartAnimating = false;
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    animaionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )
      ..addListener(
        () => tranController.value = animation!.value,
      )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          removeOverLayEntry();
        }
      });
  }

  @override
  void dispose() {
    animaionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserPostModel post = new UserPostModel.getJson(widget.snap);

    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                CustomPageRoute(
                  child: UserProfileScreen(
                    userID: post.uID as String,
                    appBarUserName: post.userName.toString(),
                  ),
                  direction: AxisDirection.left,
                ),
              );
            },
            child: postHeader(
              context: context,
              userName: post.userName.toString(),
              profileImage: post.profileImage.toString(),
              postID: post.postID.toString(),
            ),
          ),
          BlocConsumer<UserCubit, UserStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final userCubit = UserCubit.getUserCubit(context);
              return Column(
                children: [
                  GestureDetector(
                    onDoubleTap: () async {
                      await userCubit.likingApost(
                        likes: post.likes,
                        postID: post.postID,
                        // uid: CashHelper.getSavedCashData(key: 'currentUserID'),
                        uid: userCubit.currentUser.uID , 
                      );
                      setState(() {
                        isHeartAnimating = true;
                        isLiked = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        buildInterActiveImage(post),
                        Opacity(
                          opacity: isHeartAnimating ? 1 : 0,
                          child: LikeAnimation(
                            isAnimating: isHeartAnimating,
                            duration: Duration(milliseconds: 700),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 120.0,
                            ),
                            onEnd: () {
                              setState(() {
                                isHeartAnimating = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      LikeAnimation(
                        alwaysAnimate: true,
                        isAnimating: isLiked,
                        child: IconButton(
                          onPressed: () async {
                            await userCubit.likingApost(
                              likes: post.likes,
                              postID: post.postID,
                              uid: userCubit.currentUser.uID
                            );
                            setState(() {
                              isLiked = true;
                            });
                          },
                          icon: post.likes!.contains(
                            // CashHelper.getSavedCashData(key: 'currentUserID'),
                            userCubit.currentUser.uID
                          )
                              ? Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.red,
                                )
                              : Icon(
                                  FontAwesomeIcons.heart,
                                ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CustomPageRoute(
                              child: CommentsSCreen(
                                autoFocusKeyboard: true,
                                post: post,
                              ),
                              direction: AxisDirection.left,
                            ),
                          );
                        },
                        icon: Icon(
                          FontAwesomeIcons.comment,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.paperPlane,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.bookmark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          postFooter(
            post: post,
            context: context,
          ),
        ],
      ),
    );
  }

  Builder buildInterActiveImage(UserPostModel post) {
    void resetAnimation() {
      animation = Matrix4Tween(
        begin: tranController.value,
        end: Matrix4.identity(),
      ).animate(
        CurvedAnimation(
          parent: animaionController,
          curve: Curves.easeIn,
        ),
      );
      animaionController.forward(from: 0);
    }

    void showOverLay(BuildContext context) {
      final renderBox = context.findRenderObject()! as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      final entrySize = MediaQuery.of(context).size;
      entry = OverlayEntry(
        builder: (context) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withOpacity(0.20),
                ),
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                width: entrySize.width,
                child: buildInterActiveImage(post),
              ),
            ],
          );
        },
      );

      final overLay = Overlay.of(context);
      overLay!.insert(entry!);
    }

    return Builder(
      builder: (context) {
        return InteractiveViewer(
          clipBehavior: Clip.none,
          minScale: 1,
          maxScale: 4,
          panEnabled: false,
          transformationController: tranController,
          onInteractionEnd: (details) {
            resetAnimation();
          },
          onInteractionStart: (details) {
            if (details.pointerCount < 2) {
              return;
            }
            showOverLay(context);
          },
          child: Container(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: post.postPhotoUrl.toString(),
              placeholder: (context, value) {
                bool isCurrentModeDark = CashHelper.getSavedCashData(
                  key: 'userLatestThemeMode',
                );
                return isCurrentModeDark
                    ? customRectangleShimmerEffect(
                        context: context,
                        height: getDeviceHeight(context) * 0.50,
                        width: double.infinity,
                      )
                    : customRectangleShimmerEffect(
                        context: context,
                        height: getDeviceHeight(context) * 0.50,
                        width: double.infinity,
                      );
              },
            ),
          ),
        );
      },
    );
  }

  void removeOverLayEntry() {
    entry?.remove();
    entry = null;
  }
}
