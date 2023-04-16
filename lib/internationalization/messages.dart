import 'package:get/get.dart';
import 'package:npssolutions_mobile/internationalization/message_keys.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Onboarding Page
          MessageKeys.npsSolutions: 'NPS Solutions',
          MessageKeys.onboardingSlogan: 'Technology Solutions for Everyone',
          MessageKeys.getStarted: 'Get Started',
          MessageKeys.developedBy: 'Developed by',
          //
          MessageKeys.signInDialogTitle: 'Sign in',
          MessageKeys.signInDialogSignInButton: 'Sign In',
          // Login Page
          MessageKeys.loginPageTitle: 'Log In',
          MessageKeys.loginPageUsername: 'Username',
          MessageKeys.loginPagePassword: 'Password',
          MessageKeys.loginPageRememberMe: 'Remember me',
          MessageKeys.loginPageSignInButton: 'Login',
          MessageKeys.dontHaveAnAccount: 'Don\'t have an account?',
          MessageKeys.loginPageSignUp: 'Sign Up',
        },
        'vi_VN': {
          // Onboarding Page
          MessageKeys.npsSolutions: 'NPS Solutions',
          MessageKeys.onboardingSlogan: 'Giải pháp cho mọi nhà',
          MessageKeys.getStarted: 'Bắt Đầu',
          MessageKeys.developedBy: 'Được phát triển bởi',
          //
          MessageKeys.signInDialogSignInButton: 'Đăng Nhập',
          MessageKeys.signInDialogTitle: 'Đăng nhập',
          // Login Page
          MessageKeys.loginPageTitle: 'Đăng Nhập',
          MessageKeys.loginPageUsername: 'Tên đăng nhập',
          MessageKeys.loginPagePassword: 'Mật khẩu',
          MessageKeys.loginPageRememberMe: 'Nhớ mật khẩu',
          MessageKeys.loginPageSignInButton: 'Đăng nhập',
          MessageKeys.dontHaveAnAccount: 'Bạn chưa có tài khoản?',
          MessageKeys.loginPageSignUp: 'Đăng Ký',
        },
      };
}
