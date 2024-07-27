import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';
import 'package:otp_sms_sender_mine/app/modules/home/controllers/home_controller.dart';
import 'package:otp_sms_sender_mine/app/modules/settings/views/agree_button_view.dart';
import 'package:otp_sms_sender_mine/app/modules/settings/views/custom_text_field.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController textEditingController = TextEditingController();

  TextEditingController urlEditingController = TextEditingController();

  TextEditingController heartBeatEditingController = TextEditingController();

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.readURLandEVENT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                IconlyLight.arrow_left_circle,
                color: Colors.white,
              )),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
          ),
          elevation: 1,
        ),
        body: ListView(
          children: [
            Obx(() {
              textEditingController.text = homeController.event.value;
              urlEditingController.text = homeController.url.value;
              heartBeatEditingController.text = homeController.eventHeartBeat.value;
              return Column(
                children: [
                  CustomTextField(
                    labelName: 'SMS channel',
                    controller: textEditingController,
                  ),
                  CustomTextField(
                    labelName: 'Websocket URL',
                    controller: urlEditingController,
                  ),
                  CustomTextField(
                    labelName: 'HeartBeat URL',
                    controller: heartBeatEditingController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AgreeButton(
                      onTap: () {
                        Get.back();

                        homeController.writeURLandEVENT(urll: urlEditingController.text, eventt: textEditingController.text, eventHeartBeatt: heartBeatEditingController.text);
                      },
                      text: "Agree")
                ],
              );
            }),
            const Text(
              'Created by: G.Dadebay',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
            )
          ],
        ));
  }
}
