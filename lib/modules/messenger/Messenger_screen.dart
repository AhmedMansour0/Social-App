import 'package:flutter/material.dart';

class MessengerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 20.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  'https://scontent.fcai20-5.fna.fbcdn.net/v/t1.6435-9/170632318_1892208157616787_322420864165426245_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=wGy1WkeXJFgAX8VUyNa&_nc_ht=scontent.fcai20-5.fna&oh=31776126d7a6bf6983632ce7fd5da1f6&oe=61797890'),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              'Chats',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.camera_alt,
                  size: 15.0,
                  color: Colors.white,
                ),
              )),
          IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.edit,
                  size: 15.0,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                color: Colors.grey[300],
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text('Search'),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
               Container(
                 height: 100,
                 child: ListView.separated(
                   shrinkWrap: true,
                   itemBuilder: (context, index)=> buildStoryItem (),
                   itemCount: 15,
                   scrollDirection:Axis.horizontal,
                   separatorBuilder: (context, index) => SizedBox (
                     width: 20,
                   ),
                     ),
               ),
              SizedBox(
                height: 20,),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemBuilder: (context, index)=> buildStoryItem (),
                  separatorBuilder: (context, index)=> SizedBox(height: 20,),
                itemCount: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }



 Widget buildChatItem () => Row(
   children: [
     Stack(
       alignment: AlignmentDirectional.bottomEnd,
       children: [
         CircleAvatar(
           radius: 30.0,
           backgroundImage: NetworkImage(
               'https://scontent.fcai20-5.fna.fbcdn.net/v/t1.6435-9/170632318_1892208157616787_322420864165426245_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=wGy1WkeXJFgAX8VUyNa&_nc_ht=scontent.fcai20-5.fna&oh=31776126d7a6bf6983632ce7fd5da1f6&oe=61797890'),
         ),
         Padding(
           padding: const EdgeInsetsDirectional.only(
               bottom: 3.0, end: 4.0),
           child: CircleAvatar(
             radius: 5.0,
             backgroundColor: Colors.green,
           ),
         ),
       ],
     ),
     SizedBox(
       width: 20.0,),
     Expanded(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text('Mohamed Mansour',
             style: TextStyle(
               fontSize: 16.0,
               fontWeight: FontWeight.bold,
             ),
           ),
           SizedBox(
             height: 5.0,),
           Row(
             children: [
               Text('Meet me there'
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(
                   horizontal: 7.0,),
                 child: Container(
                   width: 5.0,
                   height: 5.0,
                   decoration: BoxDecoration(
                       color: Colors.grey,
                       shape: BoxShape.circle
                   ),
                 ),
               ),
               Text('02:00 pm',
               ),
             ],
           ),

         ],
       ),
     ),
   ],
 );

  Widget buildStoryItem () => Container(
    width: 60.0,
    child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                  'https://scontent.fcai20-5.fna.fbcdn.net/v/t1.6435-9/170632318_1892208157616787_322420864165426245_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=wGy1WkeXJFgAX8VUyNa&_nc_ht=scontent.fcai20-5.fna&oh=31776126d7a6bf6983632ce7fd5da1f6&oe=61797890'),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  bottom: 3.0, end: 4.0),
              child: CircleAvatar(
                radius: 5.0,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Text(
          'Ahmed Mansour',
          maxLines: 2,
        ),
      ],
    ),
  );
}
