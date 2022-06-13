// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/models/shop_app/home_model.dart';
import 'package:untitled/modules/shop_app/products/products_details_screen.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/styles/colors.dart';

import '../../../models/shop_app/categories_model.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
        builder: (context, state)
        {
          return ConditionalBuilder(
              condition: ShopCubit.get(context).homeModel != null&& ShopCubit.get(context).categoriesModel != null,
              builder: (context) => productsBuilder(ShopCubit.get(context).homeModel!,ShopCubit.get(context).categoriesModel!,context),
              fallback:(context) => Center(
                  child: CircularProgressIndicator()),
          );
        },
        listener: (context,state)
        {
          if(state is ShopSuccessChangeFavoritesState)
            {
              if(state.model.status == false)
                {
                  showToast(text: state.model.message!, state: ToastStates.ERROR);
                }
            }
        }
    );
  }

  Widget productsBuilder (HomeModel model, CategoriesModel categoriesModel, context) => SingleChildScrollView(
     physics: BouncingScrollPhysics(),
     child: Column(
      children:
      [
        CarouselSlider(
        items: model.data.banners.map((e) =>
         Image(image: NetworkImage(e.image),
         width: double.infinity,
          fit: BoxFit.cover,
           ),).toList(),
            options: CarouselOptions(
              height: 250,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 1),
              initialPage: 0,
              autoPlayInterval: Duration(seconds: 3),
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              reverse: false,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 100.0,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      buildCategoryItem(categoriesModel.data.data[index]),
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10.0,
                  ),
                  itemCount: categoriesModel.data.data.length,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'New Products',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 1 / 1.58,
            children: List.generate(
              model.data.products.length,
                  (index) =>
                  buildGridProduct(model.data.products[index],context),
            ),
          ),
        ),
      ],),
   );
  Widget buildGridProduct(ProductModel ? model,context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> ProductDetails(model!.id)));
                  },
                  child: Image(
                    image: NetworkImage(model!.image),
                    width: double.infinity,
                    height: 200.0,
                  ),
                ),
                if(model.discount != 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  color: Colors.red,
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontSize: 9.0,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.name,
                  maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: defaultColour,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if(model.discount != 0)
                      Text(
                        '${model.oldPrice.round()}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: ()
                          {
                            ShopCubit.get(context).changeFavorites(model.id!);
                            print(model.id);
                          },
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor:
                            ShopCubit.get(context).favorites[model.id]!
                                ? defaultColour
                                : Colors.grey,
                            child: Icon(
                              Icons.favorite_border,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ),
                      ),
                      IconButton(
                        onPressed: ()
                        {
                          ShopCubit.get(context).changeCart(model.id!);
                          print(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                          ShopCubit.get(context).isCart[model.id]!
                              ? defaultColour
                              : Colors.grey,
                          child: Icon(
                            Icons.shopping_cart,
                            size: 14.0,
                            color: Colors.white,
                          ),
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
  Widget buildCategoryItem(DataModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(model.image),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(
          .8,
        ),
        width: 100.0,
        child: Text(
          model.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );

}
