import 'dart:async';
import 'dart:convert';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';
import 'package:otp_sms_sender_mine/app/modules/home/controllers/home_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
    // getPermission();
  }

  // final telephonySMS = TelephonySMS();

  final HomeController homeController = Get.put(HomeController());
  List values = [
    {"name": 'Connecting', 'color': Colors.amber},
    {"name": 'Connected', 'color': Colors.green},
    {"name": 'Disonnected', 'color': Colors.red},
    {"name": 'Error', 'color': Colors.red},
  ];
  _getPermission() async => await [
        Permission.sms,
      ].request();

  Future<bool> _isPermissionGranted() async => await Permission.sms.status.isGranted;

  late WebSocketChannel _channel;
  String? errorTitle;
  void _connectToWebSocket() {
    const url = 'ws://216.250.12.31:8051/app/sxdpwpbohufyua1yinkr?protocol=7&client=js&version=8.4.0-rc2&flash=false';
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _channel.sink.add('{"event":"pusher:subscribe","data":{"auth":"","channel":"sms.server"}}');
    _channel.stream.listen(
      (event) async {
        Map<String, dynamic> data = jsonDecode(event);
        print(data['event']);
        if (data['event'] != 'pusher:pong') {
          changeValue(data);
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
        print("OnDone____________________");
        _reconnect();
      },
      onError: (error) {
        print("Error____________________");
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
      print("Sent");
      showSnackBar("Sms", "Sms send this number $phoneNumber", Colors.green);
    } else {
      showSnackBar("Error", "Cannot send sms this number $phoneNumber", Colors.red);

      print("Failed");
    }
  }

  void sendHeartbeat() {
    showSnackBar("Sending", "Heartbeat for websocket connection every 30 seconds", Colors.purple);
    _channel.sink.add('{"event":"pusher:ping","data":{}}');
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
        body: Obx(() {
          if (homeController.valuesTITLE.value == 0) {
            return waitingForMessages();
          } else if (homeController.valuesTITLE.value == 2 || homeController.valuesTITLE.value == 3) {
            return error(homeController.valuesTITLE.value == 3 ? true : false);
          } else if (homeController.valuesTITLE.value == 1) {
            return homeController.data.isEmpty ? emptyMessages() : getData();
          }

          return const Text(
            "No data please restart app",
            style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
          );
        }));
  }

  ListView getData() {
    return ListView.separated(
      itemCount: homeController.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Phone: +${homeController.data[homeController.data.length - index - 1]['phone']}",
                style: const TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 18),
              ),
              Text(
                "OTP: ${homeController.data[homeController.data.length - index - 1]['message']}",
                style: const TextStyle(color: Colors.white, fontFamily: gilroyMedium, fontSize: 16),
              ),
              Text(
                "Date: ${homeController.data[homeController.data.length - index - 1]['date']}",
                style: const TextStyle(color: Colors.grey, fontFamily: gilroyRegular, fontSize: 16),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 1,
          color: Colors.grey.shade200,
        );
      },
    );
  }

  Center emptyMessages() {
    return const Center(
      child: Text(
        "No messages here",
        style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 18),
      ),
    );
  }

  Widget waitingForMessages() {
    return Center(child: Lottie.asset(loadingLottie, width: 80, height: 80));
  }

  Center error(bool error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(error ? "Error please try again later" : "Disconnected from server please try again",
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20)),
          ),
          ElevatedButton(
            onPressed: () {
              homeController.valuesTITLE.value = 0;
              _reconnect();
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
              backgroundColor: kPrimaryColor,
            ),
            child: Text(
              "Try Again".tr,
              style: const TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(() {
        return AppBar(
          title: Text(
            errorTitle ?? values[homeController.valuesTITLE.value]['name'],
            style: const TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
          ),
          elevation: 1,
          actions: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: values[homeController.valuesTITLE.value]['color'], shape: BoxShape.circle),
            )
          ],
        );
      }),
    );
  }

  void changeValue(Map<String, dynamic> data) {
    if (data['event'] == 'pusher_internal:subscription_succeeded' || data['event'] == 'send') {
      homeController.valuesTITLE.value = 1;
    } else if (data['event'] == 'pusher:error' || data['event'] == 'pusher_internal:ping') {
      homeController.valuesTITLE.value = 3;
    } else {
      homeController.valuesTITLE.value = 2;
    }
  }
}
