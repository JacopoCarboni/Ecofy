import 'dart:convert';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:ecofy/services/general/image_upload.dart';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Accountpage extends StatefulWidget {
  final String userId;
  final WebSocketChannel socket;
  final DatabaseService database;
  const Accountpage(
      {super.key,
      required this.userId,
      required this.socket,
      required this.database});

  @override
  State<Accountpage> createState() => _AccountpageState();
}

class _AccountpageState extends State<Accountpage> {
  Uint8List? profilePic;
  String? username;

  void selectImage() async {
    await dotenv.load(fileName: '.env');
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      profilePic = img;
    });
    if (img != null) {
      AwsS3.uploadUint8List(
        accessKey: dotenv.env["accessKey"]!,
        secretKey: dotenv.env["secretKey"]!,
        file: img,
        bucket: "ecofy-app",
        region: "eu-central-1",
        destDir: "profilePics",
        filename: "${widget.userId}.png",
      );

      var profilePicURL =
          "https://ecofy-app.s3.eu-central-1.amazonaws.com/profilePics/${widget.userId}.png";

      widget.database.updateValue("profilePic", profilePicURL, widget.userId);

      widget.socket.sink.add(jsonEncode({
        "action": "saveProfilePic",
        "userId": widget.userId,
        "profilePic": profilePicURL
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 0, 34, 255),
        title: const Text("Profile Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  )),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                  onPressed: () {
                    selectImage();
                  },
                  child: Stack(children: [
                    profilePic == null
                        ? const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://ecofy-app.s3.eu-central-1.amazonaws.com/istockphoto-1130884625-612x612.jpg"),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(profilePic!))
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
