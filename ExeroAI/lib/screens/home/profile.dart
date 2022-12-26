import 'package:CAC2020/models/user_model.dart';
import 'package:CAC2020/utils/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  Color myGreen = Color.fromRGBO(24, 165, 123, 1);

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 8.0, left: 8.0, top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            child: Icon(Icons.menu),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green),
                              ),
                            ),
                          ),
                          FlatButton(
                            child: Icon(Icons.settings, color: Colors.white12),
                            onPressed: () {
                              // signOut();
                              // Navigator.popUntil(
                              //     context, ModalRoute.withName("/signUp"));
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Transform.translate(
                                //   offset: Offset(30.0, 0.0),
                                //   child: Container(
                                //     width: 79.0,
                                //     height: 79.0,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       image: DecorationImage(
                                //           image: AssetImage(
                                //               'assets/images/background.jpg')),
                                //       color: const Color(0xffffffff),
                                //       border: Border.all(
                                //           width: 2.0, color: Colors.white),
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/background.jpg')),
                                    color: const Color(0xffffffff),
                                    border: Border.all(
                                        width: 2.0, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        Provider.of<UserModel>(context)
                                                .firstName +
                                            " " +
                                            Provider.of<UserModel>(context)
                                                .lastName,
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "16 year old student taking PE Classes",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, top: 15),
                                      child: Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                    ) //     BoxShadow(
                    //     //       color: Colors.blue,
                    //     //       spreadRadius: 100,
                    //     //       blurRadius: 0,
                    //     //       offset:
                    //     //           Offset(-2, 2), // changes position of shadow
                    //     //     ),
                    //     //   ],
                    //     // ),
                    //     child: Center(
                    //         child: Padding(
                    //       padding:
                    //           const EdgeInsets.only(right: 30.0, left: 30),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Container(
                    //               width: double.infinity,
                    //               height: 150,
                    //               color: Colors.green),
                    //         ],
                    //       ),
                    //     )),
                    //     //color: Colors.white,
                    //     // width: MediaQuery.of(context).size.width / 2,
                    //     // height: MediaQuery.of(context).size.width / 8 * 1.8,
                    //   )),
                    // ),
                  ],
                ),
                Expanded(child: bottomCard(context))
              ],
            )),
      ),
    );
  }

  Widget bottomCard(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0.0, 35.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8 * 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  //color: Color.fromRGBO(240, 240, 240, 1),
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Posts",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: getVideos(context),
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget post(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
    for (var i = 0; i < Provider.of<UserModel>(context).videos; i++) {
      videos.add(post(context));
    }
    return videos;
  }
}
