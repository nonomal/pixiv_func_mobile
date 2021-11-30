/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:filter_editor.dart
 * 创建时间:2021/11/29 上午11:47
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/components/dropdown_menu/dropdown_menu.dart';
import 'package:pixiv_func_android/components/sliding_segmented_control/sliding_segmented_control.dart';
import 'package:pixiv_func_android/models/dropdown_item.dart';
import 'package:pixiv_func_android/models/search_filter.dart';
import 'package:pixiv_func_android/pages/search/filter_editor/controller.dart';

class SearchFilterEditor extends StatelessWidget {
  final SearchFilter filter;
  final ValueChanged<SearchFilter> onChanged;

  const SearchFilterEditor({
    Key? key,
    required this.filter,
    required this.onChanged,
  }) : super(key: key);

  void _openStartDatePicker(BuildContext context) {
    final controller = Get.find<SearchFilterEditorController>();
    showDatePicker(
      context: context,
      initialDate: controller.dateTimeRange.start,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = controller.dateTimeRange;
        //+1年
        final valuePlus1 = DateTime(value.year + 1, value.month, value.day);
        if (temp.end.isAfter(valuePlus1) || value.isAfter(temp.end)) {
          //start差距大于1年
          controller.dateTimeRange = DateTimeRange(
            start: value,
            end: controller.currentDate.isAfter(valuePlus1) ? valuePlus1 : controller.currentDate,
          );
        } else {
          //start差距小于1年
          controller.dateTimeRange = DateTimeRange(start: value, end: temp.end);
        }
      }
    });
  }

  void _openEndDatePicker(BuildContext context) {
    final controller = Get.find<SearchFilterEditorController>();
    showDatePicker(
      context: context,
      initialDate: controller.dateTimeRange.end,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = controller.dateTimeRange;
        //-1年
        final minus1 = DateTime(value.year - 1, value.month, value.day);
        if (temp.start.isBefore(minus1) || value.isBefore(temp.start)) {
          //end差距大于1年
          controller.dateTimeRange = DateTimeRange(start: minus1, end: value);
        } else {
          //end差距小于1年
          controller.dateTimeRange = DateTimeRange(start: temp.start, end: value);
        }
      }
    });
  }

  Widget _buildDateRangeTypeEdit() {
    final controller = Get.find<SearchFilterEditorController>();
    return ListTile(
      title: const Text('时间范围'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownMenu<int>(
          menuItems: [
            DropdownItem(0, '不限'),
            DropdownItem(1, '一天内'),
            DropdownItem(2, '一周内'),
            DropdownItem(3, '一月内'),
            DropdownItem(4, '半年内'),
            DropdownItem(5, '一年内'),
            DropdownItem(-1, '自定义'),
          ],
          currentValue: controller.dateTimeRangeType,
          onChanged: (int? value) {
            controller.dateTimeRangeType = value!;
            if (!controller.enableDateRange && value != 0) {
              controller.enableDateRange = true;
            }
            switch (value) {
              case 0:
                controller.enableDateRange = false;
                break;
              case 1:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 1)),
                  end: controller.currentDate,
                );
                break;
              case 2:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 7)),
                  end: controller.currentDate,
                );
                break;
              case 3:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 30)),
                  end: controller.currentDate,
                );
                break;
              case 4:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 182)),
                  end: controller.currentDate,
                );
                break;
              case 5:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 365)),
                  end: controller.currentDate,
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeEdit(BuildContext context) {
    final controller = Get.find<SearchFilterEditorController>();
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _openStartDatePicker(context),
            child: Text(
              controller.startDate,
              style: Get.textTheme.headline5,
            ),
          ),
          const Text(' 到 '),
          InkWell(
            onTap: () => _openEndDatePicker(context),
            child: Text(
              controller.endDate,
              style: Get.textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchFilterEditorController(filter));
    return GetBuilder<SearchFilterEditorController>(
      builder: (SearchFilterEditorController controller) {
        return Container(
          height: 450,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SlidingSegmentedControl(
                  children: const <SearchSort, Widget>{
                    SearchSort.dateDesc: Text('时间降序'),
                    SearchSort.dateAsc: Text('时间升序'),
                    SearchSort.popularDesc: Text('热度降序'),
                  },
                  groupValue: controller.sort,
                  onValueChanged: (SearchSort? value) {
                    if (null != value) {
                      if (SearchSort.popularDesc == value && !Get.find<AccountService>().current!.user.isPremium) {
                        Get.find<PlatformApi>().toast('你不是Pixiv高级会员,所以该选项与时间降序行为一致');
                      }
                      controller.sort = value;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SlidingSegmentedControl(
                  children: const <SearchTarget, Widget>{
                    SearchTarget.partialMatchForTags: Text('标签(部分匹配)'),
                    SearchTarget.exactMatchForTags: Text('标签(完全匹配)'),
                    SearchTarget.titleAndCaption: Text('标签&简介'),
                  },
                  groupValue: controller.target,
                  onValueChanged: (SearchTarget? value) {
                    if (null != value) {
                      controller.target = value;
                    }
                  },
                ),
              ),
              const Divider(),
              Text(controller.bookmarkTotalText),
              Slider(
                value: controller.bookmarkTotalSelected.toDouble(),
                min: 0,
                max: controller.bookmarkTotalItems.length - 1,
                divisions: controller.bookmarkTotalItems.length - 1,
                onChanged: (double value) {
                  controller.bookmarkTotalSelected = value.round();
                },
              ),
              const Divider(),
              _buildDateRangeTypeEdit(),
              Visibility(
                visible: controller.dateTimeRangeType == -1,
                child: _buildDateRangeEdit(context),
              ),
              OutlinedButton(
                onPressed: () {
                  onChanged(controller.filter);
                  Get.back();
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      },
    );
  }
}