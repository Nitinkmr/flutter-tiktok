import 'package:flutter/material.dart';

class VideoDescription extends StatelessWidget {
  final username;
  //final videtoTitle;
  //final songInfo;

  VideoDescription(this.username);

  @override
  Widget build(BuildContext context) {
    return  Container(
            height: 120.0,
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                ]));
  }
}
