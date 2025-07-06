import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';

import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  LogsView({super.key});
  final LogsController logsController = Get.put(LogsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Logs View',
            style: TextStyle(color: Colors.white, fontFamily: gilroyMedium),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                IconlyLight.arrow_left_circle,
                color: Colors.white,
              )),
          centerTitle: true,
        ),
        body: Obx(() => ListView.separated(
              itemCount: logsController.logsList.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logsController.logsList[index]['date'].toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontFamily: gilroyMedium, fontSize: 14),
                    ),
                    Text(
                      logsController.logsList[index]['data'].toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontFamily: gilroyRegular, fontSize: 16),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            )));
  }
}
