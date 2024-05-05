import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../shared/custom_shimmer_effect.dart';
import '../../state_management/user_bloc/user_cubit.dart';

Widget postHeader({
  required BuildContext context,
  required String userName,
  required String profileImage,
  required String postID,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 4.0,
    ).copyWith(right: 0.0),
    child: Row(
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
              imageUrl: profileImage,
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
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    children: [
                      'delete',
                    ]
                        .map(
                          (item) => InkWell(
                            onTap: () async {
                              await UserCubit.getUserCubit(context)
                                  .deleatingPost(postID: postID);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              child: Text(item),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            );
          },
          icon: Icon(
            Icons.more_vert,
          ),
        )
      ],
    ),
  );
}
