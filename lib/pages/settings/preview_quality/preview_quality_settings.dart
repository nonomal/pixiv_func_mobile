/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:preview_quality_settings.dart
 * 创建时间:2021/11/26 下午5:02
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class PreviewQualitySettingsWidget extends StatelessWidget {
  const PreviewQualitySettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool?>(
      builder: (bool? snapshot, void Function(bool?) updater) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: const Text('中等'),
              value: false,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
            RadioListTile(
              title: const Text('大图'),
              value: true,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
          ],
        );
      },
      initialValue: Get.find<AppSettingsService>().previewQuality,
      onUpdate: (bool? value) {
        if (null != value) {
          Get.find<AppSettingsService>().previewQuality = value;
        }
      },
    );
  }
}