import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:npssolutions_mobile/controllers/auth_controller.dart';
import 'package:npssolutions_mobile/widgets/widget_button.dart';
import 'package:npssolutions_mobile/widgets/widget_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  DateTime birthday = DateTime.now();

  XFile? avatarImageXFile;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future signUp() async {
    await Get.find<AuthController>().register(
      username: usernameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      birthday: birthday,
      avatarFilePath: avatarImageXFile?.path ?? '',
    );

    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: emailController.text, password: passwordController.text);
    // } on FirebaseAuthException catch (e) {
    //   showErrorMessage(e.code);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: HexColor("#4f4f4f"),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
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
                                              backgroundColor: Colors.grey[200],
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
                                    "Username",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: HexColor('#8d8d8d'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  WidgetTextField(
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
                                  Text(
                                    "Phone",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: HexColor('#8d8d8d'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  WidgetTextField(
                                    controller: phoneController,
                                    hintText: "+0123456789",
                                    obscureText: false,
                                    prefixIcon:
                                        const Icon(Icons.phone_outlined),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: HexColor('#8d8d8d'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  WidgetTextField(
                                    controller: emailController,
                                    hintText: "salter@gmail.com",
                                    obscureText: false,
                                    prefixIcon: const Icon(Icons.mail_outline),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: HexColor('#8d8d8d'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  WidgetTextField(
                                    controller: passwordController,
                                    hintText: "**************",
                                    obscureText: obscurePassword,
                                    prefixIcon: const Icon(Icons.lock_outline),
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
                                    "Confirm Password",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: HexColor('#8d8d8d'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  WidgetTextField(
                                    controller: confirmPasswordController,
                                    hintText: "**************",
                                    obscureText: obscureConfirmPassword,
                                    prefixIcon: const Icon(Icons.lock_outline),
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
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () async {
                                      birthday = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime
                                                .fromMicrosecondsSinceEpoch(0),
                                            lastDate: DateTime.now(),
                                          ) ??
                                          birthday;
                                    },
                                    child: Text(
                                      "Birthday",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('#8d8d8d'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  WidgetTextField(
                                    controller: emailController,
                                    hintText: "salter@gmail.com",
                                    obscureText: false,
                                    prefixIcon: const Icon(Icons.mail_outline),
                                  ),
                                  const SizedBox(height: 10),
                                  const SizedBox(height: 20),
                                  MyButton(
                                    onPressed: signUp,
                                    buttonText: 'Submit',
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Do you have an account?",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: HexColor("#8d8d8d"),
                                            )),
                                        TextButton(
                                          child: Text(
                                            "Login",
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
    );
  }
}
