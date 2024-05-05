
import '../../models/user_model.dart';

abstract class UserStates {}

class UserInitialState extends UserStates {}

class FetchUserDataWaitingState extends UserStates {}

class FetchUserDocumentDataSuccessState extends UserStates {
  final UserModel user;
  FetchUserDocumentDataSuccessState({required this.user});
}

class FetchUserDocumentDataErrorState extends UserStates {}

class UploadUserPostWaitingState extends UserStates {}

class UploadUserPostImageState extends UserStates {}

class CreateUserPostDocSuccessState extends UserStates {
  bool doesUserPostUploded = false;
  CreateUserPostDocSuccessState({required this.doesUserPostUploded});
}

class CreateUserPostDocErrorState extends UserStates {}

class UpdateDislikePostState extends UserStates {}

class UpdatelikePostState extends UserStates {}

class TogglePostLikeAnimation extends UserStates {}

class CreateNewUserCommentDocSuccessState extends UserStates {
  CreateNewUserCommentDocSuccessState();
}

class CreateNewUserCommentDocErrorState extends UserStates {}

class GettingCommentsCountState extends UserStates {}

class UpdatePostCommentsCountSatate extends UserStates {}

class SwitchBetweenCommentingAndReplying extends UserStates {}

class CreateNewReplyDocSuccessState extends UserStates {}

class CreateNewReplyDocErrorState extends UserStates {}

class LikingCommentState extends UserStates {}

class DisLikingCommentState extends UserStates {}

class ToggleCommentLikeAnimation extends UserStates {}

class ToggleCommentsViewState extends UserStates {}

class DeleteingUserPostSuccessState extends UserStates {}

class DeleteingUserPostErrorState extends UserStates {}

class FollowingNewUserSuccesssState extends UserStates {}

class UnFollowingUserSuccesssState extends UserStates {}

class FollowUnfollowUserErrorState extends UserStates {}

class FetchUserProfileSuccessState extends UserStates {}

class TogglePageViewState extends UserStates {}

class UserSignOutSuccessState extends UserStates {}

class SignOutWaitingState extends UserStates {}

class ClearCashImagesState extends UserStates {}

class MarkNeedToReBuildState extends UserStates {}

class UploadUserStoryUrlSuccessState extends UserStates {}

class UploadUserStoryUrlErrorState extends UserStates {}

class AddingNewUserStoryDocSuccessState extends UserStates {}

class AddingNewUserStoryDocErrorState extends UserStates {}

class FetchStoriesLoadingState extends UserStates {}

class FetchUserStoriesSuccessState extends UserStates {}

class HidePresistenceTableViewState extends UserStates {
  final bool hidePersistentTabView;
  HidePresistenceTableViewState(this.hidePersistentTabView);
}
