import 'dart:io';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/ui/shared/file_upload.dart';
// import 'package:healthy_lifestyle_app/core/services/storage_service.dart';
// import 'package:healthy_lifestyle_app/ui/widgets/file_upload.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter/services.dart';

class EditProfileDialog extends StatefulWidget {
  final userService;
  final currentUserId;
  final name;
  final email;
  final password;
  final photo;
  final role;
  final target;
  final calculation;
  final gender;
  final activity;
  final age;
  final weight;
  final height;
  final trainingPlace;
  final bmr;
  final dailyCalories;
  final neededCaloriesForTarget;

  EditProfileDialog({
    Key key,
    this.userService,
    this.name,
    this.email,
    this.password,
    this.photo,
    this.role,
    this.currentUserId,
    this.target,
    this.calculation,
    this.gender,
    this.activity,
    this.age,
    this.weight,
    this.height,
    this.trainingPlace,
    this.bmr,
    this.dailyCalories,
    this.neededCaloriesForTarget,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  String _formName = '';

  File _imageFile;

  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://healthy-lifestyle-application.appspot.com');
  StorageUploadTask _uploadTask;
  String _fileUrl;

  @override
  void initState() {
    super.initState();
    _fileUrl = widget.photo;
  }

  _startUpload() async {
    String filePath =
        'users/${widget.currentUserId}/profile/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
    });

    await _uploadTask.onComplete;

    _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
      setState(() {
        _fileUrl = fileURL;
        //// String get fileUrl => _fileUrl;

        // _fileUrl = key.currentState.fileUrl;
      });
      print('Done >>>>>>>>>>>>>>>>>>>>>>>>>>>> URL is $_fileUrl');
      // return _fileUrl;
    });
  }

  Future _getImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        _imageFile = image;
      });
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Theme.of(context).errorColor,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // new Stack(
                  //   children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: mediaQuery.size.height / 30,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 80.0,
                      child: ConditionalBuilder(
                        condition: widget.photo == 'no-photo',
                        builder: (context) {
                          return ConditionalBuilder(
                            condition: _imageFile != null,
                            builder: (context) => Container(
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            shape: CircleBorder(),
                                            child: Icon(
                                              Icons.crop,
                                              size: mediaQuery.size.width * 0.1,
                                            ),
                                            onPressed: () {
                                              _cropImage();
                                            },
                                          ),
                                          FlatButton(
                                            shape: CircleBorder(),
                                            child: Icon(
                                              Icons.refresh,
                                              size: mediaQuery.size.width * 0.1,
                                            ),
                                            onPressed: () {
                                              _clearImage();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black26, BlendMode.darken),
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    _imageFile,
                                  ),
                                ),
                              ),
                            ),
                            fallback: (context) => Container(
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: FlatButton(
                                      shape: CircleBorder(
                                          // side: BorderSide(
                                          //   color: Theme.of(
                                          //           context)
                                          //       .accentColor,
                                          //   style:
                                          //       BorderStyle
                                          //           .solid,
                                          //   width: 2,
                                          // ),
                                          ),
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: mediaQuery.size.width * 0.1,
                                      ),
                                      // label: Text(
                                      //   'Select an Image',
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .bodyText2
                                      //       .copyWith(
                                      //         fontSize: 14,
                                      //       ),
                                      // ),
                                      onPressed: () {
                                        _getImage(ImageSource.gallery);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black54, BlendMode.darken),
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/waiting.png',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        fallback: (context) {
                          return ConditionalBuilder(
                            condition: _imageFile != null,
                            builder: (context) => Container(
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            shape: CircleBorder(),
                                            child: Icon(
                                              Icons.crop,
                                              size: mediaQuery.size.width * 0.1,
                                            ),
                                            onPressed: () {
                                              _cropImage();
                                            },
                                          ),
                                          FlatButton(
                                            shape: CircleBorder(),
                                            child: Icon(
                                              Icons.refresh,
                                              size: mediaQuery.size.width * 0.1,
                                            ),
                                            onPressed: () {
                                              _clearImage();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black26, BlendMode.darken),
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    _imageFile,
                                  ),
                                ),
                              ),
                            ),
                            fallback: (context) => Container(
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: FlatButton(
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: mediaQuery.size.width * 0.1,
                                      ),
                                      onPressed: () {
                                        _getImage(ImageSource.gallery);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black26, BlendMode.darken),
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    widget.photo,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  ConditionalBuilder(
                      condition: _imageFile != null,
                      builder: (context) {
                        return Column(
                          children: <Widget>[
                            FileUpload(
                              uploadTask: _uploadTask,
                              startUpload: _startUpload,
                            ),
                          ],
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),

                  // ConditionalBuilder(
                  //   condition: _error ==
                  //       'Please supply a valid email',
                  //   builder: (context) => Center(
                  //     child: Text(
                  //       _error,
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .headline3,
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ),
                  TextFormField(
                    initialValue: widget.name,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Enter your name';
                      } else if (val.length < 2) {
                        return 'Name not long enough';
                      } else
                        return null;
                    },
                    // (val) => val.isEmpty
                    //     ? 'Enter your name'
                    //     : null,
                    // onChanged: (val) {
                    //   setState(() {
                    //     _formName = val;
                    //   });
                    // },
                    onSaved: (val) {
                      setState(() {
                        _formName = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  // TextFormField(
                  //   initialValue: widget.email,
                  //   keyboardType: TextInputType.emailAddress,
                  //   decoration: InputDecoration(
                  //     hintText: 'Email',
                  //     prefixIcon: Icon(
                  //       Icons.email,
                  //       color: Theme.of(context).canvasColor,
                  //     ),
                  //   ),
                  //   validator: (val) {
                  //     if (val.isEmpty) {
                  //       return 'Enter your email';
                  //     } else if (!EmailValidator.validate(val)) {
                  //       return 'Please supply a valid email';
                  //     } else
                  //       return null;
                  //   },

                  //   onSaved: (val) {
                  //     setState(() {
                  //       _formEmail = val;
                  //     });

                  //   },
                  // ),
                  Padding(
                    padding: EdgeInsets.all(
                      mediaQuery.size.width / 90,
                    ),
                  ),
                  // StreamBuilder<QuerySnapshot>(
                  //     stream: roleProvider
                  //         .fetchRolesAsStream(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         roles =
                  //             snapshot.data.documents
                  //                 .map(
                  //                   (doc) => Role.fromMap(
                  //                       doc.data,
                  //                       doc.documentID),
                  //                 )
                  //                 .toList();

                  //         List<DropdownMenuItem>
                  //             rolesList = [];
                  //         for (int i = 0;
                  //             i <
                  //                 snapshot.data
                  //                     .documents.length;
                  //             i++) {
                  //           role = roles[i];
                  //           if (_roleName != 'admin') {
                  //             if (role.getName !=
                  //                 'admin') {
                  //               rolesList.add(
                  //                 DropdownMenuItem(
                  //                   child: Text(
                  //                     role.getName,
                  //                     style: Theme.of(
                  //                             context)
                  //                         .textTheme
                  //                         .bodyText1,
                  //                   ),
                  //                   value:
                  //                       "${role.getName}",
                  //                 ),
                  //               );
                  //             }
                  //           } else {
                  //             rolesList.add(
                  //               DropdownMenuItem(
                  //                 child: Text(
                  //                   role.getName,
                  //                   style: Theme.of(
                  //                           context)
                  //                       .textTheme
                  //                       .bodyText1,
                  //                 ),
                  //                 value:
                  //                     "${role.getName}",
                  //               ),
                  //             );
                  //           }
                  //         }
                  //         return Container(
                  //           width:
                  //               mediaQuery.size.width,
                  //           child: Row(
                  //             mainAxisAlignment:
                  //                 MainAxisAlignment
                  //                     .center,
                  //             children: <Widget>[
                  //               Container(
                  //                 width: mediaQuery
                  //                         .size.width *
                  //                     0.4,
                  //                 child:
                  //                     DropdownButtonFormField<
                  //                         dynamic>(
                  //                   icon: Icon(
                  //                     FontAwesomeIcons
                  //                         .userCircle,
                  //                     color: Theme.of(
                  //                             context)
                  //                         .canvasColor,
                  //                   ),
                  //                   items: rolesList,
                  //                   onChanged:
                  //                       (val) async {
                  //                     setState(() {
                  //                       _currentItemSelected =
                  //                           val;
                  //                     });
                  //                     rolesWithCondition =
                  //                         await roleProvider
                  //                             .fetchRolesWithCondition(
                  //                                 'name',
                  //                                 val);
                  //                     print('rolesWithCondition >>>>>>>>>>>>>> ' +
                  //                         rolesWithCondition
                  //                             .toString());

                  //                     for (int i = 0;
                  //                         i <
                  //                             rolesWithCondition
                  //                                 .length;
                  //                         i++) {
                  //                       print('rolesWithCondition name >>>>>>>>>>>>>> ' +
                  //                           '${rolesWithCondition[i].getName}');

                  //                       roleObject =
                  //                           rolesWithCondition[
                  //                                   i]
                  //                               .toJson();
                  //                       print('roleObject >>>>>>>>>>>>>> ' +
                  //                           roleObject
                  //                               .toString());
                  //                     }
                  //                     setState(() {
                  //                       _formRole =
                  //                           roleObject;
                  //                     });

                  //                   },
                  //                   value:
                  //                       _currentItemSelected,
                  //                   isExpanded: false,
                  //                   hint: new Text(
                  //                     _roleName
                  //                         .toString(),
                  //                     // 'Type'
                  //                   ),
                  //                   validator: (val) =>
                  //                       val == null
                  //                           ? 'Select a type'
                  //                           : null,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       } else {
                  //         return SpinKitChasingDots(
                  //           color: Theme.of(context)
                  //               .accentColor,
                  //           size: 40.0,
                  //         );
                  //       }
                  //     }),
                  // Padding(
                  //   padding: EdgeInsets.all(
                  //       mediaQuery.size.width / 90),
                  // ),

                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        await widget.userService.updateUser(
                          User.fromUser(
                            uId: widget.currentUserId,
                            // email: _formEmail.toLowerCase().trim(),
                            email: widget.email,
                            password: widget.password,
                            name: _formName.trim(),
                            photo: _fileUrl,
                            role: widget.role,
                            target: widget.target,
                            gender: widget.gender.toLowerCase().trim(),
                            calculation: widget.calculation,
                            age: widget.age,
                            weight: widget.weight,
                            height: widget.height,
                            activity: widget.activity.toLowerCase().trim(),
                          ),
                          widget.currentUserId,
                        );

                        Navigator.of(context).pop();
                        print('Edited');
                      }
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
