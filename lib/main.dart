import 'package:flutter/material.dart';
import 'package:gromnombeta/homePage.dart';
import 'package:gromnombeta/hostAMeal.dart';
import 'package:gromnombeta/hostAMealPreview.dart';
import 'package:gromnombeta/restaurant.dart';
import 'loginPage.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'SFDisplay',
        ),
        routes: {
        //'/chatPage': (context) => ChatPage(),
       HostAMeal.routeName: (context) => HostAMeal(),
        Restaurant.routeName: (context) => Restaurant(),
        HostAMealPreview.routeName: (context) => HostAMealPreview()
      },
      home: new LoginPage(new Auth()),
    );
  }
}

