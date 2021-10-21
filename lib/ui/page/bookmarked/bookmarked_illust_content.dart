/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_illust_content.dart
 * 创建时间:2021/10/4 下午3:15
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/bookmarked_illust_model.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class BookmarkedIllustContent extends StatelessWidget {
  final BookmarkedFilter filter;

  const BookmarkedIllustContent(this.filter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: BookmarkedIllustModel(filter),
      builder: (BuildContext context, BookmarkedIllustModel model, Widget? child) {
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
