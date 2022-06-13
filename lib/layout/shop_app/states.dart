import 'package:untitled/models/shop_app/change_favorites_model.dart';
import 'package:untitled/models/shop_app/login_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates{}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates
{
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopChangeFavoritesState extends ShopStates{}

class ShopErrorFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopLoadingGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates
{
  final ShopLoginModel ? loginModel;

  ShopSuccessUserDataState(this.loginModel);}

class ShopLoadingUserDataState extends ShopStates{}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateUserState extends ShopStates {}

class ShopSuccessUpdateUserState extends ShopStates
{
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends ShopStates {}

class ShopLoadingProductDataState extends ShopStates{}

class ShopSuccessProductDataState extends ShopStates{}

class ShopErrorProductDataState extends ShopStates{}

class ChangeIndicatorState extends ShopStates{}

class ShopLoadingCartState extends ShopStates{}

class ShopSuccessCartState extends ShopStates{}

class ShopChangeCartState extends ShopStates{}

class ShopErrorCartState extends ShopStates{}

class ShopLoadingGetCartState extends ShopStates{}

class ShopSuccessGetCartState extends ShopStates{}

class ShopErrorGetCartState extends ShopStates{}
