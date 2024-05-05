import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit(LayoutStates initialState) : super(initialState);

  static LayoutCubit getLayoutCubit(BuildContext context) {
    return BlocProvider.of<LayoutCubit>(context);
  }

  void switchThemeMode({required bool isDarkMode}) {
    emit(SwitchThemeModeState(
      isDarkMode: isDarkMode,
    ));
  }
}
