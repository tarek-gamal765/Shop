import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/modules/search/search_screen.dart';
import 'package:shop/network/local/shared_prefrence.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              defaultIconButton(
                color: Colors.white,
                icon: Icons.search,
                onPressed: () {
                  navigateTo(
                    context: context,
                    widget: ShopSearchScreen(),
                  );
                },
              ),
              defaultIconButton(
                color: Colors.white,
                icon: Icons.logout,
                onPressed: () {
                  ShopCacheHelper.removeData(key: 'token').then((value) {
                    buildToast(
                      message: 'Logout Successfully',
                      toastStates: ToastStates.SUCCESS,
                    );
                    navigateAndReplacement(context: context, widget: const ShopLoginScreen());
                  }).catchError((error) {
                    buildToast(
                      message: 'Can not logout',
                      toastStates: ToastStates.ERROR,
                    );
                  });
                },
              ),
            ],
            title: const Text(
              'Shop',
            ),
          ),
          body: cubit.bottomNavScreen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) => cubit.changeBottomNavIndex(index),
            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart_sharp,
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
