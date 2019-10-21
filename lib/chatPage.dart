import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.user, this.chatid) : super();
  final FirebaseUser user;
  final String chatid;
  //DateTime _date = DateTime.now();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  //final List<Msg> _messages = <Msg>[];

  final TextEditingController _textController = new TextEditingController();
  ScrollController scrollController = ScrollController();
  bool _isWriting = false;

  Future<void> callback(String txt) async {
    DateTime _date = DateTime.now();

    DocumentReference reference = _fireStore
        .collection('chatgroups')
        .document('${widget.chatid}')
        .collection('messages')
        .document('$_date${widget.user.email}');

    reference.setData({'from': widget.user.email, 'msg': txt, 'isme': true});
  }

  _alignment(snapshot, index) {
    if (snapshot.data.documents[index]['from'] == widget.user.email) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  // _itemCount(snapshot){

  //   try{ return snapshot.data.documents.length;}
  //   catch(e){print(e);}

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
            backgroundColor: Color(0xffEAB543),
            elevation: 0,
            child: Icon(Icons.arrow_back, color: Color(0xfff5f5f5)),
            heroTag: "go back",
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Color(0xffEAB543),
        title: Text(
          "Chat",
          style: TextStyle(
            color: Color(0xfff5f5f5),
            fontSize: 22,
            fontFamily: 'SFDisplay',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: Color(0xffdfe4ea),
        child: Column(
          children: <Widget>[
            new Flexible(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('chatgroups')
                        .document('${widget.chatid}')
                        .collection('messages')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          //reverse: true,

                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      _alignment(snapshot, index),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        '${snapshot.data.documents[index]['from'].toString().split('@')[0]}',
                                        style: TextStyle(
                                          color: Color(0xff3498db),
                                          fontSize: 15,
                                          fontFamily: 'SFDisplay',
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0, top: 6,bottom: 4),
                                      child: Text(
                                        '${snapshot.data.documents[index]['msg']}',
                                        style: TextStyle(
                                          color: Color(0xff34495e),
                                          fontSize: 20,
                                          fontFamily: 'SFDisplay',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          });
                    })),
            new Divider(height: 1.0),
            new Container(
                child: _buildComposer(), //this is the input field
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return new Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),

      margin: EdgeInsets.symmetric(horizontal: 9.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            //Input Field
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.only(left: 10, top: 15, bottom: 10),
              child: new TextField(
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWriting = (txt.length > 0);
                  });
                },
                decoration: new InputDecoration.collapsed(
                    hintText: "Write a message..."),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
                decoration: BoxDecoration(
                  color: Color(0xff3498db),
                  borderRadius: BorderRadius.circular(50),
                ),
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: new IconButton(
                  //Send Button
                  icon: Icon(Icons.send, color: Color(0xfff5f5f5)),
                  onPressed: _isWriting
                      ? () => _submitMsg(_textController.text)
                      : null,
                )),
          )
        ],
      ),
      //  ),
    );
  }

  _submitMsg(String txt) {
    //Cleans the textField and changes state
    txt == null ? null : callback(txt);
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
  }
}
