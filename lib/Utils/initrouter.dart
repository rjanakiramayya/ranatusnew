import 'package:get/get.dart';
import 'package:renatus/Models/order_status_model.dart';
import 'package:renatus/Views/Orders/cart_view.dart';
import 'package:renatus/Views/Orders/check_out_view.dart';
import 'package:renatus/Views/Orders/order_products.dart';
import 'package:renatus/Views/Orders/order_status_view.dart';
import 'package:renatus/Views/Orders/order_user_check.dart';
import 'package:renatus/Views/add_fund_pre_view.dart';
import 'package:renatus/Views/add_fund_view.dart';
import 'package:renatus/Views/address_details_view.dart';
import 'package:renatus/Views/bank_details_view.dart';
import 'package:renatus/Views/company_bank_details.dart';
import 'package:renatus/Views/credit_request_report_data.dart';
import 'package:renatus/Views/download_report.dart';
import 'package:renatus/Views/fundtransfer_data.dart';
import 'package:renatus/Views/grievancecell.dart';
import 'package:renatus/Views/my_referrals.dart';
import 'package:renatus/Views/pan_details_view.dart';
import 'package:renatus/Views/pay_income_report.dart';
import 'package:renatus/Views/pay_onhold_report.dart';
import 'package:renatus/Views/pay_scheme_offer.dart';
import 'package:renatus/Views/scheme_offer_status.dart';
import 'package:renatus/Views/update_profile_picture.dart';
import 'package:renatus/Views/upload_gst_view.dart';
import 'package:renatus/Views/version_update_view.dart';
import 'package:renatus/Views/business_report_view.dart';
import 'package:renatus/Views/change_password_view.dart';
import 'package:renatus/Views/dashboard_view.dart';
import 'package:renatus/Views/forget_password_view.dart';
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
import 'package:renatus/Views/visual_genealogy_view.dart';
import 'package:renatus/Views/wallet_summary.dart';
import 'package:renatus/Views/wallet_transfer_data.dart';
import 'package:renatus/Views/web_view.dart';

List<GetPage> routes = [
  GetPage(name: MainView.routeName, page: () => MainView()),
  GetPage(name: LoginView.routeName, page: () => const LoginView()),
  GetPage(name: ChangePasswordView.routeName, page: () => const ChangePasswordView()),
  GetPage(name: ForgetPasswordView.routeName, page: () =>  const ForgetPasswordView()),
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
  GetPage(name: GenealogyUnilevel.routeName, page: () => GenealogyUnilevel()),
  GetPage(name: BusinessReportView.routeName, page: () => const BusinessReportView()),
  GetPage(name: TabularGenealogy.routeName, page: () => const TabularGenealogy()),
  GetPage(name: TabularCountView.routeName, page: () => const TabularCountView()),
  GetPage(name: VersionUpdateView.routeName, page:() => VersionUpdateView()),
  GetPage(name: BankDetailsView.routeName, page:() => const BankDetailsView()),
  GetPage(name: MyReferralsPage.routeName, page: () => const MyReferralsPage()),
  GetPage(name: PanDetailsView.routeName, page: () => const PanDetailsView()),
  GetPage(name: AddressDetailsView.routeName, page: () => const AddressDetailsView()),
  GetPage(name: UploadGSTNoView.routeName, page: () => const UploadGSTNoView()),
  GetPage(name: DownloadReportView.routeName, page: () => const DownloadReportView()),
  GetPage(name: CompanyBankDetails.routeName, page: () => const CompanyBankDetails()),
  GetPage(name: GrievanceCell.routeName, page: () => const GrievanceCell()),
  GetPage(name: WalletSummary.routeName, page: () => const WalletSummary()),
  GetPage(name: WalletTransferData.routeName, page: () => const WalletTransferData()),
  GetPage(name: UpdateProfilePicture.routeName, page: () =>  const UpdateProfilePicture()),
  GetPage(name: AddFundView.routeName, page: () =>  const AddFundView()),
  GetPage(name: AddFundPreView.routeName, page: () =>  AddFundPreView()),
  GetPage(name: FundTransferData.routeName, page: () => const FundTransferData()),
  GetPage(name: CreditRequestReportData.routeName, page: () => const CreditRequestReportData()),
  GetPage(name: PayIncomeReport.routeName, page: () => const PayIncomeReport()),
  GetPage(name: PayOnholdReport.routeName, page: () => const PayOnholdReport()),
  GetPage(name: PaySchemeOffer.routeName, page: () =>  const PaySchemeOffer()),
  GetPage(name: SchemeOfferStatus.routeName, page: () =>  SchemeOfferStatus()),

];


