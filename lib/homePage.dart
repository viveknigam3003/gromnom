import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage(this.user, this._location);
  final FirebaseUser user;
  final Address _location;
  static const routeName = '/hostAMeal';

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffecf0f1),
      child: Column(
        children: <Widget>[
          //Filter(),
          Expanded(
            child: ListView(
              //scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  width: 280,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "Currently Hosted",
                      style: TextStyle(
                          color: Color(0xff34495e),
                          fontSize: 30,
                          fontFamily: 'SFDisplay',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 10, top: 15),
                ),
                Container(
                    child: new StreamBuilder(
                        stream:
                            Firestore.instance.collection('orders').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: Text(
                              "No Orders Hosted Currently.",
                              style: TextStyle(
                                  color: Color(0xfff5f5f5),
                                  fontSize: 25,
                                  fontFamily: 'SFDisplay',
                                  fontWeight: FontWeight.w500),
                            ));
                          } else {
                            return ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _controller,
                              itemCount: snapshot.data.documents
                                  .length, //snapshot.data.length,
                              //scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot ds =
                                    snapshot.data.documents[index];
                                Map combo = ds['items'];
                                String time = ds.data['scheduledtime'];
                                String dname = ds.documentID;

                                return Container(
                                  //height: ds['items'].length.toDouble(),
                                  //child: Card(child: Text('${ds['host']} \n ${combo['items'].length}')),
                                  child: OneCard2(combo, time, dname),
                                  //child: Text("${ds.documentID}"),
                                );
                              },
                            );
                          }
                        }))
              ],
            ),
          )
        ],
      ),
    );
  }
}

//This is one card or one combo
class OneCard2 extends StatefulWidget {
  OneCard2(this.combo, this.time, this.dname);
  final Map combo;
  final String time;
  final String dname;
  @override
  _OneCard2State createState() => _OneCard2State();
}

class _OneCard2State extends State<OneCard2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: (50 * widget.combo['items'].length + 140).toDouble(),
        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                  color: Color(0xff7f8c8d),
                  offset: new Offset(0.0, 8.0),
                  blurRadius: 8.0,
                  spreadRadius: -5.0)
            ],
            borderRadius: BorderRadius.circular(20),
            //border: Border.all(color: Color(0xff7f8c8d),width: 3),
            color: Color(0xfff5f5f5)),
        child: Column(
          children: <Widget>[
            Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(children: <Widget>[
                  ListView.builder(
                    itemCount: widget.combo['items'].length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          OneItem2(widget.combo, index),
                          //Text('${widget.combo.length}')
                        ],
                      );
                    },
                  ),
                ]
                    //child: Text('${widget.combo['items'].length}'),
                    )),
            Container(
              child: Align(
                alignment: Alignment(-1, 0),
                child: Text(
                  'Scheduled at :\n ${widget.time}',
                  style: TextStyle(
                    color: Color(0xff34495e),
                    fontSize: 15,
                    fontFamily: 'SFDisplay',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              margin: EdgeInsets.only(top: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 10),
              child: Align(
                alignment: Alignment(0.9, 0.0),
                child: Material(
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    color: Color(0xff3498db),
                    child: Text(
                      'JOIN',
                      style: TextStyle(
                        color: Color(0xfff5f5f5),
                        fontSize: 15,
                        letterSpacing: 1.5,
                        fontFamily: 'SFDisplay',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OneItem2 extends StatefulWidget {
  OneItem2(this.combo, this.index);
  final Map combo;
  final int index;
  //int count = combo.items.length;

  @override
  State<StatefulWidget> createState() => OneItem2State();
}

class OneItem2State extends State<OneItem2> {
  List<bool> Vals = new List();

  @override
  void initState() {
    super.initState();

    int count = widget.combo['items'].length;

    Vals = List<bool>.generate(count, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          child: Text(
            widget.combo['items'][widget.index]['item'].toString(),
            style: TextStyle(
                color: Color(0xff34495e),
                fontSize: 15,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w600),
          ),
          alignment: Alignment(-1, 0),
        ),
        Align(
            child:
                Text('₹${widget.combo['items'][widget.index]['price'].toString()}',
                style: TextStyle(
                color: Color(0xff34495e),
                fontSize: 15,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w600),
                ),
            alignment: Alignment(0.2, 0)),
        Align(
            child: Bool(widget.combo['items'][widget.index]['boolValue'],),
            alignment: Alignment(0.6, 0))
      ],
    );
    //return Text("sda");
  }
}

Widget Bool(bool val) {
  if (val) {
    return Text("taken",
    style: TextStyle(
                color: Color(0xff7f8c8d),
                fontSize: 15,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w600),);
  } else {
    return Text("Available",
    style: TextStyle(
                color: Color(0xff2ecc71),
                fontSize: 15,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w600),);
  }
}
