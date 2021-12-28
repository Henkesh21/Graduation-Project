import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:healthy_lifestyle_app/core/models/role_model.dart';

class AddRoleDialog extends StatefulWidget {
  final roleProvider;

  AddRoleDialog({
    Key key,
    @required this.roleProvider,
  }) : super(key: key);

  @override
  _AddRoleDialogState createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<AddRoleDialog> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  int value;

  String numberValidator(String value) {
    if (value.isEmpty) {
      return 'Enter role value';
    }
    final n = num.tryParse(value);
    if (n < 1 || n > 4) {
      return '"$value" is not valid, only 1:4 is valid';
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
          // SingleChildScrollView(
          //   child:
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (val) => val.isEmpty ? 'Enter role name' : null,
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
                      decoration: InputDecoration(hintText: 'Value'),
                      validator: numberValidator,
                      onSaved: (val) {
                        value = numberCasting(val);
                      }),
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
                        await widget.roleProvider.addRole(
                          Role.fromRole(
                            name: name.toLowerCase().trim(),
                            value: value,
                            // rId: rId,
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
