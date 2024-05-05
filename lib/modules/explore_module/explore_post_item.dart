import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/user_post_model.dart';
import '../../shared/custom_shimmer_effect.dart';


class ExplorePostItem extends StatelessWidget {
  final UserPostModel post;
  ExplorePostItem({
    required this.post,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        showDialog(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 200,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.grey[800],
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          key: GlobalKey(),
                          radius: 20,
                          backgroundImage: CachedNetworkImageProvider(
                            post.profileImage.toString(),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(post.userName.toString()),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: 380,
                    width: 700,
                    child: CachedNetworkImage(
                      imageUrl: post.postPhotoUrl.toString(),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      onTap: () {},
      child: Container(
        child: CachedNetworkImage(
          imageUrl: post.postPhotoUrl.toString(),
          fit: BoxFit.cover,
          placeholder: (context, image) {
            return customRectangleShimmerEffect(
              context: context,
              height: 150,
              width: 100,
            );
          },
        ),
      ),
    );
  }
}
