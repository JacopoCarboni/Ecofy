import 'dart:convert';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectToWebsocket(String paramsApiUrl) {
  print("Connected to WebSocket");
  final socket = WebSocketChannel.connect(Uri.parse(paramsApiUrl));
  return socket;
}

void listendMsg(WebSocketChannel socket, DatabaseService database, String userId) {
  socket.stream.listen(
    (data) {
      try {
        final parsedData = jsonDecode(data);
        //print("Message received: $parsedData");

        if (parsedData.containsKey("data")) {
          final res = parsedData["data"];

          processMsg(res["statusCode"], res, socket, database, userId);
        } else {
          print("Message does not contain 'data': $parsedData");
        }
      } catch (e) {
        print("Error parsing WebSocket message: $e");
      }
    },
    onError: (error) {
      print("WebSocket error: $error");
    },
    onDone: () {
      print("WebSocket connection closed");
    },
  );
}

void processMsg(int statusCode, Map<String, dynamic> data,
    WebSocketChannel socket, DatabaseService database, String userId) {
  print("Processing: $statusCode");
  switch (statusCode) {
    case 100: // No Return Value
      break;
    case 200: // No Relevent Return Value
      print("Success: ${data["msg"]}");
      break;
    case 201:
      List<Map<String, dynamic>> allUsers = jsonDecode(data["allUsers"])
          .whereType<Map<String, dynamic>>()
          .toList();

      // Clear outdated data
      database.clearAllExecpt(userId); // Add a method in DatabaseService to clear all data

      for (int index = 0; index < allUsers.length; index++) {
        database.replace(allUsers[index]);
      }
      break;
    default:
      print("Unhandled statusCode: $statusCode with data: $data");
      break;
  }
}
