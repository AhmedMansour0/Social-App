// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/layout/news_app/cubit/states.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/modules/news_app/web_view/web_view_screen.dart';
import 'package:untitled/shared/components/cubit/cubit.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function ? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function!(),
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget buildTaskItem(Map model,context)=> Dismissible(
  key: Key(model['id'].toString()),
 onDismissed: (direction)
 {

AppCubit.get(context).deleteData(id: model['id']);
 },
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}'
              ,)
        ),

        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${model['title']}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '${model['date']}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20.0,

        ),
        IconButton(
            onPressed:() {
              AppCubit.get(context).updateData(
                  status: 'done', id: model['id']
              );
            },
            icon: (
            const Icon(Icons.check_box)
            ),
          color: Colors.green,
        ),
        IconButton(
          onPressed:() {
            AppCubit.get(context).updateData(
                status: 'archive', id: model['id']
            );
          },
          icon: (
              const Icon(Icons.archive)
          ),
          color: Colors.black45,
        ),

      ],

    ),
  ),
);
Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
      onPressed: function(),
      child: Text(
        text.toUpperCase(),
      ),
    );
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit!(),
      onChanged: onChange!(),
      onTap: onTap!(),
      validator: validate(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed!(),
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );
Widget taskBuilder ({
  required List<Map>tasks,
    })=> ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) =>ListView.separated(itemBuilder: (context, index)=>buildTaskItem(tasks[index],context),
        separatorBuilder: (context,index)=>myDivider(),
        itemCount: tasks.length
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(
             Icons.menu,
            size: 70.0,
            color: Colors.grey,
           ),
          Text('No Tasts Yet, Please Add Some Tasks',
            style: TextStyle
              (
                fontSize: 17.0,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    )
);

Widget myDivider () => Container(
  width: double.infinity,
  color: Colors.grey[300],
  height: 1.0,
);

Widget buildArticleItem(article, context) => InkWell(
  onTap: (){
    navigateTo(context, WebViewScreen(article['url']),);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children:
      [
        Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0,),
            image: DecorationImage(
              image: NetworkImage('${article['urlToImage']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:
              [
                Expanded(
                  child: Text(
                    '${article['title']}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
      ],
    ),
  ),
);

void navigateTo(context, widget) => Navigator.push(context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context, widget
    )=> Navigator.pushAndRemoveUntil
  (context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (route)
      {
        return false;
      }
  );

Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
  condition: list.length > 0,
  builder: (context) =>
      ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: 10,),
  fallback: (context) => isSearch ? Container() : Center(child: CircularProgressIndicator()),
);

Widget defaultAppBar ({
  required BuildContext context,
  String ? title,
  List<Widget> ? actions,
})=> AppBar(
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    }, icon: (
      Icon(IconBroken.Arrow___Left_2)
  ),
  ),
  title: Text(
  title!,
),

  actions: actions,

);


void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0
    );

enum ToastStates{SUCCESS,ERROR,WARNING}

Color ?color;

Color ?chooseToastColor(ToastStates sate)
{
  switch(sate)
  {
    case ToastStates.SUCCESS :
    color = Colors.green;
    break;

    case ToastStates.ERROR :
      color = Colors.red;
      break;

      case ToastStates.WARNING :
    color = Colors.amber;
  }
}