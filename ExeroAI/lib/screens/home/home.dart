//dashboard class
import 'package:CAC2020/screens/pose/info.dart';
import 'package:CAC2020/explore.dart';
import 'package:CAC2020/models/user_model.dart';
import 'package:CAC2020/screens/pose/pose.dart';
import 'package:CAC2020/screens/home/profile.dart';
import 'package:CAC2020/utils/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat.dart';
import 'center.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String> images = [
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "mainThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
    "firstThumbnail.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25);
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Community",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white12,
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Provider.of<UserModel>(context).centers == null ||
                            Provider.of<UserModel>(context).centers.length == 0
                        ? Column(
                            children: [
                              Text(
                                "You are not following any centers",
                                style: headerStyle,
                              ),
                              Text(
                                "Recommended Centers near you ",
                                style: headerStyle,
                              ),
                            ],
                          )
                        : Container(),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 3 / 4,
                      child: getAllCenters(
                          Provider.of<UserModel>(context).centers),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAllCenters(List<dynamic> centers) {
    TextStyle headerStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('centers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              if (centers == null || centers.length == 0) {
                return CenterHomeTile(
                    data: snapshot.data.documents[index].data,
                    id: snapshot.data.documents[index].documentID);
                // return Container();
              } else if (centers
                  .contains(snapshot.data.documents[index].documentID)) {
                print(images[index]);
                return CenterHomeTile(
                  data: snapshot.data.documents[index].data,
                  id: snapshot.data.documents[index].documentID,
                  imageName: images[index],
                );
              } else
                return Container();
            },
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }
}

//drawer

//Center or GYM Home widget tile

class CenterHomeTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  final String imageName;
  CenterHomeTile({this.data, this.id, this.imageName});

  @override
  _CenterHomeTileState createState() => _CenterHomeTileState();
}

class _CenterHomeTileState extends State<CenterHomeTile> {
  @override
  Widget build(BuildContext context) {
    TextStyle _tileHeader = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Container(
          // width: double.infinity,
          // height: MediaQuery.of(context).size.height * 2 / 2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) =>
                                CenterPage(widget.data, widget.id, 0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data["centerName"],
                          style: _tileHeader,
                        ),
                        Text(
                          widget.data["city"],
                          style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Latest Lesson",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                            width: double.infinity,
                            child: VideoTile(
                                "assets/images/" + widget.imageName, context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget optionButton(String title, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width / 4,
    height: 30,
    decoration: BoxDecoration(
        color: Colors.green[600], borderRadius: BorderRadius.circular(5)),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

//large button widget
Widget VideoTile(String imageThumbnail, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: AssetImage(imageThumbnail),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_arrow,
                size: 75,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              optionButton("Watch", context),
              GestureDetector(
                child: optionButton("Record", context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Info(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  Provider.of<UserModel>(context).firstName +
                      " " +
                      Provider.of<UserModel>(context).lastName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  Provider.of<UserModel>(context).username.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Dashboard()));
          },
          leading: Icon(Icons.home),
          title: Text("Home"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Profile()));
          },
          leading: Icon(Icons.person),
          title: Text("Profile"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Explore()));
          },
          leading: Icon(
            Icons.explore,
          ),
          title: Text("Explore"),
        ),
        // ListTile(
        //   onTap: () {},
        //   leading: Icon(
        //     Icons.local_activity,
        //   ),
        //   title: Text("Activity"),
        // ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChatMain()));
          },
          leading: Icon(
            Icons.ac_unit,
          ),
          title: Text("Messages"),
        ),
        ListTile(
          onTap: () {
            signOut();
            Navigator.popUntil(context, ModalRoute.withName("/signUp"));
          },
          leading: Icon(
            Icons.exit_to_app,
          ),
          title: Text("Sign Out"),
        )
      ],
    );
  }
}
