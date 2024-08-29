import 'package:flutter/material.dart';
import 'package:trx/components/custom_text_field.dart';
import 'package:trx/features/home/view/home_view.dart';
import 'package:trx/features/signup/view/sign_up_view.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

import '../../../components/custom_elevated_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool isObscure = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // user view modelimiz
  UserViewmodel uvm = UserViewmodel();

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
            CustomElevatedButton(
              buttonText: "Giriş Yap",
              onPressed: () {
                // login olunca bunun user modeli dönmesi lazım (mı?)
                //
                uvm.login(
                    email: usernameController.text,
                    password: passwordController.text);

                // Home ekranına pushlama işlemi
                /*  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeView())); */
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                const Text("Henüz TRAXNAVlı değil misin?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()));
                    },
                    child: const Text(
                      "TRAXNAVLI Ol",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 154, 160),
                      ),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
