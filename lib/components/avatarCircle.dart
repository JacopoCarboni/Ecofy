import 'package:flutter/material.dart';

class AvatarCircle extends StatelessWidget {
  final double width;
  final String profilePic;
  const AvatarCircle(
      {super.key, required this.width, required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: width, // Adjusted size
      backgroundImage: profilePic == ""
          ? NetworkImage(
              "https://ecofy-app.s3.eu-central-1.amazonaws.com/istockphoto-1130884625-612x612.jpg")
          : NetworkImage(profilePic),
    );
  }
}
