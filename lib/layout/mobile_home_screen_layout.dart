import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/add_new_post_screen.dart';
import '../modules/explore_module/explore_screen.dart';
import '../modules/favourites_module/favourites_module.dart';
import '../modules/news_feed_module/news_feed_screen.dart';
import '../modules/user_profile_module/user_profile_screen.dart';
import '../state_management/user_bloc/user_cubit.dart';
import '../state_management/user_bloc/user_cubit_states.dart';

class MobileHomeScreenLayout extends StatefulWidget {
  static const String routeName = './MobileScreenHomeLayout';

  @override
  State<MobileHomeScreenLayout> createState() => _MobileHomeScreenLayoutState();
}

class _MobileHomeScreenLayoutState extends State<MobileHomeScreenLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> homeLayoutScreens = [
      NewsFeedScreen(),
      ExploreScreen(),
      AddNewPostScreen(),
      FavoruitesScreen(),
      BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final userCubit = UserCubit.getUserCubit(context);
          return UserProfileScreen(
            userID: userCubit.currentUser.uID!,
            appBarUserName: userCubit.currentUser.userName!,
          );
        },
      ),
    ];
    return Scaffold(
      body: homeLayoutScreens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
