import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:gromnombeta/hostAMeal.dart';
import 'package:gromnombeta/podoRest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserArguments {
  final FirebaseUser user;
  final Address location;
  UserArguments(this.user, this.location);
}

class Restaurant extends StatefulWidget {
  static const routeName = '/restaurant';

  @override
  State<StatefulWidget> createState() => RestaurantState();
}

class RestaurantState extends State<Restaurant> {
  var jsonResponse;

  Future _getRestaurants() async {
    var url =
        "http://192.168.43.47:8080/fetchrestaurants/?pincode=835215&address=%20Mesra";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          jsonResponse = json.decode((response.body));
        });
      }
    }

    Restaurants restaurants = Restaurants.fromJson(jsonResponse);
    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    final UserArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEAB543),
        title: Text(
          "Pick a Restaurant",
          style: TextStyle(
            color: Color(0xfff5f5f5),
            fontSize: 22,
            fontFamily: 'SFDisplay',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _getRestaurants(),
        builder: (context, AsyncSnapshot snapshot) {
          //return Text('${snapshot.data.restaurants[0]}');
          if (!snapshot.hasData) return Center(child: Text("Connecting"));

          return ListView.builder(
            itemCount: snapshot.data.restaurants.length,
            itemBuilder: (context, index) {
              //Combo combo = snapshot.data.combo[index];
              RestaurantInfo restaurant =
                  snapshot.data.restaurants[index]; //.restaurants[index];
              if (!snapshot.hasData) return Center(child: Text("Connecting"));

              return Container(child: OneRest(args.user, restaurant));
            },
          );
        },
      ),
    );
  }
}

class OneRest extends StatefulWidget {
  OneRest(this.user, this.restaurantInfo);
  final FirebaseUser user;
  final RestaurantInfo restaurantInfo;
  @override
  State<StatefulWidget> createState() => OneRestState();
}

class OneRestState extends State<OneRest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, HostAMeal.routeName,
            arguments: RestArguments(widget.user, widget.restaurantInfo));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(top: 5, left: 5, right: 5,bottom: 8),
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(
                color: Color(0xff7f8c8d),
                offset: new Offset(0.0, 0.0),
                blurRadius: 8.0,
                spreadRadius: -5.0)
          ],
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 6.0),
              child: Align(
                  alignment: Alignment(-0.85, 0.0),
                  child: Text('${widget.restaurantInfo.name}',
                      style: TextStyle(
                        color: Color(0xff34495e),
                        fontSize: 20,
                        fontFamily: 'SFDisplay',
                        fontWeight: FontWeight.w500,
                      ))),
            ),
            Align(
              alignment: Alignment(-0.8, 0.0),
              child: Text(
                  'Cost for two : ${widget.restaurantInfo.costfortwo}|Rating : ${widget.restaurantInfo.rating}',
                  style: TextStyle(
                    color: Color(0xff34495e),
                    fontSize: 16,
                    fontFamily: 'SFDisplay',
                    fontWeight: FontWeight.w200,
                  )),
            ),
            //SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
