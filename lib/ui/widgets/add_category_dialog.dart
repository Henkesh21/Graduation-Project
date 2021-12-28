import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_lifestyle_app/ui/shared/file_upload.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:healthy_lifestyle_app/core/models/category_model.dart';
// import 'package:healthy_lifestyle_app/core/services/storage_service.dart';

class AddCategoryDialog extends StatefulWidget {
  final categoryProvider;

  AddCategoryDialog({
    Key key,
    @required this.categoryProvider,
  }) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  // File imageFile;
  String type = '';
  var typesList = [
    'Food',
    'Exercise',
    'Chat room',
  ];
  var _currentItemSelected;

  File _imageFile;

  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://healthy-lifestyle-application.appspot.com');
  StorageUploadTask _uploadTask;
  String _fileUrl;

  // @override
  // void initState() {
  //   super.initState();
  //   _fileUrl = widget.photo;
  // }

  _startUpload() async {
    String filePath = 'app/categories/${DateTime.now()}.png';

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

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
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
                  Container(
                    width: mediaQuery.size.width * 0.4,
                    child: DropdownButtonFormField<dynamic>(
                      icon: Icon(
                        FontAwesomeIcons.layerGroup,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      items: typesList.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(
                            dropDownStringItem,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        _onDropDownItemSelected(val);
                        setState(() {
                          type = _currentItemSelected;
                        });
                      },
                      value: _currentItemSelected,
                      isExpanded: false,
                      hint: new Text(
                        "Type",
                      ),
                      validator: (val) => val == null ? 'Select a type' : null,
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
                        await widget.categoryProvider.addCategory(
                          MyCategory.fromMyCategory(
                            name: name.toLowerCase().trim(),
                            description: description.toLowerCase().trim(),
                            type: type.toLowerCase().trim(),
                            imageUrl: _fileUrl,
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
