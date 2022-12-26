//Pose class
import 'package:CAC2020/camera.dart';
import 'package:CAC2020/home.dart';
import 'package:CAC2020/models/user_model.dart';
import 'package:CAC2020/screens/pose/results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Pose extends StatefulWidget {
  @override
  _PoseState createState() => _PoseState();
}
/*Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              Provider.of<UserModel>(context, listen: false)
                                  .cameras,
                            ),
                          ),
                        ); */

class _PoseState extends State<Pose> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/images/jumpingjacks.mp4")
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Results(),
              ),
            );
          }
        });
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              HomePage(
                Provider.of<UserModel>(context, listen: false).cameras,
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.1,
                  color: Colors.blue,
                  child: _controller.value.initialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ),
              ),
              Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width / 2 - 50,
                right: MediaQuery.of(context).size.width / 2 - 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.check),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
