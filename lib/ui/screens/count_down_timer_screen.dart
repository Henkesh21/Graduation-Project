import 'package:flutter/material.dart';

import 'dart:math' as math;

class CountDownTimerScreen extends StatefulWidget {
  static const routeName = '/timer';
  final args;
  // final days;
  // final hours;
  // final minutes;
  // final seconds;

  const CountDownTimerScreen({
    Key key,
    this.args,
  }) : super(key: key);

  @override
  _CountDownTimerScreenState createState() => _CountDownTimerScreenState();
}

class _CountDownTimerScreenState extends State<CountDownTimerScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  // Duration _duration;
  // ignore: unused_field
  int _days, _hours, _minutes, _seconds;
  var routeArgs;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    // Duration duration = controller.duration;
    return '${duration.inDays} : ${duration.inHours} : ${duration.inMinutes} : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    // return '${duration.inDays} : ${duration.inHours} : ${duration.inMinutes} : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

    // return '${duration.inDays} : ${duration.inHours} : ${duration.inMinutes} : ${(duration.inSeconds)}';
    // return '';
  }

  // @override
  // void didChangeDependencies() {
  //   final routeArgs = widget.args;
  //   _days = routeArgs['days'];
  //   _hours = routeArgs['hours'];
  //   _minutes = routeArgs['minutes'];
  //   _seconds = routeArgs['seconds'];
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    routeArgs = widget.args;
    // _duration = routeArgs['duration'];
    _days = routeArgs['days'];
    _hours = routeArgs['hours'];
    _minutes = routeArgs['minutes'];
    _seconds = routeArgs['seconds'];
    controller = AnimationController(
      vsync: this,
      duration:
          //  _duration,
          Duration(
        days: _days,
        // days: 1,

        // hours: _hours,
        // hours: 23,
        hours: 0,

        // minutes: _minutes,
        // minutes: 59,
        minutes: 0,

        // seconds: _seconds,
        // seconds: 59,
        seconds: 0,

        // days: _days,
        // hours: _hours,
        // minutes: _minutes,
        // seconds: _seconds,
      ),
    );
    // controller.duration= _duration;
    // controller.reverse(from: controller.value);
    // controller.reset();
    // controller.value = ;
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    // controller.reverse(from: controller.value);
    // controller.reverse();
    // controller.(from: controller.value == 0.0 ? 1.0 : controller.value);
    // controller.forward();
    super.initState();
    print('Controller duration days >>>>>>>>>>>>>> ' +
        controller.duration.inDays.toString());
    print('Controller duration hours >>>>>>>>>>>>>> ' +
        controller.duration.inHours.toString());
    print('Controller duration minutes >>>>>>>>>>>>>> ' +
        controller.duration.inMinutes.toString());
    print('Controller duration seconds >>>>>>>>>>>>>> ' +
        controller.duration.inSeconds.toString());
    // didChangeDependencies();
  }

  @override
  void didChangeDependencies() {
    routeArgs = widget.args;
    // _duration = routeArgs['duration'];
    _days = routeArgs['days'];
    _hours = routeArgs['hours'];
    _minutes = routeArgs['minutes'];
    _seconds = routeArgs['seconds'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Count down',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    height: controller.value * mediaQuery.size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.black26black38,
                                    color: themeData.indicatorColor,
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Never Give Up",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        overflow: TextOverflow.fade,
                                      ),
                                      // FittedBox(
                                      //   child:
                                      Column(
                                        children: <Widget>[
                                          FittedBox(
                                            child: Text(
                                              'Days : Hours : Min : Sec',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          Text(
                                            timerString,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ],
                                      ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // AnimatedBuilder(
                      //     animation: controller,
                      //     builder: (context, child) {
                      //       return FloatingActionButton.extended(
                      //           onPressed: () {
                      //             setState(() {});
                      //             if (controller.isAnimating)
                      //               controller.stop();
                      //             else {
                      //               controller.reverse(
                      //                   from: controller.value == 0.0
                      //                       ? 1.0
                      //                       : controller.value);
                      //             }
                      //           },
                      //           icon: Icon(controller.isAnimating
                      //               ? Icons.pause
                      //               : Icons.play_arrow),
                      //           label: Text(
                      //               controller.isAnimating ? "Pause" : "Play"));
                      //     }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;
  Tween<double> tween;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
    // tween = Tween(begin: 0.0, end: 0.1);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
