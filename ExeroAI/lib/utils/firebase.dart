import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:CAC2020/models/user_model.dart';
import 'package:CAC2020/screens/auth/auth.dart';
import 'package:CAC2020/screens/home/home.dart';
import 'package:camera/camera.dart' as cam;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage =
    FirebaseStorage(storageBucket: 'gs://cac2020-dc3a0.appspot.com');
final GoogleSignIn googleSignIn = GoogleSignIn();
final Firestore firestore = Firestore.instance;
StreamBuilder autoLogin(
    BuildContext context, List<cam.CameraDescription> cameras) {
  Provider.of<UserModel>(context, listen: false).cameras = cameras;
  //signOut();
  print("hello");
  // signOut();
  return StreamBuilder(
    stream: _auth.onAuthStateChanged,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        FirebaseUser user = snapshot.data;
        print(user);
        if (user == null) {
          return AuthHome(); // user does not exist
        } else {
          // return Home(); // user exists and is logged in.
          print("yo wassup");
          return FutureBuilder<DocumentSnapshot>(
            future: firestore
                .collection("users")
                .document(user.uid.toString())
                .get(),
            builder: (context, data) {
              if (data.hasData) {
                var value = data.data;
                UserModel user = Provider.of<UserModel>(context, listen: false);
                user.username = value.data["email"];
                user.firstName = value.data["firstName"];
                user.lastName = value.data["lastName"];
                user.followers = value.data["followers"];
                user.following = value.data["following"];
                user.videos = value.data["videos"];
                user.uid = value.documentID;
                user.centers = value.data["centers"];
                user.chatsWith = value.data["chatsWith"];

                return Dashboard();
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
      } else {
        FirebaseUser user = snapshot.data;
        print(user);
        if (user == null) {
          return AuthHome(); // user does not exist
        } else {
          return AuthHome(); // user exists and is not logged in.
        }
      }
    },
  );
}

Future<FirebaseUser> signInWithEmail(
    BuildContext context, String email, String password) {
  FirebaseUser fbUser;
  try {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      fbUser = value.user;
      var data = firestore
          .collection("users")
          .document(value.user.uid.toString())
          .get()
          .then((value) {
        UserModel user = Provider.of<UserModel>(context, listen: false);
        user.username = email;
        user.firstName = value.data["firstName"];
        user.lastName = value.data["lastName"];
        user.followers = value.data["followers"];
        user.following = value.data["following"];
        user.videos = value.data["videos"];
        user.uid = value.documentID;
        user.centers = value.data["centers"];
        user.chatsWith = value.data["chatsWith"];
      });

      return fbUser;
    }).catchError((onError) {
      // dialog(context, onError.message, false);
      print(onError);
    });
  } catch (e) {
    print("hello " + e.toString());
  }
}

Future<FirebaseUser> signUpWithEmailAndPassword(String email, String password,
    String firstName, String lastName, BuildContext context) {
  try {
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      UserModel user = Provider.of<UserModel>(context, listen: false);
      user.username = email;
      user.firstName = firstName;
      user.lastName = lastName;
      user.followers = 0;
      user.following = 0;
      user.videos = 0;
      user.uid = value.user.uid;
      user.centers = [];
      firestore
          .collection("users")
          .document(value.user.uid.toString())
          .setData({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "followers": 0,
        "following": 0,
        "videos": 0,
        "centers": [],
        "chatsWith": [],
      });
      return value.user;
    }).catchError((error) {
      print(email);
      print(error.toString());
      print("sad face");
      // dialog(context, error.message, true);
    });
  } catch (e) {
    print("hello" + e.toString());
  }
}

void signOut() async {
  try {
    await googleSignIn.signOut();
  } catch (e) {
    print("Google: " + e.toString());
  }
  try {
    await _auth.signOut();
  } catch (e) {
    print(e);
  }

  print("User Sign Out");
}

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return user;
}

Future<Map<String, dynamic>> readJsonFromStorage(String filename) async {
  final StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  final String url = await ref.getDownloadURL();
  final http.Response data = await http.get(url);
  Map<String, dynamic> output = jsonDecode(data.body);
  return output;
}

Future<void> uploadJsonToStorage(
    Map<String, dynamic> json, String filename) async {
  String jsonString = json.toString();
  final StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  ref.putData(Uint8List.fromList(jsonString.codeUnits));
}

// upload video
// https://html.developreference.com/article/11537918/Flutter-+Firebase+Storage+upload+video
