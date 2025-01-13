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
          name: 'Pages',
          children: [
            WidgetbookComponent(
              name: 'MyAppraisalPage',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => MyAppraisalPage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppraisalDetailPage',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => AppraisalDetailPage(appraisalId: '1'),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'DataFormatPage',
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