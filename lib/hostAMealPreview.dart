import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

import 'podoMeal.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'podoItems.dart';
import 'podoRest.dart';

typedef IntCallback = Function(int number);
typedef ListCallback = Function(Combo chosenCombo);

class MealArguments2 {
  final Combo combo;
  final FirebaseUser user;
  final RestaurantInfo restaurantInfo;

  MealArguments2(this.combo, this.user, this.restaurantInfo);
}

// A widget that extracts the necessary arguments from the ModalRoute.
class HostAMealPreview extends StatefulWidget {
  static const routeName = '/hostAMealPreview';

  @override
  _HostAMealPreviewState createState() => _HostAMealPreviewState();
}

class _HostAMealPreviewState extends State<HostAMealPreview> {
  double price;
  List<bool> mylist = [];
  Combo finalCombo;

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020),
        initialDate: _date);

    if (picked != null) {
      print("date selected : ${picked.toString()}");
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      print("Time selected : ${picked.toString()}");
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  initState() {
    super.initState();
    price = 0;
  }

  void _changeprice(num) {
    setState(() {
      price += num;
    });
  }

  void _getData(chosenCombo) {
    setState(() {
      finalCombo = chosenCombo;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final MealArguments2 args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEAB543),
        title: Text(
          'Confirm Your Order',
          style: TextStyle(
            color: Color(0xfff5f5f5),
            fontSize: 22,
            fontFamily: 'SFDisplay',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ViewCard(args.combo, _changeprice, _getData),
          ),

          //This is the container which contains cart price and buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //margin: EdgeInsets.only(left: 5, right: 5,bottom: 8),
              alignment: Alignment(0.0, -1.0),
              padding: EdgeInsets.only(top: 15),
              height: 180,
              decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                        color: Color(0xff7f8c8d),
                        offset: new Offset(0.0, 0.0),
                        blurRadius: 8.0,
                        spreadRadius: -5.0)
                  ],
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(10)),
              child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Cart price : $price",
                          style: TextStyle(
                              color: Color(0xff34495e),
                              fontSize: 15,
                              fontFamily: 'SFDisplay',
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 75,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(25),
                          //     color: Color(0xffEAB543)),
                          //alignment: Alignment(-1, 0),
                          child: RaisedButton(
                            color: Color(0xff3498db),
                            onPressed: () {
                              if (finalCombo != null) {
                                //print('${finalCombo.items[1].boolValue}');
                                var itemCount = finalCombo.items.length;
                                for (var i = 0; i < itemCount; i++) {
                                  print('${finalCombo.items[i].boolValue}');
                                }

                                var docName = randomAlpha(20);
                                List<Items2> items2 = [];
                                for (var u in finalCombo.items) {
                                  if (u.boolValue) {
                                    items2.add(Items2(
                                        item: u.item,
                                        price: u.price,
                                        boolValue: u.boolValue,
                                        user: args.user.email));
                                  } else {
                                    items2.add(Items2(
                                        item: u.item,
                                        price: u.price,
                                        boolValue: u.boolValue));
                                  }
                                  //print(u.toJson());
                                }

                                Combo2 combo2 = Combo2(items: items2);
                                List users = [];
                                users.add(args.user.email);

                                Firestore.instance
                                    .collection('orders')
                                    .document('$docName')
                                    .setData({
                                  'currentlyhosted': true,
                                  'restaurant': args.restaurantInfo.name,
                                  'host': "${args.user.email}",
                                  'totalitems': finalCombo.items.length,
                                  'items': combo2.toJson(),
                                  'scheduledtime':
                                      "${_time.hour}:${_time.minute} on ${_date.day}/${_date.month}/${_date.year}"
                                });
                                print(finalCombo.toJson());
                                print(combo2.toJson());
                                Firestore.instance
                                    .collection('chatgroups')
                                    .document('${docName}')
                                    .setData({
                                  'users': users,
                                  'orderid': docName,
                                  'host': args.user.email
                                });
                              }
                            },
                            child: Text(
                              "Host this order",
                              style: TextStyle(
                                color: Color(0xfff5f5f5),
                                fontSize: 15,
                                //letterSpacing: 1.5,
                                fontFamily: 'SFDisplay',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            "Selected Date : ${_date.day.toString()}/${_date.month.toString()}/${_date.year.toString()}"),
                        Container(
                          child: RaisedButton(
                            child: Text("Select Date"),
                            onPressed: () {
                              _selectDate(context);
                              print('_date');
                            },
                          ),
                          margin: EdgeInsets.only(left: 42)
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            "Selected Time : ${_time.hour.toString()}:${_time.minute.toString()}"),
                        Container(
                          child: RaisedButton(
                            child: Text("Select Time"),
                            onPressed: () {
                              _selectTime(context);
                              print('${_time.hour}');
                            },
                          ),
                          margin: EdgeInsets.only(left: 82)
                        ),
                      ],
                    ),
                  ])),
            ),
          ),
        ],
      ),
    );
  }
}

//This is one card
class ViewCard extends StatefulWidget {
  ViewCard(this.combo, this.changePrice, this.getData);
  final Combo combo;
  final IntCallback changePrice;
  final ListCallback getData;

  @override
  _ViewCardState createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (50 * widget.combo.items.length + 125).toDouble(),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xffEAB543)),
      child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.combo.items.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    OneItem(widget.combo, index, widget.changePrice,
                        widget.getData),
                  ],
                );
              },
            ),
          ])),
    );
  }
}

//This class returns one item or one row of the class
class OneItem extends StatefulWidget {
  OneItem(this.combo, this.index, this.changePrice, this.getData);
  final Combo combo;
  final int index;
  final Function changePrice;
  double priceval;
  final ListCallback getData;

  @override
  State<StatefulWidget> createState() => OneItemState();
}

class OneItemState extends State<OneItem> {
  List<bool> Vals = new List();

  @override
  void initState() {
    super.initState();

    int count = widget.combo.items.length;

    Vals = List<bool>.generate(count, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          child: Text(
            widget.combo.items[widget.index].item,
            style: TextStyle(
              color: Color(0xfff5f5f5),
              fontSize: 18,
              fontFamily: 'SFDisplay',
              fontWeight: FontWeight.w400,
            ),
          ),
          alignment: Alignment(-1, 0),
        ),
        Align(
            child: Text(
              widget.combo.items[widget.index].price.toString(),
              style: TextStyle(
                color: Color(0xfff5f5f5),
                fontSize: 18,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w400,
              ),
            ),
            alignment: Alignment(0.1, 0)),
        Align(
            child: Checkbox(
              value: Vals[widget.index],
              onChanged: (bool value) {
                setState(() {
                  Vals[widget.index] = value;
                  if (value == true) {
                    widget.priceval = double.parse(
                        widget.combo.items[widget.index].price.toString());
                  } else {
                    double val = double.parse(
                        widget.combo.items[widget.index].price.toString());
                    widget.priceval = -1 * val;
                  }
                  widget.changePrice(widget.priceval);
                  widget.combo.items[widget.index].boolValue = value;
                  widget.getData(widget.combo);
                  print('${widget.priceval}');
                });
              },
            ),
            alignment: Alignment(0.6, 0)),
      ],
    );
  }
}
