import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Center(child: Text('First App')),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              pressedButton();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.alarm,
            ),
            onPressed: () {
              pressedButton();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Image(
                    image: NetworkImage(
                        'data:image/jpeg;base64,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'),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    width: 200.0,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'DeadPool',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void pressedButton() {
  int r = 10;
  for (int i = 0; i <= r; i++) {
    print('ahmed');
  }
}
