import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thumbnails/thumbnails.dart';
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
    return WillPopScope(
        child:  Scaffold(
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
                        aspectRatio: _galleryVideoPlayerController!=null? _galleryVideoPlayerController.value.aspectRatio: 0.5,
                        child: _galleryVideoPlayerController != null ? VideoPlayer(_galleryVideoPlayerController): Container(),
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
                                  child: _galleryVideoPlayerController != null ? Column(
                                    children: <Widget>[
                                      Icon(deleteIcon,color: Colors.black,size: 50)

                                    ],
                                  ) : Container(),
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
                            child:_galleryVideoPlayerController != null ? Column(
                              children: <Widget>[
                                Icon(checkIcon,color: Colors.black,size: 50)
                              ],
                            ): Container(),
                          ))
                      ,
                    )

                  ],
                ),
              ])),
        ), onWillPop : () async{
          return true;
    });


  }

  void _pickVideoFromGallery() async {
    if( _galleryVideoPlayerController != null && _galleryVideoPlayerController.value.isPlaying)
        _galleryVideoPlayerController.pause();
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if(pickedFile != null){
      _galleryVideo = File(pickedFile.path);
      _galleryVideoPlayerController = VideoPlayerController.file(_galleryVideo)
        ..initialize().then((_) {
          setState(() {});
          _galleryVideoPlayerController.play();
        });
    }else{
      Navigator.pop(context);
    }
  }

  Future<void> uploadVideoToFirebaseAndGoBack(File galleryVideo) async {
    if( _galleryVideoPlayerController != null && _galleryVideoPlayerController.value.isPlaying)
      _galleryVideoPlayerController.pause();
    Future<File> result = testCompressAndGetFile(galleryVideo);
    String thumbnail = await Thumbnails.getThumbnail(
        //thumbnailFolder:'[FOLDER PATH TO STORE THUMBNAILS]', // creates the specified path if it doesnt exist
        videoFile: galleryVideo.path,
        imageType: ThumbFormat.PNG,

        quality: 30);

    result.then((videoFile) async  {
      //TODO use user name in filename combination
      String name = getRandomString(7);
        StorageUploadTask videoUploadTask = await _firebaseStorage.ref().child('videos/' +  name + '.mp4')
        .putFile(videoFile);
         Future videoDownloadUrlFuture = (await videoUploadTask.onComplete).ref.getDownloadURL();

        StorageUploadTask thumbnailUploadTask = await _firebaseStorage.ref().child('thumbnails/' + name + '.png')
             .putFile(File.fromUri(Uri.file(thumbnail)));

         videoDownloadUrlFuture.then((videoDownloadUrl) =>
             {
               uploadVideoAndThumbnail(user,videoDownloadUrl,thumbnailUploadTask)
             }
         );

    });

    Navigator.of(context).push(
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

  uploadVideoAndThumbnail(User user, videoDownloadUrl, StorageUploadTask thumbnailUploadTask) async {

    Future thumbnailUrlFuture = (await thumbnailUploadTask.onComplete).ref.getDownloadURL();
    thumbnailUrlFuture.then((thumbnailUrl)  {
      Future videoIdFuture = DatabaseService().createVideoResource(user,videoDownloadUrl,thumbnailUrl);
      videoIdFuture.then((videoId) {
        DatabaseService().updateUserVideos(user.email, videoId);
      });
    });
  }
}
