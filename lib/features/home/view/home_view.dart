import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final files =
              await userViewModel.getUserFiles(userToken: userViewModel.token!);
          userViewModel.setUserFiles(files);
          if (mounted) {
            buildDialog(context, userViewModel.userFiles ?? List.empty());
          }
        },
        child: const Icon(Icons.games_outlined),
      ),
      appBar: AppBar(
        title: const Text("TRAXNAV"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.3,
                "assets/logo.png"),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Lottie.asset("assets/tractor.json",
                  height: MediaQuery.of(context).size.height * 0.4),
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
      ),
    );
  }

  Future<dynamic> buildDialog(BuildContext context, List<dynamic> items) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Liste'),
          content: SingleChildScrollView(
            child: ListBody(
              children: items.map((item) => Text(item)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
