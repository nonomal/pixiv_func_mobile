/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommended_page.dart
 * 创建时间:2021/8/25 上午10:19
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/ui/widget/segment_bar.dart';
import 'package:pixiv_func_android/view_model/recommended_model.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: RecommendedModel(),
      builder: (BuildContext context, RecommendedModel model, Widget? child) {
        return Column(
          children: [
            SegmentBar(
              items: ['插画', '漫画'],
              values: [WorkType.ILLUST, WorkType.MANGA],
              onSelected: (WorkType value) => model.type = value,
              selectedValue: model.type,
            ),
            Expanded(
              child: RefresherWidget(
                model,
                child: CustomScrollView(
                  slivers: [
                    SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 2,
                      itemBuilder: (BuildContext context, int index) => IllustPreviewer(illust: model.list[index]),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      itemCount: model.list.length,
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}