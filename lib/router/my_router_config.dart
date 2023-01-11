import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:npssolutions_mobile/pages/home/home_page.dart';
import 'package:npssolutions_mobile/pages/onboarding_page/onboarding_page.dart';

class MyRouterConfig {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
        routes: [
          GoRoute(
            path: 'home',
            builder: (context, state) => const HomePage(),
          ),
        ],
      ),
    ],
  );
}
