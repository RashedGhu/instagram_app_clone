import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user_post_model.dart';
import '../../util/global_variables.dart';
import 'CommentCardItem.dart';
import 'adding_comment_bottom_sction.dart';
import 'post_owner_des_comment.dart';

class CommentsSCreen extends StatefulWidget {
  static const String routeName = './Comments_Screen';
  final UserPostModel post;
  final bool autoFocusKeyboard;
  CommentsSCreen({
    required this.autoFocusKeyboard,
    required this.post,
  });

  @override
  State<CommentsSCreen> createState() => _CommentsSCreenState();
}

class _CommentsSCreenState extends State<CommentsSCreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text('Comments'),
          ),
          body: StreamBuilder(
            stream: GlobalV.firestore
                .collection('userPosts')
                .doc(widget.post.postID)
                .collection('postComments')
                .orderBy(
                  'commentPublishedDate',
                  descending: false,
                )
                .snapshots()
                .handleError(
              (error) {
                print('stream commments error is : ${error}');
              },
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot,
            ) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 0.4,
                  ),
                );
              } else
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: OwnerPostDescriptionComment(post: widget.post),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.1,
                      width: double.infinity,
                    ),
                    ListView.separated(
                          padding: EdgeInsets.only(top: 25.0),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CommentCardItem(
                              snapShot: snapShot.data!.docs[index].data(),
                              postID: widget.post.postID.toString(),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(height: 10);
                          },
                          itemCount: snapShot.data!.docs.length,
                      
                    ),
                  ],
                );
            },
          ),
          bottomNavigationBar: AddingCommentBottomSection(
            post: widget.post,
            autoFocusKeyboard: widget.autoFocusKeyboard,
          ),
      
    );
  }
}
