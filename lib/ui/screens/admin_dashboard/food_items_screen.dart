import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/core/models/food_item_model.dart';
import 'package:healthy_lifestyle_app/core/services/food_item_service.dart';
import 'package:healthy_lifestyle_app/ui/widgets/add_food_item_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_food_item_dialog.dart';

import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FoodItemsScreen extends StatefulWidget {
  static const routeName = '/food-items';
  FoodItemsScreen({Key key}) : super(key: key);

  @override
  _FoodItemsScreenState createState() => _FoodItemsScreenState();
}

class _FoodItemsScreenState extends State<FoodItemsScreen> {
  List<FoodItem> _foodItems;

  @override
  Widget build(BuildContext context) {
    final foodItemProvider = Provider.of<FoodItemService>(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AddFoodItemDialog(
                  foodItemProvider: foodItemProvider,
                );
              });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Food Items',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: foodItemProvider.fetchFoodItemsAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  _foodItems = snapshot.data.documents
                      .map((doc) => FoodItem.fromMap(doc.data, doc.documentID))
                      .toList();

                  return Expanded(
                    child: _foodItems.isEmpty
                        ? ConditionalBuilder(
                            condition: _foodItems.isEmpty,
                            builder: (context) => LayoutBuilder(
                              builder: (ctx, constraints) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'No food items added yet!',
                                      style:
                                          Theme.of(context).textTheme.headline6,
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
                          )
                        : ListView.builder(
                            itemCount: _foodItems.length,
                            itemBuilder: (buildContext, index) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              elevation: 10,
                              margin:
                                  EdgeInsets.all(mediaQuery.size.width / 30),
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Edit',
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    icon: Icons.edit,
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return EditFoodItemDialog(
                                              foodItemProvider:
                                                  foodItemProvider,
                                              name: _foodItems[index].getName,
                                              category: _foodItems[index]
                                                      .getCategory
                                                      .toJson()['name'] ??
                                                  '',
                                              imageUrl:
                                                  _foodItems[index].getImageUrl,
                                              quantity:
                                                  _foodItems[index].getQuantity,
                                              calories:
                                                  _foodItems[index].getCalories,
                                              proteins:
                                                  _foodItems[index].getProteins,
                                              fat: _foodItems[index].getFat,
                                              carb: _foodItems[index].getCarb,
                                              id: _foodItems[index].getfIId,
                                              unit: _foodItems[index].getUnit,
                                            );
                                          });
                                    },
                                  ),
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Theme.of(context).errorColor,
                                    icon: Icons.delete,
                                    onTap: () async =>
                                        await foodItemProvider.deleteFoodItem(
                                            _foodItems[index].getfIId),
                                  ),
                                ],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(
                                      mediaQuery.size.height / 60,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      radius: 30,
                                      child: ConditionalBuilder(
                                        condition:
                                            _foodItems[index].getImageUrl == '',
                                        builder: (context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: AssetImage(
                                                  'assets/images/waiting.png',
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        fallback: (context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  _foodItems[index].getImageUrl,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // ),
                                    ),
                                    // ),
                                    title: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: mediaQuery.size.width / 90,
                                      ),
                                      child: Text(
                                        '${_foodItems[index].getName}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FittedBox(
                                          child: Text(
                                            'Category : ${_foodItems[index].getCategory.toJson()['name'] ?? ''}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical:
                                                mediaQuery.size.width / 90,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Quantity : ${_foodItems[index].getQuantity}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical:
                                                mediaQuery.size.width / 90,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Unit : ${_foodItems[index].getUnit}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical:
                                                mediaQuery.size.width / 90,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Calories : ${_foodItems[index].getCalories}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical:
                                                mediaQuery.size.width / 90,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Proteins : ${_foodItems[index].getProteins}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical:
                                                mediaQuery.size.width / 90,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Fat : ${_foodItems[index].getFat}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical:
                                                mediaQuery.size.width / 90,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Carb : ${_foodItems[index].getCarb}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
      // ),
    );
  }
}
