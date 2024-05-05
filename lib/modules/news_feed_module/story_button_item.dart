
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../shared/custom_shimmer_effect.dart';
import '../stories_module/stories_screen.dart';

class StoryButtonItem extends StatelessWidget {
  final String userProfileImage;
  final String userName;
  StoryButtonItem({
    required this.userName,
    required this.userProfileImage,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StoriesScreen(
                  '',
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
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
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(userProfileImage),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: userProfileImage.toString(),
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            userName,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
          ),
        ),
      ],
    );
  }
}
