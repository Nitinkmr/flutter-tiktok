import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<Gallery> {
  File _cameraImage;
  File _galleryVideo;

  ImagePicker picker = null;
  VideoPlayerController _galleryVideoPlayerController;

  @override
  void initState() {
    super.initState();
    if (this.picker == null) this.picker = new ImagePicker();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _pickVideoFromGallery());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Container(
              color: Colors.white,
              height: 100,
            ))
          ],
        ),

            Expanded(
              child: Container(
                  child: AspectRatio(
                aspectRatio: _galleryVideoPlayerController.value.aspectRatio,
                child: VideoPlayer(_galleryVideoPlayerController),
              )),
            ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Container(
              color: Colors.white,
              height: 100,
            ))
          ],
        ),
      ])),
    );
  }

  void _pickVideoFromGallery() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);

    _galleryVideo = File(pickedFile.path);
    _galleryVideoPlayerController = VideoPlayerController.file(_galleryVideo)
      ..initialize().then((_) {
        setState(() {});
        _galleryVideoPlayerController.play();
      });
  }
}
