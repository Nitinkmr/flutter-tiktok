import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/utils/tik_tok_icons_icons.dart';
import 'package:tiktok_flutter/widgets/circle_image_animation.dart';

class ActionsToolbar  extends StatefulWidget {
  String user;

  String comments ;

  String userPic;
  String likes;

  ActionsToolbar(String this.user, String this.likes, String this.comments, String this.userPic);


  @override
  ActionsToolbarState createState()  => ActionsToolbarState(user,likes,comments,userPic);
}

class ActionsToolbarState extends State<ActionsToolbar> {
  // Full dimensions of an action
  static const double ActionWidgetSize = 60.0;

// The size of the icon showen for Social Actions
  static const double ActionIconSize = 35.0;

// The size of the share social icon
  static const double ShareActionIconSize = 25.0;

// The size of the profile image in the follow Action
  static const double ProfileImageSize = 50.0;

// The size of the plus icon under the profile image in follow action
  static const double PlusIconSize = 20.0;

  bool clicked = false;

   String numLikes;
   String numComments;
   String userPic;
   String userName;

  ActionsToolbarState(String userName,this.numLikes, this.numComments, this.userPic){
      if(userName.length > 7)
        userName =  userName.substring(0,7) + "...";
      this.userName = userName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100.0,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          '@' + userName,
          style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        _getFollowAction(pictureUrl: userPic),
        _getSocialAction(icon: TikTokIcons.heart, title: numLikes),
        /*
        * TODO version 2
        *  _getSocialAction(icon: TikTokIcons.chat_bubble, title: numComments),
        _getSocialAction(
            icon: TikTokIcons.reply, title: 'Share', isShare: true),
        * */

        CircleImageAnimation(
          child: _getMusicPlayerAction(userPic),
        )
      ]),
    );
  }

  Widget _getSocialAction({String title, IconData icon, bool isShare = false}) {
    return InkWell(
      onTap: () async{

        setState(() {
          if(this.clicked == true)
            this.numLikes = (int.parse(this.numLikes) - 1).toString();
          else
            this.numLikes = (int.parse(this.numLikes) + 1).toString();
          this.clicked = !this.clicked;
        });
        },
      child: Container(
          margin: EdgeInsets.only(top: 15.0),
          width: 60.0,
          height: 60.0,
          child: Column(children: [
            clicked == false?
            Icon(icon, size: isShare ? 25.0 : 35.0, color: Colors.grey[300])
                :
            Icon(icon, size: isShare ? 25.0 : 35.0, color: Colors.red[300]),
            Padding(
              padding: EdgeInsets.only(top: isShare ? 8.0 : 8.0),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: isShare ? 14.0 : 14.0)),
            )
          ])),
      );


  }

  Widget _getFollowAction({String pictureUrl}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: 60.0,
        height: 60.0,
        child:
            Stack(children: [_getProfilePicture(pictureUrl), _getPlusIcon()]));
  }

  Widget _getPlusIcon() {
    return Positioned(
      bottom: 0,
      left: ((ActionWidgetSize / 2) - (PlusIconSize / 2)),
      child: Container(
          width: PlusIconSize, // PlusIconSize = 20.0;
          height: PlusIconSize, // PlusIconSize = 20.0;
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 43, 84),
              borderRadius: BorderRadius.circular(15.0)),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20.0,
          )),
    );
  }

  Widget _getProfilePicture(userPic) {
    return Positioned(
        left: (ActionWidgetSize / 2) - (ProfileImageSize / 2),
        child: Container(
            padding:
                EdgeInsets.all(1.0), // Add 1.0 point padding to create border
            height: ProfileImageSize, // ProfileImageSize = 50.0;
            width: ProfileImageSize, // ProfileImageSize = 50.0;
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ProfileImageSize / 2)),
            // import 'package:cached_network_image/cached_network_image.dart'; at the top to use CachedNetworkImage
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: CachedNetworkImage(
                  imageUrl: userPic,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ))));
  }

  LinearGradient get musicGradient => LinearGradient(colors: [
        Colors.grey[800],
        Colors.grey[900],
        Colors.grey[900],
        Colors.grey[800]
      ], stops: [
        0.0,
        0.4,
        0.6,
        1.0
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  Widget _getMusicPlayerAction(userPic) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        width: ActionWidgetSize,
        height: ActionWidgetSize,
        child: Column(children: [
          Container(
              padding: EdgeInsets.all(11.0),
              height: ProfileImageSize,
              width: ProfileImageSize,
              decoration: BoxDecoration(
                  gradient: musicGradient,
                  borderRadius: BorderRadius.circular(ProfileImageSize / 2)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: CachedNetworkImage(
                    imageUrl: userPic,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ))),
        ]));
  }


}
