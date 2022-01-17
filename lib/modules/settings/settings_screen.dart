import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';

class SettingsScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context).userModel;
        nameController.text = cubit!.data!.name!;
        emailController.text = cubit.data!.email!;
        phoneController.text = cubit.data!.phone!;
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                children: [
                  defaultFormField(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (value) {
                      if (value!.trim().isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (value) {
                      if (value!.trim().isEmpty) {
                        return 'email must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    labelText: 'Phone',
                    prefixIcon: const Icon(Icons.phone),
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (value) {
                      if (value!.trim().isEmpty) {
                        return 'phone must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (state is UpdateUserDataLoadingState)
                    const LinearProgressIndicator(),
                  if (state is UpdateUserDataLoadingState)
                    const SizedBox(height: 20),
                  defaultButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (state is UpdateUserDataLoadingState &&
                              cubit.data!.email != emailController.text ||
                          cubit.data!.name != nameController.text ||
                          cubit.data!.phone != phoneController.text)
                        AppCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                    },
                    textButton: 'update',
                    isUpperCase: true,
                    backgroundColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
