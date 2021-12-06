import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  //Pref Keys
  static const String PREF_IsLogin = 'IsLogin';
  static const String PREF_UserId = 'mUserId';
  static const String PREF_UserName = 'mUserName';
  static const String PREF_RegId = 'mRegId';
  static const String PREF_IDNo = 'mIDNO';
  static const String PREF_profilePic = 'mProdilePic';
  static const String PREF_lessAccess = 'mLessAccess';
  static const String PREF_EncriptRegId = 'mEncriptRegid';
  static const String PREF_LoginPincode = 'mLoginPincode';
  static const String PREF_password = 'mPassword';
  static const String PREF_mStatus = 'mStatus';

  static const String PREF_OpenCartCount = 'mOpenCartCount';
  static const String PREF_OrderUserId = 'mOrderUserId';
  static const String PREF_OrderCartSSID = 'mOrderCartSSID';
  static const String PREF_OrderCartUUID = 'mOrderCartUUID';

  static const String PREF_ShipName = 'mShipName';
  static const String PREF_ShipAddress = 'mShipAddress';
  static const String PREF_ShipCity = 'mShipCity';
  static const String PREF_ShipStateId = 'mShipStateId';
  static const String PREF_ShipStateName = 'mShipStateName';
  static const String PREF_ShipPincode = 'mShipPinCode';
  static const String PREF_ShipMobile = 'mShipMobile';



  //Staging
  static const String baseUrl = 'http://staging.renatuswellness.net/MobileAPP/api/Mobile/';
  static const String profileUrl = 'http://staging.renatuswellness.net/fileUpload/DistributorPhotos/';
  static const String gstUrl = 'http://staging.renatuswellness.net/fileUpload/GSTImages/';
  static const String panUrl = 'http://staging.renatuswellness.net/fileUpload/PanCardImages/';
  static const String bankUrl = 'http://staging.renatuswellness.net/fileUpload/BankPassbooks/';
  static const String addressUrl = 'http://staging.renatuswellness.net/fileUpload/AddressProof/';
  static const String terms = 'https://renatuswellness.net/Mob_Terms-Conditions.html';
  static const String about_us = 'https://renatuswellness.net/Mob_about-us.html';
  static const String Disclaimer = 'https://renatuswellness.net/Mob_Disclaimer.html';
  static const String PrivacyPolicy = 'https://renatuswellness.net/Mob_Privacy-Policy.html';
  static const String RefundPolicy = 'https://renatuswellness.net/Mob_Refund-policy.html';
  static const String BusinessPlan = 'https://renatuswellness.net/Mob_Business-plan.html';

  //Live
  // static const String baseUrl = '';

  // Apis
  static const String apiLogin = 'CheckLogin';
  static const String apiHome = 'BannerProduct';
  static const String apiMemberProfile = 'MemberProfile';
  static const String apiDashboard = 'Dashboard';
  static const String apiRegSponsorCheck = 'RegSponsorCheck';
  static const String apiInsertReg = 'InsertReg';
  static const String apiAChangePassword = 'ChangePassword';
  static const String apiForgotPassword = 'ForgotPwd';
  static const String apiTabularGenealogyOrderRpt ='UniLevelPrintViewCount';
  static const String apiTabularCountViewRpt ='UniLevelPrintViewCountRpt';
  static const String apiMemberKycRequestStsUsr ='MemberKycRequestStsUsr';
  static const String apiUploadBankDetailsRequestUsr ='UploadBankDetailsRequestUsr';
  static const String apiUploadIDProofDetailsRequestUsr ='UploadIDProofDetailsRequestUsr';
  static const String apiBankDetails ='BankDetails';
  static const String apiGetUploadBankDetailsUsr ='GetUploadBankDetailsUsr';
  static const String apiMyReferralsViewRpt ='DirectConsultantsReport';
  static const String apiDownloads ='DownloadsRpt';
  static const String apiCompanyBankRpt ='CompanyBanks';
  static const String apiGrievanceCellRpt ='GrievanceCell';
  static const String apiMemberKYC ='MemberKYC';
  static const String apiMemberUploads ='MemberUploads';
  static const String apiMemberPhotoRequest ='MemberPhotoRequest';
  static const String apiWalletSummary ='EwalletSummaryRpt';
  static const String apiCreditRequestReport ='CreditRequestReport';
  static const String apiFundTransfer ='FundTransfer';
  static const String apiCreditRequestddl ='CreditRequestddl';
  static const String apiCreditRequest ='CreditRequest';
  static const String apiUserCheckId ='CheckUserID';

//Payouts
  static const String apiIncomeReport ='WeeklyIncomeRpt';
  static const String apiOnholdReport ='WeeklyOnHoldRpt';
  static const String apischemeofferstatus ='SchemeandOfferStatus';
  static const String apiCashRewardAward='';
  static const String apiDropDown='GetDropdown';

  //OrderApis
  static const String apiOrderUserCheck ='CheckUserID';
  static const String apiOrderCheck ='OrderChk';
  static const String apiStates ='States';
  static const String apiGetOrderProducts ='GetOrderProducts';
  static const String apiTempRepurchaseItems ='TempRepurchaseItems';
  static const String apiGetModeDetails ='GetModeDetails';
  static const String apiEwalletBalanceUsr ='EwalletBalanceUsr';
  static const String apiInsRepurchaseOrder ='InsRepurchaseOrder';
  static const String apiRepurchaseOrderRpt ='RepurchaseOrderRpt';
  static const String apiGetSubTreeUniway ='GetSubTreeUniway';
  static const String apiGetParentTree ='GetParentTree';
  static const String apiCheckPlacement ='CheckPlacement';
  static const String apiBusinessReport ='BusinessReport';



  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  static const String somethingWrong = 'Some Thing Went Wrong';
  static const String NODATAFOUND = 'No Records Found';
  static const String rupeesymbol = '\u20B9';
  static const String success = 'SUCCESS';

  static launchUrl(String url) async {
    await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch ${url}';
  }


  //lists
  static const List<String> relations = [
    'Select',
    'MOTHER',
    'FATHER',
    'BROTHER',
    'WIFE',
    'SISTER',
    'SON',
    'DAUGHTER',
    'FRIEND',
    'GRAND SON',
    'GRAND DAUGHTER',
    'SON IN LAW',
    'DAUGHTER IN LAW',
    'BROTHER IN LAW',
    'SISTER IN LAW',
    'HUSBAND',
    'PROPRETER',
    'PARTNER',
    'DIRECTOR'
  ];

  static const double spaceZero = 0.0;

  static const double spaceXS = 2.0;

  static const double spaceS = 4.0;

  static const double spaceM = 8.0;

  static const double spaceL = 16.0;

  static const double spaceXL = 32.0;

  static const double marginZero = 0.0;

  static const double marginXS = 2.0;

  static const double marginS = 4.0;

  static const double marginM = 8.0;

  static const double marginL = 16.0;

  static const double marginXL = 32.0;

  static const double paddingZero = 0.0;

  static const double paddingXS = 2.0;

  static const double paddingS = 4.0;

  static const double paddingM = 8.0;

  static const double paddingL = 16.0;

  static const double paddingXL = 32.0;

  static const List<String> months = ['MM','jan', 'feb', 'mar', 'apr', 'may','jun','jul','aug','sep','oct','nov','dec'];

  static double getFontSize(double size) {
    return size * Get.height * 0.001;
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

}