import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserInfo extends StatefulWidget {
  MyUserInfo(this.user);
  final FirebaseUser user;
  @override
  State<StatefulWidget> createState() => MyUserInfoState();
}

class MyUserInfoState extends State<MyUserInfo> {
  var _myUser;

  initState() {
    super.initState();
    _memberSince();
  }

  // _memberSince() async {
  //   var doc = await Firestore.instance
  //       .collection('users')
  //       .document('${widget.user.email}')
  //       .get();

  //       _myUser = doc;
  //   print(doc.data['membersince'].toString());
  // }

  Future _memberSince() async {
    final documents = await Firestore.instance
        .collection('users')
        .document('${widget.user.email}')
        .get();
    final userObject = documents.data['membersince'];
    _myUser = documents.data;
    print(userObject.toString());
    return documents;
  }

  _showName() {
    if (widget.user.displayName == null) {
      String name = widget.user.email.split('@')[0];
      return name;
    } else {
      return widget.user.displayName;
    }
  }

  _showImage() {
    if (widget.user.photoUrl == null) {
      return AssetImage('assets/userIcon.png');
    } else {
      return NetworkImage(widget.user.photoUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    var doc = Firestore.instance
        .collection('users')
        .document('${widget.user.email}')
        .get();

    //var doc2 = doc.toString();

    return Container(
      alignment: Alignment.topLeft,
      child: Stack(
        children: <Widget>[
          //The container containing profile and name
          Container(
            height: 1080,
            color: Color(0xffecf0f1),
          ),

          Container(
            height: 250,
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
                boxShadow: [
                  new BoxShadow(
                      color: Color(0xff7f8c8d),
                      offset: new Offset(0.0, 1.0),
                      blurRadius: 50.0,
                      spreadRadius: 5.0)
                ]),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(0.0, 0.4),
                  child: Text(_showName().toString(),
                      style: TextStyle(
                        color: Color(0xff2c3e50),
                        fontSize: 30,
                        fontFamily: 'SFDisplay',
                        fontWeight: FontWeight.w500,
                      )),
                ),

                //),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.85),
            child: Container(
              child: CircleAvatar(
                backgroundImage: _showImage(),
                backgroundColor: Colors.transparent,
                radius: 50,
              ),
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   boxShadow: [
              //     new BoxShadow(
              //         color: Color(0xff7f8c8d),
              //         offset: new Offset(3, 3),
              //         blurRadius: 18.0,
              //         spreadRadius: 1.0)
              //   ]
              // ),
            ),
          ),

          Align(
            alignment: Alignment(0, -0.35),
            child: FutureBuilder(
              future: _memberSince(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Center(child: Text("Connecting"));

                return Text(
                    'Member Since : ${snapshot.data['membersince'].toString().split(' ')[0].split('-')[1]}/${snapshot.data['membersince'].toString().split(' ')[0].split('-')[0]}',
                    style: TextStyle(
                      color: Color(0xff7f8c8d),
                      fontSize: 15,
                      fontFamily: 'SFDisplay',
                      fontWeight: FontWeight.w500,
                    ));
              },
            ),
          ),
          Align(
            alignment: Alignment(0, -0.42),
            child: FutureBuilder(
              future: _memberSince(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Center(child: Text("Connecting"));

                return Text('${snapshot.data['email'].toString()}',
                    style: TextStyle(
                      color: Color(0xff7f8c8d),
                      fontSize: 15,
                      fontFamily: 'SFDisplay',
                      fontWeight: FontWeight.w500,
                    )
                    );
              },
            ),
          ),

          //Text('${_myUser['membersince'].tostring}'),
        ],
      ),
    );
  }
}
