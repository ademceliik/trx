import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:trx/components/custom_elevated_button.dart';
import 'package:trx/components/custom_text_field.dart';
import 'package:trx/features/signup/view/sign_up_view.dart';
import 'package:trx/product/components/snackbar.dart';
import 'package:trx/user/model/user_model.dart';
import 'package:trx/user/viewmodel/user_viewmodel.dart';

// HomeView import edilmeli
import 'package:trx/features/home/view/home_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final GlobalKey<FormState> _formKey;

  bool isObscure = true;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // User ViewModel
  UserViewmodel uvm = UserViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  hintText: "E-Posta",
                  icon: Icons.email,
                ),
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
                  onPressed: () async {
                    await _login();
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  children: [
                    const Text("Henüz TRAXNAV'lı değil misin?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()));
                      },
                      child: const Text(
                        "TRAXNAV'lı Ol",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 154, 160),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final response = await uvm.login(
      email: usernameController.text.replaceAll(" ", ""),
      password: passwordController.text,
    );

    if (!mounted) return; // Check if the widget is still mounted

    if (response is String) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(response);
      Provider.of<UserViewmodel>(context, listen: false).setToken(response);
      Provider.of<UserViewmodel>(context, listen: false)
          .setUser(User(email: decodedToken.values.elementAt(1)));
      // Giriş başarılıysa HomeView ekranına yönlendir
      CustomSnackBar(
        contentText: "Giriş Başarılı.",
        color: Color.fromARGB(255, 0, 154, 160),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(),
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
    }
  }
}
