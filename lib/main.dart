import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trx/features/signin/view/sign_in_view.dart';
import 'package:trx/user/model/user_provider.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await AndroidAlarmManager.initialize();

  // Schedule the alarm to start the service on boot
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("is_service_running") ?? false) {
    startBackgroundService();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserViewmodel(),
      child: MyApp(),
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer<UserViewmodel>(
        builder: (context, authProvider, child) {
          // Token olup olmadığını kontrol ederek ekranı yönlendirin
          return SignInView();
        },
      ),
    );

    /*  MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserViewmodel()),
          ProxyProvider<UserViewmodel, UserProvider>(
            update: (_, userViewmodel, __) =>
                UserProvider(userViewmodel.userModel),
          ),
        ],
        child: MaterialApp(
          title: '',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SignInView(),
        )); */
  }
}
