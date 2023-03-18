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
        },
      };
}
