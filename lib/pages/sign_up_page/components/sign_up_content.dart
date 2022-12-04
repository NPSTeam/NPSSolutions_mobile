import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/widgets/widget_dialog.dart';
import 'package:nps_social/widgets/widget_icon_textfield.dart';
import 'package:nps_social/widgets/widget_snackbar.dart';

import '../../../utils/constants.dart';

class SignUpContent extends StatefulWidget {
  const SignUpContent({Key? key}) : super(key: key);

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController reEnterPasswordTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController sexTextController = TextEditingController(text: 'Male');

  final AuthController _authController = Get.find();

  Widget inputField(String hint, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          if (passwordTextController.text.trim() !=
              reEnterPasswordTextController.text.trim()) {
            WidgetSnackbar.showSnackbar(
              title: "Invalid",
              message: "Password and re-enter password aren't matching.",
              icon: const Icon(Ionicons.alert_circle_outline),
            );
            return;
          }

          UserModel? user = await _authController.register(
            firstName: firstNameTextController.text.trim(),
            lastName: lastNameTextController.text.trim(),
            email: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
            mobile: mobileTextController.text.trim(),
            sex: sexTextController.text.trim(),
          );
          if (user != null) {
            debugPrint(user.email);
            WidgetDialog.showDialog(
              title: "Confirm",
              middleText:
                  "Confirm before sending activation email. ${user.email}",
              cancelText: "Cancel",
              confirmText: "Ok",
              onConfirm: () async {
                await _authController.sendVerificationEmail(user: user);
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          const SizedBox(width: 24),
          Image.asset('assets/images/google.png'),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    mobileTextController.dispose();
    sexTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 136, left: 24),
            child: Text(
              'Create\nAccount',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70, left: 36, right: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: WidgetIconTextfield(
                          controller: firstNameTextController,
                          iconData: Ionicons.person_outline,
                          hintText: 'First Name',
                          enableSuggestions: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: WidgetIconTextfield(
                          controller: lastNameTextController,
                          iconData: Ionicons.person_outline,
                          hintText: 'Last Name',
                          enableSuggestions: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WidgetIconTextfield(
                    controller: emailTextController,
                    iconData: Ionicons.mail_outline,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WidgetIconTextfield(
                    controller: passwordTextController,
                    iconData: Ionicons.lock_closed_outline,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WidgetIconTextfield(
                    controller: reEnterPasswordTextController,
                    iconData: Ionicons.lock_closed_outline,
                    hintText: 'Re-enter password',
                    obscureText: true,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: WidgetIconTextfield(
                          controller: mobileTextController,
                          iconData: Ionicons.call_outline,
                          hintText: 'Mobile',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Material(
                          elevation: 8,
                          shadowColor: Colors.black87,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                enableFeedback: true,
                                value: sexTextController.text,
                                icon: const Icon(Ionicons.transgender_outline),
                                underline: Container(),
                                onChanged: (value) {
                                  setState(() {
                                    sexTextController.text = value ?? '';
                                  });
                                },
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: "Male",
                                    child: Text("Male"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "Female",
                                    child: Text("Female"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                loginButton('Sign Up'),
                orDivider(),
                logos(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
