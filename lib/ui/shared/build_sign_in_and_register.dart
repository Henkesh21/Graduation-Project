import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:healthy_lifestyle_app/ui/shared/loading.dart';

class BuildSignInAndRegister extends StatefulWidget {
  final Form form;
  final bool loading;

  BuildSignInAndRegister({
    @required this.form,
    @required this.loading,
  });

  @override
  BuildSignInAndRegisterState createState() => BuildSignInAndRegisterState();
}

class BuildSignInAndRegisterState extends State<BuildSignInAndRegister> {
  final homeTexts = [
    'You don’t have to be great to start. But you have to start to be great ✌️',
    'Strength does not come from physical capacity. It comes from an indomitable will 💪',
    'Fitness is not 30% gym and 70% diet. It’s 100% DEDICATION to the gym and your diet ',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return widget.loading
        ? Loading()
        : Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     'Sign in',
            //     style: Theme.of(context).textTheme.title,
            //   ),
            //   // elevation: 0.0,
            //   actions: <Widget>[
            //     FlatButton.icon(
            //       onPressed: () {
            //         widget.toggleView();
            //       },
            //       icon: Icon(
            //         Icons.person,
            //         color: Theme.of(context).accentColor,
            //       ),
            //       label: Text(
            //         'Register',
            //         style: Theme.of(context).textTheme.body2,
            //       ),
            //     )
            //   ],
            // ),
            body: SafeArea(
              bottom: false,
              top: false,
              child: SingleChildScrollView(
                child: Container(
                  width: mediaQuery.size.width,
                  height: mediaQuery.size.height,
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(255, 0, 0, 0.5),
                    image: DecorationImage(
                      image: ExactAssetImage(
                        'assets/images/home2.jpg',
                      ),
                      // colorFilter: new ColorFilter.mode(
                      //   Color.fromRGBO(0, 0, 0, 0.7),
                      //   BlendMode.dstATop,
                      // ),
                      colorFilter:
                          ColorFilter.mode(Colors.black54, BlendMode.darken),
                      fit: BoxFit.cover,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  // padding: EdgeInsets.symmetric(
                  //   vertical: 20.0,
                  //   horizontal: 50.0,
                  // ),
                  padding: EdgeInsets.all(mediaQuery.size.width / 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: mediaQuery.size.width,
                        height: mediaQuery.size.height * 0.3,
                        child: Swiper(
                          scrollDirection: Axis.horizontal,
                          autoplay: true,
                          loop: true,
                          autoplayDelay: 5000,
                          // autoplayDisableOnInteraction: true,
                          itemCount: 3,
                          transformer: null,
                          pagination: new SwiperPagination(builder: SwiperPagination.rect),
                          control: new SwiperControl(),
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Container(
                                width: mediaQuery.size.width * 0.7,
                                child: Text(
                                  homeTexts[index],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline1,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            );
                          },
                          viewportFraction: 20,
                          scale: 0.9,
                          // layout: SwiperLayout.DEFAULT,
                        ),
                      ),
                      Container(
                        width: mediaQuery.size.width,
                        height: mediaQuery.size.height * 0.6,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              widget.form,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
