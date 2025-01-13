import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'pages/my_appraisal_page.dart';
import 'pages/appraisal_detail_page.dart';
import 'pages/data_format_page.dart';

void main() {
  runApp(WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: '参考widget 和 数据格式',
          children: [
            WidgetbookComponent(
              name: '线上鉴定',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => MyAppraisalPage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: '鉴定详情页',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => AppraisalDetailPage(appraisalId: '1'),
                ),
              ],
            ),
            WidgetbookComponent(
              name: '参考数据格式',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => DataFormatPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}