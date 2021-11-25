import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/loaclpackageinfo.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/Orders/order_user_check.dart';
import 'package:renatus/Views/bank_details_view.dart';
import 'package:renatus/Views/change_password_view.dart';
import 'package:renatus/Views/dashboard_view.dart';
import 'package:renatus/Views/login_view.dart';
import 'package:renatus/Views/main_view.dart';
import 'package:renatus/Views/my_date_filter.dart';
import 'package:renatus/Views/my_referrals.dart';
import 'package:renatus/Views/profile_view.dart';
import 'package:renatus/Views/sponsor_check_view.dart';
import 'package:renatus/Views/tabular_genealogy_view.dart';
import 'package:renatus/Views/visual_genealogy_view.dart';

class MianDrawer extends StatelessWidget {
  const MianDrawer({Key? key}) : super(key: key);

  void _checkKycStatus(String type) {
    Map<String, String> param = {
      'regid':SessionManager.getString(Constants.PREF_RegId),
      'tblname':'MemberKyc',
      'stscolumn':'kycsts',
      'proftype':type,
    };
    NetworkCalls().callServer(Constants.apiMemberKycRequestStsUsr, param).then((value) {
      var data = jsonDecode(value!.body);
      //0-pendding 1-Approved -1 or 2 - allow to upload
      if(data['Requeststs']=='0') {
        Logger.ShowWorningAlert('Warning', 'Your Request Is Waiting for Admin Approval.');
      } else {
        if(type=='BANK') {
          Get.toNamed(BankDetailsView.routeName,arguments: data['Requeststs']);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SessionManager.getString(Constants.PREF_IsLogin) == '1'
          ? ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Constants.hexToColor('#35A31F'),
                        Constants.hexToColor('#35A31F'),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 46,
                        height: 45,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: SessionManager.getString(Constants.PREF_profilePic),
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: const Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                        size: 38,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          SessionManager.getString(Constants.PREF_UserName),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 3),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          SessionManager.getString(Constants.PREF_UserId),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () => {
                    Get.back(),
                    Get.toNamed(DashboardView.routeName),
                  },
                ),
                const Divider(),
                ExpansionTile(
                  title: const Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        ' View Profile ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () => {
                        Get.back(),
                        Get.toNamed(ProfileView.routeName),
                      },
                    ),
                    ListTile(
                      title: const Text(
                        ' Change Password',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () => {
                        Get.back(),
                        Get.toNamed(ChangePasswordView.routeName),
                      },
                    ),
                    ListTile(
                      title: const Text(
                        ' Profile Picture',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () => {
                        Navigator.pop(context),

                      },
                    ),
                  ],
                ),
                const Divider(),
                ExpansionTile(
                  title: const Text(
                    "My Orders",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        ' Order Now ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () => {
                        Get.back(),
                        Get.toNamed(OrderUserCheck.routeName),
                      },
                    ),
                    ListTile(
                      title: const Text(
                        ' Order Report ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: ()  {
                        Get.back();
                        Map<String, dynamic> args ={
                          'type':'Order Report Filter'
                        };
                        Get.toNamed(MyDateFilter.routeName,arguments: args);
                      },
                    ),
                  ],
                ),
                const Divider(),
                ExpansionTile(
                  title: const Text(
                    "KYC Manager",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        ' Upload Bank Details ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () => {
                        Get.back(),
                        _checkKycStatus('BANK'),
                      },
                    ),
                  ],
                ),
                const Divider(),
                ExpansionTile(
                  title: const Text(
                    " Team ",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        ' Visual Genealogy ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () => {
                        Get.back(),
                        Get.toNamed(GenealogyUnilevel.routeName,arguments: SessionManager.getString(Constants.PREF_IDNo)),
                      },
                    ),
                    ListTile(
                      title: const Text(
                        ' Tabular Genealogy ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: ()  {
                        Get.back();
                        Get.toNamed(TabularGenealogy.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        ' Business Report ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: ()  {
                        Get.back();
                        Map<String, dynamic> args ={
                          'type':'Business Report Filter'
                        };
                        Get.toNamed(MyDateFilter.routeName,arguments: args);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        ' My Referrals ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: ()  {
                        Get.back();
                        Get.toNamed(MyReferralsPage.routeName);
                      },
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    ' Registration ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: ()  {
                    Get.back();
                    Get.toNamed(SponsorCheckView.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () => {
                    Get.back(),
                    Get.defaultDialog(
                      title: 'Are you Sure ?',
                      middleText: 'Do You want To Logout.',
                      textConfirm: 'YES',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        SessionManager.ClearAllPREF();
                        Get.offAllNamed(MainView.routeName);
                      },
                    ),
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Version: ${LocalPackageInfo.getVersion()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )
          : ListView(
              children: [
                DrawerHeader(
                  child: Image.asset(
                    '${Constants.iconPath}rlogo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () => {
                    Navigator.pop(context),
                    Get.toNamed(LoginView.routeName),
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Registration',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () => {
                    Navigator.pop(context),
                    Get.toNamed(SponsorCheckView.routeName),
                  },
                ),
                const Divider(),
              ],
            ),
    );
  }
}
