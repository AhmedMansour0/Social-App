import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/components/cubit/cubit.dart';
import '../../shared/components/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body:  ConditionalBuilder(
            builder: (context)=> cubit.screens[cubit.currentIndex],
            condition: state is! AppGetDatabaseLoadingState,
            fallback:(context)=> Center(child: CircularProgressIndicator()),
          ),
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if(formKey.currentState!.validate())
                {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text
                  );
                }
              } else {
                scaffoldKey.currentState!.showBottomSheet(
                      (context) => Container(
                    color: Colors.grey[100],
                        padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: titleController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                prefix: const Icon(
                                  Icons.title,
                                  color: Colors.grey,
                                  size: 25.0,
                                ),
                                hintText: 'Task title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title must not be empty';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: timeController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                prefix: const Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.grey,
                                  size: 25.0,
                                ),
                                hintText: 'Task time'),
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return('Time must not be empty');
                              }
                            },
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value)
                              {
                                print(value!.format(context));
                                timeController.text = value.format(context);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            controller: dateController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                prefix: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                  size: 25.0,
                                ),
                                hintText: 'Task date'),
                            enabled: true,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return('date must not be empty');
                              }
                            },
                            onTap: () {
                              showDatePicker(
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2025-12-11'),
                                context: context,
                                initialDate: DateTime.now(),
                              ).then((value)
                              {
                                dateController.text=DateFormat.yMMMd().format(value!);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ).closed.then((value)
                {
                  cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit
                  );
                });
              cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add
              );
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: 'New Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archived Tasks'),
            ],
          ),
        );
      },
      ),
    );/**/
  }



}

