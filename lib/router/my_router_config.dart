import 'package:go_router/go_router.dart';
import 'package:npssolutions_mobile/pages/home_page/home_page.dart';
import 'package:npssolutions_mobile/pages/login_page/login_page.dart';
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
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
        ],
      ),
    ],
  );
}
