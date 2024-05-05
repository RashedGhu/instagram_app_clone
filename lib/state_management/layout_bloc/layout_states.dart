abstract class LayoutStates {}

class HomeLayoutInitialState extends LayoutStates {}

class ToggleBottomNavigationBarItemsState extends LayoutStates {}

class ToggleLikeAnimationForPostState extends LayoutStates {}

class SwitchThemeModeState extends LayoutStates {
  final bool isDarkMode;
  SwitchThemeModeState({required this.isDarkMode});
}
