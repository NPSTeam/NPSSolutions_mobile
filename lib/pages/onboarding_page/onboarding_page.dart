import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/internationalization/message_keys.dart';
import 'package:npssolutions_mobile/pages/login_page/login_page.dart';
import 'package:npssolutions_mobile/widgets/widget_language_toggle.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 260,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MessageKeys.npsTeam.tr,
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Roboto",
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Don't skip design. Learn design and code, by building real apps with Flutter and Swift. Complete courses about the best tools.",
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 2),
                        AnimatedBtn(
                          btnAnimationController: _btnAnimationController,
                          press: () {
                            _btnAnimationController.isActive = true;

                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                Get.to(const LoginPage());
                                // setState(() {
                                //   isShowSignInDialog = true;
                                // });
                                // showCustomDialog(
                                //   context,
                                //   onValue: (_) {
                                //     setState(() {
                                //       isShowSignInDialog = false;
                                //     });
                                //   },
                                // );
                              },
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                              "Purchase includes access to 30+ courses, 240+ premium tutorials, 120+ hours of videos, source files and certificates."),
                        )
                      ],
                    ),
                    const Positioned(
                      top: 20,
                      right: 0,
                      child: WidgetLanguageToggle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
