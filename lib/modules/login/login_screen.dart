import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/modules/login/cubit/shop_cubit.dart';
import 'package:shop/modules/login/cubit/shop_states.dart';
import 'package:shop/modules/register/shop_register_screen.dart';
import 'package:shop/network/local/shared_prefrence.dart';
import 'package:shop/shop_layout/shop_layout.dart';

class ShopLoginScreen extends StatefulWidget {
  const ShopLoginScreen({Key? key}) : super(key: key);

  @override
  _ShopLoginScreenState createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopLoginCubit>(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, states) {
          var state = ShopLoginCubit.get(context);
          if (states is ShopLoginSuccessState) {
            if (state.loginModel!.status == true) {
              buildToast(
                message: state.loginModel!.message!,
                toastStates: ToastStates.SUCCESS,
              );
              ShopCacheHelper.saveData(
                key: 'token',
                value: state.loginModel!.data!.token,
              ).then((value) {
                token = state.loginModel!.data!.token;
                navigateAndReplacement(
                  context: context,
                  widget: const ShopLayout(),
                );
              });
            }
          }
          if (states is ShopLoginErrorState) {
            if (state.loginModel!.status == false) {
              Fluttertoast.showToast(
                msg: state.loginModel!.message!,
                backgroundColor: Colors.red,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_LONG,
              );
            }
          }
        },
        builder: (context, states) {
          var cubit = ShopLoginCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        defaultFormField(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email),
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        defaultFormField(
                          isPassword: cubit.isPassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changeLoginVisibility();
                            },
                            icon: cubit.icon,
                          ),
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          controller: passwordController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30
                        ),
                        ConditionalBuilder(
                          condition: states is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            backgroundColor: primaryColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            textButton: 'Login',
                            isUpperCase: true,
                          ),
                          fallback: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                                isUpperCase: true,
                                text: 'register',
                                color: primaryColor,
                                onPressed: () {
                                  navigateAndReplacement(
                                      context: context,
                                      widget: ShopRegisterScreen());
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
