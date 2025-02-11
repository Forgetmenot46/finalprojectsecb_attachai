import 'package:flutter/material.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Share')),
      body: Center(
        child: Text(
          'This is the Share Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
