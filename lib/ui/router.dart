import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/categories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/exercises_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/food_items_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/modules_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/roles_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/authenticate_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/register_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/sign_in_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/category_exercises_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/category_foods_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/count_down_timer_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/daily_calories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/exercises_categories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/foods_categories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/home_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/profile_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/settings_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/targets_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/wrapper_screen.dart';
import 'package:healthy_lifestyle_app/ui/shared/tabs_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(
        //   builder: (ctx) => TargetsScreen(
        //     // args: settings.arguments as Map<String, String>,
        //   ),
        // );
        return MaterialPageRoute(builder: (ctx) => WrapperScreen());
      case '/tabs':
        return MaterialPageRoute(builder: (ctx) => TabsScreen());
      case '/authenticate':
        return MaterialPageRoute(builder: (ctx) => AuthenticateScreen());
      case '/register':
        return MaterialPageRoute(builder: (ctx) => RegisterScreen());
      case '/sign-in':
        return MaterialPageRoute(builder: (ctx) => SignInScreen());
      case '/home':
        return MaterialPageRoute(builder: (ctx) => HomeScreen());
      case '/exercises-categories':
        return MaterialPageRoute(builder: (ctx) => ExercisesCategoriesScreen());
      case '/food-categories':
        return MaterialPageRoute(builder: (ctx) => FoodsCategoriesScreen());
      case '/settings':
        return MaterialPageRoute(builder: (ctx) => SettingsScreen());
      case '/profile':
        return MaterialPageRoute(builder: (ctx) => ProfileScreen());
      case '/roles':
        return MaterialPageRoute(builder: (ctx) => RolesScreen());
      case '/modules':
        return MaterialPageRoute(builder: (ctx) => ModulesScreen());
      case '/categories':
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      case '/exercises':
        return MaterialPageRoute(builder: (ctx) => ExercisesScreen());
      case '/food-items':
        return MaterialPageRoute(builder: (ctx) => FoodItemsScreen());
      case '/category-exercises':
        return MaterialPageRoute(
          builder: (ctx) => CategoryExercisesScreen(
            args: settings.arguments as Map<String, String>,
          ),
        );
      case '/category-foods':
        return MaterialPageRoute(
          builder: (ctx) => CategoryFoodsScreen(
            args: settings.arguments as Map<String, String>,
          ),
        );
      case '/timer':
        return MaterialPageRoute(
          builder: (ctx) => CountDownTimerScreen(
            args: settings.arguments as Map<String, int>,
          ),
        );
      case '/targets':
        return MaterialPageRoute(
          builder: (ctx) => TargetsScreen(),
        );
      case '/daily-calories':
        return MaterialPageRoute(
          builder: (ctx) => DailyCaloriesScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}!',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
    }
  }
}
