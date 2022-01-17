import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/modules/search/cubit/search_cubit.dart';
import 'package:shop/modules/search/cubit/search_states.dart';

class ShopSearchScreen extends StatelessWidget {
  ShopSearchScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopSearchCubit>(
      create: (context) => ShopSearchCubit(),
      child: BlocConsumer<ShopSearchCubit, ShopSearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ShopSearchCubit cubit = ShopSearchCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultFormField(
                    hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      controller: searchController,
                      type: TextInputType.text,
                      
                      onChanged: (String? text) {
                        cubit.getShopSearchData(text: text);
                      }),
                  const SizedBox(height: 10),
                  if (state is ShopSearchLoadingState)
                    const LinearProgressIndicator(),
                  if (state is ShopSearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildSearchItem(
                          cubit.searchModel!.data!.dataModel[index],
                          context,
                        ),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: cubit.searchModel!.data!.dataModel.length,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildSearchItem(DataModel model, context) => Container(
      margin: const EdgeInsets.all(20),
      height: 120,
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(
                  '${model.image}',
                ),
                height: 100,
                width: 100,
              ),
              if (model.oldPrice != model.price)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  color: primaryColor,
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.name.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
