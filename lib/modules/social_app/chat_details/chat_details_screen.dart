// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/models/social_app/message_model.dart';
import 'package:untitled/models/social_app/social_user_model.dart';
import 'package:untitled/shared/styles/colors.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel? userModel;

  ChatDetailsScreen({
    this.userModel,
  });
  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    var messageController = TextEditingController();
    return Builder(
      builder: (context) {
        cubit.getMessages(receiverId: userModel!.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SocialSendMessageSuccessState){
              cubit.removeMessageImage();
              messageController.clear();
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    if (cubit.userModel?.image != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          userModel!.image!,
                        ),
                      ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(userModel!.name!),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              var message = cubit.messages[index];
                              if (cubit.userModel!.uId == message.senderId) {
                                return buildMyMessage(message);
                              } else {
                                return buildMessage(message);
                              }
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 15.0,
                                ),
                            itemCount: cubit.messages.length),
                      ),
                      if (SocialCubit.get(context).messageImage != null)
                        Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 200.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    image: DecorationImage(
                                      image: FileImage(SocialCubit.get(context)
                                          .messageImage!),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context)
                                            .removeMessageImage();
                                      },
                                      icon: (Icon(Icons.close))),
                                ),
                              ),
                            ]),
                      if (state is SocialSendMessageLoadingState)
                        LinearProgressIndicator(),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[300]!, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          SocialCubit.get(context)
                                              .getMessageImage();
                                        },
                                        icon: Icon(
                                          IconBroken.Image,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Type your message here'),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 50.0,
                                  color: defaultColour,
                                  child: MaterialButton(
                                      onPressed: () {
                                        if (cubit.messageImage == null) {
                                          cubit.sendMessage(
                                            dateTime: DateTime.now().toString(),
                                            receiverId: userModel!.uId,
                                            text: messageController.text,
                                          );
                                        } else {
                                          cubit.uploadMessageImage(
                                            dateTime: DateTime.now().toString(),
                                            text: messageController.text,
                                            receiverId: userModel!.uId,
                                          );
                                        }
                                        messageController.clear();
                                      },
                                      minWidth: 1.0,
                                      child: (Icon(
                                        IconBroken.Send,
                                        size: 16.0,
                                        color: Colors.white,
                                      ))),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildMessage(MessageModel? model) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model!.text != '')
            Container(
              height: 32.0,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10.0),
                    topStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0),
                  )),
              child: Text(
                model.text!,
              ),
            ),
          if (model.image != null && model.image != '')
            Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(model.image!), fit: BoxFit.cover))),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );

Widget buildMyMessage(MessageModel? model) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (model!.text != '')
            Container(
                height: 32.0,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                    color: defaultColour.withOpacity(0.2),
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(10.0),
                      topStart: Radius.circular(10.0),
                      topEnd: Radius.circular(10.0),
                    )),
                child: Text(
                  model.text!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),
          if (model.image != null && model.image != '')
            Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                    image: NetworkImage(model.image!), fit: BoxFit.cover))),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
