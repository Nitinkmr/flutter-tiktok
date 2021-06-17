
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok_flutter/data/videos_firebase.dart';
import 'package:tiktok_flutter/res/custom_colors.dart';

import 'feed_screen.dart';
import 'feed_viewmodel.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState ();

}

class HomeScreenState extends State<HomeScreen> {

  var feedViewModel = null;
  var videosList;
  final locator = GetIt.instance;


  @override
  Widget build(BuildContext context) {

   return FutureBuilder(
     future: VideosAPI().getVideoList(),
     builder: (context, snapshot) {
       if (snapshot.hasError) {
         return Text('Error initializing Firebase');
       } else if (snapshot.hasData) {
         print("GOT DATA  ................");
         SchedulerBinding.instance.addPostFrameCallback((_) {
           // for(int i=0;i<3;i++){
           //   snapshot.data[i]
           // }
           this.feedViewModel = FeedViewModel(snapshot.data);
           locator.registerSingleton<FeedViewModel>( this.feedViewModel);
           Navigator.of(context).push(
             MaterialPageRoute(
               builder: (context) => FeedScreen(),
             ),
           );

         });

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