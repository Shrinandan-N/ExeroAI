import 'dart:async';
import 'package:CAC2020/utils/firebase.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'models/user_model.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
      ],
      child: MyApp(cameras),
    ),
  );
}

class MyApp extends StatelessWidget {
  List<CameraDescription> cameras;
  MyApp(this.cameras);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/signUp": (context) => SignUp()},
      title: 'tflite real-time detection',
      debugShowCheckedModeBanner: false,
      // home: HomePage(cameras),
      home: autoLogin(context, cameras),
    );
  }
}
