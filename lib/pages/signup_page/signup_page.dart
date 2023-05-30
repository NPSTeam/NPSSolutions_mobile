import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/widgets/widget_button.dart';
import 'package:npssolutions_mobile/widgets/widget_login_text_field.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../configs/themes/text_style_const.dart';
import '../../internationalization/message_keys.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final displayNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  DateTime birthday = DateTime.now();

  XFile? avatarImageXFile;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final RoundedLoadingButtonController _signUpBtnController =
      RoundedLoadingButtonController();

  Future signUp() async {
    if (await Get.find<AuthController>().register(
      username: usernameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      birthday: birthday,
      avatarFilePath: avatarImageXFile?.path,
    )) {
      _signUpBtnController.success();
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } else {
      _signUpBtnController.error();
      await Future.delayed(const Duration(milliseconds: 500));
      _signUpBtnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: Scaffold(
          backgroundColor: HexColor("#fed8c3"),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
            shrinkWrap: true,
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
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MessageKeys.signUpPageTitle.tr,
                                style: GoogleFonts.poppins(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          avatarImageXFile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          setState(() {});
                                        },
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 50.0,
                                              backgroundColor: Colors.blue,
                                              child: CircleAvatar(
                                                radius: 48.0,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                backgroundImage:
                                                    avatarImageXFile != null
                                                        ? Image.file(File(
                                                                avatarImageXFile
                                                                        ?.path ??
                                                                    ''))
                                                            .image
                                                        : null,
                                              ),
                                            ),
                                            const Positioned(
                                              bottom: 0.0,
                                              right: 0.0,
                                              child: Icon(Ionicons.add_circle,
                                                  size: 30),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${MessageKeys.signUpPageUsername.tr} *',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#8d8d8d'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    WidgetLoginTextField(
                                      controller: usernameController,
                                      hintText: "salter",
                                      obscureText: false,
                                      prefixIcon:
                                          const Icon(Icons.person_outline),
                                    ),
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    //   child: Text(
                                    //     _errorMessage,
                                    //     style: GoogleFonts.poppins(
                                    //       fontSize: 12,
                                    //       color: Colors.red,
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Email *",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#8d8d8d'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    WidgetLoginTextField(
                                      controller: emailController,
                                      hintText: "salter@gmail.com",
                                      obscureText: false,
                                      prefixIcon:
                                          const Icon(Icons.mail_outline),
                                    ),
                                    Text(
                                      '${MessageKeys.signUpPhone.tr} *',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#8d8d8d'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    WidgetLoginTextField(
                                      controller: phoneController,
                                      hintText: "+0123456789",
                                      obscureText: false,
                                      prefixIcon:
                                          const Icon(Icons.phone_outlined),
                                    ),

                                    const SizedBox(height: 10),
                                    Text(
                                      MessageKeys.signUpPassword.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#8d8d8d'),
                                      ),
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
                                            obscurePassword = !obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      MessageKeys.signUpConfirmPassword.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#8d8d8d'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    WidgetLoginTextField(
                                      controller: confirmPasswordController,
                                      hintText: "**************",
                                      obscureText: obscureConfirmPassword,
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
                                            obscureConfirmPassword =
                                                !obscureConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    RoundedLoadingButton(
                                      controller: _signUpBtnController,
                                      color: HexColor('#44564a'),
                                      onPressed: signUp,
                                      child: Text(MessageKeys.signUpSignUp.tr,
                                          style: TextStyleConst.semiBoldStyle(
                                              fontSize: 18,
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
                                                  .signUpDoYouHaveAnAccount.tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#8d8d8d"),
                                              )),
                                          TextButton(
                                            child: Text(
                                              MessageKeys.signUpLogin.tr,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#44564a"),
                                              ),
                                            ),
                                            onPressed: () => Get.back(),
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
                          child: Image.asset(
                            'assets/images/plants2.png',
                            scale: 1.5,
                            width: double.infinity,
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
