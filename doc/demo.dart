
import 'package:flutter/cupertino.dart';

class PayDialog extends StatefulWidget {
  final GlobalKey<PayDialogState> key;
  const PayDialog(this.key) : super(key: key);



  @override
  State<PayDialog> createState() => PayDialogState();


  // 通过 GlobalKey 暴露的方法
  static PayDialogState? of(BuildContext context) {
    return context.findAncestorStateOfType<PayDialogState>();
  }


}
class PayDialogState extends State<PayDialog> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    //底部弹出支付选择框
    return Container(
    );
  }
}
