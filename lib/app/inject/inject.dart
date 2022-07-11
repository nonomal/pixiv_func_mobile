import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';
import 'package:pixiv_func_mobile/app/data/history_service.dart';
import 'package:pixiv_func_mobile/app/data/settings_service.dart';


class Inject {
  static Future<void> init() async {
    Get.lazyPut(() => AuthClient().initSuper());
    Get.lazyPut(() => ApiClient().initSuper(Get.find()));

    await Get.putAsync(() => AccountService().init());
    await Get.putAsync(() => HistoryService().init());
    await Get.putAsync(() => SettingsService().init());
    // await Get.putAsync(() => VersionInfoController().init());
  }
}
