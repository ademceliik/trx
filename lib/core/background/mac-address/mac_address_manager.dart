import 'package:flutter/services.dart';

// TODO: package name degistiginde ilgili yerleri degistirmeyi unutma!!
class MacAddressManager {
  // method channel android>app>src>main>kotlin>com>example>trx>MainActivity.kt icerisinde
  // method yazilirken networkInterface classi kullandildi
  // fonksiyon ref link: https://www.geeksforgeeks.org/how-to-get-the-mac-of-an-android-device-using-networkinterface-class/
  final platform = const MethodChannel('com.example.trx/macAddress');

  Future<String?> getMacAddress() async {
    try {
      final String? macAddress = await platform.invokeMethod('getMacAddress');
      return macAddress;
    } on PlatformException catch (e) {
      print("Failed to get MAC address: '${e.message}'.");
      return null;
    }
  }
}
