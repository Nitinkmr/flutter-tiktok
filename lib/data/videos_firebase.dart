import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok_flutter/data/demo_data.dart';
import 'package:tiktok_flutter/data/video.dart';

class VideosAPI {
  List<Video> listVideos = List<Video>();

  // VideosAPI() {
  //   load();
  // }

  Future<void> load()  async {
    listVideos =  await getVideoList();
  }

  setVideosList(List videos  ){
      this.listVideos = videos;
  }
  Future<List<Video>> getVideoList()  async {
    var data =  await FirebaseFirestore.instance.collection("videos").get();

    var videoList = <Video>[];
    var videos;

    if (data.docs.length == 0) {
      await addDemoData();
      videos = (await FirebaseFirestore.instance.collection("videos").get());
    } else {
      videos = data;
    }

    videos.docs.forEach((element) {
      Video video = Video.fromJson(element.data());
      videoList.add(video);
    });

    return videoList;
  }

  Future<Null> addDemoData() async {
    for (var video in data) {
      await FirebaseFirestore.instance.collection("videos").add(video);
    }
  }
}
