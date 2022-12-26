//Info class

import 'package:CAC2020/screens/pose/pose.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              "Get Ready to Exercise! \n Make sure to stand 10 feet away",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            Image.asset("assets/images/fit1.png"),
            Image.asset("assets/images/fit2.png"),
            Expanded(
              child: TimeCircularCountdown(
                repeat: false,
                countdownCurrentColor: Colors.green,
                countdownRemainingColor: Colors.blue,
                countdownTotalColor: Colors.grey,
                unit: CountdownUnit.second,
                countdownTotal: 8,
                onUpdated: (unit, remainingTime) => print('Updated'),
                onFinished: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pose(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
