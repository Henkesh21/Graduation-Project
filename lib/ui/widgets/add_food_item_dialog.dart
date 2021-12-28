import 'dart:io';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:healthy_lifestyle_app/ui/shared/file_upload.dart';
// import 'package:healthy_lifestyle_app/core/services/storage_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:healthy_lifestyle_app/core/models/category_model.dart';
import 'package:healthy_lifestyle_app/core/models/food_item_model.dart';
import 'package:healthy_lifestyle_app/core/services/category_service.dart';

class AddFoodItemDialog extends StatefulWidget {
  final foodItemProvider;

  AddFoodItemDialog({
    Key key,
    @required this.foodItemProvider,
  }) : super(key: key);

  @override
  _AddFoodItemDialogState createState() => _AddFoodItemDialogState();
}

class _AddFoodItemDialogState extends State<AddFoodItemDialog> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  // File imageFile;
  // String imageUrl;
  List<MyCategory> categories;
  MyCategory category;
  List<MyCategory> categoriesWithCondition;
  var categoryObject;
  var currentItemSelected;
  int quantity;
  int calories;
  int proteins;
  int fat;
  int carb;
  File _imageFile;

  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://healthy-lifestyle-application.appspot.com');
  StorageUploadTask _uploadTask;
  String _fileUrl;

  var _unitsList = [
    'Grams',
    'mL',
    'Big Spoons',
    'Small Spoons',
    'Medium Cups',
    'Medium Pieces',
  ];
  String _unit;

  var _currentUnitSelected;

  void _onDropDownUnitSelected(String newValueSelected) {
    setState(() {
      this._currentUnitSelected = newValueSelected;
    });
  }

  _startUpload() async {
    String filePath = 'app/food-items/${DateTime.now()}.png';

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

  String numberValidator(String value) {
    if (value.isEmpty) {
      return 'Enter a value';
    }
    final n = num.tryParse(value);
    if (n < 0 || n == 0) {
      return '"$value" is not valid';
    }
    return null;
  }

  String numberValidator2(String value) {
    if (value.isEmpty) {
      return 'Enter a value';
    }
    final n = num.tryParse(value);
    if (n < 0) {
      return '"$value" is not valid';
    }
    return null;
  }

  int numberCasting(String value) {
    final n = num.tryParse(value);
    return n;
  }

  String stringCasting(int value) {
    final s = value.toString();
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryService>(context);

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
                        condition: _imageFile != null,
                        builder: (context) => Container(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  Colors.black54, BlendMode.darken),
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/waiting.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  // ),
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
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter food item name' : null,
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Quantity'),
                      validator: numberValidator,
                      onSaved: (val) {
                        quantity = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Calories'),
                      validator: numberValidator,
                      onSaved: (val) {
                        calories = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Proteins'),
                      validator: numberValidator2,
                      onSaved: (val) {
                        proteins = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Fat'),
                      validator: numberValidator2,
                      onSaved: (val) {
                        fat = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Carb'),
                      validator: numberValidator2,
                      onSaved: (val) {
                        carb = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),

                  TextFormField(
                    decoration: InputDecoration(hintText: 'Image URL'),
                    onChanged: (val) {
                      setState(() {
                        _fileUrl = val;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: categoryProvider
                          .fetchCategoriesAsStreamWithCondition('type', 'food'),
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

                            // if (category.getType == 'food') {
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
                            // }
                          }
                          return Container(
                            width: mediaQuery.size.width,
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: <Widget>[
                                // Container(
                                //   width: mediaQuery.size.width ,
                                  child: 
                                  DropdownButtonFormField<dynamic>(
                                    icon: Icon(
                                      FontAwesomeIcons.layerGroup,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    items: categoriesList,
                                    onChanged: (val) async {
                                      setState(() {
                                        currentItemSelected = val;
                                      });
                                      categoriesWithCondition =
                                          await categoryProvider
                                              .fetchCategoriesWithCondition(
                                                  'name', val);
                                      print(
                                          'categoriesWithCondition >>>>>>>>>>>>>> ' +
                                              categoriesWithCondition
                                                  .toString());

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
                                      "Category",
                                    ),
                                    validator: (val) => val == null
                                        ? 'Select a category'
                                        : null,
                                  ),
                                // ),
                            //   ],
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
                        icon: Icon(
                          FontAwesomeIcons.utensilSpoon,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        items: _unitsList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _onDropDownUnitSelected(val);
                          setState(() {
                            _unit = _currentUnitSelected;
                          });
                        },
                        value: _currentUnitSelected,
                        isExpanded: false,
                        hint: new Text(
                          "Unit",
                        ),
                        validator: (val) =>
                            val == null ? 'Select a unit' : null,
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
                        await widget.foodItemProvider.addFoodItem(
                          FoodItem.fromFoodItem(
                            name: name.toLowerCase().trim(),
                            category: categoryObject,
                            quantity: quantity,
                            calories: calories,
                            proteins: proteins,
                            fat: fat,
                            carb: carb,
                            imageUrl: _fileUrl,
                            unit: _unit.toLowerCase().trim(),
                          ),
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
