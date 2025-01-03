import 'package:ecofy/components/avatarCircle.dart';
import 'package:ecofy/services/general/image_upload.dart';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:ecofy/pages/settings_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ignore: must_be_immutable
class OwnProfileScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  final String userId;
  final WebSocketChannel socket;
  final DatabaseService database;
  final Function refreshData;
  final double width;
  final double height;

  OwnProfileScreen(
      {super.key,
      required this.userData,
      required this.userId,
      required this.socket,
      required this.database,
      required this.refreshData,
      required this.width,
      required this.height});

  @override
  State<OwnProfileScreen> createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends State<OwnProfileScreen> {
  bool isLoading = true;
  bool isFollowing = false;
  // ignore: non_constant_identifier_names
  String? S3Url;

  @override
  void initState() {
    super.initState();
    setState(() {
      S3Url = "https://ecofy-app.s3.eu-central-1.amazonaws.com/";
      //_addDefaultPhotos();
      isLoading = false;
    });
  }

  /*void _addDefaultPhotos() {
    // Only add placeholders for display, but they won't count as uploaded photos
    //widget.userData['countUploadedPhotos'] ??= [];
    if (widget.userData['countUploadedPhotos'] == 0) {
      widget.userData['placeholders'] = List.generate(9, (index) => "");
    } else {
      widget.userData['placeholders'] = [];
    }
  }*/

  void followUser() {
    setState(() {
      if (!isFollowing) {
        widget.userData['followers'] = (widget.userData['followers'] ?? 0) + 1;
      } else {
        widget.userData['followers'] = (widget.userData['followers'] ?? 0) - 1;
      }
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildUserInfo(),
                _buildButtons(),
                const Divider(),
                _buildTabBar(),
                S3Url == null
                    ? Center(
                        child: SizedBox(
                            height: widget.height * 0.5,
                            child: Center(
                                child: CircularProgressIndicator.adaptive())))
                    : _buildTabView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              selectImage(widget.userId, widget.database, widget.socket);
              widget.refreshData();
            },
            child: Column(
              children: [
                AvatarCircle(
                    width: widget.width * 0.12,
                    profilePic: widget.userData["profilePic"]),
                SizedBox(height: widget.height * 0.009),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountColumn("Posts",
                    (widget.userData['countUploadedPhotos']).toString()),
                _buildCountColumn(
                    "Followers", (widget.userData['followers']).toString()),
                _buildCountColumn(
                    "Following", (widget.userData['following']).toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.userData['username'] ?? "Unknown User",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.userData['bio'] ?? "No bio available",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the settings screen
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                            database: widget.database,
                            refreshData: widget.refreshData,
                            userId: widget.userId,
                            socket: widget.socket,
                          )),
                );*/
                selectImage(widget.userId, widget.database, widget.socket,
                        isProfilePic: false,
                        count: widget.userData["countUploadedPhotos"] + 1)
                    .then((data) {
                  //print("Count: $data");
                  widget.refreshData();
                  //print("UserData ${widget.userData}");
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF37BE81),
              ),
              child: const Text(
                "Upload Picture of Recycling",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: widget.width * 0.02),
          ElevatedButton(
            onPressed: () {
              // Navigate to the settings screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                        database: widget.database,
                        refreshData: widget.refreshData,
                        userId: widget.userId,
                        socket: widget.socket,
                        width: widget.width,
                        height: widget.height)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBar(
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.black,
      indicatorColor: Colors.black,
      tabs: [
        Icon(Icons.grid_on),
        Icon(Icons.video_collection),
        Icon(Icons.person),
      ],
    );
  }

  Widget _buildTabView() {
    return SizedBox(
      height: widget.height * 0.5,
      child: TabBarView(
        children: [
          _buildGridView(),
          const Center(child: Text("Videos")),
          const Center(child: Text("Tagged")),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    final int countPhotos = widget.userData['countUploadedPhotos']!;
    //print('countPhotos $countPhotos');

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        padding: const EdgeInsets.all(2.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: countPhotos,
        itemBuilder: (context, index) {
          //print('index $index');
          //print('$S3Url${widget.userId}/${index + 1}.png');

          //Find a way to check if the image is real!!!
          return Container(
            color: const Color(0xFF37BE81),
            alignment: Alignment.center,
            child: Image.network('$S3Url${widget.userId}/${index + 1}.png'),
          );
        },
      ),
    );
  }
}
