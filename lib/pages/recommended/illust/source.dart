/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/17 下午5:14
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/entity/illust.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/api/model/illusts.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class RecommendedIllustListSource extends DataSourceBase<Illust> {
  WorkType type;

  RecommendedIllustListSource(this.type);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getRecommendedIllusts(
          Utils.enumTypeStringToLittleHump(type),
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(result.illusts);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.next<Illusts>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.illusts);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}