import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/internationalization/message_keys.dart';
import 'package:npssolutions_mobile/pages/home_page/home_page.dart';
import 'package:npssolutions_mobile/pages/signup_page/signup_page.dart';
import 'package:npssolutions_mobile/widgets/widget_button.dart';
import 'package:npssolutions_mobile/widgets/widget_language_toggle.dart';
import 'package:npssolutions_mobile/widgets/widget_login_text_field.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../widgets/widget_checkbox_list_tile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;

  final RoundedLoadingButtonController _loginBtnController =
      RoundedLoadingButtonController();

  void signUserIn() async {
    debugPrint("Signing in...");

    if (await Get.find<AuthController>().login(
      username: usernameController.text,
      password: passwordController.text,
      rememberMe: rememberMe,
    )) {
      _loginBtnController.success();
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => const HomePage());
    } else {
      _loginBtnController.error();
      await Future.delayed(const Duration(milliseconds: 500));
      _loginBtnController.reset();
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    // if (val.isEmpty) {
    //   setState(() {
    //     _errorMessage = "Email can not be empty";
    //   });
    // } else if (!EmailValidator.validate(val, true)) {
    //   setState(() {
    //     _errorMessage = "Invalid Email Address";
    //   });
    // } else {
    //   setState(() {
    //     _errorMessage = "";
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          backgroundColor: HexColor("#fed8c3"),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#ffffff"),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    MessageKeys.loginPageTitle.tr,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor("#4f4f4f"),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          MessageKeys.loginPageUsername.tr,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: HexColor('#8d8d8d'),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        WidgetLoginTextField(
                                          onChanged: (() {
                                            validateEmail(
                                                usernameController.text);
                                          }),
                                          controller: usernameController,
                                          hintText: "salter",
                                          obscureText: false,
                                          prefixIcon:
                                              const Icon(Icons.person_outline),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Text(
                                            _errorMessage,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.red),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          MessageKeys.loginPagePassword.tr,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: HexColor('#8d8d8d')),
                                        ),
                                        const SizedBox(height: 10),
                                        WidgetLoginTextField(
                                          controller: passwordController,
                                          hintText: "**************",
                                          obscureText: obscurePassword,
                                          prefixIcon:
                                              const Icon(Icons.lock_outline),
                                          suffixWidget: IconButton(
                                            icon: Icon(
                                              obscurePassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: HexColor("#4f4f4f"),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                obscurePassword =
                                                    !obscurePassword;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        WidgetCheckboxListTile(
                                          title: Text(
                                            MessageKeys.loginPageRememberMe.tr,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          value: rememberMe,
                                          onChanged: (value) => setState(() =>
                                              rememberMe = value ?? false),
                                        ),
                                        const SizedBox(height: 20),
                                        RoundedLoadingButton(
                                          controller: _loginBtnController,
                                          color: HexColor('#44564a'),
                                          onPressed: signUserIn,
                                          child: Text(
                                              MessageKeys
                                                  .loginPageSignInButton.tr,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              35, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  MessageKeys
                                                      .dontHaveAnAccount.tr,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color:
                                                          HexColor("#8d8d8d"))),
                                              TextButton(
                                                child: Text(
                                                  MessageKeys
                                                      .loginPageSignUp.tr,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color:
                                                          HexColor("#44564a")),
                                                ),
                                                onPressed: () => Get.to(
                                                    () => const SignUpPage()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -253),
                            child: Image.asset('assets/images/plants2.png',
                                scale: 1.5, width: double.infinity),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const Positioned(
                top: 20,
                right: 10,
                child: WidgetLanguageToggle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
