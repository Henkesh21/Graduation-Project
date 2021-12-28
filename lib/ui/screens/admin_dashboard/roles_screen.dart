import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healthy_lifestyle_app/ui/widgets/add_role_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_role_dialog.dart';
import 'package:provider/provider.dart';

import 'package:healthy_lifestyle_app/core/models/role_model.dart';
import 'package:healthy_lifestyle_app/core/services/role_service.dart';

class RolesScreen extends StatefulWidget {
  static const routeName = '/roles';

  @override
  _RolesScreenState createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  List<Role> roles;

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleService>(context);
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
                return AddRoleDialog(
                  roleProvider: roleProvider,
                );
              });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Roles',
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
              stream: roleProvider.fetchRolesAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  roles = snapshot.data.documents
                      .map((doc) => Role.fromMap(doc.data, doc.documentID))
                      .toList();
                  // rId = roles[index].rId;

                  // print(doc.documentID);
                  return Expanded(
                      child: ConditionalBuilder(
                    condition: roles.isEmpty,
                    builder: (context) => LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(
                            //   height: mediaQuery.size.height * 0.1,
                            // ),
                            Text(
                              'No roles added yet!',
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
                    fallback: (context) {
                      return ListView.builder(
                        // scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        itemCount: roles.length,
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
                                          return EditRoleDialog(
                                            roleProvider: roleProvider,
                                            name: roles[index].getName,
                                            value: roles[index].getValue,
                                            id: roles[index].getRId,
                                          );
                                        });
                                    // buildEditDialog(
                                    //   roles[index].getName,
                                    //   roles[index].getValue,
                                    //   roles[index].getRId,
                                    // );
                                  }),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Theme.of(context).errorColor,
                                icon: Icons.delete,
                                onTap: () async => await roleProvider
                                    .deleteRole(roles[index].getRId),
                              ),
                            ],
                            // direction: Axis.vertical,

                            // Row(
                            //   // mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     // IconButton(
                            //     //   icon: const Icon(Icons.delete),
                            //     //   color: Theme.of(context).errorColor,
                            //     //   onPressed: () async {
                            //     //     // await roleProvider.deleteRole(roles[index].rId);
                            //     //   },
                            //     // ),
                            //     IconButton(
                            //       icon: const Icon(Icons.edit),
                            //       color: Theme.of(context)
                            //           .secondaryHeaderColor,
                            //       onPressed: () {
                            //         buildEditDialog();
                            //       },
                            //     ),
                            //   ],
                            // ),
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

                                leading:
                                    //  Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //     horizontal: 0,
                                    //     vertical: mediaQuery.size.height / 400,
                                    //   ),
                                    //   child:
                                    CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  radius: 30,
                                  child:
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(
                                      //     horizontal: 0,
                                      //     vertical:
                                      //         mediaQuery.size.height / 400,
                                      //   ),
                                      // child:
                                      Padding(
                                    padding: EdgeInsets.all(
                                      mediaQuery.size.height / 100,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        'Value : ${roles[index].getValue}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  ),
                                ),
                                // ),
                                // ),
                                title:
                                    //  Padding(
                                    //   padding: EdgeInsets.all(
                                    //     mediaQuery.size.width / 90,
                                    //   ),
                                    //   child:
                                    Text(
                                  //  'Name : ${roles[index].name}',
                                  ' ${roles[index].getName}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                // ),
                                // subtitle: Text(
                                //   'Value : ${roles[index].value}',
                                //   style: Theme.of(context).textTheme.body1,
                                // ),

                                //  Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: <Widget>[
                                //     // IconButton(
                                //     //   icon: const Icon(Icons.delete),
                                //     //   color: Theme.of(context).errorColor,
                                //     //   onPressed: () async {
                                //     //     // await roleProvider.deleteRole(roles[index].rId);
                                //     //   },
                                //     // ),
                                //     IconButton(
                                //       icon: const Icon(Icons.edit),
                                //       color: Theme.of(context)
                                //           .secondaryHeaderColor,
                                //       onPressed: () {
                                //          buildEditDialog();
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
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
//  ConditionalBuilder(
//                     condition: roles.isEmpty,
//                     builder: (context) => LayoutBuilder(
//                       builder: (ctx, constraints) {
//                         return Column(
//                           children: <Widget>[
//                             // SizedBox(
//                             //   height: mediaQuery.size.height * 0.1,
//                             // ),
//                             Text(
//                               'No roles added yet!',
//                               style: Theme.of(context).textTheme.title,
//                             ),
//                             SizedBox(
//                               height: mediaQuery.size.height * 0.1,
//                             ),
//                             Container(
//                               // height: constraints.minHeight * 0.6,
//                               height: mediaQuery.size.height * 0.6,
//                               child: Image.asset(
//                                 'assets/images/waiting.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   );
