import 'package:permission_handler/permission_handler.dart';
//import 'dart:io' show exit;

class PermissionManager {
  Future requestAllPermissions() async {
    await requestStoragePermission();
    await requestNotificationPermission();
    await requestExternalStoragePermission();
  }

  // Eski android surumleri icin depolama izni
  Future requestStoragePermission() async {
    // İzin durumunu kontrol et
    final status = await Permission.storage.status;

    if (status.isGranted) {
      // İzin zaten verilmişse
      print("Depolama izni zaten verilmiş.");
    } else if (status.isDenied) {
      // İzin reddedilmişse, talep et
      final result = await Permission.storage.request();

      if (result.isGranted) {
        // İzin verildiyse
        print("Depolama izni verildi.");
      } else if (result.isDenied) {
        // İzin hala reddedildiyse
        print("Depolama izni reddedildi.");
        //exit(0);
      }
    }
  }

  // bildirim gonderme izni
  Future requestNotificationPermission() async {
    if (await Permission.notification.request().isGranted) {
      print("Bildirim izni verildi");
    } else {
      print("Bildirim izni alınamadı");
    }
  }

  // yeni android surumleri icin depolama izni
  Future<void> requestExternalStoragePermission() async {
    // İzin durumunu kontrol et
    final status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      // İzin zaten verilmişse
      print("Kapsamlı depolama izni zaten verilmiş.");
    } else if (status.isDenied) {
      // İzin reddedilmişse, talep et
      final result = await Permission.manageExternalStorage.request();

      if (result.isGranted) {
        // İzin verildiyse
        print("Kapsamlı depolama izni verildi.");
      } else if (result.isDenied) {
        // İzin hala reddedildiyse
        print("Kapsamlı depolama izni reddedildi.");
        //exit(0);
      }
    }
  }
}
