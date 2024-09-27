import 'package:trx/core/background/notification/notification_manager.dart';
import 'package:trx/product/enum/file_path.dart';
import '../../../user/viewmodel/user_viewmodel.dart';
import '../token/token_manager.dart';

class UploadFileManager {
  final notificationManager = NotificationManager();
  final tokenManager = TokenManager();

  Future<void> uploadFile() async {
    final token = await tokenManager.checkToken();
    if (token is bool) {
      notificationManager.showTokenDoneError();
      return;
    }
    if (token == null) {
      notificationManager.showTokenNotAvailableError();
      return;
    }
    final UserViewmodel uvm = UserViewmodel();

    print("calisti");
    final userFiles = await uvm.getUserFiles(userToken: token);
    if (userFiles.length >= 5) {
      await uvm.deleteFile(fileName: userFiles[0], userToken: token);
    }
    var result =
        await uvm.uploadFile(filePath: FilePath.dbFile.path, userToken: token);
    print(result);
    if (result) {
      notificationManager.showFileUploaded();
    } else {
      notificationManager.showFileUploadError();
    }
  }
}
