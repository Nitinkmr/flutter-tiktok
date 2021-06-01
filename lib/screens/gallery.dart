

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Gallery extends StatefulWidget{

  Gallery({Key key}) : super(key: key);

  @override
  _GalleryScreenState createState() =>_GalleryScreenState ();
}

class _GalleryScreenState extends State<Gallery>{
  File  _cameraImage;
  var picker = null;

  @override
  void initState() {
     super.initState();
     if(this.picker == null)
       this.picker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
              children: <Widget>[
                if(_cameraImage != null)
                  Image.file(_cameraImage)
                else
                  Text("Click on Pick Image to select an Image", style: TextStyle(fontSize: 18.0),),
                RaisedButton(
                  onPressed: () {
                    _pickImageFromGallery();
                    // or
                    // _pickImageFromCamera();
                    // use the variables accordingly
                  },
                  child: Text("Pick Image From Gallery"),
                ),
              ]
          )
      ),
    );
  }


  void _pickImageFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    File image = File(pickedFile.path);

    setState(() {
      _cameraImage = image;
    });
  }
}