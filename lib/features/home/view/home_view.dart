import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

import '../../../user/model/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final UserModel userViewModel;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  late String token;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? selectedFilePath;
  final int maxBackups = 5; // Maksimum yedek sayısını 5 olarak belirledik.
  Future<void> selectFilePath() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          selectedFilePath = result.files.single.path;
        });

        // Yedekleme işlemi için dosya yolunu kaydedin
        await backupFile();
      }
    } on PlatformException catch (e) {
      print("Unsupported operation: $e");
    } catch (e) {
      print(e);
    }
  }

  Future<void> backupFile() async {
    if (selectedFilePath != null) {
      final userViewModel = Provider.of<UserViewmodel>(context, listen: false);

      // Yedekleme işlemi
      await userViewModel.uploadFile(
          filePath: selectedFilePath!, userToken: userViewModel.token!);

      // Yedek dosyalarını yönet
      //  await manageBackups();
    }
  }

/*   Future<void> manageBackups() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');

    // Yedek klasörü mevcut değilse oluştur
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    // Yedek dosyalarını listele
    List<FileSystemEntity> backups = backupDir.listSync();

    // Yedek dosyası sayısı kontrolü
    if (backups.length > maxBackups) {
      backups.sort(
          (a, b) => a.statSync().modified.compareTo(b.statSync().modified));
      await backups.first.delete(); // En eski yedeği sil
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserViewmodel>(context, listen: false);
    token = provider.token!;
    return Scaffold(
      appBar: AppBar(
        title: Text("TRAXNAV"),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: selectFilePath,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo.png"),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Lottie.asset("assets/tractor.json",
                height: MediaQuery.of(context).size.height * 0.5),
          ),
          SlideTransition(
            position: _offsetAnimation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Çalışıyor ${provider.userModel.user?.email}",
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 154, 160)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //);
}
//}
