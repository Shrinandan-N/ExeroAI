import 'package:CAC2020/screens/auth/signup.dart';
import 'package:flutter/material.dart';

import 'local_widgets/largeButton.dart';
import 'login.dart';

class AuthHome extends StatefulWidget {
  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.green.withOpacity(0.3), BlendMode.dstATop)),
          ),
        ),
        Container(
          color: Color.fromRGBO(10, 170, 10, 0.19),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "exeroAI",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/signUp");
                      },
                      child: LargeButton("Sign Up", Colors.green[700],
                          Colors.white, false, context),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: LargeButton("Log In", Colors.transparent,
                          Colors.white, true, context),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}
