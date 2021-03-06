import 'package:flutter/services.dart';
import 'package:tiktok_flutter/data/videos_firebase.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class FeedViewModel extends BaseViewModel {
  VideoPlayerController controller;
  VideosAPI videoSource;
  List videos;
  int prevVideo = 0;

  int actualScreen = 0;

  FeedViewModel(videosList){
    this.videos = videosList;
    init();
  }

  // FeedViewModel() {
  //   videoSource = VideosAPI();
  // }

  init(){
    videoSource = VideosAPI();
    videoSource.setVideosList(this.videos);
  }

  changeVideo(index) async {

    //videoSource.listVideos[prevVideo].controller.pause();
    if (videoSource.listVideos[prevVideo].controller != null) {
      videoSource.listVideos[prevVideo].controller.pause();
      videoSource.listVideos[prevVideo].controller.removeListener(() {});
    }
    if (videoSource.listVideos[index].controller == null) {
      await videoSource.listVideos[index].loadController();
    }
    videoSource.listVideos[index].controller.play();
    //videoSource.listVideos[prevVideo].controller.removeListener(() {});

    //videoSource.listVideos[prevVideo].controller.dispose();

    prevVideo = index;
    notifyListeners();

    print(index);
  }

  void loadVideo(int index) async {

    if(index >= videoSource.listVideos.length){
      await videoSource.getVideoList();
    }
    if(index < videoSource.listVideos.length){
      await videoSource.listVideos[index].loadController();
      videoSource.listVideos[index].controller.play();
      notifyListeners();
    }

  }

  void setActualScreen(index) {
    actualScreen = index;
    if (index == 0) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    notifyListeners();
  }
}
