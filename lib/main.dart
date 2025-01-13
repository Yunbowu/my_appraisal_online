import 'package:flutter/material.dart';
import 'pages/my_appraisal_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Appraisal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(key: GlobalKey<MyHomePageState>()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final GlobalKey<MyHomePageState> key;
  const MyHomePage({
    required this.key,
  }) : super(key: key);


  @override
  MyHomePageState createState() => MyHomePageState();

  // 通过 GlobalKey 暴露的方法
  static MyHomePageState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyHomePageState>();
  }
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAppraisalPage()),
            );
          },
          child: Text('Go to My Appraisal Page'),
        ),
      ),
    );
  }
}
