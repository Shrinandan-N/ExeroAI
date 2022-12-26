import 'package:CAC2020/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CAC2020/screens/home/home.dart';
import 'package:provider/provider.dart';

import '../chat_home.dart';

class ChatMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatMain();
}

class _ChatMain extends State<ChatMain> {
  Future<QuerySnapshot> messages;
  getMessages() {
    return Firestore.instance
        .collection("users")
        .document(Provider.of<UserModel>(context, listen: false).uid)
        .collection("messages")
        .getDocuments();
  }

  @override
  void initState() {
    super.initState();
    print("hello");
    messages = getMessages();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        drawer: Drawer(
          child: CustomDrawer(),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 50),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        icon: Icon(Icons.menu),
                      ),
                      Column(
                        children: [
                          Text("ExeroAI",
                              style: TextStyle(
                                  color: Colors.green[400], fontSize: 14)),
                          Row(
                            children: [
                              Text("Messages",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 20)
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 3 / 4,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection("centers")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          if (Provider.of<UserModel>(context,
                                                  listen: false)
                                              .chatsWith
                                              .contains(snapshot
                                                  .data
                                                  .documents[index]
                                                  .data["centerName"])) {
                                            return index == 0
                                                ? Column(children: [
                                                    Divider(
                                                        color: Colors.black),
                                                    chatRowCard(context,
                                                        snapshot, index)
                                                  ])
                                                : chatRowCard(
                                                    context, snapshot, index);
                                          } else {
                                            return Container();
                                          }
                                        });
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                })),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }

  Widget chatRowCard(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => chatHome(
                chatName: snapshot.data.documents[index].data["centerName"],
                chatId: snapshot.data.documents[index].documentID,
                documentId: Provider.of<UserModel>(context, listen: false).uid,
                myName:
                    Provider.of<UserModel>(context, listen: false).firstName,
                check: true,
                data: snapshot.data.documents[index].data,
              ))),
      child: Column(
        children: [
          // Divider(color: Colors.black, indent: 0),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Container(
              padding: EdgeInsets.all(8),
              // decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data.documents[index].data["centerName"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      FutureBuilder<QuerySnapshot>(
                          future: messages,
                          builder: (context, data) {
                            if (data.hasData) {
                              List<DocumentSnapshot> docs = data.data.documents;
                              docs.sort((a, b) {
                                int aTime = a.data["time"];
                                int bTime = b.data["time"];
                                return bTime.compareTo(aTime);
                              });
                              for (var i in docs) {
                                if (i.data["receiver"] ==
                                    snapshot.data.documents[index]
                                        .data["centerName"]) {
                                  return Text("Me: " + i.data["text"]);
                                } else if (i.data["sender"] ==
                                    snapshot.data.documents[index]
                                        .data["centerName"]) {
                                  return Text(snapshot.data.documents[index]
                                          .data["centerName"]
                                          .toString() +
                                      ": " +
                                      i.data["text"]);
                                } else {
                                  continue;
                                }
                              }
                              return Container();
                            } else {
                              return Container();
                            }
                          })
                    ],
                  ),
                  // SizedBox(
                  //   width: 30,
                  // )
                ],
              ),
            ),
          ),
          Divider(color: Colors.black),
        ],
      ),
    );
  }
}
