import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/models/get_from_cart_model.dart';
import 'package:shop/modules/product%20details/product_details.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddToCartSuccessState) {
          buildToast(
            message: cubit.addToCartModel!.message!,
            toastStates: ToastStates.SUCCESS,
          );
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.getFromCartModel != null,
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
          builder: (context) {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  navigateTo(
                    context: context,
                    widget: ProductDetails(
                      productModel: cubit
                          .getFromCartModel!.data!.cartItems[index].product!,
                    ),
                  );
                },
                child: buildCartItem(
                  cubit.getFromCartModel!.data!.cartItems[index].product!,
                  context,
                  cubit,
                ),
              ),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: cubit.getFromCartModel!.data!.cartItems.length,
            );
          },
        );
      },
    );
  }
}

Widget buildCartItem(ProductCartDataModel model, context, AppCubit cubit) =>
    Container(
      margin: const EdgeInsets.all(20),
      height: 150,
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                height: 120,
                width: 120,
                image: NetworkImage(model.image!),
              ),
              if (model.discount != 0)
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    children: [
                      Text(
                        '${model.price} L.E',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                      if (model.discount != 0) const SizedBox(width: 15),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice} L.E',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      const Spacer(),
                      defaultIconButton(
                        onPressed: () {
                          AppCubit.get(context).changeFavourites(model.id);
                        },
                        icon: Icons.favorite_rounded,
                        color: AppCubit.get(context).favourites[model.id]!
                            ? primaryColor
                            : Colors.grey,
                      ),
                    ],
                  ),
                  defaultButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      cubit.addToCart(productId: model.id!);
                    },
                    textButton: 'Delete',
                  )
                ],),
          ),
        ],
      ),
    );
