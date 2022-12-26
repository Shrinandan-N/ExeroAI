import 'dart:async';

import 'package:CAC2020/screens/chat.dart';
import 'package:CAC2020/screens/home/center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

class chatHome extends StatefulWidget {
  final String chatName;
  final String chatId;
  final String documentId;
  final String myName;
  final bool check;
  final Map<String, dynamic> data;
  chatHome(
      {this.chatName,
      this.chatId,
      this.documentId,
      this.myName,
      this.check,
      this.data});
  @override
  _chatHomeState createState() => _chatHomeState();
}

class _chatHomeState extends State<chatHome> {
  final messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  Stream chatMessagesStream;

  sendMessage(String documentId, String chatRoomId, String name,
      TextEditingController messageController) {
    Firestore.instance.collection("users").document(widget.documentId).setData({
      "chatsWith": FieldValue.arrayUnion([widget.chatName])
    }, merge: true);

    if (!Provider.of<UserModel>(context, listen: false)
        .chatsWith
        .contains(widget.chatName)) {
      List<String> chatsWith = [];
      for (var i in Provider.of<UserModel>(context, listen: false).chatsWith) {
        chatsWith.add(i);
      }
      chatsWith.add(widget.chatName);
      Provider.of<UserModel>(context, listen: false).chatsWith = chatsWith;
    }
    Firestore.instance
        .collection("users")
        .document(widget.documentId)
        .collection("messages")
        .document()
        .setData({
      "receiver": widget.chatName,
      "text": messageController.text,
      "time": DateTime.now().millisecondsSinceEpoch,
      "sender": widget.documentId,
    }, merge: true);

    messageController.text = "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(widget.documentId)
          .collection("messages")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView(
                children: getMessages(snapshot.data),
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
                onPressed: () {
                  widget.check
                      ? Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ChatMain()))
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CenterPage(widget.data, widget.chatId, 0)));
                },
                child: Icon(Icons.arrow_back)),
            Text(widget.chatName),
            SizedBox(
              width: 50,
            )
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 10),
              child: ChatMessageList(),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: TextField(
                              onTap: () {
                                // Timer(
                                //     Duration(milliseconds: 100),
                                //     () => _scrollController.jumpTo(
                                //         _scrollController
                                //             .position.maxScrollExtent));
                              },
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: "Message...",
                                  border: InputBorder.none),
                              onSubmitted: (value) {
                                sendMessage(widget.documentId, widget.chatId,
                                    widget.myName, messageController);
                              },
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                sendMessage(widget.documentId, widget.chatId,
                                    widget.myName, messageController);
                              },
                              child: IconButton(
                                  icon: Icon(Icons.send,
                                      color: messageController.text.isNotEmpty
                                          ? Colors.blue
                                          : Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getMessages(QuerySnapshot data) {
    List<Widget> widgets = [];
    List<DocumentSnapshot> docs = data.documents;
    docs.sort((a, b) {
      int aTime = a.data["time"];
      int bTime = b.data["time"];
      return aTime.compareTo(bTime);
    });
    for (var i in docs) {
      if (i.data["receiver"].toString() != widget.chatName &&
          i.data["sender"].toString() != widget.chatName) continue;
      widgets.add(MessageTile(
        message: i.data["text"].toString(),
        isSendByMe: i.data["receiver"].toString() == widget.chatName,
      ));
    }

    return widgets;
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({this.message, this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isSendByMe
              ? CircleAvatar(
                  backgroundImage: AssetImage("assets/images/planetfit.jpeg"),
                )
              : Container(),
          Container(
            padding: EdgeInsets.only(
                left: isSendByMe ? 0 : 10, right: isSendByMe ? 10 : 0),
            margin: EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width / 2,
            alignment:
                isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: isSendByMe
                          ? [Colors.blue[500], Colors.blue[700]]
                          : [Colors.grey[500], Colors.grey[700]]),
                  borderRadius: isSendByMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30))
                      : BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
          isSendByMe
              ? CircleAvatar(
                  backgroundImage: AssetImage("assets/images/background.jpg"),
                )
              : Container(),
        ],
      ),
    );
  }
}
