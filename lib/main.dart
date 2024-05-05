import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cash/cash_helper.dart';
import 'layout/mobile_home_screen_layout.dart';
import 'layout/web_home_screen_layout.dart';
import 'modules/explore_module/explored_post_details_screen.dart';
import 'modules/login_screen.dart';
import 'modules/register_screen.dart';
import 'state_management/block_observer.dart';
import 'state_management/layout_bloc/home_layout_cubit.dart';
import 'state_management/layout_bloc/layout_states.dart';
import 'state_management/user_bloc/user_cubit.dart';
import 'state_management/user_bloc/user_cubit_states.dart';
import 'util/Responsive.dart';
import 'util/theme_data.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Widget? _startingWidget;
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBjC6zqnVSuNLZgM1OzKygbZfnezwEz9LE",
            appId: "1:852244261186:web:3f0d09544314a227dd80db",
            messagingSenderId: "852244261186",
            projectId: "instacloneapp-17431",
            storageBucket: "instacloneapp-17431.appspot.com",
          ),
        );
      } else {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.white,
          ),
        );
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBjC6zqnVSuNLZgM1OzKygbZfnezwEz9LE",
            appId: "1:852244261186:web:3f0d09544314a227dd80db",
            messagingSenderId: "852244261186",
            projectId: "instacloneapp-17431",
            storageBucket: "instacloneapp-17431.appspot.com",
          ),
        );
        CashHelper.sharedPref = await SharedPreferences.getInstance();
        await CashHelper.saveDataInCash(
          key: 'userLatestThemeMode',
          value: false,
        );

        final userID = CashHelper.getSavedCashData(key: 'currentUserID');
        final currenttUserToken = CashHelper.getSavedCashData(key: 'userToken');
        if (currenttUserToken != null && userID != null) {
          _startingWidget = ResponsiveLayout(
            mobileScreenLayout: MobileHomeScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          );
        } else {
          _startingWidget = LoginScreen();
        }
      }

      runApp(AppRoot(_startingWidget!));
    },
    blocObserver: MyBlocObserver(),
  );
}

class AppRoot extends StatelessWidget {
  final Widget staringWidget;
  AppRoot(this.staringWidget);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              UserCubit(UserInitialState())..fetchCurrentUserPersonalData(),
        ),
        BlocProvider(
          create: (context) => LayoutCubit(HomeLayoutInitialState()),
        ),
      ],
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isCurrentModeDark = CashHelper.getSavedCashData(
            key: 'userLatestThemeMode',
          );
          if (state is SwitchThemeModeState) {
            isCurrentModeDark = state.isDarkMode;
          }
          return MaterialApp(
            title: 'Instagram Clone ',
            debugShowCheckedModeBanner: false,
            theme: isCurrentModeDark ? darkModeTheme : lightTheme,
            home: staringWidget,
            routes: {
              RegisterScreen.routeName: (context) => RegisterScreen(),
              LoginScreen.routeName: (context) => LoginScreen(),
              MobileHomeScreenLayout.routeName: (context) =>
                  MobileHomeScreenLayout(),
              ExploredPostDetailsScreen.routeName: (context) =>
                  ExploredPostDetailsScreen(),
            },
          );
        },
      ),
    );
  }
}
