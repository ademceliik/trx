import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trx/features/home/view/home_view.dart';
import 'package:trx/features/signin/view/sign_in_view.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_token');
}

Future<void> deleteToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_token');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await AndroidAlarmManager.initialize();

  // Schedule the alarm to start the service on boot
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("is_service_running") ?? false) {
    startBackgroundService();
  }
  String? token = await getToken();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserViewmodel(),
      child: MyApp(
        token: token,
      ),
    ),
  );
}

const notificationChannelId = 'my_foreground';
const notificationId = 888;
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
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

@pragma('vm:entry-point')
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

  final socket = io.io("your-server-url", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  socket.onConnect((_) {
    print('Connected. Socket ID: ${socket.id}');
  });

  socket.onDisconnect((_) {
    print('Disconnected');
  });

  socket.on("event-name", (data) {
    // Do something here like pushing a notification
  });

  service.on("stop").listen((event) {
    service.stopSelf();
    print("Background process is now stopped");

    prefs.setBool("is_service_running", false);
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.show(
    notificationId,
    'Service Started',
    'The background service has been started successfully.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        notificationChannelId,
        'MY FOREGROUND SERVICE',
        icon: 'ic_bg_service_small',
        ongoing: true,
      ),
    ),
  );

  Timer.periodic(const Duration(seconds: 1), (timer) {
    socket.emit("event-name", "your-message");
    print("Service is successfully running ${DateTime.now().second}");
  });

  // arkaplanda upload islemleri yapilacak
/*   final token = await getToken();

  Timer.periodic(const Duration(minutes: 1), (timer) {
    final UserViewmodel uvm = UserViewmodel();

    if (token != null) {
      uvm.uploadFile(filePath: "/storage/emulated/0/test.db", userToken: token);
    }
  }); */
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    flutterLocalNotificationsPlugin.show(
      notificationId,
      'COOL SERVICE',
      'Awesome ${DateTime.now()}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    // token hala gecerliyse tokenla giris yap
    final provider = Provider.of<UserViewmodel>(context, listen: false);
    // kayitli token varsa tokeni viewmodela ekle ve homeview icin user olustur
    if (token != null) {
      var decodedDate = JwtDecoder.getExpirationDate(token!);
      if (decodedDate.isAfter(DateTime.now())) {
        provider.setToken(token!);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

        provider.setUser(User(email: decodedToken.values.elementAt(1)));
        //isStillAvailable = true;
      }
      // token gecerli degilse tokeni sil
      else {
        deleteToken();
        //isStillAvailable = false;
      }
    }

    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer<UserViewmodel>(
        builder: (context, authProvider, child) {
          return provider.token != null ? const HomeView() : const SignInView();
        },
      ),
    );
  }
}
