// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors



import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/layout/shop_app/cubit.dart';
import 'package:untitled/layout/shop_app/shop_layout.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/social_layout.dart';
import 'package:untitled/layout/todo_app/todo_layout.dart';
import 'package:untitled/modules/login/On_boarding_screen.dart';
import 'package:untitled/modules/login/login_screen.dart';
import 'package:untitled/modules/social_app/social_login/social_login_screen.dart';
import 'package:untitled/shared/bloc_observer.dart';
import 'package:untitled/shared/components/constances.dart';
import 'package:untitled/shared/components/cubit/cubit.dart';
import 'package:untitled/shared/components/cubit/states.dart';
import 'package:untitled/shared/network/local/cache_helper.dart';
import 'package:untitled/shared/network/remote/dio_helper.dart';
import 'package:untitled/shared/styles/themes.dart';
import 'layout/news_app/cubit/cubit.dart';
import 'layout/news_app/cubit/states.dart';
import 'layout/news_app/news_layout.dart';
import 'modules/shop_app/login/shop_login_screen.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'modules/shop_app/products/products_details_screen.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
  bool ? isDark = CacheHelper.getData(key: 'isDark');
  bool ? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  // uId = CacheHelper.getData(key: 'uId');
  //
  //   if(uId != null)
  //     {
  //       widget = SocialLayout();
  //     }
  //   else
  //     {
  //       widget = SocialLoginScreen();
  //     }

  if(onBoarding !=null)
  {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  }
  else {
    widget = OnBoardingScreen();
  }
   BlocOverrides.runZoned(() {

    runApp(MyApp(
      isDark: isDark,
      startWidget: widget,
    ));
    // Use cubits...
  },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  final bool ? isDark;
  final Widget startWidget;

  MyApp({
    required this.isDark,
     required this.startWidget,
  }
  );
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider(
          create: (context) => NewsCubit()..getBusiness()..getSports()..getScience(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()..changeAppMode
            (
              fromShared: isDark,
            ),
         ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData()..getAllCarts(),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData()..getPost(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
            AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
