import 'package:firebase_auth/firebase_auth.dart';

class User{
  final String name;
  final String userName;
  final String email;
  final String profilePic;
  //final List liveUrls;
  final List pics;
  final List videos;
  final int numFollowers;
  final List followers;
  final int numFollowing;
  final List following;
  final int likes;

  User(this.name,this.userName, this.email, this.profilePic, this.pics, this.videos, this.numFollowers, this.followers, this.numFollowing,
  this.following, this.likes
      );

  static convert(User user){
    return User(user.name, null, user.email, null, [], [], 0, [], 0, [],0);
  }

  static User convertFromSnapshot(var snapshot){
    return User(snapshot['name'], snapshot['userName'], snapshot['email'], snapshot['profilePic'], [], [], 0, [], 0 , [],0);
  }

}



