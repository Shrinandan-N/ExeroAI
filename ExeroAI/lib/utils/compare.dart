import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:ml_linalg/linalg.dart';

class Compare {
  static List<double> preprocessPoseNet(Map posenetData) {
    List<double> xy = [];

    if (posenetData.containsKey("keypoints")) {
      var keypoints = posenetData["keypoints"];
      for (var i = 0; i < 17; i++) {
        if (keypoints[i] != null) {
          xy.add(keypoints[i]["x"]);
          xy.add(keypoints[i]["y"]);
        } else {
          xy.add(1.0);
          xy.add(1.0);
        }
      }
    }
    return xy;
  }

  static double comparePoseNet(List<dynamic> posenet1, List<dynamic> posenet2) {
    double score = 0;

    void printWrapped(String text) {
      final pattern = RegExp('.{1,1600}'); // 800 is the size of each chunk
      pattern.allMatches(text).forEach((match) => print(match.group(0)));
    }

    printWrapped(posenet2.toString());

    if (posenet1.length != 0 && posenet2.length != 0) {
      List<double> posenet1_xy = preprocessPoseNet(posenet1[0]);
      List<double> posenet2_xy = preprocessPoseNet(posenet2[0]);

      if (posenet1_xy.length != 0 &&
          posenet2_xy.length != 0 &&
          posenet1_xy.length == posenet2_xy.length) {
        final vector1 = Vector.fromList(posenet1_xy);
        final vector2 = Vector.fromList(posenet2_xy);
        score = vector1.distanceTo(vector2, distance: Distance.cosine);
      }
    }
    print("score ${score}");

    return score;
  }
}
