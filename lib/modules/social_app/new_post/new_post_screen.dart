// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/modules/social_app/feeds/feeds_screen.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    var postImage = SocialCubit.get(context).postImage;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, icon: (
            Icon(IconBroken.Arrow___Left_2)),),
        title: Text(
          'Create Post',
        ),
        actions: [
          TextButton(onPressed: (){
            var now = DateTime.now();
            if(SocialCubit.get(context).postImage == null)
            {
              SocialCubit.get(context).createPost(
                  dateTime: now.toString(),
                  text: textController.text
              );
            }else
              {
                SocialCubit.get(context).uploadPostImage(
                    dateTime: now.toString(),
                    text: textController.text
                );
              }
            textController.clear();
          },
              child: Text('Post'))
        ],
      ),
      body: BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){},
        builder: (context,state){
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                        SocialCubit.get(context).userModel!.image!,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      SocialCubit.get(context).userModel!.name!,
                      style: TextStyle(height: 1.4),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                if(SocialCubit.get(context).postImage!=null)
                Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: FileImage(SocialCubit.get(context).postImage!),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: CircleAvatar(
                          radius: 20.0,
                          child: IconButton(
                              onPressed: ()
                              {
                                SocialCubit.get(context).removePostImage();
                              },
                              icon: (
                                  Icon(Icons.close)
                              )
                          ),
                        ),
                      ),
                    ]
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'what is on your mind ......',
                        border: InputBorder.none
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: (){
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('add photos'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(onPressed: (){},
                          child: Text('# tags')),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
