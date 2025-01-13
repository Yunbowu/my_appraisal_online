import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class DataFormatPage extends StatefulWidget {
  @override
  _DataFormatPageState createState() => _DataFormatPageState();
}

class _DataFormatPageState extends State<DataFormatPage> {
  List<String> _files = [
    'appraisals.json', // 手动维护的文件列表

    // 在这里添加更多 JSON 文件名
  ];
  String _selectedFileContent = '';

  Future<void> _loadFileContent(String fileName) async {
    try {
      String data = await rootBundle.loadString('assets/data/$fileName');
      setState(() {
        _selectedFileContent = data;
      });
    } catch (e) {
      setState(() {
        _selectedFileContent = 'Error loading file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数据格式页'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_files[index]),
                  onTap: () => _loadFileContent(_files[index]),
                );
              },
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Text(_selectedFileContent),
            ),
          ),
        ],
      ),
    );
  }
} 