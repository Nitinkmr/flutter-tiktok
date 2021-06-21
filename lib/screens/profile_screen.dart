import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/models/User.dart' as MyUser;
import 'package:tiktok_flutter/screens/sign_in_screen.dart';
import 'package:tiktok_flutter/services/database_service.dart';
import 'package:tiktok_flutter/widgets/bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  MyUser.User myUser;

  ProfileScreen({Key key, this.myUser}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(myUser);
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyUser.User myUser;

  _ProfileScreenState(MyUser.User myUser) {
    this.myUser = myUser;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: displayProfile(),
        ),
        onWillPop: () async {
          return true;
        });
  }

  displayProfile() {
    return SafeArea(
        child: Container(
            color: Colors.black,
            child: Column(children: [
              //myUser != null ? showProfile(myUser) :
              Expanded(child: setUserAndShowProfile()),
              BottomBar(),
            ])));
  }

  setUserAndShowProfile() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder(
          future: DatabaseService()
              .getUserData(FirebaseAuth.instance.currentUser.email),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data.docs.length > 0) {
                print(snapshot.data.docs[0].data());
                myUser = MyUser.User.convertFromSnapshot(
                    snapshot.data.docs[0].data());
                //   Authentication.signOut(context: context);
                return showProfile(myUser);
              }
            }
            return CircularProgressIndicator();
          });
    } else
      return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
  }

  showProfile(MyUser.User myUser) {
    return FutureBuilder(
        future: DatabaseService().getUserVideos(myUser.userName),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error initializing Firebase');
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              List videos = snapshot.data.docs; //[0].data();
              return SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //TODO version 2
                            //Icon(Icons.person_add_alt_1_outlined),
                            Text(
                              myUser.name,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            //TODO version 2
                            //Icon(Icons.more_horiz)
                          ],
                        ),
                      ),

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: myUser.profilePic,
                                    height: 100.0,
                                    width: 100.0,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              myUser.userName,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*

                      TODO VERSION 2

                    Column(
                      children: [

                        Text(
                          myUser.numFollowing.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Following",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black54,
                      width: 1,
                      height: 15,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    Column(
                      children: [
                        Text(
                          myUser.numFollowers.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.black54,
                      width: 1,
                      height: 15,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    Column(
                      children: [
                        Text(
                          myUser.likes.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Likes",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),

                     */
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            /*
                TODO VERSION 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 47,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Center(
                        child: Text(
                          "Edit profile",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 45,
                      height: 47,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Center(child: Icon(Icons.bookmark)),
                    )
                  ],
                ),*/
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.menu),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        color: Colors.black,
                                        height: 2,
                                        width: 55,
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //TODO version 2
                                      // Icon(
                                      //   Icons.favorite_border,
                                      //   color: Colors.black26,
                                      // ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        color: Colors.transparent,
                                        height: 2,
                                        width: 55,
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //TODO version 2
                                      // Icon(
                                      //   Icons.lock_outline,
                                      //   color: Colors.black26,
                                      // ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        color: Colors.transparent,
                                        height: 2,
                                        width: 55,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: List.generate(videos.length, (index) {
                                return Stack(children: <Widget>[
                                  Container(
                                    height: 160,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        border: Border.all(
                                            color: Colors.white70, width: .5)),
                                    child: FittedBox(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            //"https://media.giphy.com/media/Ii4Cv63yG9iYawDtKC/giphy.gif",
                                            videos[index]
                                                .data()["thumbnailUrl"],
                                        placeholder: (context, url) => Padding(
                                          padding: const EdgeInsets.all(35.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                          child: Icon(const
                                            IconData(0xedb4,
                                                fontFamily: 'MaterialIcons'),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 25),
                                          child: Text(
                                            videos[index]
                                                .data()["views"]
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ]);
                              }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      // Container(
                      //   color: Colors.black,
                      //   //alignment: FractionalOffset.bottomCenter,
                      //   padding: const EdgeInsets.only(bottom: 16.0),
                      //   child: BottomBar(),
                      // ),
                    ],
                  ),
                ),
              );
            }
          }
          return Container(
            height: 0,
            width: 0,
          );
        });
  }
}
