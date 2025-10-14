import 'package:bluedock/common/helper/navigation/format_route.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';
import 'package:bluedock/features/dailyTask/presentation/pages/daily_task_detail_page.dart';
import 'package:bluedock/features/dailyTask/presentation/pages/daily_task_page.dart';
import 'package:bluedock/features/dailyTask/presentation/pages/form_daily_task_page.dart';
import 'package:bluedock/features/dailyTask/presentation/pages/success_daily_task_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/access_denied_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/page_not_found_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/under_construction_page.dart';
import 'package:bluedock/features/home/presentation/pages/error/you_are_offline_page.dart';
import 'package:bluedock/features/home/presentation/pages/home/home_page.dart';
import 'package:bluedock/features/home/presentation/pages/profile/change_password_page.dart';
import 'package:bluedock/features/home/presentation/pages/profile/profile_page.dart';
import 'package:bluedock/features/invoice/presentation/pages/invoice_detail_page.dart';
import 'package:bluedock/features/invoice/presentation/pages/manage_invoice_page.dart';
import 'package:bluedock/features/invoice/presentation/pages/success_invoice_page.dart';
import 'package:bluedock/features/login/presentation/pages/forgot_password_page.dart';
import 'package:bluedock/features/login/presentation/pages/login_page.dart';
import 'package:bluedock/features/login/presentation/pages/send_email_page.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_incenerator_entity.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_sewage_treatment_plant_entity.dart';
import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';
import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';
import 'package:bluedock/features/product/presentation/pages/detegasaIncenerator/add_detegasa_incenerator_page.dart';
import 'package:bluedock/features/product/presentation/pages/detegasaIncenerator/detegasa_incenerator_page.dart';
import 'package:bluedock/features/product/presentation/pages/detegasaOilyWaterSeparator/add_detegasa_oily_water_separator_page.dart';
import 'package:bluedock/features/product/presentation/pages/detegasaOilyWaterSeparator/detegasa_oily_water_separator_page.dart';
import 'package:bluedock/features/product/presentation/pages/detegasaSewageTreatmentPlant/add_detegasa_sewage_treatment_plant_page.dart';
import 'package:bluedock/features/product/presentation/pages/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_page.dart';
import 'package:bluedock/features/product/presentation/pages/productCategory/product_category_page.dart';
import 'package:bluedock/features/product/presentation/pages/quantumFreshWaterGenerator/add_quantum_fresh_water_generator_page.dart';
import 'package:bluedock/features/product/presentation/pages/quantumFreshWaterGenerator/quantum_fresh_water_generator_page.dart';
import 'package:bluedock/features/product/presentation/pages/sperreAirCompressor/add_sperre_air_compressor_page.dart';
import 'package:bluedock/features/product/presentation/pages/sperreAirCompressor/sperre_air_compressor_page.dart';
import 'package:bluedock/features/product/presentation/pages/sperreAirSystemSolutions/add_sperre_air_system_solutions_page.dart';
import 'package:bluedock/features/product/presentation/pages/sperreAirSystemSolutions/sperre_air_system_solutions_page.dart';
import 'package:bluedock/features/product/presentation/pages/sperreScrewCompressor/add_sperre_screw_compressor_page.dart';
import 'package:bluedock/features/product/presentation/pages/sperreScrewCompressor/sperre_screw_compressor_page.dart';
import 'package:bluedock/features/product/presentation/pages/successProduct/success_product_page.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/features/project/presentation/pages/project_detail_page.dart';
import 'package:bluedock/features/project/presentation/pages/project_form_page.dart';
import 'package:bluedock/features/project/presentation/pages/manage_project_page.dart';
import 'package:bluedock/features/project/presentation/pages/success_project_page.dart';
import 'package:bluedock/features/splash/pages/splash_page.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
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
        path: formatRoute(AppRoutes.dailyTask),
        name: AppRoutes.dailyTask,
        builder: (context, state) => const DailyTaskPage(),
        routes: [
          GoRoute(
            path: AppRoutes.formDailyTask,
            name: AppRoutes.formDailyTask,
            builder: (context, state) {
              final extra = state.extra as DailyTaskEntity?;
              return FormDailyTaskPage(task: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.detailDailyTask,
            name: AppRoutes.detailDailyTask,
            builder: (context, state) {
              final extra = state.extra as DailyTaskEntity;
              return DailyTaskDetailPage(task: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.successDaily,
            name: AppRoutes.successDaily,
            builder: (context, state) {
              final map = (state.extra is Map)
                  ? Map<String, dynamic>.from(state.extra as Map)
                  : const <String, dynamic>{};
              final title = map['title'] as String? ?? '';
              final image = map['image'] as String? ?? '';
              return SuccessDailyTaskPage(title: title, image: image);
            },
          ),
        ],
      ),
      GoRoute(
        path: formatRoute(AppRoutes.invoice),
        name: AppRoutes.invoice,
        builder: (context, state) => const ManageInvoicePage(),
        routes: [
          GoRoute(
            path: AppRoutes.invoiceDetail,
            name: AppRoutes.invoiceDetail,
            builder: (context, state) {
              final extra = state.extra as String;
              return InvoiceDetailPage(invoiceId: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.successInvoice,
            name: AppRoutes.successInvoice,
            builder: (context, state) {
              final extra = state.extra as String;
              return SuccessInvoicePage(title: extra);
            },
          ),
        ],
      ),
      GoRoute(
        path: formatRoute(AppRoutes.login),
        name: AppRoutes.login,
        builder: (context, state) => LoginPage(),
        routes: [
          GoRoute(
            path: AppRoutes.forgotPassword,
            name: AppRoutes.forgotPassword,
            builder: (context, state) => ForgotPasswordPage(),
          ),
          GoRoute(
            path: AppRoutes.sendEmail,
            name: AppRoutes.sendEmail,
            builder: (context, state) => const SendEmailPage(),
          ),
        ],
      ),
      GoRoute(
        path: formatRoute(AppRoutes.manageProject),
        name: AppRoutes.manageProject,
        builder: (context, state) => ManageProjectPage(),
        routes: [
          GoRoute(
            path: AppRoutes.formProject,
            name: AppRoutes.formProject,
            builder: (context, state) {
              final extra = state.extra as ProjectEntity?;
              return ProjectFormPage(project: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.projectDetail,
            name: AppRoutes.projectDetail,
            builder: (context, state) {
              final extra = state.extra as String;
              return ProjectDetailPage(projectId: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.successProject,
            name: AppRoutes.successProject,
            builder: (context, state) {
              final map = (state.extra is Map)
                  ? Map<String, dynamic>.from(state.extra as Map)
                  : const <String, dynamic>{};
              final title = map['title'] as String? ?? '';
              final image = map['image'] as String? ?? '';
              return SuccessProjectPage(title: title, image: image);
            },
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
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profile,
            builder: (context, state) {
              return ProfilePage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.changePassword,
                name: AppRoutes.changePassword,
                builder: (context, state) => ChangePasswordPage(),
              ),
            ],
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
            builder: (context, state) {
              final extra = state.extra as StaffEntity;
              return StaffDetailPage(staff: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.addOrUpdateStaff,
            name: AppRoutes.addOrUpdateStaff,
            builder: (context, state) {
              final extra = state.extra as StaffEntity?;
              return AddOrUpdateStaffPage(staff: extra);
            },
          ),
          GoRoute(
            path: AppRoutes.successStaff,
            name: AppRoutes.successStaff,
            builder: (context, state) {
              final map = (state.extra is Map)
                  ? Map<String, dynamic>.from(state.extra as Map)
                  : const <String, dynamic>{};
              final title = map['title'] as String? ?? '';
              final image = map['image'] as String? ?? '';
              return SuccessStaffPage(title: title, image: image);
            },
          ),
        ],
      ),
      GoRoute(
        path: formatRoute(AppRoutes.productCategory),
        name: AppRoutes.productCategory,
        builder: (context, state) => const ProductCategoryPage(),
        routes: [
          GoRoute(
            path: AppRoutes.successProduct,
            name: AppRoutes.successProduct,
            builder: (context, state) {
              final map = (state.extra is Map)
                  ? Map<String, dynamic>.from(state.extra as Map)
                  : const <String, dynamic>{};
              final title = map['title'] as String? ?? '';
              final image = map['image'] as String? ?? '';
              return SuccessProductPage(title: title, image: image);
            },
          ),
          GoRoute(
            path: AppRoutes.sperreAirCompressor,
            name: AppRoutes.sperreAirCompressor,
            builder: (context, state) {
              return SperreAirCompressorPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addSperreAirCompressor,
                name: AppRoutes.addSperreAirCompressor,
                builder: (context, state) {
                  final extra = state.extra as SperreAirCompressorEntity?;
                  return AddSperreAirCompressorPage(product: extra);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.sperreScrewCompressor,
            name: AppRoutes.sperreScrewCompressor,
            builder: (context, state) {
              return SperreScrewCompressorPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addSperreScrewCompressor,
                name: AppRoutes.addSperreScrewCompressor,
                builder: (context, state) {
                  final extra = state.extra as SperreScrewCompressorEntity?;
                  return AddSperreScrewCompressorPage(product: extra);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.sperreAirSystemSolutions,
            name: AppRoutes.sperreAirSystemSolutions,
            builder: (context, state) {
              return SperreAirSystemSolutionsPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addSperreAirSystemSolutions,
                name: AppRoutes.addSperreAirSystemSolutions,
                builder: (context, state) {
                  final extra = state.extra as SperreAirSystemSolutionsEntity?;
                  return AddSperreAirSystemSolutionsPage(product: extra);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.quantumFreshWaterGenerator,
            name: AppRoutes.quantumFreshWaterGenerator,
            builder: (context, state) {
              return QuantumFreshWaterGeneratorPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addQuantumFreshWaterGenerator,
                name: AppRoutes.addQuantumFreshWaterGenerator,
                builder: (context, state) {
                  final extra =
                      state.extra as QuantumFreshWaterGeneratorEntity?;
                  return AddQuantumFreshWaterGeneratorPage(product: extra);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.detegasaSewageTreatmentPlant,
            name: AppRoutes.detegasaSewageTreatmentPlant,
            builder: (context, state) {
              return DetegasaSewageTreatmentPlantPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addDetegasaSewageTreatmentPlant,
                name: AppRoutes.addDetegasaSewageTreatmentPlant,
                builder: (context, state) {
                  final extra =
                      state.extra as DetegasaSewageTreatmentPlantEntity?;
                  return AddDetegasaSewageTreatmentPlantPage(product: extra);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.detegasaIncenerator,
            name: AppRoutes.detegasaIncenerator,
            builder: (context, state) {
              return DetegasaInceneratorPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addDetegasaIncenerator,
                name: AppRoutes.addDetegasaIncenerator,
                builder: (context, state) {
                  final extra = state.extra as DetegasaInceneratorEntity?;
                  return AddDetegasaInceneratorPage(product: extra);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.detegasaOilyWaterSeparator,
            name: AppRoutes.detegasaOilyWaterSeparator,
            builder: (context, state) {
              return DetegasaOilyWaterSeparatorPage();
            },
            routes: [
              GoRoute(
                path: AppRoutes.addDetegasaOilyWaterSeparator,
                name: AppRoutes.addDetegasaOilyWaterSeparator,
                builder: (context, state) {
                  final extra =
                      state.extra as DetegasaOilyWaterSeparatorEntity?;
                  return AddDetegasaOilyWaterSeparatorPage(product: extra);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
