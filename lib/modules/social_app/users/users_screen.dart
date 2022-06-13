// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/models/social_app/social_user_model.dart';
import 'package:untitled/shared/components/components.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit =  SocialCubit.get(context);
    return BlocConsumer<SocialCubit,SocialStates>
      (
        builder: (context,state){
          return ConditionalBuilder(
            condition: (cubit.users.isNotEmpty),
            builder: (context)=>ListView.separated(
              itemBuilder: (context,index)=>buildChatItem(cubit.users[index],context),
              separatorBuilder:(context,index)=> myDivider(),
              itemCount: SocialCubit.get(context).users.length,
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          );
        },
        listener: (context,state) {}
    );
  }
}

Widget buildChatItem (SocialUserModel model,context)=> InkWell(
  onTap: (){},
  child: Column(
    children: [
      Text('More features are coming soon',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold
      ),),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            if(model.image !=null)
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  model.image!,
                ),
              ),
            SizedBox(
              width: 15.0,
            ),
            if(model.image !=null)
              Text(
                model.name!,
                style: TextStyle(height: 1.4),
              ),
          ],
        ),
      ),
    ],
  ),
);