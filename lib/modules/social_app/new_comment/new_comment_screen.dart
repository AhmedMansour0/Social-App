// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/models/social_app/comment_model.dart';
import 'package:untitled/shared/styles/colors.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

class NewCommentScreen extends StatelessWidget {
  const NewCommentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, state) {
        var commentController =TextEditingController();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, icon: (
                Icon(IconBroken.Arrow___Left_2)),),
            title: Text('Comments'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(itemBuilder: (context,index){
                  return buildCommentList(
                      SocialCubit.get(context).commentModelList[index],context,index
                  );
                }, separatorBuilder: (context,index)=> SizedBox(width: 10.0,),
                    itemCount: SocialCubit.get(context).commentModelList.length
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18.0,
                                  backgroundImage: NetworkImage(
                                    SocialCubit.get(context).userModel!.image!,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: commentController,
                                    decoration: InputDecoration(
                                        hintText: 'Add a comment',
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(onPressed: (){
                          String now = DateFormat.yMMMMEEEEd().format(DateTime.now());

                          SocialCubit.get(context).createComment(
                              dataTime: now.toString(),
                              comment: commentController.text,
                              postId: SocialCubit.get(context).newPostId.toString(),
                          );
                          commentController.clear();
                        },
                          child: Text('Post'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        );
      },
    );
  }
}

Widget buildCommentList(CommentModel model,context,index) {
  var now= DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm'). format(now);
  return Container(
    height: 80,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:NetworkImage(model.image!),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                              height: 1.4
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.check_circle,
                          color: defaultColour,
                          size: 16,
                        )
                      ],
                    ),
                    Text(
                        formattedDate.toString(),
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            height: 1.4
                        )
                    ),
                    Text('${model.text}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ],
            ),
          ]
       ),
    ),
  );
}
