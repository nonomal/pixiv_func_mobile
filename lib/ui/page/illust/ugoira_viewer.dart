/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ugoira_viewer.dart
 * 创建时间:2021/10/20 下午4:46
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/widget/gif_view.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/view_model/ugoira_viewer_model.dart';

class UgoiraViewer extends StatelessWidget {
  final int id;
  final String previewUrl;
  final String? heroTag;

  const UgoiraViewer({
    Key? key,
    required this.id,
    required this.previewUrl,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: UgoiraViewerModel(id, MediaQuery.of(context).size.width),
      builder: (BuildContext context, UgoiraViewerModel model, Widget? child) {
        return SizedBox(
          child: model.initialized
              ? GestureDetector(
                  onLongPress: () => model.save(),
                  child: GifView(
                    id: id,
                    previewUrl: previewUrl,
                    images: model.images,
                    delays: model.delays,
                    size: model.size,
                  ),
                )
              : GestureDetector(
                  onTap: () => model.play(),
                  onLongPress: () => model.save(),
                  child: Hero(
                    tag: heroTag ?? 'illust:$id',
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageViewFromUrl(
                          previewUrl,
                          color: settingsManager.isLightTheme ? Colors.white24 : Colors.black45,
                          colorBlendMode: BlendMode.srcOver,
                        ),
                        ViewState.busy == model.viewState
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.play_circle_outline_outlined, size: 70),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
