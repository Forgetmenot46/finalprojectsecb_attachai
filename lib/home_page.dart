import 'package:flutter/material.dart';

/// ธีมการออกแบบ: ฟุตบอล (เชลซีเป็นตัวเลือกหลัก)
class HomePage extends StatelessWidget {
  static const String routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ยินดีต้อนรับ: Welcome!',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
