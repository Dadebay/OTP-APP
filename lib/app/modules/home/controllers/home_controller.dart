import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';

class HomeController extends GetxController {
  RxInt valuesTITLE = 0.obs;
  RxList data = [].obs;
  RxString url = "".obs;
  RxString event = "".obs;
  RxString eventHeartBeat = "".obs;
  RxBool login = false.obs;
  List values = [
    {"name": 'Connecting', 'color': Colors.amber},
    {"name": 'Connected', 'color': Colors.green},
    {"name": 'Disonnected', 'color': Colors.red},
    {"name": 'Error', 'color': Colors.red},
  ];
  GetStorage storage = GetStorage();
  addData({required String phone, required String message}) async {
    data.add({"phone": phone, "message": message, 'date': DateTime.now().toString().substring(0, 10)});
    update();
    storage.write('data', jsonEncode(data));
  }

  void changeValue(Map<String, dynamic> data) {
    if (data['event'] == 'pusher_internal:subscription_succeeded' || data['event'] == 'send') {
      valuesTITLE.value = 1;
    } else if (data['event'] == 'pusher:error' || data['event'] == 'pusher_internal:ping') {
      valuesTITLE.value = 3;
    } else {
      valuesTITLE.value = 2;
    }
  }

  writeURLandEVENT({required String urll, required String eventt, required String eventHeartBeatt}) {
    url.value = urll;
    event.value = eventt;
    eventHeartBeat.value = eventHeartBeatt;
    storage.write('url', urll);
    storage.write('event', eventt);
    storage.write('heartBeat', eventHeartBeatt);
    print(eventHeartBeatt);
    showSnackBar("Done", "Succesfully changed data", Colors.green);
  }

  void readURLandEVENT() {
    url.value = storage.read('url') ?? 'ws://216.250.12.31:8051/app/sxdpwpbohufyua1yinkr?protocol=7&client=js&version=8.4.0-rc2&flash=false';
    event.value = storage.read('event') ?? '{"event":"pusher:subscribe","data":{"auth":"","channel":"sms.server"}}';
    eventHeartBeat.value = storage.read('heartBeat') ?? '{"event":"pusher:ping","data":{}}';
  }
}
