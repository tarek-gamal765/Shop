import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/components.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/cubit/shop_cubit.dart';
import 'package:shop/cubit/shop_states.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/modules/product%20details/product_details.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit shopCubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: shopCubit.homeModel != null,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) => productBuilder(
            shopCubit.homeModel,
            shopCubit.categoriesModel,
            context,
          ),
        );
      },
    );
  }

  Widget productBuilder(
    HomeModel? homeModel,
    CategoriesModel? categoriesModel,
    context,
  ) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: homeModel!.data!.banners
                    .map(
                      (e) => Image(
                        height: 120,
                        width: double.infinity,
                        image: NetworkImage('${e.image}'),
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                  autoPlayAnimationDuration: const Duration(
                    seconds: 1,
                  ),
                  reverse: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 120,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesModel!.data!.data.length,
                  separatorBuilder: (context, index) => myDivider(),
                  itemBuilder: (context, index) => buildCategoryItem(
                      categoriesModel.data!.data[index], context),
                ),
              ),
              const Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: GridView.count(
                  shrinkWrap: true,
                  cacheExtent: 1 / 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.65,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(
                    homeModel.data!.products.length,
                    (index) => GestureDetector(
                      onTap: () {
                        navigateTo(
                          context: context,
                          widget: ProductDetails(
                            productModel: homeModel.data!.products[index],
                          ),
                        );
                      },
                      child: buildProductGrid(
                          homeModel.data!.products[index], context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildCategoryItem(DataModel? model, context) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            height: 120,
            width: 120,
            image: NetworkImage('${model!.image}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: 120,
            color: primaryColor,
            child: Text(
              '${model.name}',
              style: const TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

  Widget buildProductGrid(ProductModel productModel, context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(
                      '${productModel.image}',
                    ),
                    height: 200,
                  ),
                  if (productModel.oldPrice != productModel.price)
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
            const SizedBox(
              height: 10,
            ),
            Text(
              '${productModel.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${productModel.price} L.E',
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
                if (productModel.oldPrice != productModel.price)
                  Expanded(
                    child: Text(
                      '${productModel.oldPrice} L.E',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                defaultIconButton(
                  onPressed: () {
                    AppCubit.get(context).changeFavourites(productModel.id);
                  },
                  icon: Icons.favorite_rounded,
                  color: AppCubit.get(context).favourites[productModel.id]!
                      ? primaryColor
                      : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      );
}
