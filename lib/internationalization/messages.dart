import 'package:get/get.dart';
import 'package:npssolutions_mobile/internationalization/message_keys.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Common
          MessageKeys.notFoundPage: 'Not found page',
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
          // Sign Up Page
          MessageKeys.signUpPageTitle: 'Sign Up',
          MessageKeys.signUpPageUsername: 'Username',
          MessageKeys.signUpPhone: 'Phone',
          MessageKeys.signUpPassword: 'Password',
          MessageKeys.signUpConfirmPassword: 'Confirm Password',
          MessageKeys.signUpSignUp: 'Sign Up',
          MessageKeys.signUpDoYouHaveAnAccount: 'Do you have an account?',
          MessageKeys.signUpLogin: 'Login',
          // Drawer Component
          MessageKeys.tasks: 'Tasks',
          MessageKeys.scrumboard: 'Scrum Board',
          MessageKeys.system: 'System',
          MessageKeys.workspaceManagement: 'Workspace Management',
          MessageKeys.languageToggle: 'Language',
          MessageKeys.logOut: 'Log Out',
          // Home Title
          MessageKeys.homeTitleTask: 'Tasks',
          MessageKeys.homeTitleScrumboard: 'Scrum Board',
          MessageKeys.homeTitleWorkspace: 'Workspace',
          MessageKeys.homeTitleUntitled: 'Untitled',
          // Task Tab
          MessageKeys.remainingTasks: '@value remaining tasks',
          MessageKeys.addTask: 'Add Task',
          MessageKeys.addSection: 'Add Section',
        },
        'vi_VN': {
          // Common
          MessageKeys.notFoundPage: 'Không tìm thấy trang',
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
          // Sign Up Page
          MessageKeys.signUpPageTitle: 'Đăng Ký',
          MessageKeys.signUpPageUsername: 'Tên đăng nhập',
          MessageKeys.signUpPhone: 'Điện thoại',
          MessageKeys.signUpPassword: 'Mật khẩu',
          MessageKeys.signUpConfirmPassword: 'Xác nhận mật khẩu',
          MessageKeys.signUpSignUp: 'Đăng Ký',
          MessageKeys.signUpDoYouHaveAnAccount: 'Bạn đã có tài khoản?',
          MessageKeys.signUpLogin: 'Đăng nhập',
          // Drawer Component
          MessageKeys.tasks: 'Nhiệm vụ',
          MessageKeys.scrumboard: 'Scrum Board',
          MessageKeys.system: 'Hệ thống',
          MessageKeys.workspaceManagement: 'Không gian làm việc',
          MessageKeys.languageToggle: 'Ngôn ngữ',
          MessageKeys.logOut: 'Đăng xuất',
          // Home Title
          MessageKeys.homeTitleTask: 'Công việc',
          MessageKeys.homeTitleScrumboard: 'Scrum Board',
          MessageKeys.homeTitleWorkspace: 'Không gian làm việc',
          MessageKeys.homeTitleUntitled: 'Untitled',
          // Task Tab
          MessageKeys.remainingTasks: '@value chưa hoàn thành',
          MessageKeys.addTask: 'Thêm Task',
          MessageKeys.addSection: 'Thêm Section',
        },
      };
}
