import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        // primarySwatch: isDarkTheme ? Color(0xff10171F) : Colors.brown,
        primaryColor: isDarkTheme ? Color(0xff10171F) : Colors.brown,
        accentColor: isDarkTheme ? Color(0xFF9E103D) : Colors.orange[300],
        canvasColor:
            isDarkTheme ? Color(0xFF16202A) : Color.fromRGBO(255, 254, 229, 1),
        backgroundColor:  isDarkTheme ? Color(0xff8799A4) : Colors.brown[400],
        errorColor: isDarkTheme ? Color(0xffD4235B) : Colors.red,
        secondaryHeaderColor: isDarkTheme ? Color(0xff8799A4) : Colors.brown,
        fontFamily: 'Raleway',
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: isDarkTheme ? Color(0xFF9E103D) : Colors.orange[300],
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          fillColor: Colors.white38,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkTheme ? Color(0xff8799A4) : Colors.brown,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkTheme ? Color(0xff8799A4) : Colors.brown,
              width: 2.0,
            ),
          ),
        ),
        iconTheme: IconThemeData(
            color: isDarkTheme ? Color(0xFF9E103D) : Colors.orange[300]),
        buttonTheme: ButtonThemeData(
          buttonColor: isDarkTheme ? Color(0xff10171F) : Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: isDarkTheme ? Color(0xFF9E103D) : Colors.orange[300],
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          textTheme: ButtonTextTheme.accent,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText2: TextStyle(
                color: isDarkTheme ? Color(0xFFFFFFFF) : Colors.brown[900],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyText1: TextStyle(
                color: isDarkTheme ? Color(0xFF9E103D) : Colors.orange[300],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              headline4: TextStyle(
                color: Colors.brown,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              headline3: TextStyle(
                color: isDarkTheme ? Color(0xffD4235B) : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(
                color: isDarkTheme ? Color(0xFF9E103D) : Colors.brown[900],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headline1: TextStyle(
                color: isDarkTheme
                    ? Color(0xFFFFFFFF)
                    : Color.fromRGBO(255, 254, 229, 1),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headline6: TextStyle(
                color: isDarkTheme ? Color(0xff8799A4) : Colors.orange[300],
                fontSize: 20,
                // fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: isDarkTheme ? Color(0xff10171F) : Colors.brown,
          barBackgroundColor: isDarkTheme
              ? Color(0xFF16202A)
              : Color.fromRGBO(255, 254, 229, 1),
          scaffoldBackgroundColor: isDarkTheme
              ? Color(0xFF16202A)
              : Color.fromRGBO(255, 254, 229, 1),
        ));
  }
}
