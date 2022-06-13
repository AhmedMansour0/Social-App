import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/cubit/cubit.dart';
import '../../../shared/components/cubit/states.dart';


class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).archivedTasks;
          return taskBuilder(
              tasks: tasks
          );
        }
    );
  }
}
