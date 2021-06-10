import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tiktok_flutter/models/User.dart' as MyUser;
import 'package:tiktok_flutter/screens/profile_screen.dart';
import 'package:tiktok_flutter/screens/registration_screen.dart';
import 'package:tiktok_flutter/services/database_service.dart';
import 'package:tiktok_flutter/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User user =
                    await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                    MyUser.User myUser = null;
                    var userFuture = await DatabaseService().getUserData(user.email);

                    if(userFuture.docs != null && userFuture.docs.length > 0  ){
                       myUser = MyUser.User.convertFromSnapshot(userFuture.docs[0].data());

                       Navigator.of(context).push(
                         MaterialPageRoute(
                             builder: (context) => ProfileScreen()
                         ),
                       );

                    }else{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Register(user)
                          ),
                        );
                     }

               }else{
                  // TODO this could be google auth error
                }

              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0,
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  // setUser(existingUser) {
  //
  //   MyUser.User myUser = MyUser.User.convert(existingUser);
  //   myUser.
  // }
}
