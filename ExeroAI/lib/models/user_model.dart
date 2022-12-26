import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _username;
  String _firstName;
  String _lastName;
  String _uid;
  List<CameraDescription> _cameras;
  int _followers;
  int _following;
  int _videos;
  List<dynamic> _centers;
  List<double> _scores = [];
  List<dynamic> _chatsWith = [];

  String get username => _username;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get uid => _uid;
  List<CameraDescription> get cameras => _cameras;
  int get followers => _followers;
  int get following => _following;
  int get videos => _videos;
  List<dynamic> get centers => _centers;
  List<dynamic> get scores => _scores;
  List<dynamic> get chatsWith => _chatsWith;
  set uid(String val) {
    _uid = val;
  }

  set username(String val) {
    _username = val;
  }

  set firstName(String val) {
    _firstName = val;
  }

  set lastName(String val) {
    _lastName = val;
  }

  set cameras(List<CameraDescription> val) {
    _cameras = val;
  }

  set followers(int val) {
    _followers = val;
  }

  set following(int val) {
    _following = val;
  }

  set videos(int val) {
    _videos = val;
  }

  set centers(List<dynamic> val) {
    _centers = val;
  }

  set scores(List<dynamic> val) {
    _scores = val;
  }

  set chatsWith(List<dynamic> val) {
    _chatsWith = val;
  }
}
