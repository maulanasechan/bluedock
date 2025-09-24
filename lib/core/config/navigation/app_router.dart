import 'package:bluedock/common/helper/navigation/format_route.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/home/presentation/pages/error/access_denied_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/page_not_found_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/under_construction_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/you_are_offline_page.dart';
import 'package:bluedock/features/home/presentation/pages/home/home_page.dart';
import 'package:bluedock/features/login/presentation/pages/forgot_password_page.dart';
import 'package:bluedock/features/login/presentation/pages/login_page.dart';
import 'package:bluedock/features/login/presentation/pages/send_email_page.dart';
import 'package:bluedock/features/splash/pages/splash_page.dart';
import 'package:bluedock/features/staff/presentation/pages/add_or_update_staff_page.dart';
import 'package:bluedock/features/staff/presentation/pages/manage_staff_page.dart';
import 'package:bluedock/features/staff/presentation/pages/staff_detail_page.dart';
import 'package:bluedock/features/staff/presentation/pages/success_staff_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: formatRoute(AppRoutes.splash),
    routes: [
      GoRoute(
        path: formatRoute(AppRoutes.splash),
        name: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: formatRoute(AppRoutes.login),
        name: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: AppRoutes.forgotPassword,
            name: AppRoutes.forgotPassword,
            builder: (context, state) => const ForgotPasswordPage(),
          ),
          GoRoute(
            path: AppRoutes.sendEmail,
            name: AppRoutes.sendEmail,
            builder: (context, state) => const SendEmailPage(),
          ),
        ],
      ),
      GoRoute(
        path: formatRoute(AppRoutes.home),
        name: AppRoutes.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: AppRoutes.pageNotFound,
            name: AppRoutes.pageNotFound,
            builder: (context, state) => const PageNotFoundPage(),
          ),
          GoRoute(
            path: AppRoutes.underConstruction,
            name: AppRoutes.underConstruction,
            builder: (context, state) => const UnderConstructionPage(),
          ),
          GoRoute(
            path: AppRoutes.youAreOffline,
            name: AppRoutes.youAreOffline,
            builder: (context, state) => const YouAreOfflinePage(),
          ),
          GoRoute(
            path: AppRoutes.accessDenied,
            name: AppRoutes.accessDenied,
            builder: (context, state) => const AccessDeniedPage(),
          ),
        ],
      ),
      GoRoute(
        path: formatRoute(AppRoutes.manageStaff),
        name: AppRoutes.manageStaff,
        builder: (context, state) => const ManageStaffPage(),
        routes: [
          GoRoute(
            path: AppRoutes.staffDetail,
            name: AppRoutes.staffDetail,
            builder: (context, state) => const StaffDetailPage(),
          ),
          GoRoute(
            path: AppRoutes.addOrUpdateStaff,
            name: AppRoutes.addOrUpdateStaff,
            builder: (context, state) => const AddOrUpdateStaffPage(),
          ),
          GoRoute(
            path: AppRoutes.successStaff,
            name: AppRoutes.successStaff,
            builder: (context, state) {
              final extra = state.extra as String;
              return SuccessStaffPage(title: extra);
            },
          ),
        ],
      ),
    ],
  );
}
