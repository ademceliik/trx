import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  final notificationChannelId = 'my_foreground';
  final notificationId = 888;
  final FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  // bir sonraki yukleme islemine kac saniye kaldi bildirimi
  void showCounter(int count) {
    notification.show(
      notificationId,
      'Planlı Dosya Yüklemesi',
      'Bir sonraki yükleme işlemine kalan: $count saniye',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }

  // servis baglandi bildirimi
  void showServiceStarted() {
    notification.show(
      notificationId,
      'Servis Bağlandı',
      'Arkaplanda çalışma servisi bağlandı.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }

  // internet kaynakli yukleme hatasi bildirimi
  void showConnectionError() {
    notification.show(
      notificationId,
      'Dosya Yüklenemedi',
      'Lütfen internet bağlantınızı kontrol ediniz.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }

  // token gecersiz bildirimi
  void showTokenDoneError() {
    notification.show(
      notificationId,
      'Giriş Başarısız',
      'Hesaba giriş sağlanamadı. Tekrar giriş yapınız.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }

  // token bulunamadi / giris yapilmadi bildirimi
  void showTokenNotAvailableError() {
    notification.show(
      notificationId,
      'Giriş Yapılmadı',
      'Hesaba giriş sağlanamadı. Lütfen giriş yapınız.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }

  // basarili yukleme bildirimi
  void showFileUploaded() {
    notification.show(
      notificationId,
      'Yükleme Başarılı',
      'Dosya başarıyla veritabanına yüklendi.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }

  // dosya yuklemede hata bildirimi
  void showFileUploadError() {
    notification.show(
      notificationId,
      'Yükleme Başarısız',
      'Dosya yüklenemedi.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationChannelId,
          'TRAXNAV SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: false,
        ),
      ),
    );
  }
}
