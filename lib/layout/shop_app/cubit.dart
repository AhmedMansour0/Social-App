// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/models/shop_app/cart_model.dart';
import 'package:untitled/models/shop_app/get_carts_model.dart';
import 'package:untitled/models/shop_app/home_model.dart';
import 'package:untitled/models/shop_app/login_model.dart';
import 'package:untitled/models/shop_app/products_model.dart';
import 'package:untitled/modules/shop_app/categories/categories_screen.dart';
import 'package:untitled/modules/shop_app/favorites/favorites_screen.dart';
import 'package:untitled/modules/shop_app/products/products_details_screen.dart';
import 'package:untitled/modules/shop_app/products/products_screen.dart';
import 'package:untitled/modules/shop_app/settings/settings_screen.dart';
import 'package:untitled/shared/components/constances.dart';
import 'package:untitled/shared/network/end_points.dart';
import 'package:untitled/shared/network/remote/dio_helper.dart';

import '../../models/shop_app/categories_model.dart';
import '../../models/shop_app/change_favorites_model.dart';
import '../../models/shop_app/favorites_model.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex= 0;

  List<Widget> bottomScreens =[
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  Map <dynamic ,dynamic> favorites = {};

  Map <dynamic ,dynamic> isCart = {};

  void changeBottom(int index){
    currentIndex = index;
    emit(ShopChangeBottomNavState());
}
 HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      emit(ShopSuccessHomeDataState());
      for (var element in homeModel!.data.products) {
        favorites.addAll({
          element.id : element.inFavorites
        });
      }
      for (var element in homeModel!.data.products)
      {
        isCart.addAll({ element.id : element.inCart });
      }
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }
 late ChangeFavoritesModel  changeFavoritesModel;

  void changeFavorites(int productId)
  {
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
        url: FAVORITES,
        data:
        {
          'product_id': productId
        },
        token: token,
       ).then((value)
    {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if(changeFavoritesModel.status == false)
        {
          favorites[productId] =! favorites[productId];
        }
      else
        {
          getFavorites();
        }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
    }).catchError((error)
    {
      favorites[productId] = !favorites[productId];
      emit(ShopErrorFavoritesState());
      print(error.toString());
    });
  }

  FavoritesModel ? favoritesModel;

  void getFavorites() {

    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel ? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }
  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
  ProductDetailsModel ? productDetailsModel;
  void getProductDetails(int productId)
{
  emit(ShopLoadingProductDataState());
  DioHelper.getData(
    url: 'products/$productId',
      token: token,
  ).then((value)
  {
    productDetailsModel = ProductDetailsModel.fromJson(value.data);
  print('ProductDetails'+ productDetailsModel!.status.toString());
  emit((ShopSuccessProductDataState()));
  }).catchError((error){
    print(error.toString());
    emit(ShopErrorProductDataState());
  });
}
int value = 0;
  void changeVal(val){
    value = val;
    emit(ChangeIndicatorState());
  }


  CartModel ? cartModel ;
  void changeCart(int productId)
  {
    isCart[productId] =! isCart[productId];
    emit(ShopChangeCartState());
    DioHelper.postData(
        url: CARTS,
        token: token,
        data:
        {
          'product_id': productId
        }
    ).then((value)
    {
      cartModel = CartModel.fromJson(value.data);
      if(cartModel!.status == false)
      {
        isCart[productId] =! isCart[productId];
      }
      else
        {
          getAllCarts();
        }
      emit(ShopSuccessCartState());
    }).catchError((error)
    {
      isCart[productId] =! isCart[productId];
      print(error.toString());
    });
  }

  GetCartModel? getCartModel;

  void getAllCarts(){
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
        url: CARTS,
      token: token
    ).then((value){
      getCartModel = GetCartModel.fromJson(value.data);
      emit(ShopSuccessGetCartState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetCartState());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  }

}

