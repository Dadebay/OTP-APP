import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';

Center emptyMessages() {
  return const Center(
    child: Text("No messages here", style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 18)),
  );
}

Widget waitingForMessages() {
  return Center(child: Lottie.asset(loadingLottie, width: 80, height: 80));
}

Center error(bool error, Function() onTap) {
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
          onPressed: onTap,
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

ListView getData(List list) {
  return ListView.separated(
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phone: +${list[list.length - index - 1]['phone']}",
                  style: const TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 16),
                ),
                Text(
                  "ID: ${list[list.length - index - 1]['id']}",
                  style: const TextStyle(color: Colors.white, fontFamily: gilroyRegular, fontSize: 14),
                ),
              ],
            ),
            Text(
              "OTP: ${list[list.length - index - 1]['message']}",
              style: const TextStyle(color: Colors.white, fontFamily: gilroyMedium, fontSize: 14),
            ),
            Text(
              "Date: ${list[list.length - index - 1]['date']}",
              style: const TextStyle(color: Colors.grey, fontFamily: gilroyRegular, fontSize: 14),
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

Center errorWidget() {
  return const Center(
      child: Text(
    "Go to settings and fill the URL and EVENT ana HeartBeat",
    style: TextStyle(color: Colors.white, fontFamily: gilroySemiBold, fontSize: 20),
  ));
}
