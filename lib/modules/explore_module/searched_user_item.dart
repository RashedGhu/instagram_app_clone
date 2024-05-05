import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../cash/cash_helper.dart';
import '../../models/user_model.dart';
import '../../shared/custom_page_route.dart';
import '../user_profile_module/user_profile_screen.dart';

class SearchedUserItem extends StatelessWidget {
  final bool isCurrentModeDark = CashHelper.getSavedCashData(
    key: 'userLatestThemeMode',
  );
  final UserModel searchedUser;
  SearchedUserItem({required this.searchedUser});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CustomPageRoute(
            child: UserProfileScreen(
              appBarUserName: searchedUser.userName.toString(),
              userID: searchedUser.uID.toString(),
            ),
            direction: AxisDirection.left,
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: searchedUser.profileImage.toString(),
              fit: BoxFit.cover,
              placeholder: (context, image) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        isCurrentModeDark ? Colors.grey[850] : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
        ),
        title: Text(
          searchedUser.userName.toString(),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        subtitle: Text(
          searchedUser.bio.toString(),
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
