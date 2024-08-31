import 'package:flutter/material.dart';
import 'package:trx/components/custom_elevated_button.dart';
import 'package:trx/components/custom_text_field.dart';
import 'package:trx/features/signin/view/sign_in_view.dart';

import '../../../product/components/snackbar.dart';
import '../../../user/viewmodel/user_viewmodel.dart';
import '../../home/view/home_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isObscure = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController macAdressController = TextEditingController();
  UserViewmodel uvm = UserViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  controller: nameController,
                  hintText: "Ad Soyad",
                  icon: Icons.person),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              CustomTextField(
                  controller: usernameController,
                  hintText: "Kullanıcı Adı",
                  icon: Icons.person),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              CustomTextField(
                  controller: emailController,
                  hintText: "E-Posta",
                  icon: Icons.mail),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              CustomTextField(
                  controller: macAdressController,
                  hintText: "Cihaz Mac Adresi",
                  icon: Icons.mobile_friendly),
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
                buttonText: "Kayıt Ol",
                onPressed: () async {
                  await register();
                },
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    final result = await uvm.register(
      email: emailController.text.replaceAll(" ", ""),
      password: passwordController.text,
      fullName: nameController.text,
      userName: usernameController.text,
      // macAddress: macAdressController.text,
    );

    if (!mounted) return; // Check if the widget is still mounted

    if (result is Map) {
      //return result["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          contentText: "Kayıt Başarılı.",
          color: Colors.redAccent,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInView(),
        ),
      );
    } else if (result is List) {
      String message = "";
      for (var item in result) {
        if (item["code"] == "DuplicateEmail") {
          message += "Bu E-Posta Kullanılıyor.";
        } else if (item["code"] == "DuplicateUserName") {
          message += "Bu Kullanıcı Adı Var.";
        } else if (item["code"] == "PasswordTooShort") {
          message += "Şifre 6 Karakterden Uzun Olmalı.";
        }
        //message += "${item["description"]}\n";
      }
      // return message;
      // Giriş başarısızsa uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          contentText: message,
          color: Colors.redAccent,
        ),
      );
    }
/*     if (result is bool) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          contentText: "Kayıt Başarılı.",
          color: Colors.redAccent,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInView(),
        ),
      );
    } else {
      // Giriş başarısızsa uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          contentText: "Giriş başarısız. Lütfen bilgilerinizi kontrol edin.",
          color: Colors.redAccent,
        ),
      );
    } */
  }
}
