import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_flutter/models/User.dart' as MyUser;
import 'package:tiktok_flutter/services/database_service.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import 'feed_screen.dart';

class Gallery extends StatefulWidget {
  User user;

  Gallery({Key key, this.user}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState(this.user);
}

class _GalleryScreenState extends State<Gallery> {
  User user;
  File _cameraImage;
  File _galleryVideo;
  final _firebaseStorage = FirebaseStorage.instance;

  _GalleryScreenState(User user){
    this.user = user;
  }

  static const IconData checkIcon = IconData(0xe156, fontFamily: 'MaterialIcons');
  static const IconData deleteIcon = IconData(0xe8b6, fontFamily: 'MaterialIcons');


  ImagePicker picker = null;
  VideoPlayerController _galleryVideoPlayerController;

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
              child: (
                InkWell(
                    onTap:(){ _pickVideoFromGallery() ;},
                    child: Container(
                      color: Colors.white,
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          Icon(deleteIcon,color: Colors.black,size: 50)

                        ],
                      ),
                    ))
              )
            ),
            Expanded(
              child:
                InkWell(
                    onTap:(){ uploadVideoToFirebaseAndGoBack(_galleryVideo) ;},
                    child: Container(
                      color: Colors.white,
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          Icon(checkIcon,color: Colors.black,size: 50)
                        ],
                      ),
                    ))
              ,
            )

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

  Future<void> uploadVideoToFirebaseAndGoBack(File galleryVideo) async {
    Future<File> result = testCompressAndGetFile(galleryVideo);

    StorageUploadTask snapshot;
    result.then((value) async  {
      //TODO use user name in filename combination
         snapshot = await _firebaseStorage.ref().child('videos/' + getRandomString(7) + '.mp4')
        .putFile(value);
         Future downloadUrl = (await snapshot.onComplete).ref.getDownloadURL();
         downloadUrl.then((value) =>
             DatabaseService().updateUserVideoLinks(user.email,value));

    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FeedScreen(),
      ),
    );
  }

 Future<File> testCompressAndGetFile(File file) async {

    MediaInfo mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo.file;
  }
}
