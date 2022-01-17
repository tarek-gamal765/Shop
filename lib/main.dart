import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/dio_helper/dio_helper.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop/network/local/shared_prefrence.dart';
import 'package:shop/shop_layout/shop_layout.dart';

import 'modules/splash/slpash_screen.dart';

Widget? startWidget;
bool? isDark;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ShopDioHelper.shopDioInit();
  await ShopCacheHelper.init();
  bool? onBoarding = ShopCacheHelper.getData(key: 'onBoarding');

  token = ShopCacheHelper.getData(key: 'token');
  if (onBoarding != null) {
    if (token != null) {
      startWidget = const ShopLayout();
    } else {
      startWidget = const ShopLoginScreen();
    }
  } else {
    startWidget = const OnBoardingScreen();
  }
  isDark = ShopCacheHelper.getData(key: 'isDark');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AppCubit()
            ..getShopHomeData()
            ..getFromCart()
            ..getCategoriesData()
            ..changeShopTheme()
            ..getFavouritesData()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, states) {},
        builder: (BuildContext context, states) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: primaryColor,
            ),
            primarySwatch
            : Colors.red,
          ),
          color: primaryColor,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
