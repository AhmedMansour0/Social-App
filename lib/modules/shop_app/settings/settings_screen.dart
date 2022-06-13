// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/modules/shop_app/login/cubit/cubit.dart';
import 'package:untitled/shared/components/constances.dart';
import 'package:untitled/shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        ShopCubit cubit =  ShopCubit.get(context);
        var model = cubit.userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder:(context)=>Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column
                (
                children:
                [
                  if(state is ShopLoadingUpdateUserState)
                  LinearProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    validator:(String ? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'Name must not be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration
                      (
                        label: Text('Name'),
                        prefixIcon: (
                            Icon(Icons.person)
                        )
                    ),
                  ),
                  SizedBox
                  (
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator:(String ? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'Email must not be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration
                      (
                        label: Text('Email'),
                        prefixIcon: (
                            Icon(Icons.email)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: phoneController,
                    validator:(String ? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'Phone must not be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration
                      (
                        label: Text('Phone'),
                        prefixIcon: (
                            Icon(Icons.phone)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    color: defaultColour,
                    child: TextButton(
                        onPressed: ()
                        {
                          signOut(context);
                        },
                       child: (
                        Text('LOGOUT',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        )
                       ),
                     ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: defaultColour,
                        child: TextButton(
                          onPressed: ()
                          {
                            if(formKey.currentState!.validate())
                              {
                                cubit.updateUserData
                                  (
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text
                                );
                              }
                          },
                          child: (
                              Text('UPDATE',
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
