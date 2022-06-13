// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/layout/shop_app/cubit.dart';
import 'package:untitled/layout/shop_app/states.dart';
import 'package:untitled/models/shop_app/products_model.dart';
import 'package:untitled/shared/styles/colors.dart';

class ProductDetails extends StatelessWidget {
  final id;
  ProductDetails(this.id);

  var SmoothController = PageController();

  @override
  Widget build(BuildContext context) {
    return  BlocProvider.value(
        value: BlocProvider.of<ShopCubit>(context)..getProductDetails(id),
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state)
          {
          },
            builder: (context, state) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                    color: Colors.deepPurple
                ),
              ),
              body: state is ShopLoadingProductDataState
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: LinearProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              )
                  : bodyBuild(
                  context,
                  ShopCubit.get(context).productDetailsModel,
                  SmoothController,
            ),
            )) );
  }
}

Widget bodyBuild(context, ProductDetailsModel? model, smoothController) {
  List<Widget> images = [];
  for (var element in model!.data.images) {
    images.add(
        Image.network(element, fit: BoxFit.contain));
  }
  return ShopCubit.get(context).productDetailsModel == null
      ? Center(child: CircularProgressIndicator())
      : Container(
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(
        children: [
          Text(
            model.data.name!,
            style: TextStyle(fontSize: 25),
          ),
          CarouselSlider(
              items: images,
              options: CarouselOptions(
                  height: 300,
                  onPageChanged: (index,reason){
                    ShopCubit.get(context).changeVal(index);
                  })),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: AnimatedSmoothIndicator(
                  activeIndex: ShopCubit.get(context).value,
                  count: images.length,
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Text("${model.data.price.toString()} EGP",style: TextStyle(fontSize: 20,color: Colors.deepPurpleAccent),),
              Spacer(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Divider(height: 2,color: Colors.deepPurpleAccent,endIndent: 10,indent: 10,),
          ),
          SizedBox(height: 15,),
          Text("Description",style: TextStyle(fontSize: 20),),
          SizedBox(height: 15,),
          Text(model.data.description!)
        ],
      ),
    ),
  );
}
