import 'package:flutter/material.dart';
import 'dart:convert';

import 'appraisal_detail_page.dart';

// 定义鉴定信息的数据模型
class Appraisal {
  final String id;
  final String title;
  final String date;
  final String status;
  final String dimensions;
  final String imageUrl;
  final String orderNumber;
  final String paymentMethod;

  Appraisal({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.dimensions,
    required this.imageUrl,
    required this.orderNumber,
    required this.paymentMethod,
  });

  // 从 JSON 数据创建 Appraisal 实例
  factory Appraisal.fromJson(Map<String, dynamic> json) {
    return Appraisal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      dimensions: json['dimensions'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      orderNumber: json['orderNumber'] ?? '未知',
      paymentMethod: json['paymentMethod'] ?? '未知',
    );
  }
}

class MyAppraisalPage extends StatelessWidget {
  // 从 JSON 文件加载数据
  Future<List<Appraisal>> _loadAppraisals(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString('assets/data/appraisals.json');
      List<dynamic> jsonResult = json.decode(data);
      return jsonResult.map((json) => Appraisal.fromJson(json)).toList();
    } catch (e) {
      print('Error loading appraisals: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的鉴定'),
          bottom: TabBar(
            tabs: [
              Tab(text: '线上鉴定'),
              Tab(text: '线下鉴定'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAppraisalList(context), // 线上鉴定
            Center(child: Text('线下鉴定内容')), // 线下鉴定
          ],
        ),
      ),
    );
  }

  Widget _buildAppraisalList(BuildContext context) {
    return FutureBuilder<List<Appraisal>>(
      future: _loadAppraisals(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('加载数据出错'));
        } else {
          return ListView(
            children: snapshot.data!.map((appraisal) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Image.network(appraisal.imageUrl),
                  title: Text(appraisal.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('状态: ${appraisal.status}'),
                      Text('日期: ${appraisal.date}'),
                      Text('尺寸: ${appraisal.dimensions}'),
                      Row(
                        children: _buildActionButtons(context, appraisal),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppraisalDetailPage(appraisalId: appraisal.id),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, Appraisal appraisal) {
    List<Widget> buttons = [];
    if (appraisal.status == '审核中') {
      buttons.add(TextButton(
        onPressed: () => _cancelAppraisal(context, appraisal),
        child: Text('取消鉴定'),
      ));
    } else if (appraisal.status == '已驳回') {
      buttons.add(TextButton(
        onPressed: () => _cancelAppraisal(context, appraisal),
        child: Text('取消鉴定'),
      ));
      buttons.add(TextButton(
        onPressed: () => _reuploadAppraisal(context, appraisal),
        child: Text('重新上传'),
      ));
    }
    return buttons;
  }

  void _cancelAppraisal(BuildContext context, Appraisal appraisal) {
    // 取消鉴定逻辑
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('取消鉴定: ${appraisal.title} - 状态: ${appraisal.status} - 提交时间: ${appraisal.date}'),
    ));
  }

  void _reuploadAppraisal(BuildContext context, Appraisal appraisal) {
    // 重新上传逻辑
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('重新上传: ${appraisal.title} - 状态: ${appraisal.status} - 提交时间: ${appraisal.date}'),
    ));
  }
}