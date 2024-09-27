import 'package:flutter/material.dart';
import 'package:trx/product/components/custom_elevated_button.dart';
import 'package:trx/product/components/custom_text_field.dart';
import 'package:trx/features/signin/view/sign_in_view.dart';

import '../../../core/background/connection/connection_manager.dart';
import '../../../product/components/loading_indicator.dart';
import '../../../product/components/snackbar.dart';
import '../../../user/viewmodel/user_viewmodel.dart';

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
    final connectionManager = ConnectionManager();
    var connection = await connectionManager.isInternetConnected();
    if (!mounted) return; // Check if the widget is still mounted
    if (!connection) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          contentText:
              "Kayıt başarısız. Lütfen internet bağlantınızı kontrol edin.",
          color: Colors.redAccent,
        ),
      );
      return;
    }
    LoadingIndicatorDialog lid = LoadingIndicatorDialog();

    lid.show(context, text: "Kayıt Oluyor..");
    final result = await uvm.register(
      email: emailController.text.replaceAll(" ", ""),
      password: passwordController.text,
      fullName: nameController.text,
      userName: usernameController.text,
      macAddress: macAdressController.text,
    );
    lid.dismiss();
    if (!mounted) return; // Check if the widget is still mounted

    if (result is Map) {
      if (result["status"] == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            contentText: "Lütfen alanları eksiksiz doldurunuz.",
            color: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            contentText: "Kayıt Başarılı.",
            color: const Color.fromARGB(255, 0, 154, 160),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInView(),
          ),
        );
      }
      //return result["message"];
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
      }
      // Giriş başarısızsa uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          contentText: message,
          color: Colors.red,
        ),
      );
    }
  }
}
