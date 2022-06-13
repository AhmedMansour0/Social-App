
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/news_app/cubit/states.dart';
import 'package:untitled/modules/news_app/business/business_screen.dart';
import 'package:untitled/modules/news_app/science/science_screen.dart';
import 'package:untitled/modules/news_app/sports/sports_screen.dart';
import 'package:untitled/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{

   NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context ) => BlocProvider.of(context);
  int currentIndex = 0;
List <Widget> screens = [
  BusinessScreen(),
  SportsScreen(),
  ScienceScreen(),

];
List <dynamic> business =[];
List <dynamic> sports =[];
List <dynamic> science =[];


   List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
  ];
void changeBottomNavBar(int index)
{
   currentIndex = index;
   if(index==1) {
     getSports();
   }
   if(index==2) {
     getScience();
   }
  emit(NewsBottomNavState());
}
void getBusiness()
{
  emit(NewsGetBusinessLoadingState());
  if(business.isEmpty)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'business',
          'apiKey':'2a8894cc74c645b18a7660c041eb45cb',
        },
      ).then((value) {
        business = value.data['articles'];
        print(business[0]['title']);
        emit(NewsGetBusinessSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetBusinessErrorState(error));
      });
    }
  else {
    emit(NewsGetBusinessSuccessState());
  }

}

void getSports()
{
     emit(NewsGetSportsLoadingState());
     if(sports.isEmpty)
       {
         DioHelper.getData(
           url: 'v2/top-headlines',
           query:
           {
             'country':'eg',
             'category':'Sports',
             'apiKey':'2a8894cc74c645b18a7660c041eb45cb',
           },
         ).then((value) {
           sports = value.data['articles'];
           print(sports[0]['title']);
           emit(NewsGetSportsSuccessState());
         }).catchError((error){
           print(error.toString());
           emit(NewsGetSportsErrorState(error));
         });
       }else{
       emit(NewsGetSportsSuccessState());
     }

   }

void getScience()
{
     emit(NewsGetScienceLoadingState());
     if(science.isEmpty)
       {
         DioHelper.getData(
           url: 'v2/top-headlines',
           query:
           {
             'country':'eg',
             'category':'science',
             'apiKey':'2a8894cc74c645b18a7660c041eb45cb',
           },
         ).then((value) {
           science = value.data['articles'];
           print(science[0]['title']);
           emit(NewsGetScienceSuccessState());
         }).catchError((error){
           print(error.toString());
           emit(NewsGetScienceErrorState(error));
         });
       }else
         {
       emit(NewsGetScienceSuccessState());
     }

   }

   List<dynamic> search = [];

   void getSearch(String value)
   {
     emit(NewsGetSearchLoadingState());

     DioHelper.getData(
       url: 'v2/everything',
       query:
       {
         'q':value,
         'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
       },
     ).then((value)
     {
       //print(value.data['articles'][0]['title']);
       search = value.data['articles'];
       print(search[0]['title']);

       emit(NewsGetSearchSuccessState());
     }).catchError((error){
       print(error.toString());
       emit(NewsGetSearchErrorState(error.toString()));
     });
   }
}




