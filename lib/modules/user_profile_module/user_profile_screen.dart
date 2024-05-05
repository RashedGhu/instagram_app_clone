import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../cash/cash_helper.dart';
import '../../models/user_model.dart';
import '../../models/user_post_model.dart';
import '../../shared/custom_page_route.dart';
import '../../shared/custom_shimmer_effect.dart';
import '../../shared/primary_button.dart';
import '../../shared/shared_functions.dart';
import '../../shared/show_toast.dart';
import '../../state_management/layout_bloc/home_layout_cubit.dart';
import '../../state_management/user_bloc/user_cubit.dart';
import '../../util/global_variables.dart';
import '../login_screen.dart';
import 'user_post_details_screen.dart';
import 'user_profile_header.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = './UserProfileScreen';
  final String userID;
  final String appBarUserName;
  UserProfileScreen({
    required this.appBarUserName,
    required this.userID,
  });
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserModel? user = UserModel.getJson({});
  bool isLoading = true;
  int postLeng = 0;
  int followersLeng = 0;
  int followingLeng = 0;
  bool isFollowing = false;
  bool signOutLaoding = false;
  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  Future<void> getUserProfile() async {
    try {
      var snapShot =
          await GlobalV.firestore.collection('users').doc(widget.userID).get();

      user = UserModel.getJson(
        snapShot.data()!,
      );

      QuerySnapshot<Map<String, dynamic>> postSnap = await GlobalV.firestore
          .collection('userPosts')
          .where(
            'uID',
            isEqualTo: widget.userID,
          )
          .get();
      postLeng = postSnap.docs.length;
      followersLeng = snapShot.data()!['followers'].length;
      followingLeng = snapShot.data()!['following'].length;
      isFollowing = snapShot.data()!['followers'].contains(
            CashHelper.getSavedCashData(key: 'currentUserID'),
          );

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentModeDark =
        CashHelper.getSavedCashData(key: 'userLatestThemeMode');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.appBarUserName.toString()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                await openRightSideBottomSheet();
              },
              icon: Icon(FontAwesomeIcons.bars),
            ),
          )
        ],
      ),
      body: signOutLaoding
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 0.3,
              ),
            )
          : Conditional.single(
              context: context,
              conditionBuilder: (context) => isLoading,
              widgetBuilder: (context) {
                return Center(
                  child: isCurrentModeDark
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 0.3,
                        )
                      : CircularProgressIndicator(
                          color: Colors.grey[600],
                          strokeWidth: 0.6,
                        ),
                );
              },
              fallbackBuilder: (context) {
                return LiquidPullToRefresh(
                  color:
                      isCurrentModeDark ? Colors.grey[800] : Colors.grey[200],
                  showChildOpacityTransition: false,
                  animSpeedFactor: 10.0,
                  backgroundColor:
                      isCurrentModeDark ? Colors.grey[200] : Colors.grey[800],
                  onRefresh: getUserProfile,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      UserProfileHeader(
                        user: user,
                        userPostsLength: postLeng,
                        isFollowing: isFollowing,
                        followersLeng: followersLeng,
                        followingLeng: followingLeng,
                      ),
                      Container(
                        child: FutureBuilder(
                          future: GlobalV.firestore
                              .collection('userPosts')
                              .where('uID', isEqualTo: widget.userID)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return customProgressIndecator();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: GridView.builder(
                                padding: EdgeInsets.all(10),
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                itemBuilder: (context, index) {
                                  UserPostModel post = UserPostModel.getJson(
                                    snapshot.data!.docs[index].data(),
                                  );

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CustomPageRoute(
                                          child: UserPostDetailsScreen(
                                            userID: widget.userID,
                                          ),
                                          direction: AxisDirection.left,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: CachedNetworkImage(
                                        imageUrl: post.postPhotoUrl.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, image) {
                                          return Center(
                                            child: isCurrentModeDark
                                                ? customRectangleShimmerEffect(
                                                    context: context,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                  )
                                                : customRectangleShimmerEffect(
                                                    context: context,
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                  ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> openRightSideBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: 40,
                height: 3,
                color: Colors.white70,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                height: 35,
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
                  title: 'Sign Out',
                  hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                  context: context,
                  backGroundColor: Colors.transparent,
                  titleColor: Colors.white,
                  onTap: () async {
                    setState(() {
                      signOutLaoding = true;
                    });
                    final resp =
                        await UserCubit.getUserCubit(context).signOut();

                    if (resp) {
                      await CashHelper.clearCashImages();
                      await Future.delayed(Duration(seconds: 3));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                      setState(() {
                        signOutLaoding = false;
                      });
                      showToast(
                          message: 'You have been signed out',
                          state: ToastStates.SUCCESS);
                    } else {
                      showToast(message: 'False ');
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                height: 35,
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
                  title: 'Switch To Dark Theme',
                  hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                  titleColor: Colors.white,
                  context: context,
                  backGroundColor: Colors.transparent,
                  onTap: () async {
                    await CashHelper.saveDataInCash(
                      key: 'userLatestThemeMode',
                      value: true,
                    );
                    LayoutCubit.getLayoutCubit(context).switchThemeMode(
                      isDarkMode: true,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                height: 35,
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
                  title: 'Switch To light Theme',
                  hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                  context: context,
                  backGroundColor: Colors.transparent,
                  titleColor: Colors.white,
                  onTap: () async {
                    await CashHelper.saveDataInCash(
                      key: 'userLatestThemeMode',
                      value: false,
                    );
                    LayoutCubit.getLayoutCubit(context).switchThemeMode(
                      isDarkMode: false,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
