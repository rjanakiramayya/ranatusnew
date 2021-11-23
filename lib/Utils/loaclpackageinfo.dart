import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class LocalPackageInfo {
  static Future<PackageInfo> get _instance async => await PackageInfo.fromPlatform();
  static late PackageInfo _packageInfo;

  static Future<PackageInfo> init() async {
    _packageInfo = await _instance;
    return _packageInfo;
  }

  static String getVersion() {
    return _packageInfo.version;
  }

  static String getBuildId() {
    return _packageInfo.buildNumber;
  }

  static String getPackageName() {
    return _packageInfo.packageName;
  }

  static String getPlatformType() {
    if(Platform.isAndroid) {
      return 'A';
    } else {
      return 'I';
    }
  }

}