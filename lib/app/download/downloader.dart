/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:downloader.dart
 * 创建时间:2021/11/26 下午4:58
 * 作者:小草
 */

import 'dart:isolate';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/entity/illust.dart';
import 'package:pixiv_func_android/app/download/download_manager_controller.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/models/download_task.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class Downloader {
  static int _idCount = 0;

  static int get _currentId => _idCount++;

  static final ReceivePort _hostReceivePort = ReceivePort()..listen(_hostReceive);

  static Future<void> _hostReceive(dynamic message) async {
    if (message is DownloadTask) {
      final index = Get.find<DownloadManagerController>().tasks.indexWhere((task) => message.filename == task.filename);
      if (-1 != index) {
        //如果存在
        Get.find<DownloadManagerController>().tasks[index] = message;
        Get.find<DownloadManagerController>().stateChange(index, (task) {
          task.progress = message.progress;
          task.state = message.state;
        });
      } else {
        //如果不存在
        Get.find<DownloadManagerController>().add(message);
      }
    } else if (message is _DownloadComplete) {
      final saveResult = await Get.find<PlatformApi>().saveImage(message.imageBytes, message.filename);
      if (null == saveResult) {
        Get.find<PlatformApi>().toast('图片已经存在');
        return;
      }
      if (saveResult) {
        Get.find<PlatformApi>().toast('保存成功');
      } else {
        Get.find<PlatformApi>().toast('保存失败');
      }
    } else if (message is _DownloadError) {
      Get.find<PlatformApi>().toast('下载失败');
    }
  }

  static Future<void> _task(_DownloadStartProps props) async {
    final httpClient = Dio(
      BaseOptions(
        headers: const {'Referer': 'https://app-api.pixiv.net/'},
        responseType: ResponseType.bytes,
        sendTimeout: 6000,
        //60秒
        receiveTimeout: 60000,
        connectTimeout: 6000,
      ),
    );
    (httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };

    if (null != props.illust) {
      final task = DownloadTask.create(
        id: props.id,
        illust: props.illust!,
        originalUrl: props.originalUrl,
        url: props.url,
        filename: props.filename,
      );
      task.state = DownloadState.downloading;
      props.hostSendPort.send(task);
      await httpClient.get<Uint8List>(
        props.url,
        onReceiveProgress: (int count, int total) {
          task.progress = count / total;
          props.hostSendPort.send(task);
        },
      ).then((result) async {
        task.state = DownloadState.complete;
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename));
        props.hostSendPort.send(task);
      }).catchError((e, s) async {
        task.state = DownloadState.failed;
        props.hostSendPort.send(task);
        props.hostSendPort.send(_DownloadError());
      });
    } else {
      await httpClient
          .get<Uint8List>(
        props.url,
      )
          .then((result) async {
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename));
      }).catchError((e, s) async {
        props.hostSendPort.send(_DownloadError());
      });
    }
  }

  static Future<void> start({
    Illust? illust,
    required String url,
    int? id,
  }) async {
    final filename = url.substring(url.lastIndexOf('/') + 1);
    final imageUrl = Utils.replaceImageSource(url);

    if (await Get.find<PlatformApi>().imageIsExist(filename)) {
      Get.find<PlatformApi>().toast('图片已经存在');
      return;
    }

    final taskIndex = Get.find<DownloadManagerController>().tasks.indexWhere((task) => filename == task.filename);
    if (-1 != taskIndex && DownloadState.failed != Get.find<DownloadManagerController>().tasks[taskIndex].state) {
      Get.find<PlatformApi>().toast('下载任务已存在');
      return;
    }

    Get.find<PlatformApi>().toast('开始下载');
    Isolate.spawn(
      _task,
      _DownloadStartProps(
        hostSendPort: _hostReceivePort.sendPort,
        id: id ?? _currentId,
        illust: illust,
        originalUrl: url,
        url: imageUrl,
        filename: filename,
      ),
      debugName: 'IsolateDebug',
    );
  }
}

class _DownloadStartProps {
  SendPort hostSendPort;
  int id;
  Illust? illust;
  String originalUrl;
  String url;
  String filename;

  _DownloadStartProps({
    required this.hostSendPort,
    required this.id,
    required this.illust,
    required this.originalUrl,
    required this.url,
    required this.filename,
  });
}

class _DownloadComplete {
  final Uint8List imageBytes;
  final String filename;

  _DownloadComplete(this.imageBytes, this.filename);
}

class _DownloadError {}