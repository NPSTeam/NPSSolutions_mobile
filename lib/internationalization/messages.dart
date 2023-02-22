import 'package:get/get.dart';
import 'package:npssolutions_mobile/internationalization/message_keys.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          MessageKeys.npsTeam: 'NPS Team',
          MessageKeys.getStarted: 'Get Started',
          MessageKeys.signInDialogTitle: 'Sign in',
          MessageKeys.signInDialogSignInButton: 'Sign In',
        },
        'vi_VN': {
          MessageKeys.npsTeam: 'NPS Team',
          MessageKeys.getStarted: 'Bắt Đầu',
          MessageKeys.signInDialogTitle: 'Đăng nhập',
          MessageKeys.signInDialogSignInButton: 'Đăng Nhập',
        },
      };
}
