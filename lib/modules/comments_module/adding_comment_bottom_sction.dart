import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../../cash/cash_helper.dart';
import '../../models/user_post_model.dart';
import '../../shared/primary_InputField.dart';
import '../../state_management/user_bloc/user_cubit.dart';
import '../../state_management/user_bloc/user_cubit_states.dart';

class AddingCommentBottomSection extends StatefulWidget {
  final bool autoFocusKeyboard;
  final UserPostModel post;
  AddingCommentBottomSection({
    required this.post,
    required this.autoFocusKeyboard,
  });
  @override
  _AddingCommentBottomSectionState createState() =>
      _AddingCommentBottomSectionState();
}

class _AddingCommentBottomSectionState
    extends State<AddingCommentBottomSection> {
  final _commentController = TextEditingController();
  bool enablePost = false;
  @override
  void initState() {
    UserCubit.getUserCubit(context).switchBetwwenReplyingAndCommenting(false);
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool isReply = false;

  @override
  Widget build(BuildContext context) {
    final bool isCurrentModeDark = CashHelper.getSavedCashData(
      key: 'userLatestThemeMode',
    );
    final userCubit = UserCubit.getUserCubit(context);
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Conditional.single(
                context: context,
                conditionBuilder: (context) => userCubit.isReply,
                widgetBuilder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isCurrentModeDark
                          ? Color(0xFF333333).withOpacity(0.70)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                          ),
                          child: Text(
                            'replying to @${userCubit.commentUserName}',
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Container(
                                child: IconButton(
                                  padding:
                                      EdgeInsets.only(top: 16.0, right: 16.0),
                                  onPressed: () {
                                    userCubit
                                        .switchBetwwenReplyingAndCommenting(
                                            false);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                fallbackBuilder: (context) => Container(),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isCurrentModeDark
                      ? Color(0xFF333333).withOpacity(0.70)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 80,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: primaryInputField(
                        fillColor: Colors.transparent,
                        context: context,
                        controller: _commentController,
                        hintText: userCubit.isReply
                            ? '@${userCubit.commentUserName}'
                            : 'Add a comment',
                        keyBoardType: TextInputType.text,
                        cursorHeight: 20,
                        focusBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIconConstraints: BoxConstraints.tightForFinite(),
                        autoFocusKeyboard: widget.autoFocusKeyboard,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            left: 15,
                          ),
                          
                        ),
                        suffix: Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                          ),
                          child: InkWell(
                            onTap: _commentController.text.isNotEmpty &&
                                    userCubit.isReply == false
                                ? () async {
                                  print('adding commentnt function : ${userCubit.currentUser.uID}') ; 
                                  print('adding commentnt function : ${userCubit.currentUser.userName}') ; 
                                    await userCubit.postUserComment(
                                      commentDes: _commentController.text,
                                      postID: widget.post.postID.toString(),
                                      userID: userCubit.currentUser.uID,
                                      userName: userCubit.currentUser.userName
                                          .toString(),
                                      userProfileImage:
                                          userCubit.currentUser.profileImage,
                                    );
                                    setState(() {
                                      _commentController.clear();
                                    });
                                  }
                                : _commentController.text.isNotEmpty &&
                                        userCubit.isReply == true
                                    ? () async {
                                        await userCubit.postUserCommentReply(
                                          commentUserName:
                                              userCubit.commentUserName,
                                          userName: userCubit
                                              .currentUser.userName
                                              .toString(),
                                          uID: userCubit.currentUser.uID
                                              .toString(),
                                          userProfileImage: userCubit
                                              .currentUser.profileImage
                                              .toString(),
                                          replyDes: _commentController.text,
                                          commentID: userCubit.commentID,
                                          postID: widget.post.postID.toString(),
                                        );
                                        userCubit
                                            .switchBetwwenReplyingAndCommenting(
                                                false);
                                        setState(() {
                                          _commentController.clear();
                                        });
                                      }
                                    : null,
                            child: Text(
                              userCubit.isReply ? 'reply' : 'post',
                              style: TextStyle(
                                color: _commentController.text.isNotEmpty
                                    ? Colors.blueAccent
                                    : Colors.blueAccent.withOpacity(0.50),
                              ),
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CachedNetworkImageProvider {}
