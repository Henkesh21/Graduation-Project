import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:healthy_lifestyle_app/ui/widgets/add_module_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_module_dialog.dart';
import 'package:healthy_lifestyle_app/core/models/module_model.dart';
import 'package:healthy_lifestyle_app/core/services/module_service.dart';

class ModulesScreen extends StatefulWidget {
  static const routeName = '/modules';
  ModulesScreen({Key key}) : super(key: key);

  @override
  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  List<Module> _modules;

  @override
  Widget build(BuildContext context) {
    final moduleProvider = Provider.of<ModuleService>(context);

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
                return AddModuleDialog(
                  moduleProvider: moduleProvider,
                );
              });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Modules',
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
              stream: moduleProvider.fetchModulesAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  _modules = snapshot.data.documents
                      .map((doc) => Module.fromMap(doc.data, doc.documentID))
                      .toList();

                  return Expanded(
                    child: ConditionalBuilder(
                      condition: _modules.isEmpty,
                      builder: (context) => LayoutBuilder(
                        builder: (ctx, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No modules added yet!',
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
                        itemCount: _modules.length,
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
                                        return EditModuleDialog(
                                          moduleProvider: moduleProvider,
                                          name: _modules[index].getName,
                                          description:
                                              _modules[index].getDescription,
                                          active: _modules[index].getActive,
                                          // imageUrl:
                                          // _modules[index].getImageUrl,
                                          id: _modules[index].getMId,
                                        );
                                      });
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Theme.of(context).errorColor,
                                icon: Icons.delete,
                                onTap: () async => await moduleProvider
                                    .deleteModule(_modules[index].getMId),
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
                                // leading: CircleAvatar(
                                //   backgroundColor:
                                //       Theme.of(context).accentColor,
                                //   radius: 30,
                                //   child: ConditionalBuilder(
                                //     condition:
                                //         _modules[index].getImageUrl == '',
                                //     builder: (context) {
                                //       return Container(
                                //         decoration: BoxDecoration(
                                //           shape: BoxShape.circle,
                                //           image: DecorationImage(
                                //             fit: BoxFit.contain,
                                //             image: AssetImage(
                                //               'assets/images/waiting.png',
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //     fallback: (context) {
                                //       return Container(
                                //         decoration: BoxDecoration(
                                //           shape: BoxShape.circle,
                                //           image: DecorationImage(
                                //             fit: BoxFit.cover,
                                //             image: NetworkImage(
                                //               _modules[index].getImageUrl,
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   ),
                                //   // ),
                                // ),
                                // ),
                                title: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: mediaQuery.size.width / 90,
                                  ),
                                  child: Text(
                                    '${_modules[index].getName}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(
                                        'Active : ${_modules[index].getActive}',
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
                                          _modules[index].getDescription == '',
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
                                            '${_modules[index].getDescription}',
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
