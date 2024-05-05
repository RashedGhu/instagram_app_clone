import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../cash/cash_helper.dart';
import '../../models/user_model.dart';
import '../../util/global_variables.dart';
import '../../shared/shared_functions.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(RegisterStates initialState) : super(initialState);

  static RegisterCubit getRegisterCubit(BuildContext context) {
    return BlocProvider.of<RegisterCubit>(context);
  }

  bool isPasswordVisible = true;
  void togglePsswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(TogglePasswordVisibiltyState());
  }

  Uint8List? selectedImage;
  void registerSelectProfileImage() {
    pickImage(source: ImageSource.gallery).then((futureImage) {
      selectedImage = futureImage;
      emit(RegisterSelectProfileImageState());
    });
  }

  String? photoUrl;
  UserModel? user;
  bool isLoading = false;
  Future registeringNewUser({
    required String userName,
    required String email,
    required String password,
    required String bio,
    required Uint8List? file,
  }) async {
    isLoading = true;
    emit(RegisterWaitingResponseState());

    final userCred = await GlobalV.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    emit(RegisterNewUserSuccessState());

   
    final token = await userCred.user!.getIdToken();
    await CashHelper.saveDataInCash(key: 'userToken', value: token);
    await CashHelper.saveDataInCash(
      key: 'currentUserID',
      value: userCred.user!.uid,
    );
   
    final photoUrl = await uploadImageToFireBaseStorage(
      childName: 'profilePics',
      file: file,
      isPostImage: false,
    );
    emit(RegisterUplaodProfileImageState());

    user = UserModel(
      bio: bio,
      email: email,
      profileImage: photoUrl,
      userName: userName,
      followers: [],
      following: [],
      uID: userCred.user!.uid,
    );
    await GlobalV.firestore
        .collection('users')
        .doc(user!.uID)
        .set(user!.sendJson())
        .then((value) {
      emit(RegisterNewUserDocumentSuccessState(
         
          ));
    });
    print(user!.userName);
    print(user!.email);
    print('registered user Token is : ${token}');
    print(
        'registered user Token is : ${CashHelper.getSavedCashData(key: 'userToken')}');
    print('regestired user ID is ${user!.uID}');
    print(
        'regestired user ID is ${CashHelper.getSavedCashData(key: 'currentUserID')}');
  }
}
