import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trx/product/components/snackbar.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final UserViewmodel userViewModel;

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
    userViewModel = Provider.of<UserViewmodel>(context, listen: false);

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
        if (userViewModel.userFiles != null) {
          if (userViewModel.userFiles!.length >= 4) {
            userViewModel.deleteFile(
                fileName: userViewModel.userFiles![0],
                userToken: userViewModel.token!);
          }
        }

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
      // Yedekleme işlemi
      var result = await userViewModel.uploadFile(
          filePath: selectedFilePath!, userToken: userViewModel.token!);
      final files =
          await userViewModel.getUserFiles(userToken: userViewModel.token!);
      userViewModel.setUserFiles(files);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            contentText: "Dosya Başarıyla Yüklendi.",
            color: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            contentText: "Dosya Yüklenemedi.",
            color: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          buildDialog(context, userViewModel.userFiles ?? List.empty());

          //selectedFilePath = "/storage/emulated/0/test.db";
          //await backupFile();

/*           final file = File(
              '/storage/emulated/0/test.db'); // Burada 'your_file.txt' dosya adını güncelleyin

          // Dosyanın varlığını kontrol et
          if (!await file.exists()) {
            print('Dosya bulunamadı');
            return;
          } else {
            await userViewModel.uploadFile(
                filePath: file.path, userToken: userViewModel.token!);
          } */

/*           var status = await Permission.storage.status;
          if (status.isDenied) {
            print('İzin Hiç sorulmadı');
            await Permission.storage.request();
            await Permission.manageExternalStorage.status;
          } else if (status.isGranted) {
            print('İzin önceden soruldu ve kullanıcı izni verdi');
          } else {
            print('İzin önceden soruldu ve kullanıcı izni vermedi');
          } */
        },
        child: Icon(Icons.games_outlined),
      ),
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
                "Çalışıyor ${userViewModel.userModel.user?.email}",
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

  Future<dynamic> buildDialog(BuildContext context, List<dynamic> items) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Liste'),
          content: SingleChildScrollView(
            child: ListBody(
              children: items.map((item) => Text(item)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //);
}
//}
