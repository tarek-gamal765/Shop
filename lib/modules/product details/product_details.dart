import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/models/home_model.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    Key? key,
    required this.productModel,
  }) : super(key: key);
  final dynamic productModel;

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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Product Details'),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Image(
                          image: NetworkImage(
                            '${productModel.image}',
                          ),
                          fit: BoxFit.cover,
                        ),
                        if (productModel.discount != 0)
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
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productModel.name!,
                    style:  TextStyle(fontSize: 20,color: primaryColor,),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${productModel.price} L.E',
                        style:  TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (productModel.discount != 0) const SizedBox(width: 15),
                      if (productModel.discount != 0)
                        Text(
                          '${productModel.oldPrice} L.E',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      defaultIconButton(
                        onPressed: () {
                          AppCubit.get(context)
                              .changeFavourites(productModel.id);
                        },
                        icon: Icons.favorite_rounded,
                        color:
                            AppCubit.get(context).favourites[productModel.id]!
                                ? primaryColor
                                : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  defaultButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      cubit.addToCart(
                        productId: productModel.id!,
                      );
                      print(productModel.inCart.toString());
                    },
                    isUpperCase: false,
                    textButton:  'Add to Cart',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productModel.description!,
                    style:  TextStyle(color: primaryColor),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
