import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_lifestyle_app/core/models/category_model.dart';
import 'package:healthy_lifestyle_app/core/models/exercise_model.dart';
import 'package:healthy_lifestyle_app/core/services/category_service.dart';
import 'package:healthy_lifestyle_app/ui/shared/file_upload.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditExerciseDialog extends StatefulWidget {
  final exerciseProvider;
  final name;
  final description;
  final category;
  final animatedPhotoUrl;
  final videoUrl;
  final id;
  final trainingPlace;
  EditExerciseDialog({
    Key key,
    @required this.exerciseProvider,
    @required this.name,
    @required this.description,
    @required this.category,
    @required this.animatedPhotoUrl,
    @required this.videoUrl,
    @required this.id,
    @required this.trainingPlace,
  }) : super(key: key);

  @override
  _EditExerciseDialogState createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  File animatedPhotoFile;
  String animatedPhotoUrl;
  File videoFile;
  String videoUrl;
  List<MyCategory> categories;
  MyCategory category;
  List<MyCategory> categoriesWithCondition;
  var categoryObject;
  var currentItemSelected;
  File _imageFile;
  String _trainingPlace;
  var _placesList = [
    'Home',
    'Gym',
    'Both',
  ];

  var _currentPlaceSelected;

  void _onDropDownPlaceSelected(String newValueSelected) {
    setState(() {
      this._currentPlaceSelected = newValueSelected;
    });
  }

  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://healthy-lifestyle-application.appspot.com');
  StorageUploadTask _uploadTask;
  String _fileUrl;

  @override
  void initState() {
    super.initState();
    _fileUrl = widget.animatedPhotoUrl;
  }

  _startUpload() async {
    String filePath = 'app/exercises/${DateTime.now()}.gif';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
    });

    await _uploadTask.onComplete;

    _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
      setState(() {
        _fileUrl = fileURL;
      });
      print('Done >>>>>>>>>>>>>>>>>>>>>>>>>>>> URL is $_fileUrl');
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
    final categoryProvider = Provider.of<CategoryService>(context);

    final mediaQuery = MediaQuery.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
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

          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: mediaQuery.size.height / 30,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 80.0,
                      child: ConditionalBuilder(
                        condition: widget.animatedPhotoUrl == '',
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
                                          // FlatButton(
                                          //   shape: CircleBorder(),
                                          //   child: Icon(
                                          //     Icons.crop,
                                          //     size: mediaQuery.size.width * 0.1,
                                          //   ),
                                          //   onPressed: () {
                                          //     _cropImage();
                                          //   },
                                          // ),
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
                                      Colors.black54, BlendMode.darken),
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
                                      Colors.black54, BlendMode.darken),
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
                                        Icons.gif,
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
                                      Colors.black54, BlendMode.darken),
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    widget.animatedPhotoUrl,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
                  TextFormField(
                    initialValue: widget.name,
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter category name' : null,
                    onSaved: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                    initialValue: widget.description,
                    decoration: InputDecoration(hintText: 'Description'),
                    onSaved: (val) {
                      setState(() {
                        description = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                    initialValue: widget.animatedPhotoUrl,
                    decoration: InputDecoration(hintText: 'GIF URL'),
                    onChanged: (val) {
                      setState(() {
                        _fileUrl = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                    initialValue: widget.videoUrl,
                    decoration: InputDecoration(hintText: 'Video URL'),
                    onSaved: (val) {
                      setState(() {
                        videoUrl = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream:
                          categoryProvider.fetchCategoriesAsStreamWithCondition(
                              'type', 'exercise'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          categories = snapshot.data.documents
                              .map((doc) =>
                                  MyCategory.fromMap(doc.data, doc.documentID))
                              .toList();

                          List<DropdownMenuItem> categoriesList = [];
                          for (int i = 0;
                              i < snapshot.data.documents.length;
                              i++) {
                            category = categories[i];

                            categoriesList.add(
                              DropdownMenuItem(
                                child: Text(
                                  category.getName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize: 7,
                                      ),
                                ),
                                value: "${category.getName}",
                              ),
                            );
                          }
                          return
                              // Center(

                              // child:
                              Container(
                            width: mediaQuery.size.width,
                            // child:
                            //  Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: <Widget>[
                            //     Container(
                            //       width: mediaQuery.size.width * 0.5,
                            child: DropdownButtonFormField<dynamic>(
                              icon: Icon(
                                FontAwesomeIcons.layerGroup,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              items: categoriesList,
                              onChanged: (val) async {
                                // final snackBar = SnackBar(
                                //   backgroundColor:
                                //       Theme.of(context).primaryColor,
                                //   content: Text(
                                //     'Type is $val',
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .headline1
                                //         .copyWith(
                                //           fontSize: 12,
                                //         ),
                                //   ),
                                // );
                                // Scaffold.of(context)
                                //     .showSnackBar(snackBar);
                                setState(() {
                                  currentItemSelected = val;
                                });
                                categoriesWithCondition = await categoryProvider
                                    .fetchCategoriesWithCondition('name', val);
                                print(
                                    'categoriesWithCondition >>>>>>>>>>>>>> ' +
                                        categoriesWithCondition.toString());

                                for (int i = 0;
                                    i < categoriesWithCondition.length;
                                    i++) {
                                  print('categoriesWithCondition name >>>>>>>>>>>>>> ' +
                                      '${categoriesWithCondition[i].getName}');
                                  // setState(() {
                                  categoryObject =
                                      categoriesWithCondition[i].toJson();
                                  // });
                                  print('categoryObject >>>>>>>>>>>>>> ' +
                                      categoryObject.toString());
                                }
                              },
                              value: currentItemSelected,
                              isExpanded: false,
                              hint: new Text(
                                "${widget.category}",
                              ),
                              validator: (val) =>
                                  val == null ? 'Select a category' : null,
                            ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          );
                        } else {
                          return SpinKitChasingDots(
                            color: Theme.of(context).accentColor,
                            size: 40.0,
                          );
                        }
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  Center(
                    child: Container(
                      width: mediaQuery.size.width ,
                      child: DropdownButtonFormField<dynamic>(
                        icon: ConditionalBuilder(
                          condition: _currentPlaceSelected == null,
                          builder: (context) => Icon(
                            Icons.place,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          fallback: (context) => ConditionalBuilder(
                            condition: _currentPlaceSelected == 'Home',
                            builder: (context) => Icon(
                              FontAwesomeIcons.home,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                            fallback: (context) => ConditionalBuilder(
                              condition: _currentPlaceSelected == null,
                              builder: (context) => Icon(
                                Icons.place,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              fallback: (context) => ConditionalBuilder(
                                condition: _currentPlaceSelected == 'Gym',
                                builder: (context) => Icon(
                                  Icons.fitness_center,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                fallback: (context) => Icon(
                                  Icons.place,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        items: _placesList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _onDropDownPlaceSelected(val);
                          setState(() {
                            _trainingPlace = _currentPlaceSelected;
                          });
                        },
                        value: _currentPlaceSelected,
                        isExpanded: false,
                        hint: new Text(
                          "${widget.trainingPlace}",
                        ),
                        validator: (val) =>
                            val == null ? 'Select a place' : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  RaisedButton(
                    child: Text(
                      "Submit",
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        await widget.exerciseProvider.updateExercise(
                          Exercise.fromExercise(
                            name: name.toLowerCase().trim(),
                            description: description.toLowerCase().trim(),
                            category: categoryObject,
                            animatedPhotoUrl: _fileUrl,
                            videoUrl: videoUrl,
                            trainingPlace: _trainingPlace.toLowerCase().trim(),
                          ),
                          widget.id,
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
