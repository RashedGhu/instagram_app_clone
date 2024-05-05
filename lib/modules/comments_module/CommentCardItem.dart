import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/user_comment_model.dart';
import '../../shared/custom_shimmer_effect.dart';
import '../../shared/shared_functions.dart';
import '../../state_management/user_bloc/user_cubit.dart';
import '../../state_management/user_bloc/user_cubit_states.dart';
import '../../util/global_variables.dart';
import '../news_feed_module/like_animation.dart';
import 'replyItem.dart';

class CommentCardItem extends StatefulWidget {
  final String postID;
  final Map<String, dynamic>? snapShot;
  CommentCardItem({
    required this.snapShot,
    required this.postID,
  });

  @override
  State<CommentCardItem> createState() => _CommentCardItemState();
}

class _CommentCardItemState extends State<CommentCardItem> {
  bool isStreamActive = false;

  @override
  Widget build(BuildContext context) {
    
    final userCubit = UserCubit.getUserCubit(context);
    final UserCommentModel comment = UserCommentModel.getJson(widget.snapShot!);
    print('comment card items : ${comment.uerName}');
    print('comment card items : ${comment.userID}');
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: CachedNetworkImage(
                    imageUrl: comment.userProfileImage.toString(),
                    fit: BoxFit.cover,
                    placeholder: (context, image) {
                      return customCircularShimmerEffect(
                        context: context,
                        height: 35,
                        width: 35,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: '${comment.uerName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(fontSize: 16),
                            ),
                            TextSpan(
                              text: '  ${comment.commentDes}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getDeviceWidth(context) * 0.50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                timeAgoSinceNow(
                                  time: comment.commentPublishedDate!
                                      .millisecondsSinceEpoch,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                '${comment.commentLikes!.length} like',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'reply',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                ),
                              ),
                              onTap: () {
                                userCubit.switchBetwwenReplyingAndCommenting(
                                  true,
                                );
                                userCubit.commentID = comment.commentID!;
                                userCubit.commentUserName = comment.uerName!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: LikeAnimation(
                  alwaysAnimate: true,
                  isAnimating:
                      comment.commentLikes!.contains(userCubit.currentUser.uID),
                  child: IconButton(
                    onPressed: () async {
                      await userCubit.likingComment(
                        uid: userCubit.currentUser.uID,
                        postID: widget.postID,
                        commentID: comment.commentID,
                        likes: comment.commentLikes,
                      );
                    },
                    icon: comment.commentLikes!
                            .contains(userCubit.currentUser.uID)
                        ? Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                            size: 15,
                          )
                        : Icon(
                            FontAwesomeIcons.heart,
                            color: Colors.black,
                            size: 15,
                          ),
                  ),
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.10,
                    ),
                    StreamBuilder(
                      stream: GlobalV.firestore
                          .collection('userPosts')
                          .doc(widget.postID)
                          .collection('postComments')
                          .doc(comment.commentID)
                          .collection('replies')
                          .orderBy(
                            'publishedDate',
                            descending: true,
                          )
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapShot,
                      ) {
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 0.2,
                            ),
                          );
                        }
                        return BlocConsumer<UserCubit, UserStates>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return Container(
                              child: Expanded(
                                child: Conditional.single(
                                  context: context,
                                  conditionBuilder: (context) =>
                                      snapShot.data!.docs.length >= 2,
                                  widgetBuilder: (context) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            userCubit
                                                .toggleCommentsView(comment);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(left: 15),
                                            margin: EdgeInsets.symmetric(
                                              vertical: 25,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  color: Colors.grey,
                                                  height: 0.3,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  comment.showMoreReplies
                                                      ? 'hide replies'
                                                      : snapShot.connectionState ==
                                                              ConnectionState
                                                                  .waiting
                                                          ? 'loading'
                                                          : 'view ${snapShot.data!.docs.length} more replies',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        comment.showMoreReplies
                                            ? ListView.separated(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 20.0,
                                                ),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return ReplyItem(
                                                    snapShot: snapShot
                                                        .data!.docs[index]
                                                        .data(),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Divider();
                                                },
                                                itemCount:
                                                    snapShot.data!.docs.length,
                                              )
                                            : Container(),
                                      ],
                                    );
                                  },
                                  fallbackBuilder: (context) {
                                    return ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(left: 15),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ReplyItem(
                                          snapShot:
                                              snapShot.data!.docs[index].data(),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                      itemCount: snapShot.data!.docs.length,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
