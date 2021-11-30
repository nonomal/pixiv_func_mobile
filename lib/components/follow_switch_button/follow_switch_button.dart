/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follow_switch_button.dart
 * 创建时间:2021/11/24 下午1:55
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/components/follow_switch_button/controller.dart';

class FollowSwitchButton extends StatelessWidget {
  final int id;
  final bool initValue;

  const FollowSwitchButton({
    Key? key,
    required this.id,
    required this.initValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';

    final bool isRootController = !Get.isRegistered<FollowSwitchButtonController>(tag: controllerTag);
    if (isRootController) {
      Get.put(FollowSwitchButtonController(id, initValue: initValue), tag: controllerTag);
    }

    return GetBuilder<FollowSwitchButtonController>(
      tag: controllerTag,
      dispose: (state) {
        if (isRootController) {
          Get.delete<FollowSwitchButtonController>(tag: controllerTag);
          // print('根控制器删除:$controllerTag');
        }
      },
      builder: (controller) {
        return controller.requesting
            ? const RefreshProgressIndicator()
            : controller.isFollowed
                ? ElevatedButton(onPressed: controller.changeFollowState, child: const Text('已关注'))
                : OutlinedButton(onPressed: controller.changeFollowState, child: const Text('关注'));
      },
    );
  }
}