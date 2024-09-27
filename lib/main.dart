import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:trx/features/home/view/home_view.dart';
import 'package:trx/features/signin/view/sign_in_view.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';
import 'core/background/service/background_service.dart';
import 'core/background/token/token_manager.dart';
import 'core/background/upload-file/permission_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // izin sorgusu yapilir
  final permissionManager = PermissionManager();
  await permissionManager.requestAllPermissions();
  // kayitli token kontrolu yap
  final tokenManager = TokenManager();
  await tokenManager.checkToken();
  // token gecerliyse servisleri baslat
  if (tokenManager.token != null) {
    await initializeRun();
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserViewmodel(),
      child: MyApp(
        tokenManager: tokenManager,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final TokenManager tokenManager;
  const MyApp({super.key, required this.tokenManager});

  @override
  Widget build(BuildContext context) {
    // token hala gecerliyse tokenla giris yap
    final provider = Provider.of<UserViewmodel>(context, listen: false);
    // kayitli token varsa tokeni viewmodela ekle ve homeview icin user olustur

    if (tokenManager.token != null) {
      var decodedDate = JwtDecoder.getExpirationDate(tokenManager.token!);
      // tokenin kullanim tarihi gecti mi
      if (decodedDate.isAfter(DateTime.now())) {
        provider.setToken(tokenManager.token!);
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(tokenManager.token!);

        provider.setUser(User(email: decodedToken.values.elementAt(1)));
      }
      // token gecerli degilse tokeni sil
      else {
        tokenManager.deleteToken();
      }
    }

    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 154, 160)),
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

/* package com.example.trx

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
 */


/* val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        return wifiManager.connectionInfo.macAddress ?: "00:00:00:00:00:00" */