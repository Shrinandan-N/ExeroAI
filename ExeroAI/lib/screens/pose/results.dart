//Results class

import 'package:CAC2020/models/user_model.dart';
import 'package:CAC2020/screens/home/home.dart';
import 'package:CAC2020/screens/pose/pose.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:confetti/confetti.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  ConfettiController _controller;

  String getText(List<double> scores) {
    if (scores.length == 0) {
      return "0%";
    }
    double total = 0;
    for (double score in scores) {
      total += score;
    }

    double avg = total / scores.length;
    print(avg);
    return (100 - (100 * avg)).toString();
  }

  @override
  void initState() {
    _controller = ConfettiController(duration: const Duration(seconds: 10));
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double score = double.parse(double.parse(getText(
      Provider.of<UserModel>(context, listen: false).scores,
    )).toStringAsFixed(2));
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.blue],
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                customWidths:
                                    CustomSliderWidths(progressBarWidth: 10),
                              ),
                              min: 0,
                              max: 100,
                              initialValue:
                                  score < 0 ? 0 : score > 100 ? 100 : score,
                              innerWidget: (x) {
                                String score = getText(
                                  Provider.of<UserModel>(context, listen: false)
                                      .scores,
                                );
                                return Center(
                                  child: Text(
                                    score.substring(0, score.indexOf(".") + 3),
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Center(
                              child: Text(
                                "New High Score!",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 215, 0, 1),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset("assets/images/win.png"),
                Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 75,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.redo),
                            title: Text("Try Again?"),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.blue],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: ListTile(
                              leading: Icon(Icons.ac_unit),
                              title: Text("Save"),
                            ),
                          ),
                        ),
                        onTap: () {
                          BuildContext oldCont = context;
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text('Save!'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text('Public'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(),
                                      ),
                                    );
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('Private'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
            ),
          ),
        ],
      ),
    );
  }
}
