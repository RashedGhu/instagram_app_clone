abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class TogglePasswordVisibilityLoginState extends LoginStates {}

class LoginWaitingResponseState extends LoginStates {}

class LoginUserSuccessState extends LoginStates {
}

class LoginUserErrorState extends LoginStates {
  final String error;
  LoginUserErrorState(this.error);
}
