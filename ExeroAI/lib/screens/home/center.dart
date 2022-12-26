import 'package:CAC2020/chat_home.dart';
import 'package:CAC2020/models/user_model.dart';
import 'package:CAC2020/utils/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../explore.dart';
import 'home.dart';

class CenterPage extends StatefulWidget {
  @override
  Map<String, dynamic> data;
  String id;
  int check;

  CenterPage(this.data, this.id, this.check);
  State<StatefulWidget> createState() => _Center();
}

class _Center extends State<CenterPage> {
  Color myGreen = Color.fromRGBO(24, 165, 123, 1);
  bool togglePosts = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Stack(children: [
                  Container(
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      height: 225,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/planetfit.jpeg'),
                            fit: BoxFit.cover),
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, left: 8.0, top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                if (widget.check == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()));
                                } else if (widget.check == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Explore()));
                                }
                              },
                            ),
                            // Provider.of<UserModel>(context)
                            //         .centers
                            //         .contains(widget.id)
                            //     ? Container()
                            //     : FlatButton(
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.add),
                            //             Text("Add Center")
                            //           ],
                            //         ),
                            //         onPressed: () {
                            //           List<dynamic> centerids = [];
                            //           for (var i in Provider.of<UserModel>(
                            //                   context,
                            //                   listen: false)
                            //               .centers) {
                            //             centerids.add(i);
                            //           }
                            //           centerids.add(widget.id);
                            //           Provider.of<UserModel>(context,
                            //                   listen: false)
                            //               .centers = centerids;
                            //           Firestore.instance
                            //               .collection("users")
                            //               .document(Provider.of<UserModel>(
                            //                       context,
                            //                       listen: false)
                            //                   .uid)
                            //               .setData({"centers": centerids},
                            //                   merge: true);
                            //           Navigator.of(context).push(
                            //               MaterialPageRoute(
                            //                   builder: (context) => CenterPage(
                            //                       widget.data, widget.id)));
                            //         },
                            //       ),
                            // FlatButton(
                            //     child: Icon(Icons.chat),
                            //     onPressed: () => Navigator.of(context).push(
                            //           MaterialPageRoute(
                            //               builder: (context) => chatHome(
                            //                   chatName: widget.data["centerName"],
                            //                   chatId: widget.id,
                            //                   documentId: Provider.of<UserModel>(
                            //                           context,
                            //                           listen: false)
                            //                       .uid,
                            //                   myName: Provider.of<UserModel>(
                            //                           context,
                            //                           listen: false)
                            //                       .firstName)),
                            //         ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 140,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data["centerName"],
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.data["city"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "10",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Text(
                                  "Members",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "6",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Text("Instructors",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "4",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Text("Lessons", style: TextStyle(fontSize: 16))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (!Provider.of<UserModel>(context,
                                        listen: false)
                                    .centers
                                    .contains(widget.id)) {
                                  List<dynamic> centerids = [];
                                  for (var i in Provider.of<UserModel>(context,
                                          listen: false)
                                      .centers) {
                                    centerids.add(i);
                                  }
                                  centerids.add(widget.id);
                                  Provider.of<UserModel>(context, listen: false)
                                      .centers = centerids;
                                  Firestore.instance
                                      .collection("users")
                                      .document(Provider.of<UserModel>(context,
                                              listen: false)
                                          .uid)
                                      .setData({"centers": centerids},
                                          merge: true);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CenterPage(
                                          widget.data,
                                          widget.id,
                                          widget.check)));
                                }
                              },
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 3.5 / 8,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  Provider.of<UserModel>(context)
                                          .centers
                                          .contains(widget.id)
                                      ? "Following"
                                      : "Follow",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => chatHome(
                                          chatName: widget.data["centerName"],
                                          chatId: widget.id,
                                          documentId: Provider.of<UserModel>(
                                                  context,
                                                  listen: false)
                                              .uid,
                                          myName: Provider.of<UserModel>(
                                                  context,
                                                  listen: false)
                                              .firstName,
                                          check: false,
                                          data: widget.data)),
                                );
                              },
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 3.5 / 8,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  "Message",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
                Expanded(
                  child: bottomCard(context),
                )
              ],
            )),
      ),
    );
  }

  // Widget view() {
  //   return Expanded(
  //     child: Column(
  //       children: [
  //         ToggleSwitch(
  //           initialLabelIndex: 0,
  //           labels: ['Lessons', 'Info'],
  //           onToggle: (index) {
  //             togglePosts = !togglePosts;
  //           },
  //         ),
  //         togglePosts ? bottomCard(context) : ourInstructors(context)
  //       ],
  //     ),
  //   );
  // }

  Widget bottomCard(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0.0, 35.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7 * 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  //color: Color.fromRGBO(240, 240, 240, 1),
                  border: Border.all(width: 1.0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
              alignment: Alignment.topCenter,
              child: ToggleSwitch(
                minWidth: 120.0,
                minHeight: 30.0,
                fontSize: 16.0,
                initialLabelIndex: 0,
                activeBgColor: Colors.green,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey[400],
                inactiveFgColor: Colors.grey[900],
                labels: ['Lessons', 'Info'],
                onToggle: (index) {
                  setState(() {
                    togglePosts = !togglePosts;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            togglePosts ? postContainer(context) : ourInstructors(context)
          ],
        ),
      ),
    ]);
  }

  Widget postContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   "Lessons",
          //   style: TextStyle(
          //       color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
          // ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                post(context),
                post(context),
                post(context),
                post(context),
                // ListView(
                //   children: getVideos(context),
                // )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget ourInstructors(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Our Instructors",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    instructorCard("John Doe", "Cardio", "person1.png"),
                    instructorCard("Jane Doe", "Yoga", "person2.png"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    instructorCard("John Doe", "Cardio", "person3.png"),
                    instructorCard("Jane Doe", "Yoga", "person4.png"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    instructorCard("John Doe", "Cardio", "person5.png"),
                    instructorCard("Jane Doe", "Yoga", "person1.png"),
                  ],
                ),
                // ListView(
                //   children: getVideos(context),
                // )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget instructorCard(String name, String field, String imageLink) {
    return Container(
      width: 150,
      height: 150,
      child: Column(
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                  image: AssetImage('assets/images/' + imageLink),
                  fit: BoxFit.cover),
            ),
          ),
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(field)
        ],
      ),
    );
  }

  Widget post(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 350,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 75,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getVideos(BuildContext context) {
    List<Widget> videos = [];
    for (var i = 0; i < widget.data["numLessons"]; i++) {
      videos.add(VideoTile("assets/images/tileImage.jpg", context));
    }
    return videos;
  }
}
