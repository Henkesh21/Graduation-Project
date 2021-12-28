import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:healthy_lifestyle_app/ui/widgets/add_category_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_category_dialog.dart';
import 'package:healthy_lifestyle_app/core/models/category_model.dart';
import 'package:healthy_lifestyle_app/core/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories';
  CategoriesScreen({Key key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<MyCategory> _categories;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryService>(context);

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
                return AddCategoryDialog(
                  categoryProvider: categoryProvider,
                );
              });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Categories',
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
              stream: categoryProvider.fetchCategoriesAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  _categories = snapshot.data.documents
                      .map(
                          (doc) => MyCategory.fromMap(doc.data, doc.documentID))
                      .toList();

                  return Expanded(
                    child: ConditionalBuilder(
                      condition: _categories.isEmpty,
                      builder: (context) => LayoutBuilder(
                        builder: (ctx, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No categories added yet!',
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
                        itemCount: _categories.length,
                        itemBuilder: (buildContext, index) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          elevation: 10,
                          margin: EdgeInsets.all(mediaQuery.size.width / 30),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Edit',
                                color: Theme.of(context).secondaryHeaderColor,
                                icon: Icons.edit,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return EditCategoryDialog(
                                          categoryProvider: categoryProvider,
                                          name: _categories[index].getName,
                                          description:
                                              _categories[index].getDescription,
                                          type: _categories[index].getType,
                                          imageUrl:
                                              _categories[index].getImageUrl,
                                          id: _categories[index].getCId,
                                        );
                                      });
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Theme.of(context).errorColor,
                                icon: Icons.delete,
                                onTap: () async => await categoryProvider
                                    .deleteCategory(_categories[index].getCId),
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
                                        _categories[index].getImageUrl == '',
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
                                              _categories[index].getImageUrl,
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
                                    '${_categories[index].getName}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(
                                        'Type : ${_categories[index].getType}',
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
                                        vertical: mediaQuery.size.width / 90,
                                      ),
                                    ),
                                    ConditionalBuilder(
                                      condition:
                                          _categories[index].getDescription ==
                                              '',
                                      builder: (context) {
                                        return FittedBox(
                                          child: Text(
                                            'No description added yet',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        );
                                      },
                                      fallback: (context) {
                                        return FittedBox(
                                          child: Text(
                                            '${_categories[index].getDescription}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
