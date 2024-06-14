import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_sms_sender_mine/app/constants/constants.dart';
import 'package:otp_sms_sender_mine/app/modules/home/views/connection_check_view.dart';
import 'package:otp_sms_sender_mine/app/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  WakelockPlus.enable();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "OTP CONNECTION WEBSOCKET",
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: gilroyRegular,
          colorSchemeSeed: kPrimaryColor,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark),
            titleTextStyle: TextStyle(color: Colors.black, fontFamily: gilroySemiBold, fontSize: 20),
            elevation: 0,
          ),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent.withOpacity(0)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        fallbackLocale: const Locale('tm'),
        locale: storage.read('langCode') != null ? Locale(storage.read('langCode')) : const Locale('tm'),
        translations: MyTranslations(),
        defaultTransition: Transition.fade,
        home: const ConnectionCheckView());
  }
}
