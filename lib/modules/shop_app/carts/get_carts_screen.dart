
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/models/shop_app/get_carts_model.dart';
import 'package:untitled/modules/shop_app/products/products_details_screen.dart';
import 'package:untitled/shared/styles/colors.dart';

import '../../../shared/components/components.dart';

class GetCartsScreen extends StatelessWidget {
  const GetCartsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder:  (context,state) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder:(context,index) => cartProducts(ShopCubit.get(context).getCartModel!.data.cartItems[index],context),
                  separatorBuilder:(context,index) =>myDivider(),
                  itemCount: ShopCubit.get(context).getCartModel!.data.cartItems.length
              ),
            ],
          ),
        ) ;
      },
    );
  }
  }

Widget buildCartItem(CartItems model, context) =>  Padding(
    padding: const EdgeInsets.all(20.0),
    child:Container(
      height:  120,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.product.image),
                width: 120.0,
                height: 120.0,
              ),
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
              children:
              [
                Text(
                  model.product.name,
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
                      model.product.price.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: defaultColour,
                      ),
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

Widget cartProducts(CartItems? model,context)
{
  return Card(
    child: Container(
      height: 180,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              children:
              [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProductDetails(model!.id)));
                  },
                  child: Image(image: NetworkImage(model!.product.image),
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Text(model.product.name,
                        style: TextStyle(fontSize: 15,),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10,),
                      Text('EGP ''${model.product.price}'
                        ,style: TextStyle(
                            fontSize: 17,fontWeight: FontWeight.bold),),
                    ],
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:
            [
              Container(
                height: 20,
                width: 1,
                color: Colors.grey[300],
              ),
              TextButton(
                  onPressed: ()
                  {
                    ShopCubit.get(context).changeCart(model.product.id);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_outlined,
                        color: Colors.grey,size: 18,),
                      SizedBox(
                        width: 2.5,
                      ),
                      Text('Remove',
                          style: TextStyle(
                            color: Colors.grey,fontSize: 13,
                          )),
                    ],
                  )
              ),
            ],
          )
        ],
      ),
    ),
  );
}

