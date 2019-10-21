import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gromnombeta/chatPage.dart';

class ChatIndex extends StatefulWidget {
  ChatIndex(this.user);
  final FirebaseUser user;
  @override
  State<StatefulWidget> createState() => ChatIndexState();
}

class ChatIndexState extends State<ChatIndex> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xffecf0f1),
        child: StreamBuilder(
            stream: Firestore.instance.collection('chatgroups').snapshots(),
            builder: (context, snapshot) {
              int count = 0;
              List<int> indices = [];

              for (var i = 0; i < snapshot.data.documents.length; i++) {
                if (snapshot.data.documents[i]['users']
                    .toString()
                    .contains(widget.user.email.toString())) {
                  count++;
                  indices.add(i);
                }
              }

              if (count == 0) {
                return Container(
                  alignment: Alignment(0, 0),
                  child: Text(
                    'Oh Snap!\nLooks like you have no open orders',
                    style: TextStyle(
                        color: Color(0xff7f8c8d),
                        fontSize: 20,
                        fontFamily: 'SFDisplay',
                        fontWeight: FontWeight.w600),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: count,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    widget.user,
                                    snapshot.data.documents[indices[index]]
                                        ['orderid'])));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                                child: Text(
                                  "Chats",
                                  style: TextStyle(
                                      color: Color(0xff34495e),
                                      fontSize: 30,
                                      fontFamily: 'SFDisplay',
                                      fontWeight: FontWeight.w600),
                                ),
                                margin: EdgeInsets.only(left: 10, top: 15)),
                          ),
                          Container(
                              color: Color(0xfff5f5f5),
                              alignment: Alignment(-1, 0),
                              height: 80,
                              margin:
                                  EdgeInsets.only(top: 20, left: 0, right: 0),
                              padding: EdgeInsets.only(
                                  top: 25, bottom: 25, left: 15, right: 15),
                              child: Text(
                                snapshot.data.documents[indices[index]]
                                    ['orderid'],
                                style: TextStyle(
                                  color: Color(0xff34495e),
                                  fontSize: 20,
                                  letterSpacing: 1.5,
                                  fontFamily: 'SFDisplay',
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ],
                      ),
                    );
                  });
            })
        //Text('${snapshot.data.documents[0]['users']}');

        );
  }
}
