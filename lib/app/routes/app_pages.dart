import 'package:get/get.dart';

import '../modules/action_parent/bindings/action_parent_binding.dart';
import '../modules/action_parent/views/action_parent_view.dart';
import '../modules/choose_child/bindings/choose_child_binding.dart';
import '../modules/choose_child/views/choose_child_view.dart';
import '../modules/choose_user/bindings/choose_user_binding.dart';
import '../modules/choose_user/views/choose_user_view.dart';
import '../modules/detection/bindings/detection_binding.dart';
import '../modules/detection/views/detection_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login_report/bindings/login_report_binding.dart';
import '../modules/login_report/views/login_report_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_USER,
      page: () => const ChooseUserView(),
      binding: ChooseUserBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_REPORT,
      page: () => const LoginReportView(),
      binding: LoginReportBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_CHILD,
      page: () => const ChooseChildView(),
      binding: ChooseChildBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.DETECTION,
      page: () => const DetectionView(),
      binding: DetectionBinding(),
    ),
    GetPage(
      name: _Paths.ACTION_PARENT,
      page: () => const ActionParentView(),
      binding: ActionParentBinding(),
    ),
  ];
}
