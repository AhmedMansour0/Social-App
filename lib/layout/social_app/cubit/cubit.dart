// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/models/social_app/comment_model.dart';
import 'package:untitled/models/social_app/message_model.dart';
import 'package:untitled/models/social_app/post_model.dart';
import 'package:untitled/models/social_app/social_user_model.dart';
import 'package:untitled/modules/social_app/chats/chats_screen.dart';
import 'package:untitled/modules/social_app/feeds/feeds_screen.dart';
import 'package:untitled/modules/social_app/settings/settings_screen.dart';
import 'package:untitled/modules/social_app/social_login/social_login_screen.dart';
import 'package:untitled/modules/social_app/users/users_screen.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/components/constances.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;
import 'package:untitled/shared/network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel ? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).get()
        .then((value) {
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError(((error) {
      print(error.toString());
    }));
  }


  void signOut(context)
  {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId');
      navigateTo(context, SocialLoginScreen());
    });
  }

  int currentIndex = 0;
  List<Widget> screens =
  [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List <String> titles =
  [
    'HOME',
    'Chats',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {

    if(index == 1) {
      getAllUsers();
    }
    if (index == 10) {
      emit(SocialNewPostState());
    }
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path.toString());
      emit(SocialUploadProfileImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialUploadProfileImageErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialUploadCoverImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialUploadCoverImageErrorState());
    }
  }

  //uploadImageFireBase

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
    required String email,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(
          email: email,
          name: name, phone: phone, bio: bio,
          image: value,
        );
        emit(SocialUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
    required String email,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(
            name: name,
            phone: phone,
            bio: bio,
            email: email ,
            cover: value
        );
        // emit(SocialUpdateUserCoverImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    required String email,
    String ?image,
    String ?cover,
  }) {
    // emit(SocialUpdateLoadingState());
    SocialUserModel modelMap = SocialUserModel(
        name: name,
        phone: phone,
        bio: bio,
        cover: cover ?? userModel!.cover,
        image: image ?? userModel!.image,
        email: userModel!.email,
        uId: userModel!.uId,
        isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(modelMap.toMap())
        .then((value) {
      getUserData();
    })
        .catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File ? postImage;

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialUploadPostImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialUploadPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
    context,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          showToast(text: 'Post uploaded successfully', state: ToastStates.SUCCESS);
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel>postList=[];
  List<String>postId=[];
  List<int>likesCountList=[];
  List<int>commentCountList=[];

  void getPost(){
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .snapshots().listen((event) {
      postList.clear();
      likesCountList.clear();
      commentCountList.clear();
      event.docs.forEach((element) {
        element.reference.collection('Comments')
            .doc(uId)
            .collection('user Comment')
            .orderBy('dateTime')
            .get()
            .then((v) {
          element.reference.collection('Likes')
              .get()
              .then((value){
            likesCountList.add(value.docs.length);
            commentCountList.add(v.docs.length);
            postId.add(element.id);
            postList.add(PostModel.fromJson(element.data()));
            emit(SocialGetPostsSuccessState());
          }).catchError((error){
            emit(SocialGetPostsErrorState(error.toString()));
            print(error);
          });
        })
            .catchError((error){
          emit(SocialGetPostsErrorState(error.toString()));
          print(error);
        });
      });
      emit(SocialGetPostsSuccessState());
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Likes')
        .doc(userModel!.uId)
        .set({
      'like':true,
    })
        .then((value) {
      emit(SocialPostLikeSuccessState());
    })
        .catchError((error){
      emit(SocialPostLikeErrorState());
    });
  }

  void createComment({required String postId,
    required String comment,
    required String dataTime}){
    emit(SocialCreateCommentLoadingState());
    CommentModel commentModel=CommentModel(
      name: userModel!.name,
      image:userModel!.image,
      uId: userModel!.uId,
      text:comment,
      dateTime:dataTime,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Comments')
        .doc(userModel!.uId)
        .collection('user Comment')
        .add(commentModel.toMap()
    ).then((value) {
      emit(SocialCreateCommentSuccessState());
      getComments(postId);
    })
        .catchError((error){
      emit(SocialCreateCommentErrorState());

    });

  }

  List<String> commentList=[];
  List<CommentModel> commentModelList=[];
  String? newPostId;

  void getComments(String postId){
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Comments')
        .doc(userModel!.uId)
        .collection('user Comment')
        .orderBy('dateTime')
        .get()
        .then((value) {
      commentModelList.clear();
      commentList.clear();
      value.docs.forEach((element) {
        commentModelList.add(CommentModel.fromJson(element.data()));
        commentList.add(element.id);
        emit(SocialGetCommentsSuccessState(postId));
      });
      newPostId = postId ;
      emit(SocialGetCommentsSuccessState(postId));
    }).catchError((error){
      emit(SocialGetCommentsErrorState(error.toString()));
      print(error);
    });
  }

  List<SocialUserModel> users = [];
  void getAllUsers(){
    emit(SocialGetAllUsersLoadingState());
    if(users.isEmpty)
    // ignore: curly_braces_in_flow_control_structures
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
  for (var element in value.docs)
  {
    if(element.data()['uId'] != userModel!.uId) {
      users.add(SocialUserModel.fromJson(element.data()));
    }
  }
  emit(SocialGetAllUsersSuccessState());
}).catchError((error){
  error.toString();
    });
  }

void sendMessage({
  required dateTime,
  required receiverId,
  required text,
  String ? image,
})
{
  MessageModel model = MessageModel(
    text: text,
    senderId: userModel!.uId,
    receiverId: receiverId,
    dateTime: dateTime,
    image: image??'',
  );

// my chat

  FirebaseFirestore.instance
      .collection('users')
  .doc(userModel!.uId)
  .collection('chats')
  .doc(receiverId)
  .collection('messages')
  .add(model.toMap()).then((value) {
    emit(SocialSendMessageSuccessState());
  }).catchError((error){
    emit(SocialSendMessageErrorState());
  });

//receiver chat

  FirebaseFirestore.instance
      .collection('users')
      .doc(receiverId)
      .collection('chats')
      .doc(userModel!.uId)
      .collection('messages')
      .add(model.toMap()).then((value) {
    emit(SocialSendMessageSuccessState());
  }).catchError((error){
    emit(SocialSendMessageErrorState());
  });
}

List <MessageModel> messages = [];
void getMessages({
  required receiverId,
})
{
  FirebaseFirestore.instance
      .collection('users')
      .doc(userModel!.uId)
      .collection('chats')
      .doc(receiverId)
      .collection('messages')
      .orderBy('dateTime')
      .snapshots()
      .listen((event)
  {
    messages = [];
    for (var element in event.docs) {
      messages.add(MessageModel.fromJson(element.data()));
    }
    emit(SocialGetMessageSuccessState());
  });
}

void deletePost({String? postId})
{
  {
    FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .delete().then((value) {
      showToast(
          text:'Post Deleted',
          state:ToastStates.SUCCESS );
        emit(SocialDeletePostSuccessState());
  }).catchError((error){
    emit(SocialDeletePostErrorState());
  });
  }
}

  File ? messageImage;

  Future getMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(SocialUploadMessageImageSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialUploadMessageImageErrorState());
    }
  }

  void uploadMessageImage({
    required String dateTime,
    required String text,
    required receiverId,
  }) {
    emit(SocialSendMessageLoadingState());
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users${userModel!.uId}chats$receiverId/messages/${Uri
        .file(messageImage!.path)
        .pathSegments
        .last}')
        .putFile(messageImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
    sendMessage(
      dateTime: dateTime,
      receiverId: receiverId,
      text: text,
      image: value,
    );
    emit(SocialSendMessageSuccessState());
      }).catchError((error) {
        emit(SocialSendMessageErrorState());
      });
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  void removeMessageImage()
  {
    messageImage = null;
    emit(SocialRemoveMessageImageState());
  }
}
