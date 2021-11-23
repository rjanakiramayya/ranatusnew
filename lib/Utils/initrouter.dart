import 'package:get/get.dart';
import 'package:renatus/Models/order_status_model.dart';
import 'package:renatus/Views/Orders/cart_view.dart';
import 'package:renatus/Views/Orders/check_out_view.dart';
import 'package:renatus/Views/Orders/order_products.dart';
import 'package:renatus/Views/Orders/order_status_view.dart';
import 'package:renatus/Views/Orders/order_user_check.dart';
import 'package:renatus/Views/dashboard_view.dart';
import 'package:renatus/Views/login_view.dart';
import 'package:renatus/Views/main_view.dart';
import 'package:renatus/Views/my_date_filter.dart';
import 'package:renatus/Views/order_report_view.dart';
import 'package:renatus/Views/profile_view.dart';
import 'package:renatus/Views/registration_form.dart';
import 'package:renatus/Views/registration_preview_screen.dart';
import 'package:renatus/Views/registration_status_view.dart';
import 'package:renatus/Views/sponsor_check_view.dart';
import 'package:renatus/Views/tabular_count_view.dart';
import 'package:renatus/Views/tabular_genealogy_view.dart';
import 'package:renatus/Views/web_view.dart';

List<GetPage> routes = [
  GetPage(name: MainView.routeName, page: () => MainView()),
  GetPage(name: LoginView.routeName, page: () => const LoginView()),
  GetPage(name: ProfileView.routeName, page: () => const ProfileView()),
  GetPage(name: DashboardView.routeName, page: () => DashboardView()),
  GetPage(name: OrderUserCheck.routeName, page: () => OrderUserCheck()),
  GetPage(name: OrderProducts.routeName, page: () => OrderProducts()),
  GetPage(name: CartView.routeName, page: () => CartView()),
  GetPage(name: CheckOutView.routeName, page: () => const CheckOutView()),
  GetPage(name: OredrStatusView.routeName, page: () => const OredrStatusView()),
  GetPage(name: FWebView.routeName, page: () => FWebView()),
  GetPage(name: SponsorCheckView.routeName, page: () => SponsorCheckView()),
  GetPage(name: RegistrationForm.routeName, page: () => RegistrationForm()),
  GetPage(name: RegistrationPreviewScreen.routeName, page: () => RegistrationPreviewScreen()),
  GetPage(name: RegistrationStausView.routeName, page: () => const RegistrationStausView()),
  GetPage(name: MyDateFilter.routeName, page: () => MyDateFilter()),
  GetPage(name: OrderReportView.routeName, page: () => const OrderReportView()),
  GetPage(name: TabularGenealogy.routeName, page: () => const TabularGenealogy()),
  GetPage(name: TabularCountView.routeName, page: () => const TabularCountView()),


];


