// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:untitled/modules/login/login_screen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Image.asset('assets/images/ex.png',
              scale: 4.0,
            ),
            SizedBox(
              height: 12.0,
            ),
            Center(
              child: Container(
                width: 300,
                height: 50,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text('Get Started',
                  style: TextStyle(color: Colors.white)
                    ,),
                  color: Colors.black12,
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> LoginScreen()
                    ),
                  );
                }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
