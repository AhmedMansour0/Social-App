// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/cubit/states.dart';
import 'package:untitled/models/social_app/post_model.dart';
import 'package:untitled/models/social_app/social_user_model.dart';
import 'package:untitled/modules/social_app/new_comment/new_comment_screen.dart';
import 'package:untitled/modules/social_app/new_post/new_post_screen.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/styles/colors.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit,SocialStates>(

      listener:(context,state){},
      builder:(context,state){
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  if( SocialCubit.get(context).userModel?.image !=null)
                                  CircleAvatar(
                                    radius: 24.0,
                                    backgroundImage: NetworkImage(
                                      SocialCubit.get(context).userModel!.image!,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text('What is on your mind ?',
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Icon(
                            IconBroken.Image,
                            color:Colors.amber ,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: (){
                    navigateTo(context, NewPostScreen());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 50
                ),
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Voice_2,
                      color:Colors.green ,
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Icon(
                      IconBroken.Discovery,
                      color: Colors.redAccent,
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Icon(
                      IconBroken.Folder,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0
                ),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[300],
                  width: double.infinity,
                ),
              ),
              ConditionalBuilder(
                condition: SocialCubit.get(context).postList.isNotEmpty,
               builder: (context){
                 return ListView.separated(
                   shrinkWrap: true,
                   physics: NeverScrollableScrollPhysics(),
                   itemBuilder:(context,index ) =>
                       buildPostItem(context,SocialCubit.get(context).postList[index],index,),
                   separatorBuilder: (context,index) => SizedBox(
                     height: 8,
                   ),
                   itemCount: SocialCubit.get(context).postList.length,
                 );
               },
                fallback:(context)=> Center(child: CircularProgressIndicator()),
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        );
    },
    );
  }
}
 Widget buildPostItem(context,PostModel model,index)
 {
   if(model.dateTime!=null){
     DateTime now = DateTime. now();
     String formattedDate = DateFormat('yyyy-MM-dd – kk:mm'). format(now);
   }
   return Card(
     clipBehavior: Clip.antiAliasWithSaveLayer,
     margin: EdgeInsets.symmetric(
         horizontal: 8.0
     ),
     elevation: 5.0,
     child: Padding(
       padding: const EdgeInsets.all(10.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               if(model.image != null)
               CircleAvatar(
                 radius: 25.0,
                 backgroundImage: NetworkImage(
                  model.image!,
                 ),
               ),
               SizedBox(
                 width: 15.0,
               ),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Text(
                           model.name!,
                           style: TextStyle(height: 1.4),
                         ),
                         SizedBox(
                           width: 5.0,
                         ),
                         Icon(
                           Icons.check_circle,
                           color:defaultColour,
                           size: 16.0,
                         )
                       ],
                     ),
                     Text('${model.dateTime}',
                       style: Theme.of(context).textTheme.caption!.copyWith(
                           height: 1.4
                       ),
                     )
                   ],
                 ),
               ),
               SizedBox(
                 width: 15.0,
               ),
             IconButton(
                 onPressed: (){
               SocialCubit.get(context).deletePost(
                   postId: SocialCubit.get(context).postId[index]);
             }, icon: Icon(IconBroken.Delete))
             ],
           ),
           Padding(
             padding: const EdgeInsets.symmetric(
                 vertical: 15.0
             ),
             child: Container(
               height: 1.0,
               color: Colors.grey[300],
               width: double.infinity,
             ),
           ),
           Text(model.text!,
             style: Theme.of(context).textTheme.subtitle1,
           ),
           // Padding(
           //   padding: const EdgeInsets.only(
           //       bottom: 10,
           //       top: 5.0
           //   ),
           //   child: Container(
           //     width: double.infinity,
           //     child: Wrap(
           //       children: [
           //         Padding(
           //           padding: const EdgeInsetsDirectional.only(end: 5.0),
           //           child: Container(
           //             height: 20.0,
           //             child: MaterialButton(
           //               minWidth: 1.0,
           //               padding: EdgeInsets.zero,
           //               onPressed: (){},
           //               child: Text('#software',
           //                 style: TextStyle(
           //                   color: defaultColour,
           //                 ),
           //               ),
           //             ),
           //           ),
           //         ),
           //         Padding(
           //           padding: const EdgeInsetsDirectional.only( end: 10.0),
           //           child: Container(
           //             height: 20.0,
           //             child: MaterialButton(
           //               minWidth: 1.0,
           //               padding: EdgeInsets.zero,
           //               onPressed: (){},
           //               child: Text('#software',
           //                 style: TextStyle(
           //                   color: defaultColour,
           //                 ),
           //               ),
           //             ),
           //           ),
           //         ),
           //         Padding(
           //           padding: const EdgeInsetsDirectional.only( end: 10.0),
           //           child: Container(
           //             height: 20.0,
           //             child: MaterialButton(
           //               minWidth: 1.0,
           //               padding: EdgeInsets.zero,
           //               onPressed: (){},
           //               child: Text('#software_development',
           //                 style: TextStyle(
           //                   color: defaultColour,
           //                 ),
           //               ),
           //             ),
           //           ),
           //         ),
           //       ],
           //     ),
           //   ),
           // ),
           if(model.postImage != '')
             Padding(
               padding: const EdgeInsets.symmetric(
                 vertical: 5.0,
               ),
               child: Container(
                 height: 340,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4.0),
                   image: DecorationImage(
                     image:(
                         NetworkImage(model.postImage!)),
                     fit: BoxFit.cover,
                   ),
                 ),
               ),
             ),
           Padding(
             padding: const EdgeInsets.symmetric(
                 vertical: 5.0
             ),
             child: Row(
               children:
               [
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.symmetric(
                         vertical: 5.0
                     ),
                     child: InkWell(
                       child: Row(
                         children: [
                           Icon(IconBroken.Heart,
                             size: 18,
                             color: Colors.red,
                           ),
                           SizedBox(
                             width: 5.0,
                           ),
                           Text('${SocialCubit.get(context).likesCountList[index]}',
                             style: Theme.of(context).textTheme.caption,
                           ),
                         ],
                       ),
                       onTap: (){},
                     ),
                   ),
                 ),
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.symmetric(
                         vertical: 5
                     ),
                     child: InkWell(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           Icon(IconBroken.Chat,
                             size: 18,
                             color: Colors.amber,
                           ),
                           Text(SocialCubit.get(context).commentModelList.length.toString(),
                             style: Theme.of(context).textTheme.caption,
                           ),
                         ],
                       ),
                       onTap: (){},
                     ),
                   ),
                 ),
               ],
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(
                 bottom: 10.0
             ),
             child: Container(
               height: 1.0,
               color: Colors.grey[300],
               width: double.infinity,
             ),
           ),
           Row(
             children: [
               Expanded(
                 child: InkWell(
                   child: Row(
                     children: [
                       CircleAvatar(
                         radius: 18.0,
                         backgroundImage: NetworkImage(
                           SocialCubit.get(context).userModel!.image!,
                         ),
                       ),
                       SizedBox(
                         width: 5.0,
                       ),
                       Text('Write a comment',
                         style: Theme.of(context).textTheme.caption,
                       )
                     ],
                   ),
                   onTap: (){
                     SocialCubit.get(context).getComments(SocialCubit.get(context).postId[index]);
                     navigateTo(context, NewCommentScreen());
                   },
                 ),
               ),
               InkWell(
                 child: Row(
                   children: [
                     Icon(IconBroken.Heart,
                       size: 18,
                       color: Colors.red,
                     ),
                     SizedBox(
                       width: 5.0,
                     ),
                     Text('Like',
                       style: Theme.of(context).textTheme.caption,
                     ),
                   ],
                 ),
                 onTap: ()
                 {
                   SocialCubit.get(context).likePost(SocialCubit.get(context).postId[index]);
                 },
               ),
             ],
           ),
         ],
       ),
     ),
   );
 }


