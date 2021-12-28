import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/ui/screens/category_foods_screen.dart';

class FoodCategoryItem extends StatelessWidget {
  final String categoryName;
  final categoryImage;

  FoodCategoryItem(this.categoryName, this.categoryImage);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryFoodsScreen.routeName,
      arguments: {
        'category_name': categoryName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      // splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: ConditionalBuilder(
        condition: categoryImage == '',
        builder: (context) {
          return Container(
            child: Center(
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
                overflow: TextOverflow.fade,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/waiting.png',
                ),
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
          );
        },
        fallback: (context) {
          return Container(
            child: Center(
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
                overflow: TextOverflow.fade,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(
                  categoryImage,
                ),
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
