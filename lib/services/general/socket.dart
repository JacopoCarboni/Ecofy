import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class Cords {
  final double lat;
  final double lon;

  Cords(this.lat, this.lon);
}

WebSocketChannel connectToWebsocket(paramsApiUrl) {
  print("connected");
  final socket = WebSocketChannel.connect(Uri.parse(paramsApiUrl));
  return socket;
}

void listendMsg(WebSocketChannel socket, Function refreshPage) {
  socket.stream.listen((data) {
    Map<String, dynamic> res = jsonDecode(data)["data"];
    processMsg(res["statusCode"], res, socket, refreshPage);
  }).onDone(() {
    socket.sink.close();
  });
}

void processMsg(int statusCode, Map<String, dynamic> data,
    WebSocketChannel socket, Function refreshPage) {
  print(statusCode);
  switch (statusCode) {
    case 100: // Empty Message
      break;
  }
}
