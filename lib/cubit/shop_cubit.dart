import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/dio_helper/dio_helper.dart';
import 'package:shop/models/add_to_cart_model.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/change_favourite_model.dart';
import 'package:shop/models/favourite_model.dart';
import 'package:shop/models/get_from_cart_model.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/models/shop_login_model.dart';
import 'package:shop/modules/cart/cart_screen.dart';
import 'package:shop/modules/favourite/favourite_screen.dart';
import 'package:shop/modules/home/products_screen.dart';
import 'package:shop/modules/settings/settings_screen.dart';
import 'package:shop/network/local/shared_prefrence.dart';
import 'package:shop/network/remote/end_points.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool? isDark = false;

  void changeShopTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark!;
      ShopCacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ChangeThemeModeState());
      });
    }
  }

  int currentIndex = 0;
  List<Widget> bottomNavScreen = [
    const ProductsScreen(),
    const FavouriteScreen(),
    const CartScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    emit(BottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favourites = {};
  BuildContext? context;

  void getShopHomeData() {
    emit(GetDataLoadingState());
    ShopDioHelper.getData(
      url: HOME,
      token: token,
      language: lang,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products) {
        favourites.addAll({
          element.id!: element.inFavorites!,
        });
      }
      emit(GetDataSuccessState());
    }).catchError((error) {
      emit(GetDataErrorState());
    });
  }

  ChangeFavouriteModel? changeFavouriteModel;

  changeFavourites(int? productId) {
    favourites[productId!] = !favourites[productId]!;
    emit(ChangeFavouriteState());
    ShopDioHelper.postData(
      url: FAVOURITES,
      data: {
        'product_id': productId,
      },
      token: token,
      language: lang,
    ).then((value) {
      changeFavouriteModel = ChangeFavouriteModel.formJson(value.data);
      if (!changeFavouriteModel!.status!) {
        favourites[productId] = !favourites[productId]!;
        emit(ChangeFavouriteSuccessState());
      } else {
        getFavouritesData();
      }
    }).catchError((error) {
      favourites[productId] = !favourites[productId]!;
      emit(ChangeFavouriteErrorState());
    });
  }

  FavouriteModel? favouriteModel;

  void getFavouritesData() {
    emit(GetFavouritesLoadingState());
    ShopDioHelper.getData(
      url: FAVOURITES,
      token: token,
      language: lang,
    ).then((value) {
      favouriteModel = FavouriteModel.fromJson(value.data);
      emit(GetFavouritesSuccessState());
    }).catchError((error) {
      emit(GetFavouritesErrorState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(GetCategoriesLoadingState());
    ShopDioHelper.getData(
      url: CATEGORIES,
      token: token,
      language: lang,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(GetCategoriesSuccessState());
    }).catchError((error) {
      emit(GetCategoriesSuccessState());
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(UserDataLoadingState());
    ShopDioHelper.getData(
      url: PROFILE,
      token: token,
      language: lang,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(UserDataSuccessState());
    }).catchError((error) {
      emit(UserDataErrorState());
    });
  }

  updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(UpdateUserDataLoadingState());
    ShopDioHelper.putData(
      url: UPDATE_PROFILE,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      token: token,
      language: lang,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      emit(UpdateUserDataErrorState());
    });
  }

  AddToCartModel? addToCartModel;

  addToCart({required int productId}) {
    emit(AddToCartLoadingState());
    ShopDioHelper.postData(
      url: CARTS,
      token: token,
      data: {
        "product_id": productId,
      },
      language: lang,
    ).then((value) {
      addToCartModel = AddToCartModel.fromJson(value.data);
      getFromCart();
      emit(AddToCartSuccessState());
    }).catchError((error) {
      emit(AddToCartErrorState());
    });
  }

  GetFromCartModel? getFromCartModel;

  getFromCart() {
    emit(GetFromCartLoadingState());
    ShopDioHelper.getData(
      url: CARTS,
      token: token,
      language: lang,
    ).then((value) {
      getFromCartModel = GetFromCartModel.fromJson(value.data);
      emit(GetFromCartSuccessState());
    }).catchError((error) {
      emit(GetFromCartErrorState());
    });
  }
}