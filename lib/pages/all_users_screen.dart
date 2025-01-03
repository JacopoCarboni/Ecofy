// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:ecofy/components/avatarCircle.dart';
import 'package:ecofy/components/circularLoader.dart';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AllUsersScreen extends StatefulWidget {
  final double height;
  final double width;
  final WebSocketChannel socket;
  final String userId;
  final DatabaseService database;
  const AllUsersScreen(
      {super.key,
      required this.width,
      required this.height,
      required this.socket,
      required this.userId,
      required this.database});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;

  void loadUserData() {
    widget.database.queryAllExcept(widget.userId).then((userList) {
      setState(() {
        allUsers = userList;
        filteredUsers = List.from(userList);
        isLoading = false;
      });
    }).catchError((error) {
      print("Error loading user data: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers
            .where((user) =>
                user["username"]?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
    print("Filtered users: $filteredUsers");
  }

  @override
  void initState() {
    super.initState();
    widget.socket.sink
        .add(jsonEncode({"action": "getAllUsers", "userId": widget.userId}));
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF37BE81),
        title: const Text("All Users", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: filteredUsers.isEmpty
          ? const Circularloader()
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterUsers,
                    decoration: const InputDecoration(
                      hintText: "Search users...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // User List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        leading: ClipOval(
                          child: AvatarCircle(
                              width: widget.width * 0.05,
                              profilePic: user["profilePic"]),
                        ),
                        title: Text(user["username"]),
                        onTap: () {
                          debugPrint("Tapped on ${user['username']}");
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
