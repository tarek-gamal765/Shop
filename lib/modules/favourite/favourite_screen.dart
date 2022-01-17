import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/models/favourite_model.dart';
import 'package:shop/modules/product%20details/product_details.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.favouriteModel != null,
          builder: (context) => cubit.favouriteModel!.data!.dataModel.isNotEmpty
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(
                        context: context,
                        widget: ProductDetails(
                          productModel:
                              cubit.favouriteModel!.data!
                              .dataModel[index].favProduct!,
                        ),
                      );
                    },
                    child: buildFavItem(
                      cubit.favouriteModel!.data!.dataModel[index].favProduct!,
                      context,
                    ),
                  ),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: cubit.favouriteModel!.data!.dataModel.length,
                )
              : const Center(
                  child: Text(
                    'No favourite product yet.',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget buildFavItem(FavouriteProductModel favouriteProductModel, context) => Container(
      margin: const EdgeInsets.all(20),
      height: 120,
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                height: 120,
                width: 120,
                image: NetworkImage(favouriteProductModel.image.toString()),
              ),
              if (favouriteProductModel.discount != 0)
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
                  favouriteProductModel.name.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style:  TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${favouriteProductModel.price} L.E',
                      style:  TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    if (favouriteProductModel.discount != 0) const SizedBox(width: 15),
                    if (favouriteProductModel.discount != 0)
                      Text(
                        '${favouriteProductModel.oldPrice} L.E',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    const Spacer(),
                    defaultIconButton(
                      onPressed: () {
                        AppCubit.get(context).changeFavourites(favouriteProductModel.id);
                      },
                      icon: Icons.favorite_rounded,
                      color: AppCubit.get(context).favourites[favouriteProductModel.id]!
                          ? primaryColor
                          : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
