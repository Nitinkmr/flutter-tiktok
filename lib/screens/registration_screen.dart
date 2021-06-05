import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/screens/profile_screen.dart';
import 'package:tiktok_flutter/services/database_service.dart';
import 'package:tiktok_flutter/shared/constants.dart';
import 'package:tiktok_flutter/models/User.dart' as MyUser;

class Register extends StatefulWidget {
  User user;

  Register(User user) {
    this.user = user;
  }

  @override
  State<StatefulWidget> createState() => _RegisterState(user);
}

class _RegisterState extends State<Register> {
  String userName;
  String userNameErrorMessage;
  final _formKey = GlobalKey<FormState>();
  String registerMessage = '';
  User user;

  _RegisterState(User user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            color: Colors.black,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text("Register",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration:
                          textInputDecoration.copyWith(labelText: 'user name'),
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                            ? null
                            : "Please enter a valid username";
                      },
                      onChanged: (val) {
                        setState(() {
                          userName = val;
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    SizedBox(height: 15.0),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text('Register',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            _validateUserName();
                          }),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(height: 10.0),
                    Text(registerMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _validateUserName() async {
    var userNameFuture =
        await DatabaseService().getUserWithUserName(this.userName);

    if (userNameFuture.docs != null && userNameFuture.docs.length > 0) {
      // userName exists
      setState(() {
        //userName = '';
        userNameErrorMessage =
            'user name already exists. Please select a different user name';
      });
    } else {
      //TODO ask user for username
      await DatabaseService().createUser(user,this.userName);
      var userFuture = await DatabaseService().getUserData(user.email);
      if (userFuture.docs != null && userFuture.docs.length > 0) {
        MyUser.User myUser = MyUser.User.convertFromSnapshot(userFuture.docs[0].data());

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(myUser: myUser)
          ),
        );
      } else {
        //TODO error
      }
    }
  }
}
