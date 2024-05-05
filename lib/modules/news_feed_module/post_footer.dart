import 'package:flutter/material.dart';
import '../../models/user_post_model.dart';
import '../../shared/custom_page_route.dart';
import '../../shared/shared_functions.dart';
import '../comments_module/comments_screen.dart';

Widget postFooter({
  required UserPostModel post,
  required BuildContext context,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 16.0,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${post.likes!.length.toString()} likes',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 8.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: post.userName,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 15),
                ),
                TextSpan(
                  text: '  ${post.description}',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: '#dance',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue[100],
                      ),
                ),
                TextSpan(
                  text: '  #friends',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue[100],
                      ),
                ),
                TextSpan(
                  text: '  #lungidance',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue[100],
                      ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              CustomPageRoute(
                child: CommentsSCreen(autoFocusKeyboard: false, post: post),
                direction: AxisDirection.left,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'View all ${post.commentsCount} comments',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            timeAgoSinceNow(
              time: post.publishedDate!.millisecondsSinceEpoch,
            ),
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
                  fontSize: 10,
                ),
          ),
        ),
      ],
    ),
  );
}
