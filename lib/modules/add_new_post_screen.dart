import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inst_clone_app/shared/custom_shimmer_effect.dart';
import '../cash/cash_helper.dart';
import '../shared/primary_InputField.dart';
import '../shared/primary_button.dart';
import '../shared/shared_functions.dart';
import '../state_management/user_bloc/user_cubit.dart';
import '../state_management/user_bloc/user_cubit_states.dart';

class AddNewPostScreen extends StatefulWidget {
  @override
  _AddNewPostScreenState createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  final _descriptionController = TextEditingController();
  final _focusNode = FocusNode();
  Uint8List? _userUploadedFile;

  bool isPostLoading = false;
  @override
  void dispose() {
    _descriptionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentModeDark =
        CashHelper.getSavedCashData(key: 'userLatestThemeMode');
    return BlocConsumer<UserCubit, UserStates>(
      listener: (BuildContext context, UserStates state) {
        if (state is CreateUserPostDocSuccessState) {
          _userUploadedFile = null;
          _descriptionController.clear();
          showSnakBar(
            context: context,
            text: 'posted',
            textColor: isCurrentModeDark ? Colors.black : Colors.white,
            backGroundColor: isCurrentModeDark ? Colors.white : Colors.black,
          );
        }
      },
      builder: (context, state) {
        final userCubit = UserCubit.getUserCubit(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isCurrentModeDark ? Colors.black : Colors.white,
            title: Text(
              'Create New Post',
              style: TextStyle(
                color: isCurrentModeDark ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              BlocConsumer<UserCubit, UserStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return _userUploadedFile != null &&
                          _descriptionController.text.isNotEmpty
                      ? userCubit.isWaiting
                          ? Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: CircularProgressIndicator(
                                color: isCurrentModeDark
                                    ? Colors.white
                                    : Colors.black,
                                strokeWidth: 0.7,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: primaryButton(
                                width: 100,
                                height: 30,
                                hintStyle: TextStyle(color: Colors.white),
                                backGroundColor: Colors.blue,
                                title: 'Add',
                                titleColor: Colors.white,
                                onTap: () async {
                                  await userCubit.uploadUserPost(
                                    postDescriptionController:
                                        _descriptionController.text,
                                    uploadedFile: _userUploadedFile,
                                    uID: userCubit.currentUser.uID,
                                    userName: userCubit.currentUser.userName,
                                    profileImage:
                                        userCubit.currentUser.profileImage,
                                  );
                                  if (_focusNode.hasFocus) {
                                    _focusNode.unfocus();
                                  }
                                },
                                context: context,
                              ),
                            )
                      : Container();
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: getDeviceHeight(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BlocConsumer<UserCubit, UserStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () async {
                            Uint8List file =
                                await pickImage(source: ImageSource.gallery);

                            _userUploadedFile = file;
                            userCubit.markNeedToReBuild();
                          },
                          child: Container(
                            height: getDeviceWidth(context),
                            width: getDeviceWidth(context),
                            color: Colors.grey[300],
                            child: _userUploadedFile == null
                                ? Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.white70,
                                    size: 150.0,
                                  )
                                : Image(
                                    image: MemoryImage(_userUploadedFile!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: userCubit.currentUser.profileImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, image) {
                                    return customCircularShimmerEffect(
                                      context: context,
                                      height: 50,
                                      width: 50,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: primaryInputField(
                                  inputStyle: TextStyle(
                                      color: isCurrentModeDark
                                          ? Colors.white
                                          : Colors.black),
                                  fillColor: Colors.transparent,
                                  context: context,
                                  controller: _descriptionController,
                                  hintText: 'Write a caption',
                                  focusNode: _focusNode,
                                  autoFocusKeyboard: false,
                                  onChanged: (value) {
                                    userCubit.markNeedToReBuild();
                                  },
                                  onFieldSubmitted: (_) {
                                    if (_userUploadedFile != null &&
                                        _descriptionController
                                            .text.isNotEmpty) {
                                      userCubit.uploadUserPost(
                                        postDescriptionController:
                                            _descriptionController.text,
                                        uploadedFile: _userUploadedFile,
                                        uID: userCubit.currentUser.uID,
                                        userName:
                                            userCubit.currentUser.userName,
                                        profileImage:
                                            userCubit.currentUser.profileImage,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
