// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/social_app/social_layout.dart';
import 'package:untitled/modules/social_app/social_login/cubit/cubit.dart';
import 'package:untitled/modules/social_app/social_login/cubit/sates.dart';
import 'package:untitled/modules/social_app/social_register/social_register_screen.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/network/local/cache_helper.dart';

class SocialLoginScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context)=> SocialLoginCubit(),
         child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
           listener:(context , state) {
             if(state is SocialLoginErrorState)
               {
                 showToast(
                     text: state.error,
                     state: ToastStates.ERROR
                 );
               }
             if(state is SocialLoginSuccessState)
               {
               CacheHelper.saveData(
                     key: 'uId',
                     value: state.uId,
                 ).then((value)
                 {
                   navigateAndFinish(context, SocialLayout());
                 });
               }
             },
           builder: (context,state){
             return Scaffold(
               appBar: AppBar(),
               body: Center(
                 child: SingleChildScrollView(
                   child: Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: Form(
                       key: formKey,
                       child: Column(
                         children: [
                           Text(
                             'LOGIN',
                             style: TextStyle(
                               fontSize: 22,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           SizedBox(
                             height: 7,
                           ),
                           Text(
                             'Login to Communicate with your friends',
                             style: TextStyle(
                               fontSize: 20,
                               color: Colors.grey,
                             ),
                             maxLines: 2,
                           ),
                           SizedBox(
                             height: 7,
                           ),
                           TextFormField(
                             controller: emailController,
                             keyboardType: TextInputType.emailAddress,
                             onFieldSubmitted: (value) {
                               if (formKey.currentState!.validate())
                               {
                                 SocialLoginCubit.get(context).userLogin(
                                     email: emailController.text,
                                     password: passwordController.text
                                 );
                               }
                             },
                             decoration: InputDecoration(
                               prefixIcon: Icon(Icons.email_outlined),
                               label: Text('Email Address'),
                             ),
                             validator: (value) {
                               if (value!.isEmpty) {
                                 return 'Email cannot be empty';
                               }
                             },
                           ),
                           SizedBox(
                             height: 15.0,
                           ),
                           TextFormField(
                             controller: passwordController,
                             obscureText: SocialLoginCubit.get(context).isPassword,
                             onFieldSubmitted: (value) {
                               if (formKey.currentState!.validate()) {
                                 SocialLoginCubit.get(context).userLogin(
                                     email: emailController.text,
                                     password: passwordController.text);
                               }
                             },
                             keyboardType: TextInputType.visiblePassword,
                             decoration: InputDecoration(
                                 prefixIcon: Icon(Icons.lock_clock_outlined),
                                 label: Text('Password'),
                                 suffix: IconButton(
                                   icon: Icon(SocialLoginCubit.get(context).suffix),
                                   onPressed: () {
                                     SocialLoginCubit.get(context)
                                         .changePasswordVisibility();
                                   },
                                 )),
                             validator: (value) {
                               if (value!.isEmpty) {
                                 return 'Password cannot be empty';
                               }
                             },
                           ),
                           SizedBox(
                             height: 30.0,
                           ),
                           ConditionalBuilder(
                             condition: State is! SocialLoginLoadingState,
                             builder: (context) => Container(
                               width: double.infinity,
                               height: 50.0,
                               decoration: BoxDecoration(
                                   color: Colors.blue,
                                   borderRadius: BorderRadius.circular(10.0)),
                               child: MaterialButton(
                                 onPressed: () {
                                   {
                                     if (formKey.currentState!.validate()) {
                                       SocialLoginCubit.get(context).userLogin(
                                           email: emailController.text,
                                           password: passwordController.text
                                       );
                                     }
                                   }
                                 },
                                 child: Text('LOGIN'),
                               ),
                             ),
                             fallback: (context) =>
                                 Center(child: CircularProgressIndicator()),
                           ),
                           SizedBox(
                             height: 15.0,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('Don/t have an account ?'),
                               TextButton(
                                 onPressed: ()
                                 {
                                   navigateTo(context, SocialRegisterScreen());
                                 },
                                 child: Text('Register'),
                               )
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             );
           } ,

        ),
    );
  }
}
