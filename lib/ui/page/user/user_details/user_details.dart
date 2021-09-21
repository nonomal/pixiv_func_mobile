/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_details.dart
 * 创建时间:2021/8/31 上午12:24
 * 作者:小草
 */

import 'package:flutter/material.dart';

import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/user_model.dart';

class UserDetails extends StatelessWidget {
  final UserModel model;

  const UserDetails(this.model, {Key? key}) : super(key: key);

  Widget _buildItem(String name, String value, {bool isUrl = false}) {
    return Card(
      child: ListTile(
        onLongPress: () async {
          if (value.isNotEmpty) {
            await Utils.copyToClipboard(value);
            await platformAPI.toast('已将 $value 复制到剪切板');
          }
        },
        onTap: isUrl
            ? () async {
                if (Utils.urlIsTwitter(value)) {
                  final twitterUsername = Utils.findTwitterUsernameByUrl(value);
                  if (!await platformAPI.urlLaunch('twitter://user?screen_name=$twitterUsername')) {
                    platformAPI.urlLaunch(value);
                  }
                } else {
                  platformAPI.urlLaunch(value);
                }
              }
            : null,
        leading: Text(name),
        title: Center(
          child: Text(
            '$value',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    final user = model.userDetail!.user;
    final profile = model.userDetail!.profile;
    final workspace = model.userDetail!.workspace;

    if (null != user.comment) {
      children.add(
        InkWell(
          onLongPress: () => model.showOriginalComment = !model.showOriginalComment,
          child: Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: HtmlRichText(user.comment!),
            ),
          ),
        ),
      );
    }

    //user
    children.add(Divider());
    children.add(_buildItem('ID', user.id.toString()));
    children.add(Divider());
    children.add(_buildItem('账号', user.account));
    children.add(Divider());

    //profile
    if (null != profile.webpage) {
      children.add(_buildItem('网站', profile.webpage!));
      children.add(Divider());
    }

    if (profile.birth.isNotEmpty) {
      children.add(_buildItem('出生', profile.birth));
      children.add(Divider());
    }

    children.add(_buildItem('工作', profile.job));
    children.add(Divider());

    if (null != profile.twitterUrl) {
      children.add(_buildItem('twitter', profile.twitterUrl!, isUrl: true));
      children.add(Divider());
    }

    if (null != profile.pawooUrl) {
      children.add(_buildItem('pawoo', profile.pawooUrl!, isUrl: true));
      children.add(Divider());
    }

    //workspace

    if (workspace.pc.isNotEmpty) {
      children.add(_buildItem('电脑', workspace.pc));
      children.add(Divider());
    }

    if (workspace.monitor.isNotEmpty) {
      children.add(_buildItem('显示器', workspace.monitor));
      children.add(Divider());
    }

    if (workspace.tool.isNotEmpty) {
      children.add(_buildItem('软件', workspace.tool));
      children.add(Divider());
    }

    if (workspace.scanner.isNotEmpty) {
      children.add(_buildItem('扫描仪', workspace.scanner));
      children.add(Divider());
    }

    if (workspace.tablet.isNotEmpty) {
      children.add(_buildItem('数位板', workspace.tablet));
      children.add(Divider());
    }

    if (workspace.mouse.isNotEmpty) {
      children.add(_buildItem('鼠标', workspace.mouse));
      children.add(Divider());
    }

    if (workspace.printer.isNotEmpty) {
      children.add(_buildItem('打印机', workspace.printer));
      children.add(Divider());
    }

    if (workspace.desktop.isNotEmpty) {
      children.add(_buildItem('桌子上的东西', workspace.desktop));
      children.add(Divider());
    }

    if (workspace.music.isNotEmpty) {
      children.add(_buildItem('画图时听的音乐', workspace.music));
      children.add(Divider());
    }

    if (workspace.desk.isNotEmpty) {
      children.add(_buildItem('桌子', workspace.desk));
      children.add(Divider());
    }

    if (workspace.chair.isNotEmpty) {
      children.add(_buildItem('椅子', workspace.chair));
      children.add(Divider());
    }

    if (workspace.comment.isNotEmpty) {
      children.add(_buildItem('其他', workspace.comment));
      children.add(Divider());
    }

    return ListView(children: children);
  }
}