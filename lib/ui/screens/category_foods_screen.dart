import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healthy_lifestyle_app/core/models/food_item_model.dart';
import 'package:healthy_lifestyle_app/core/services/food_item_service.dart';
import 'package:healthy_lifestyle_app/ui/widgets/food_item.dart';

import 'package:provider/provider.dart';

class CategoryFoodsScreen extends StatefulWidget {
  static const routeName = '/category-foods';

  final args;

  CategoryFoodsScreen({Key key, this.args}) : super(key: key);

  // CategoryFoodsScreen(String categoryName);

  @override
  _CategoryFoodsScreenState createState() => _CategoryFoodsScreenState();
}

class _CategoryFoodsScreenState extends State<CategoryFoodsScreen> {
  String name;
  var category;
  @override
  void didChangeDependencies() {
    final routeArgs = widget.args;
    name = routeArgs['category_name'];
    super.didChangeDependencies();
  }

  List<FoodItem> _foods;

  @override
  Widget build(BuildContext context) {
    final foodItemProvider = Provider.of<FoodItemService>(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: foodItemProvider.fetchFoodItemsAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  _foods = snapshot.data.documents
                      .map((doc) => FoodItem.fromMap(doc.data, doc.documentID))
                      .toList();

                  return Expanded(
                    child: ConditionalBuilder(
                      condition: _foods.isEmpty,
                      builder: (context) => LayoutBuilder(
                        builder: (ctx, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No foods added yet!',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.1,
                              ),
                              Container(
                                height: mediaQuery.size.height * 0.5,
                                child: Image.asset(
                                  'assets/images/waiting.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      fallback: (context) => ListView.builder(
                        itemCount: _foods.length,
                        itemBuilder: (buildContext, index) =>
                            ConditionalBuilder(
                          condition:
                              _foods[index].getCategory.toJson()['name'] ==
                                  name,
                          builder: (context) => FoodItemWidget(
                            name: _foods[index].getName,
                            imageUrl: _foods[index].getImageUrl,
                            quantity: _foods[index].getQuantity,
                            calories: _foods[index].getCalories,
                            proteins: _foods[index].getProteins,
                            fat: _foods[index].getFat,
                            carb: _foods[index].getCarb,
                            unit: _foods[index].getUnit,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SpinKitChasingDots(
                    color: Theme.of(context).accentColor,
                    size: 60.0,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
