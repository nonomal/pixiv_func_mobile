/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_illust_content.dart
 * 创建时间:2021/8/31 上午12:21
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/illust_content_model.dart';
import 'package:pixiv_func_android/view_model/user_illust_model.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class UserIllustContent extends StatelessWidget {
  final int id;
  final WorkType type;
  final IllustContentModel? illustContentModel;

  const UserIllustContent({Key? key, required this.id, required this.type, this.illustContentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: UserIllustModel(id, type),
      builder: (BuildContext context, UserIllustModel model, Widget? child) {
        return RefresherWidget(
          model,
          child: WaterfallFlow.builder(
            gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return IllustPreviewer(illust: model.list[index]);
            },
            itemCount: model.list.length,
          ),
        );
      },
      autoKeep: true,
    );
  }
}
