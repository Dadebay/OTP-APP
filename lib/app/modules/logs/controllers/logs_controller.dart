import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LogsController extends GetxController {
  RxList logsList = [].obs;
  GetStorage storage = GetStorage();
  addLOG({required String data, required String date}) async {
    logsList.add({"data": data, 'date': date});
    update();
    storage.write('logs', jsonEncode(logsList));
  }

  getAllLogsBack() {
    logsList.clear();
    print(logsList);
    var data = storage.read('logs') ?? '[]';
    List list = jsonDecode(data);
    for (var element in list) {
      addLOG(data: element['data'], date: element['date']);
    }
    print(logsList);
  }
}
