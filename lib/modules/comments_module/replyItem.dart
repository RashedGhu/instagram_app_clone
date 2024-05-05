import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../cash/cash_helper.dart';
import '../../models/commentReply_model.dart';
import '../../shared/custom_shimmer_effect.dart';
import '../../shared/shared_functions.dart';


class ReplyItem extends StatelessWidget {
  final Map<String, dynamic> snapShot;
  ReplyItem({required this.snapShot});

  @override
  Widget build(BuildContext context) {
    final CommentReplyModel reply = CommentReplyModel.getJson(snapShot);
    final bool isCurrentModeDark = CashHelper.getSavedCashData(
      key: 'userLatestThemeMode',
    );
    return Container(
      margin: EdgeInsets.only(
        top: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: reply.userProfilePicture.toString(),
                fit: BoxFit.cover,
                placeholder: (context, image) {
                  return customCircularShimmerEffect(
                    context: context,
                    height: 25,
                    width: 25,
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
                          text: reply.userName,
                          style: Theme.of(context).textTheme.subtitle2!,
                        ),
                        TextSpan(
                          text: ' @${reply.commentUserName}',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: isCurrentModeDark
                                        ? Colors.blue[50]
                                        : Colors.blue,
                                  ),
                        ),
                        TextSpan(
                          text: '  ${reply.replyDes}',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                timeAgoSinceNow(
                                  time: reply
                                      .publishedDate!.millisecondsSinceEpoch,
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
                                '${reply.likes!.length} like',
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
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
