import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/exercises_categories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/foods_categories_screen.dart';
import 'package:healthy_lifestyle_app/ui/shared/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  

  @override
  void initState() {
    _pages = [
     
      {
        'page': ExercisesCategoriesScreen(),
        'title': 'Exercises',
      },
      {
        'page': FoodsCategoriesScreen(),
        'title': 'Foods',
      },
    ];
    super.initState();
    // setState(() {
    //   getModuleData().then((bool a) {
    //     setState(() {
    //       _moduleActive = a;
    //     });
    //     // print('_moduleActive >>>>>>>>>>>>>> ' + '$_moduleActive');
    //   });
    // });
  }

  void _selectPage(int index) {
    // if (!_moduleActive) {
    //   setState(() {
    //     _selectedPageIndex = 1;
    //   });
    // }
    if (_pages[_selectedPageIndex]['page'] == 1) {
      //make it 1 if module is not active
      return;
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    didChangeDependencies();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: Text(
          _pages[_selectedPageIndex]['title'],
          style: Theme.of(context).textTheme.headline6,
        ),

        iconTheme: Theme.of(context).iconTheme,

        // elevation: 0.0,
        // actions: <Widget>[
        //   FlatButton.icon(
        //     onPressed: () async {
        //       await _auth.signOut();
        //     },
        //     icon: Icon(
        //       Icons.person,
        //       color: Theme.of(context).accentColor,
        //     ),
        //     label: Text(
        //       'Logout',
        //       style: Theme.of(context).textTheme.body2,
        //     ),
        //   ),
        // ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).canvasColor.withOpacity(0.8)),
        child: MainDrawer(),
      ),
      body:_pages[_selectedPageIndex]['page'],
      //  ConditionalBuilder(
      //   condition: _moduleActive,
      //   builder: (context) => _pages[_selectedPageIndex]['page'],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        onTap: _selectPage,
        // backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor.withOpacity(0.4),
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            // backgroundColor: Colors.transparent,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),

            icon: Icon(
              Icons.fitness_center,
            ),
            title: Text('Exercises'),
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            // backgroundColor: Colors.transparent,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            icon: Icon(
              Icons.restaurant,
            ),
            title: Text('Foods'),
          ),
        ],
      ),
    );
  }
}
