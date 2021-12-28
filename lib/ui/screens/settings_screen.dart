import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

// import 'package:healthy_lifestyle_app/ui/widgets/main_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  // ignore: todo
  //TODO: settings model with id for each user(uId) >> add it with each user id registered
  @override
  Widget build(BuildContext context) {
    final _themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),
      // drawer: Theme(
      //   data: Theme.of(context).copyWith(
      //       canvasColor: Theme.of(context).canvasColor.withOpacity(0.8)),
      //   child: MainDrawer(),
      // ),
      body: SingleChildScrollView(
        child: SwitchListTile(
          title: Text(
            'Dark mode',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 14,
                ),
          ),
          value: _themeChange.darkTheme,
          activeTrackColor: Theme.of(context).accentColor,
          activeColor: Theme.of(context).secondaryHeaderColor,
          onChanged: (bool value) {
            // setState(() {
            _themeChange.darkTheme = value;
            // });
          },
        ),
      ),
    );
  }
}
