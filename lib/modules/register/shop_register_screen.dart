import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/modules/register/cubit/shop_cubit.dart';
import 'package:shop/modules/register/cubit/shop_states.dart';
import 'package:shop/network/local/shared_prefrence.dart';
import 'package:shop/shop_layout/shop_layout.dart';

class ShopRegisterScreen extends StatefulWidget {
  const ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  _ShopRegisterScreenState createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopRegisterCubit>(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          var cubit = ShopRegisterCubit.get(context);
          if (state is ShopRegisterSuccessState) {
            if (cubit.registerData!.status == true) {
              buildToast(
                message: cubit.registerData!.message!,
                toastStates: ToastStates.SUCCESS,
              );
              ShopCacheHelper.saveData(
                key: 'token',
                value: cubit.registerData!.data!.token,
              ).then((value) {
                token = cubit.registerData!.data!.token;
                navigateAndReplacement(
                  context: context,
                  widget: const ShopLayout(),
                );
              });
            }
          }
          if (cubit is ShopRegisterErrorState) {
            if (cubit.registerData!.status == false) {
              Fluttertoast.showToast(
                msg: cubit.registerData!.message!,
                backgroundColor: Colors.red,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_LONG,
              );
            }
          }
        },
        builder: (context, state) {
           var cubit = ShopRegisterCubit.get(context);
          return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Register now',
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
                        prefixIcon: const Icon(Icons.person),
                        controller: nameController,
                        labelText: 'Name',
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your name';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                          prefixIcon: const Icon(Icons.email),
                          controller: emailController,
                          labelText: 'Email',
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      defaultFormField(
                        prefixIcon: const Icon(Icons.phone),
                        controller: phoneController,
                        labelText: 'Phone',
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your phone number';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit
                                .changeLoginVisibility();
                          },
                          icon: cubit.icon,
                        ),
                        isPassword: cubit.isPassword,
                        prefixIcon: const Icon(Icons.lock),
                        controller: passwordController,
                        labelText: 'Password',
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your password';
                          } else if (value.trim().length < 7) {
                            return 'please enter your password';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      defaultButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            cubit.userRegister(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        textButton: 'register',
                        isUpperCase: true,
                        backgroundColor: primaryColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                          ),
                          defaultTextButton(
                              isUpperCase: true,
                              color: primaryColor,
                              text: 'login',
                              onPressed: () {
                                navigateAndReplacement(
                                    context: context,
                                    widget: const ShopLoginScreen());
                              })
                        ],
                      )
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
