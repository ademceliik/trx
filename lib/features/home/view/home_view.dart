import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserViewmodel>(context, listen: false);
    return Scaffold(
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
