// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/styles/colors.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();
    var emailController = TextEditingController();

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        emailController.text = userModel.email!;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 5.0,
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            },
              icon: (Icon(IconBroken.Arrow___Left_2)),),
            title: Text('Edit Profile'),
            actions: [
              TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    email: emailController.text
                  );
                },
                child: Text('Save'),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if(state is SocialUserUpdateLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 180.0,
                    child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(4.0),
                                            topLeft: Radius.circular(4.0)
                                        ),
                                        image: DecorationImage(
                                          image: coverImage == null
                                              ? NetworkImage(userModel.cover!)
                                              : FileImage(
                                              coverImage) as ImageProvider,
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      child: IconButton(
                                          onPressed: () {
                                            SocialCubit.get(context)
                                                .getCoverImage();
                                          },
                                          icon: (
                                              Icon(IconBroken.Camera)
                                          )
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 65.0,
                                backgroundColor: Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                                child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: profileImage == null ?
                                    NetworkImage(userModel.image!) :
                                    FileImage(profileImage) as ImageProvider
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context)
                                            .getProfileImage();
                                      },
                                      icon: (
                                          Icon(IconBroken.Camera)
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),
                  if(SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 5,
                    ),
                  if(SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if(SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: defaultColour,
                                  ),
                                  child: MaterialButton(onPressed: () {
                                    SocialCubit.get(context).
                                    uploadProfileImage
                                      (
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                        email: emailController.text
                                    );
                                  },
                                    child: Text('Save profile pic',
                                      style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                if(state is SocialUserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if(state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if(SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: defaultColour,
                                  ),
                                  child: MaterialButton(onPressed: () {
                                    SocialCubit.get(context).
                                    uploadCoverImage
                                      (
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        bio: bioController.text
                                    );
                                  },
                                    child: Text('Save cover pic',
                                      style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                if(state is SocialUserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if(state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(IconBroken.User),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                      label: Text('Name'),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (String ? value) {
                      if (value!.isEmpty) {
                        return 'Name must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: bioController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(IconBroken.Info_Circle),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                      label: Text('Bio'),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (String ? value) {
                      if (value!.isEmpty) {
                        return 'Bio must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(IconBroken.Call),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                      label: Text('Phone'),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (String ? value) {
                      if (value!.isEmpty) {
                        return 'Bio must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                      ),
                      label: Text('Email'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String ? value) {
                      if (value!.isEmpty) {
                        return 'Email must not be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
