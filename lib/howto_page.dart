import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToPage extends StatelessWidget {
  final List<Map<String, dynamic>> energyTypes = [
    {
      'name': 'พลังงานแสงอาทิตย์',
      'url': 'https://th.wikipedia.org/wiki/พลังงานแสงอาทิตย์',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
      'description': 'พลังงานที่ได้จากแสงอาทิตย์ เป็นพลังงานสะอาดและยั่งยืน',
      'urlYoutube': 'https://www.youtube.com/watch?v=JD1WTJIwEJU',
    },
    {
      'name': 'พลังงานลม',
      'url': 'https://th.wikipedia.org/wiki/พลังงานลม',
      'icon': Icons.air,
      'color': Colors.lightBlue,
      'description': 'พลังงานที่ได้จากการเคลื่อนที่ของอากาศ ไม่ก่อให้เกิดมลพิษ',
      'urlYoutube': 'https://www.youtube.com/watch?v=k_KCmbE2ZAw',
    },
    {
      'name': 'พลังงานน้ำ',
      'url': 'https://th.wikipedia.org/wiki/พลังงานน้ำ',
      'icon': Icons.water,
      'color': Colors.blue,
      'description':
          'พลังงานที่ได้จากการเคลื่อนที่ของน้ำ เช่น เขื่อน หรือคลื่นในทะเล',
      'urlYoutube': 'https://www.youtube.com/watch?v=Y7s6N8dvjl8',
    },
    {
      'name': 'พลังงานชีวมวล',
      'url': 'https://th.wikipedia.org/wiki/พลังงานชีวมวล',
      'icon': Icons.eco,
      'color': Colors.green,
      'description':
          'พลังงานที่ได้จากสิ่งมีชีวิต เช่น พืช หรือของเสียจากการเกษตร',
      'urlYoutube': 'https://www.youtube.com/watch?v=P41NuIsjnEQ',
    },
  ];

  // ฟังก์ชันสำหรับแสดง AlertDialog เมื่อกดที่รายการพลังงาน
  void _showSourceSelectionDialog(
      BuildContext context, Map<String, dynamic> energy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'เลือกแหล่งข้อมูล ${energy['name']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(3, 70, 148, 1),
            ),
          ),
          content: Text('คุณต้องการดูข้อมูลจากแหล่งใด?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog
              },
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.menu_book),
              label: Text('Wikipedia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(3, 70, 148, 1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // ปิด AlertDialog
                final url = energy['url']!;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.play_circle_filled),
              label: Text('YouTube'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // ปิด AlertDialog
                final url = energy['urlYoutube']!;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          buttonPadding: EdgeInsets.symmetric(horizontal: 8),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(3, 70, 148, 0.1), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Text(
                  'เลือกประเภทพลังงานที่คุณสนใจ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(3, 70, 148, 1),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: energyTypes.length,
                  itemBuilder: (context, index) {
                    final energy = energyTypes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            _showSourceSelectionDialog(context, energy);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: energy['color'].withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    energy['icon'],
                                    size: 32,
                                    color: energy['color'],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        energy['name']!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        energy['description'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color.fromRGBO(3, 70, 148, 1),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
