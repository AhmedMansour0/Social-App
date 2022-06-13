// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/models/shop_app/favorites_model.dart';
import 'package:untitled/shared/components/components.dart';

import '../../../layout/shop_app/cubit.dart';
import '../../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state) {},
        builder: (context, state) => ConditionalBuilder(
            condition: state is! ShopLoadingGetFavoritesState,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                 buildFavItem(ShopCubit.get(context).favoritesModel!.data.data[index],context),
                separatorBuilder:(context, index) => myDivider(),
                itemCount: ShopCubit.get(context).favoritesModel!.data.data.length,
            ),
            fallback: (context)=> Center(child: CircularProgressIndicator())
        ),
    );
  }
}


Widget buildFavItem(FavoritesData model, context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child:Container(
    height:  120,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.product!.image),
              width: 120.0,
              height: 120.0,
            ),
            if(model.product!.discount != 0)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 6.0
                ),
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
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.product!.name,
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
                    model.product!.price.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: defaultColour,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if(model.product!.discount != 0)
                    Text(
                   'EGP''${model.product!.oldPrice.toString()}',
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
                        ShopCubit.get(context).changeFavorites(model.product!.id);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor:
                        ShopCubit.get(context).favorites[model.product?.id]
                            ? defaultColour
                            : Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
