/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:all_new_illust_content.dart
 * 创建时间:2021/10/4 下午8:37
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/all_new_illust_model.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class AllNewIllustContent extends StatelessWidget {
  const AllNewIllustContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: AllNewIllustModel(),
      builder: (BuildContext context, AllNewIllustModel model, Widget? child) {
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
    );
  }
}
