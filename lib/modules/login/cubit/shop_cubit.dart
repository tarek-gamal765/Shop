import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/dio_helper/dio_helper.dart';
import 'package:shop/models/shop_login_model.dart';
import 'package:shop/modules/login/cubit/shop_states.dart';
import 'package:shop/network/remote/end_points.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  Icon icon = const Icon(Icons.visibility);

  void changeLoginVisibility() {
    isPassword = !isPassword;
    icon = isPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off);
    emit(ChangeLoginPasswordVisibility());
  }

  LoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    ShopDioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
      language: lang,
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState());
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }
}
