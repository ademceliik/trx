import 'dart:async';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:mac_address/mac_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trx/core/background/notification/notification_manager.dart';
import '../connection/connection_manager.dart';
import '../upload-file/upload_file_manager.dart';

Future<void> initializeRun() async {
  final prefs = await SharedPreferences.getInstance();
  await initializeService();
  await AndroidAlarmManager.initialize();
  // Schedule the alarm to start the service on boot
  if (prefs.getBool("is_service_running") ?? false) {
    startBackgroundService();
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final notificationManager = NotificationManager();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationManager.notificationChannelId,
    'TRAXNAV SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  await notificationManager.notification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationManager.notificationChannelId,
      initialNotificationTitle: 'TRAXNAV SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationManager.notificationId,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_service_running", true);
  final notificationManager = NotificationManager();
  final uploadFileManager = UploadFileManager();
  final connectionManager = ConnectionManager();
  //final mac = await GetMac.macAddress;

  service.on("stop").listen((event) {
    service.stopSelf();
    print("Background process is now stopped");

    prefs.setBool("is_service_running", false);
  });
  notificationManager.showServiceStarted();
  Timer.periodic(const Duration(seconds: 1), (timer) {
    print("Service is successfully running ${DateTime.now().second}");
    //print(mac);
  });

  // dosya yukleme islemleri yapilir
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    var connection = await connectionManager.isInternetConnected();
    if (connection) {
      uploadFileManager.uploadFile();
    } else {
      Timer? timer2;
      timer2 = Timer.periodic(const Duration(seconds: 5), (timer3) async {
        notificationManager.showConnectionError();
        connection = await connectionManager.isInternetConnected();
        if (connection) {
          uploadFileManager.uploadFile();
          timer2?.cancel();
        }
      });
    }
    //Bir sonraki yukleme islemi icin kac saniye kaldi bildirimi gonderilebilir
/*     int counter = 15;
    Timer.periodic(const Duration(seconds: 1), (timer3) async {
      if (counter < 11) {
        notificationManager.showCounter(counter);
      }
      counter--;
      if (counter == 0) {
        timer3.cancel();
      }
    }); */
  });
}
