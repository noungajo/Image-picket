import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const UpdatePlaylistInfo(),
    );
  }
}

class UpdatePlaylistInfo extends StatefulWidget {
  const UpdatePlaylistInfo({Key? key}) : super(key: key);

  @override
  _UpdatePlaylistInfoState createState() => _UpdatePlaylistInfoState();
}

class _UpdatePlaylistInfoState extends State<UpdatePlaylistInfo> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  RxString lienImage = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("Modifier la playlist"),
        ),
        body: Obx(
          () => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  //l'image à afficher
                  lienImage.value == ''
                      ? FlutterLogo(size: 160)
                      : Image.file(imageFile!,
                          width: 160, height: 160, fit: BoxFit.cover),
                  SizedBox(
                    height: 40,
                  ),
                  //lien de l'image afin de voir où elle se trouve
                  Text(
                    lienImage.value,
                    style: TextStyle(color: Colors.blue, fontSize: 30),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                      color: Colors.blue,
                      child: const Text("Pick Image from Gallery",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        pickImage();
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                      color: Colors.blue,
                      child: const Text("Pick Image from Camera",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        pickCamera();
                      }),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      lienImage.value = imageTemp.toString();
      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickCamera() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      GallerySaver.saveImage(image.path);
      lienImage.value = image.path;
      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
