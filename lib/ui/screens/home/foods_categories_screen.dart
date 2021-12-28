import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healthy_lifestyle_app/core/models/category_model.dart';
import 'package:healthy_lifestyle_app/core/models/module_model.dart';
import 'package:healthy_lifestyle_app/core/services/category_service.dart';
import 'package:healthy_lifestyle_app/core/services/module_service.dart';
import 'package:healthy_lifestyle_app/ui/widgets/food_category_item.dart';
// import 'package:healthy_lifestyle_app/ui/widgets/category_item.dart';
import 'package:provider/provider.dart';

class FoodsCategoriesScreen extends StatefulWidget {
  static const routeName = '/foods-categories';

  @override
  _FoodsCategoriesScreenState createState() => _FoodsCategoriesScreenState();
}

class _FoodsCategoriesScreenState extends State<FoodsCategoriesScreen> {
  ModuleService _moduleService = new ModuleService();
  List<Module> _moduleWithCondition;
  String _name;
  bool _active;
  bool _moduleActive;

  Future<bool> getModuleData() async {
    _moduleWithCondition =
        await _moduleService.fetchModulesWithCondition('name', 'foods');
    for (int i = 0; i < _moduleWithCondition.length; i++) {
      _name = _moduleWithCondition[i].getName;
      _active = _moduleWithCondition[i].getActive;
      print('_modules >>>>>>>>>>>>>> ' + '$_moduleWithCondition');

      print('_name >>>>>>>>>>>>>> ' + '$_name');
    }
    return _active;
  }

  void initState() {
    setState(() {
      getModuleData().then((bool a) {
        setState(() {
          _moduleActive = a;
        });
        print('_moduleActive >>>>>>>>>>>>>> ' + '$_moduleActive');
      });
    });
    super.initState();
  }

  List<MyCategory> _categories;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryService>(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ConditionalBuilder(
              condition: _moduleActive != null,
              builder: (context) => ConditionalBuilder(
                condition: _moduleActive,
                builder: (context) => StreamBuilder(
                    stream: categoryProvider
                        .fetchCategoriesAsStreamWithCondition('type', 'food'),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        _categories = snapshot.data.documents
                            .map((doc) =>
                                MyCategory.fromMap(doc.data, doc.documentID))
                            .toList();
                        return Expanded(
                          child: ConditionalBuilder(
                            condition: _categories.isEmpty,
                            builder: (context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'No categories added yet!',
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
                            fallback: (context) => LayoutBuilder(
                              builder: (ctx, constraints) {
                                return GridView.builder(
                                  padding: EdgeInsets.all(
                                      mediaQuery.size.width / 30),
                                  itemCount: _categories.length,
                                  itemBuilder: (buildContext, index) =>
                                      FoodCategoryItem(
                                    _categories[index].getName,
                                    _categories[index].getImageUrl,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return SpinKitChasingDots(
                          color: Theme.of(context).accentColor,
                          size: 60.0,
                        );
                      }
                    }),
                fallback: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Coming soon...',
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
                ),
              ),
              fallback: (context) => SpinKitChasingDots(
                color: Theme.of(context).accentColor,
                size: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
