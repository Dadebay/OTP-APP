import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
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
  addData({required String id, required String phone, required String message}) async {
    data.add({"id": id, "phone": phone, "message": message, 'date': DateTime.now().toString().substring(0, 10)});
    update();
    storage.write('data', jsonEncode(data));
  }

  findAllNumbersAndRetviewThem() {
    var data = storage.read('data') ?? '[]';
    List<dynamic> list = jsonDecode(data);
    for (var element in list) {
      addData(phone: element['phone'], message: element['message'], id: element['id'] ?? "null");
    }
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
    showSnackBar("Done", "Succesfully changed data", Colors.green);
  }

  void readURLandEVENT() {
    url.value = storage.read('url') ?? 'ws://216.250.12.31:8051/app/sxdpwpbohufyua1yinkr?protocol=7&client=js&version=8.4.0-rc2&flash=false';
    event.value = storage.read('event') ?? '{"event":"pusher:subscribe","data":{"auth":"","channel":"sms.server.test"}}';
    eventHeartBeat.value = storage.read('heartBeat') ?? '{"event":"pusher:ping","data":{}}';
  }

  sendData({required int id}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Map<String, dynamic> data = jsonDecode(event.value);
    final queryParameters = {
      'device': '${androidInfo.brand}+" " + ${androidInfo.model}',
      'service': data['data']['channel'],
    };
    final response = await http.put(
      Uri.parse(
        "http://216.250.12.31:8052/sms/set-as-sent/$id",
      ).replace(queryParameters: queryParameters),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      showSnackBar("Done", "SMS put working", Colors.green);
    } else {
      showSnackBar("Error", "SMS put NOT working", Colors.red);
    }
  }
}
