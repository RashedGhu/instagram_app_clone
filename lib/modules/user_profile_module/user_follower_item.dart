import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../../cash/cash_helper.dart';
import '../../models/user_model.dart';
import '../../shared/custom_page_route.dart';
import '../../shared/primary_button.dart';
import '../../state_management/user_bloc/user_cubit.dart';
import '../../util/global_variables.dart';
import 'user_profile_screen.dart';

class UserFollowerItem extends StatefulWidget {
  final String userID;
  final userName;
  bool isFollowing;
  UserFollowerItem({
    required this.userName,
    required this.isFollowing,
    required this.userID,
  });

  @override
  State<UserFollowerItem> createState() => _UserFollowerItemState();
}

class _UserFollowerItemState extends State<UserFollowerItem> {
  var user = UserModel.getJson({});
  bool loading = true;
  @override
  void initState() {
    fetchFollowerUsersData();
    super.initState();
  }

  fetchFollowerUsersData() async {
    GlobalV.firestore
        .collection('users')
        .doc(widget.userID)
        .get()
        .then((docSnapShot) {
      user = UserModel.getJson(
        docSnapShot.data() as Map<String, dynamic>,
      );
      setState(() {
        loading = false;
      });
    });
  }

  final bool isCurrentModeDark =
      CashHelper.getSavedCashData(key: 'userLatestThemeMode');

  @override
  Widget build(BuildContext context) {
    return Conditional.single(
      context: context,
      conditionBuilder: (context) => loading,
      widgetBuilder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 0.4,
          ),
        );
      },
      fallbackBuilder: (context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              CustomPageRoute(
                child: UserProfileScreen(
                  appBarUserName: widget.userName,
                  userID: widget.userID.toString(),
                ),
                direction: AxisDirection.left,
              ),
            );

          
          },
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: user.profileImage.toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, image) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isCurrentModeDark
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              user.userName.toString(),
              style: Theme.of(context).textTheme.subtitle2,
            ),
            subtitle: Text(
              user.bio.toString(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            trailing: Conditional.single(
              context: context,
              conditionBuilder: (context) => widget.isFollowing,
              widgetBuilder: (context) {
                return Container(
                  width: 130,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: primaryButton(
                    overLayColor: Colors.grey,
                    isTitleUpperCase: false,
                    title: 'Following',
                    hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                    context: context,
                    backGroundColor: Colors.transparent,
                    titleColor: Colors.white,
                    onTap: () async {
                      UserCubit.getUserCubit(context).followingUser(
                        followingUserID: widget.userID.toString(),
                      );
                      setState(() {
                        widget.isFollowing = !widget.isFollowing;
                      });
                    },
                  ),
                );
              },
              fallbackBuilder: (context) {
                return Container(
                  child: primaryButton(
                    width: 130,
                    height: 30,
                    title: 'Follow',
                    hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                    context: context,
                    onTap: () async {
                      UserCubit.getUserCubit(context).followingUser(
                        followingUserID: widget.userID.toString(),
                      );
                      setState(() {
                        widget.isFollowing = !widget.isFollowing;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
