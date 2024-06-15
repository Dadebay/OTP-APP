import 'dart:async';
import 'dart:convert';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';
import 'package:otp_sms_sender_mine/app/modules/home/controllers/home_controller.dart';
import 'package:otp_sms_sender_mine/app/modules/home/views/widget.dart';
import 'package:otp_sms_sender_mine/app/modules/settings/views/settings_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String url = '';
  String event = '';
  String heartBeat = '';
  @override
  void initState() {
    super.initState();

    doFUnction();
  }

  doFUnction() {
    homeController.readURLandEVENT();
    print(homeController.event);
    print(homeController.url);
    print(homeController.eventHeartBeat);
    if (url == '') {
      url = homeController.url.value;
      event = homeController.event.value;
      heartBeat = homeController.eventHeartBeat.value;
      print("-------------------------");
      print(url);
      print(event);
      print(heartBeat);
      _connectToWebSocket();
    } else {
      showSnackBar("Error", "Go to settings fill the URL and EVENT ana HeartBeat", Colors.red);
    }
  }

  final HomeController homeController = Get.put(HomeController());

  _getPermission() async => await [Permission.sms].request();

  Future<bool> _isPermissionGranted() async => await Permission.sms.status.isGranted;

  late WebSocketChannel _channel;
  String? errorTitle;
  void _connectToWebSocket() {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _channel.sink.add(event);
    _channel.stream.listen(
      (event) async {
        Map<String, dynamic> data = jsonDecode(event);
        if (data['event'] != 'pusher:pong') {
          homeController.changeValue(data);
        }
        if (data['event'] == 'send') {
          Map<String, dynamic> phoneNumber = jsonDecode(data['data']);
          homeController.addData(phone: phoneNumber['phone'], message: phoneNumber['msg']);
          if (await _isPermissionGranted()) {
            sendSMS(phoneNumber['phone'], phoneNumber['msg']);
            showSnackBar("Done", "Smssend this number :${phoneNumber['phone']}", Colors.green);
          } else {
            _getPermission();
          }
        }
      },
      onDone: () {
        _reconnect();
      },
      onError: (error) {
        errorTitle = error;
        _reconnect();
      },
    );
    Timer.periodic(const Duration(seconds: 30), (timer) {
      sendHeartbeat();
    });
  }

  sendSMS(String phoneNumber, String sms) async {
    SmsStatus result = await BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: sms);
    if (result == SmsStatus.sent) {
      showSnackBar("Sms", "Sms send this number $phoneNumber", Colors.green);
    } else {
      showSnackBar("Error", "Cannot send sms this number $phoneNumber", Colors.red);
    }
  }

  void sendHeartbeat() {
    showSnackBar("Sending", "Heartbeat for websocket connection every 30 seconds", Colors.purple);
    _channel.sink.add(heartBeat);
    homeController.valuesTITLE.value = 1;
    setState(() {});
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 2), () {
      _connectToWebSocket();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(),
        body: url == ""
            ? const Center(
                child: Text(
                "Go to settings and fill the URL and EVENT ana HeartBeat",
                style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
              ))
            : Obx(() {
                if (homeController.valuesTITLE.value == 0) {
                  return waitingForMessages();
                } else if (homeController.valuesTITLE.value == 2 || homeController.valuesTITLE.value == 3) {
                  return error(homeController.valuesTITLE.value == 3 ? true : false, () {
                    homeController.valuesTITLE.value = 0;
                    _reconnect();
                  });
                } else if (homeController.valuesTITLE.value == 1) {
                  return homeController.data.isEmpty ? emptyMessages() : getData(homeController.data);
                }
                return const Text(
                  "No data please restart app",
                  style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
                );
              }));
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(() {
        return AppBar(
          title: Text(
            errorTitle ?? homeController.values[homeController.valuesTITLE.value]['name'],
            style: const TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
          ),
          elevation: 1,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => const SettingsView());
                },
                icon: const Icon(
                  IconlyLight.setting,
                  color: Colors.white,
                )),
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: homeController.values[homeController.valuesTITLE.value]['color'], shape: BoxShape.circle),
            ),
          ],
        );
      }),
    );
  }
}
