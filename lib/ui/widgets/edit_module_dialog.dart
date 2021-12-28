import 'dart:io';
import 'package:flutter/material.dart';

// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:conditional_builder/conditional_builder.dart';
import 'package:healthy_lifestyle_app/core/models/module_model.dart';
// import 'package:healthy_lifestyle_app/core/services/Storage_service.dart';

class EditModuleDialog extends StatefulWidget {
  final moduleProvider;
  final name;
  final description;
  final active;
  // final imageUrl;
  final id;
  EditModuleDialog({
    Key key,
    @required this.moduleProvider,
    @required this.name,
    @required this.description,
    @required this.active,
    // @required this.imageUrl,
    @required this.id,
  }) : super(key: key);

  @override
  _EditModuleDialogState createState() => _EditModuleDialogState();
}

class _EditModuleDialogState extends State<EditModuleDialog> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  File imageFile;
  bool active;

  @override
  void initState() {
    super.initState();
    active = widget.active;
  }

  // Future _getImage(ImageSource source) async {
  //   await ImagePicker.pickImage(source: source).then((image) {
  //     setState(() {
  //       imageFile = image;
  //     });
  //   });
  // }

  // Future<void> _cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //     sourcePath: imageFile.path,
  //   );
  //   setState(() {
  //     imageFile = cropped ?? imageFile;
  //   });
  // }

  // void _clearImage() {
  //   setState(() {
  //     imageFile = null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                  TextFormField(
                    initialValue: widget.name,
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter module name' : null,
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
                  Container(
                    child: SwitchListTile(
                      title: Text(
                        'Active status',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      value: active,
                      activeTrackColor: Theme.of(context).accentColor,
                      activeColor: Theme.of(context).secondaryHeaderColor,
                      onChanged: (bool value) {
                        setState(() {
                          active = value;
                        });
                      },
                    ),
                    // ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  // ),
                  // FlatButton.icon(
                  //   icon: Icon(Icons.add_a_photo),
                  //   label: Text(
                  //     'Select an Image',
                  //     style: Theme.of(context).textTheme.bodyText2.copyWith(
                  //           fontSize: 14,
                  //         ),
                  //   ),
                  //   onPressed: () {
                  //     _getImage(ImageSource.gallery);
                  //   },
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  // ),
                  // // ConditionalBuilder(
                  // //   condition: widget.imageUrl == '',
                  // //   // && imageFile==null,
                  // //   builder: (context) {
                  // //     return Container(
                  // //       width: mediaQuery.size.width * 0.4,
                  // //       height: mediaQuery.size.height * 0.1,
                  // //       decoration: BoxDecoration(
                  // //         borderRadius: BorderRadius.circular(7.0),
                  // //         shape: BoxShape.rectangle,
                  // //         image: DecorationImage(
                  // //           fit: BoxFit.contain,
                  // //           image: AssetImage(
                  // //             'assets/images/waiting.png',
                  // //           ),
                  // //         ),
                  // //       ),
                  // //     );
                  // //   },
                  // //   fallback: (context) {
                  // //     return Container(
                  // //       width: mediaQuery.size.width * 0.4,
                  // //       height: mediaQuery.size.height * 0.2,
                  // //       decoration: BoxDecoration(
                  // //         borderRadius: BorderRadius.circular(7.0),
                  // //         shape: BoxShape.rectangle,
                  // //         image: DecorationImage(
                  // //           fit: BoxFit.fill,
                  // //           image: NetworkImage(
                  // //             widget.imageUrl,
                  // //           ),
                  // //         ),
                  // //       ),
                  // //     );
                  // //   },
                  // // ),
                  // ConditionalBuilder(
                  //     condition: imageFile != null,
                  //     builder: (context) {
                  //       return Column(
                  //         children: <Widget>[
                  //           Container(
                  //             width: mediaQuery.size.width * 0.4,
                  //             height: mediaQuery.size.height * 0.2,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(7.0),
                  //               shape: BoxShape.rectangle,
                  //               image: DecorationImage(
                  //                 fit: BoxFit.fill,
                  //                 image: FileImage(
                  //                   imageFile,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               IconButton(
                  //                 icon: Icon(Icons.crop),
                  //                 onPressed: () {
                  //                   _cropImage();
                  //                 },
                  //               ),
                  //               IconButton(
                  //                 icon: Icon(Icons.refresh),
                  //                 onPressed: () {
                  //                   _clearImage();
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //           StorageService(
                  //             file: imageFile,
                  //             dir: 'modules/',
                  //             extention: 'png',
                  //           ),
                  //         ],
                  //       );
                  //     }),
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
                        await widget.moduleProvider.updateModule(
                          Module.fromModule(
                            name: name.toLowerCase().trim(),
                            description: description.toLowerCase().trim(),
                            active: active,
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
