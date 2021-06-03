import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_flutter/shared/constants.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userName;
  final _formKey = GlobalKey<FormState>();
  String registerMessage = '';

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
                        decoration: textInputDecoration.copyWith(
                            labelText: 'user name'),
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Please enter a valid email";
                        }
                        // onChanged: (val) {
                        //   setState(() {
                        //     fullName = val;
                        //   });
                        // },
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
                            _onRegister();
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

  void _onRegister() {}
}
