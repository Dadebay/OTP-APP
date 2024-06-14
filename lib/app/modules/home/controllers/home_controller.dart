import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  RxInt valuesTITLE = 0.obs;
  RxList data = [].obs;
  RxString url = "".obs;
  RxString evet = "".obs;
  RxBool login = false.obs;
  GetStorage storage = GetStorage();
  addData({required String phone, required String message}) async {
    data.add({"phone": phone, "message": message, 'date': DateTime.now().toString().substring(0, 10)});
    update();
    storage.write('data', jsonEncode(data));
  }

  writeURLandEVENT({required String url, required String event}) {
    storage.write('login', false);
    storage.write('url', url);
    storage.write('event', event);
    update();
  }
}
