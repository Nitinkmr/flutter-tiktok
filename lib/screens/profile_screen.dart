import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/models/User.dart' as MyUser;
import 'package:tiktok_flutter/screens/sign_in_screen.dart';
import 'package:tiktok_flutter/services/database_service.dart';
import 'package:tiktok_flutter/utils/authentication.dart';

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
    return Container(
      child:
      displayProfile()
    );
  }
  displayProfile() {
    return SafeArea(
        child: Container(
            color: Colors.white,
            child: Column(children: [
              myUser != null ? showProfile(myUser) : setUserAndShowProfile()
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
              if (snapshot.hasData) {
                print(snapshot.data.docs[0].data());
                myUser = MyUser.User.convertFromSnapshot(snapshot.data.docs[0].data());
              //   Authentication.signOut(context: context);
                return showProfile(myUser);
              }
            }
            return   CircularProgressIndicator();
          });
    }else
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => SignInScreen()
        ),
      );
  }



showProfile(MyUser.User myUser) {
  return SafeArea(
    child: Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12))),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.person_add_alt_1_outlined),
                Text(
                  myUser.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.more_horiz)
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
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
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          Icon(
                            Icons.favorite_border,
                            color: Colors.black26,
                          ),
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
                          Icon(
                            Icons.lock_outline,
                            color: Colors.black26,
                          ),
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border:
                            Border.all(color: Colors.white70, width: .5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                            "https://media.giphy.com/media/Ii4Cv63yG9iYawDtKC/giphy.gif",
                            placeholder: (context, url) =>
                                Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border:
                            Border.all(color: Colors.white70, width: .5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                            "https://media.giphy.com/media/tqfS3mgQU28ko/giphy.gif",
                            placeholder: (context, url) =>
                                Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border:
                            Border.all(color: Colors.white70, width: .5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                            "https://media.giphy.com/media/3o72EX5QZ9N9d51dqo/giphy.gif",
                            placeholder: (context, url) =>
                                Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border:
                            Border.all(color: Colors.white70, width: .5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                            "https://media.giphy.com/media/4oMoIbIQrvCjm/giphy.gif",
                            placeholder: (context, url) =>
                                Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border:
                            Border.all(color: Colors.white70, width: .5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                            "https://media.giphy.com/media/aZmD30dCFaPXG/giphy.gif",
                            placeholder: (context, url) =>
                                Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            border:
                            Border.all(color: Colors.white70, width: .5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                            "https://media.giphy.com/media/NU8tcjnPaODTy/giphy.gif",
                            placeholder: (context, url) =>
                                Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
