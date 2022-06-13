abstract class SocialStates {}

class SocialInitialState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{
  final String error;
  SocialGetUserErrorState(this.error);
}

class SocialGetAllUsersLoadingState extends SocialStates{}

class SocialGetAllUsersSuccessState extends SocialStates{}

class SocialGetAllUsersErrorState extends SocialStates{
  final String error;
  SocialGetAllUsersErrorState(this.error);
}

class SocialGetPostsLoadingState extends SocialStates{}

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates{
  final String error;
  SocialGetPostsErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}

class SocialProfileImagePickedSuccessState extends SocialStates{}

class SocialProfileImagePickedErrorState extends SocialStates{}

class SocialCoverImagePickedSuccessState extends SocialStates{}

class SocialCoverImagePickedErrorState extends SocialStates{}

class SocialUploadProfileImageSuccessState extends SocialStates{}

class SocialUploadProfileImageErrorState extends SocialStates{}

class SocialUploadCoverImageErrorState extends SocialStates{}

class SocialUploadCoverImageSuccessState extends SocialStates{}

class SocialUserUpdateErrorState extends SocialStates{}

class SocialUserUpdateLoadingState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}

class SocialCreatePostSuccessState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates{}

class SocialUploadPostImageErrorState extends SocialStates{}

class SocialUploadPostImageSuccessState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}

class SocialPostLikeSuccessState extends SocialStates {}

class SocialPostLikeErrorState extends SocialStates {
}

class SocialCreateCommentLoadingState extends SocialStates{}

class SocialCreateCommentSuccessState extends SocialStates{}

class SocialCreateCommentErrorState extends SocialStates{}

class SocialGetCommentsLoadingState extends SocialStates{}

class SocialGetCommentsSuccessState extends SocialStates{
  late String insidePostId;
  SocialGetCommentsSuccessState(this.insidePostId);
}

class SocialGetCommentsErrorState extends SocialStates{
  final String error;
  SocialGetCommentsErrorState(this.error);
}

class SocialSendMessageSuccessState extends SocialStates{

}

class SocialSendMessageLoadingState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{}

class SocialGetMessageSuccessState extends SocialStates{

}

class SocialDeletePostSuccessState extends SocialStates{}

class SocialDeletePostErrorState extends SocialStates{}

class SocialUploadMessageImageErrorState extends SocialStates{}

class SocialUploadMessageImageSuccessState extends SocialStates{}

class SocialRemoveMessageImageState extends SocialStates{}

class GetPersonPostSuccessState extends SocialStates{}

class GetPersonPostErrorState extends SocialStates{}

