import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cash/cash_helper.dart';
import '../../util/global_variables.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(LoginStates initialState) : super(initialState);

  static LoginCubit getLoginCubit(BuildContext context) {
    return BlocProvider.of<LoginCubit>(context);
  }

  bool isPasswordShown = true;
  void togglePsswordVisibility() {
    isPasswordShown = !isPasswordShown;
    emit(TogglePasswordVisibilityLoginState());
  }

  bool isWaiting = false;
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      isWaiting = !isWaiting;
      emit(LoginWaitingResponseState());

      final userCred = await GlobalV.auth
          .signInWithEmailAndPassword(email: email, password: password);

      final token = await userCred.user?.getIdToken();

    

      await CashHelper.saveDataInCash(key: 'userToken', value: token);
      await CashHelper.saveDataInCash(
        key: 'currentUserID',
        value: userCred.user!.uid,
      );
      print('loged in userID is ${userCred.user!.uid}');
      emit(LoginUserSuccessState(
          // userToken: _token,
          // currentUserID: userFutureCred.user!.uid,
          ));
      isWaiting = !isWaiting;
    } catch (error) {
      emit(LoginUserErrorState('Login error is : ${error.toString()}'));
      isWaiting = !isWaiting;
    }
  }
}
