import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition : cubit.categoriesModel != null,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => categoryItem(cubit.categoriesModel!.data!.data[index]),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: cubit.categoriesModel!.data!.data.length,
          ),
        );
      },
    );
  }
  Widget categoryItem(DataModel model) =>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(
          height: 100,
          width: 100,
          image: NetworkImage(
              '${model.image}'),
        ),
        const SizedBox(width: 15,),
        Text(
          model.name.toString(),
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_forward_ios,
          ),
        ),
      ],
    ),
  );
}
