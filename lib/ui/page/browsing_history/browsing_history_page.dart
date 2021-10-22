/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:browsing_history_page.dart
 * 创建时间:2021/10/2 下午6:22
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/view_model/browsing_history_model.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class BrowsingHistoryPage extends StatelessWidget {
  const BrowsingHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: BrowsingHistoryModel(),
      builder: (BuildContext context, BrowsingHistoryModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('浏览历史记录'),
            actions: [
              IconButton(
                tooltip: '清空历史记录',
                icon: const Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('清空'),
                        content: const Text('确定要清空历史记录嘛?'),
                        actions: [
                          OutlinedButton(onPressed: () => Navigator.pop<bool>(context, true), child: const Text('确定')),
                          OutlinedButton(onPressed: () => Navigator.pop<bool>(context, false), child: const Text('取消')),
                        ],
                      );
                    },
                  ).then((value) {
                    if (true == value) {
                      model.clear();
                    }
                  });
                },
              )
            ],
          ),
          body: WaterfallFlow.builder(
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
      onModelReady: (BrowsingHistoryModel model) async {
        await model.init();
      },
    );
  }
}
