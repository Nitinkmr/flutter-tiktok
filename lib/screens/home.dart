
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/data/videos_firebase.dart';
import 'package:tiktok_flutter/res/custom_colors.dart';

import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState ();

}

class HomeScreenState extends State<HomeScreen> {

  var videosLoaded = false;

  @override
  Widget build(BuildContext context) {

   return FutureBuilder(
     future: VideosAPI().getVideoList(),
     builder: (context, snapshot) {
       if (snapshot.hasError) {
         return Text('Error initializing Firebase');
       } else if (snapshot.hasData) {
         print("GOT DATA  ................");
         Navigator.of(context).push(
           MaterialPageRoute(
             builder: (context) => FeedScreen(videosList:snapshot.data),
           ),
         );
       }
       return CircularProgressIndicator(
         valueColor: AlwaysStoppedAnimation<Color>(
           CustomColors.firebaseOrange,
         ),
       );
     },
   );




     CircularProgressIndicator(
     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
   );
  }

  @override
  Future<void> initState()  {
    super.initState();
  }
}