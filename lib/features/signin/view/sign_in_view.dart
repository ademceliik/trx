import 'package:flutter/material.dart';
import 'package:trx/features/home/view/home_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool isObscure = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            CustomTextField(
                controller: usernameController,
                hintText: "Kullanıcı Adı",
                icon: Icons.person),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            CustomTextField(
              controller: passwordController,
              hintText: "Şifre",
              icon: Icons.lock,
              isObscure: isObscure,
              suffix: InkWell(
                onTap: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child: Icon(isObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 154, 160),
                    disabledBackgroundColor: Colors.pink.shade100),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeView()));
                },
                child: const Text(
                  "Giriş Yap",
                  style:
                      TextStyle(color: (true) ? Colors.white : Colors.white54),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.onChanged,
    this.isObscure = false,
    this.suffix,
    this.controller,
  });

  final String hintText;
  final IconData icon;
  final bool isObscure;
  final Widget? suffix;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade200),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: isObscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            border: InputBorder.none,
            suffixIcon: suffix,
            hintText: hintText,
          ),
        ));
  }
}
