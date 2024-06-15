// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelName;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.labelName,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextFormField(
        style: const TextStyle(color: Colors.white, fontFamily: gilroyMedium),
        cursorColor: Colors.white,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'errorEmpty'.tr;
          }
          return null;
        },
        maxLines: 3,
        inputFormatters: [
          LengthLimitingTextInputFormatter(labelName == 'clientNumber' ? 8 : 300),
        ],
        decoration: InputDecoration(
          errorMaxLines: 2,
          suffix: const SizedBox.shrink(),
          errorStyle: const TextStyle(fontFamily: gilroyMedium),
          hintMaxLines: 5,
          helperMaxLines: 5,
          hintStyle: TextStyle(color: Colors.grey.shade300, fontFamily: gilroyMedium),
          label: Text(
            labelName.tr,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade400, fontFamily: gilroyMedium),
          ),
          contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20, right: 10),
          border: const OutlineInputBorder(
            borderRadius: borderRadius20,
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius20,
            borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: borderRadius20,
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: borderRadius20,
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: borderRadius20,
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
