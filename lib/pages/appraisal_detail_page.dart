import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppraisalDetailPage extends StatelessWidget {
  final String appraisalId;

  AppraisalDetailPage({required this.appraisalId});

  Future<Map<String, dynamic>> _loadAppraisalDetail(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString('assets/data/appraisals.json');
      List<dynamic> jsonResult = json.decode(data);
      return jsonResult.firstWhere((json) => json['id'] == appraisalId, orElse: () => <String, dynamic>{});
    } catch (e) {
      print('Error loading appraisal detail: $e');
      return <String, dynamic>{};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadAppraisalDetail(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('加载数据出错'));
          } else {
            final appraisal = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProgressBar(appraisal['status'] ?? ''),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appraisal['title'] ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '状态: ${appraisal['status'] ?? ''}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '尺寸: ${appraisal['dimensions'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 16),
                        Image.network(
                          appraisal['imageUrl'] ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  _buildOrderInfo(context, appraisal),
                  _buildActionButtons(context, appraisal['status'] ?? '', appraisal),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProgressBar(String status) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStep('提交', true),
              _buildProgressStep('审核', status == '审核中' || status == '鉴定中' || status == '完成'),
              _buildProgressStep('鉴定', status == '鉴定中' || status == '完成'),
              _buildProgressStep('完成', status == '完成'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.green,
                  thickness: 2,
                ),
              ),
              Expanded(
                child: Divider(
                  color: status == '审核中' || status == '鉴定中' || status == '完成' ? Colors.green : Colors.grey,
                  thickness: 2,
                ),
              ),
              Expanded(
                child: Divider(
                  color: status == '鉴定中' || status == '完成' ? Colors.green : Colors.grey,
                  thickness: 2,
                ),
              ),
              Expanded(
                child: Divider(
                  color: status == '完成' ? Colors.green : Colors.grey,
                  thickness: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isActive ? Colors.green : Colors.grey,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo(BuildContext context, Map<String, dynamic> appraisal) {
    return Container(
      width: double.infinity,
      height: 111,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 307,
            top: 19,
            child: Container(
              width: 49,
              height: 19,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFF666666)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child:
              // Center(
              //   child: Text(
              //     '复制',
              //     style: TextStyle(
              //       color: Color(0xFF666666),
              //       fontSize: 12,
              //       fontFamily: 'PingFang SC',
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: '复制的内容'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已复制到剪贴板')),
                  );
                },
                child: Center(
                  child: Text(
                    '复制',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ),
          ),
          Positioned(
            left: 25,
            top: 20,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: appraisal['orderNumber'] ?? '未知'));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('鉴定单号已复制到剪贴板'),
                ));
              },
              child: Text(
                '鉴定单号：${appraisal['orderNumber'] ?? '未知'}',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 46,
            child: Text(
              '支付方式：${appraisal['paymentMethod'] ?? '未知'}',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 72,
            child: Text(
              '提交时间：${appraisal['date'] ?? '未知'}',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String status, Map<String, dynamic> appraisal) {
    List<Widget> buttons = [];
    if (status == '审核中') {
      buttons.add(TextButton(
        onPressed: () => _cancelAppraisal(context, appraisal),
        child: Text('取消鉴定'),
      ));
    } else if (status == '已驳回') {
      buttons.add(TextButton(
        onPressed: () => _cancelAppraisal(context, appraisal),
        child: Text('取消鉴定'),
      ));
      buttons.add(TextButton(
        onPressed: () => _reuploadAppraisal(context, appraisal),
        child: Text('重新上传'),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  void _cancelAppraisal(BuildContext context, Map<String, dynamic> appraisal) {
    // 取消鉴定逻辑
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('取消鉴定: ${appraisal['title']} - 状态: ${appraisal['status']} - 鉴定单号: ${appraisal['orderNumber']}'),
    ));
  }

  void _reuploadAppraisal(BuildContext context, Map<String, dynamic> appraisal) {
    // 重新上传逻辑
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('重新上传: ${appraisal['title']} - 状态: ${appraisal['status']} - 鉴定单号: ${appraisal['orderNumber']}'),
    ));
  }
} 