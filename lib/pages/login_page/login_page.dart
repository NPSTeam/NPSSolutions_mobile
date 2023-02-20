import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:npssolutions_mobile/widgets/widget_button.dart';
import 'package:npssolutions_mobile/widgets/widget_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void signUserIn() async {
    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: emailController.text, password: passwordController.text);
    // } on FirebaseAuthException catch (e) {
    //   showErrorMessage(e.code);
    // }
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
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor("#fed8c3"),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
            shrinkWrap: true,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 535,
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
                                "Log In",
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#4f4f4f"),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                      onChanged: (() {
                                        validateEmail(emailController.text);
                                      }),
                                      controller: emailController,
                                      hintText: "hello@gmail.com",
                                      obscureText: false,
                                      prefixIcon:
                                          const Icon(Icons.mail_outline),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        _errorMessage,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                      controller: passwordController,
                                      hintText: "**************",
                                      obscureText: true,
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    MyButton(
                                      onPressed: signUserIn,
                                      buttonText: 'Submit',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          35, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Text("Don't have an account?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#8d8d8d"),
                                              )),
                                          TextButton(
                                            child: Text(
                                              "Sign Up",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#44564a"),
                                              ),
                                            ),
                                            onPressed: () {},
                                            //   onPressed: () => Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           const SignUpScreen(),
                                            //     ),
                                            //   ),
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
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
