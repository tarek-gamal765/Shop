

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/dio_helper/dio_helper.dart';
import 'package:shop/models/shop_login_model.dart';
import 'package:shop/modules/register/cubit/shop_states.dart';
import 'package:shop/network/remote/end_points.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterLoadingState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

bool isPassword = true;
  Icon icon = const Icon(Icons.visibility);
  void changeLoginVisibility() {
    isPassword = !isPassword;
    icon = isPassword
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);
    emit(ChangeRegisterPasswordVisibility());
  }
  
  
  LoginModel? registerData;

  void userRegister({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) {
    emit(ShopRegisterLoadingState());
    ShopDioHelper.postData(
      url: REGISTER,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      },
      language: 'ar',
    ).then((value) {
      registerData = LoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState());
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }
}
