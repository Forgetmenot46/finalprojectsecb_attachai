import 'package:flutter/material.dart';
import 'ChlsleaPlayerDetail.dart';

/// ธีมการออกแบบ: ฟุตบอล (เชลซีเป็นตัวเลือกหลัก)
class HomePage extends StatelessWidget {
  static const String routeName = '/homepage';

  final List<Map<String, String>> goalkeepers = [
    {
      'name': 'Petr Čech',
      'image': '../assets/images/ChlseaPlayer/Petr_Cech.jpg',
      'position': 'GK'
    },
  ];

  final List<Map<String, String>> defenders = [
    {
      'name': 'Ashley Cole',
      'image': '../assets/images/ChlseaPlayer/ashley-cole.jpg',
      'position': 'LWB'
    },
    {
      'name': 'John Terry',
      'image': '../assets/images/ChlseaPlayer/John_Terry.jpg',
      'position': 'LCB'
    },
    {
      'name': 'Marcel Desailly',
      'image': '../assets/images/ChlseaPlayer/Marcel_Desailly.jpg',
      'position': 'RCB'
    },
    {
      'name': 'Cesar Azpilicueta',
      'image': '../assets/images/ChlseaPlayer/cesar_azpilicueta.jpg',
      'position': 'RWB'
    },
  ];

  final List<Map<String, String>> midfielders = [
    {
      'name': 'Frank Lampard',
      'image': '../assets/images/ChlseaPlayer/Frank_Lampard.jpg',
      'position': 'LCM'
    },
    {
      'name': 'Claude Makélélé',
      'image': '../assets/images/ChlseaPlayer/Malelele.jpg',
      'position': 'CDM'
    },
    {
      'name': 'Michael Ballack',
      'image': '../assets/images/ChlseaPlayer/Michael_Ballack.jpg',
      'position': 'RCM'
    },
  ];

  final List<Map<String, String>> strikers = [
    {
      'name': 'Eden Hazard',
      'image': '../assets/images/ChlseaPlayer/Eden_Hazard.jpg',
      'position': 'LW'
    },
    {
      'name': 'Didier Drogba',
      'image': '../assets/images/ChlseaPlayer/Didier_Drogba.jpg',
      'position': 'ST'
    },
    {
      'name': 'Gianfranco Zola',
      'image': '../assets/images/ChlseaPlayer/Gianfranco_Zolo.jpg',
      'position': 'RW'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลังสนามฟุตบอล
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/images/football.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(3, 70, 148, 0.2), // สีน้ำเงินเชลซีแบบโปร่งใส
                  BlendMode.overlay,
                ),
              ),
            ),
          ),

          // เลเยอร์สำหรับเงาและ gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(3, 70, 148, 0.7), // สีน้ำเงินเชลซี
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),

          // โลโก้เชลซี
          Positioned(
            top: 35,
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('../assets/images/chelsea_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // เพิ่มข้อความ
          Positioned(
            top: 30,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(3, 70, 148, 0.85),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CHELSEA FC",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "นักเตะที่ดีที่สุดของสโมสรฟุตบอลเชลซี",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // แถบข้อมูลด้านล่าง
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(3, 70, 148, 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoItem(
                      Icons.emoji_events, "แชมป์พรีเมียร์ลีก 5 สมัย"),
                  _buildInfoItem(Icons.star, "แชมป์ยูฟ่า 2 สมัย"),
                  _buildInfoItem(Icons.sports_soccer, "สโมสรชั้นนำของอังกฤษ"),
                ],
              ),
            ),
          ),

          // ตำแหน่งผู้รักษาประตู
          _buildPlayerButton(context, 0.42, 0.68, "GK", goalkeepers[0]['name']!,
              goalkeepers[0]['image']!),
          // ตำแหน่งกองหลัง
          _buildPlayerButton(context, 0.02, 0.50, "LWB", defenders[0]['name']!,
              defenders[0]['image']!),
          _buildPlayerButton(context, 0.23, 0.57, "LCB", defenders[1]['name']!,
              defenders[1]['image']!),
          _buildPlayerButton(context, 0.62, 0.57, "RCB", defenders[2]['name']!,
              defenders[2]['image']!),
          _buildPlayerButton(context, 0.82, 0.50, "RWB", defenders[3]['name']!,
              defenders[3]['image']!),
          // ตำแหน่งกองกลาง
          _buildPlayerButton(context, 0.16, 0.30, "LCM",
              midfielders[0]['name']!, midfielders[0]['image']!),
          _buildPlayerButton(context, 0.42, 0.40, "CDM",
              midfielders[1]['name']!, midfielders[1]['image']!),
          _buildPlayerButton(context, 0.66, 0.30, "RCM",
              midfielders[2]['name']!, midfielders[2]['image']!),
          // ตำแหน่งกองหน้า
          _buildPlayerButton(context, 0.08, 0.15, "LW", strikers[0]['name']!,
              strikers[0]['image']!),
          _buildPlayerButton(context, 0.42, 0.15, "ST", strikers[1]['name']!,
              strikers[1]['image']!),
          _buildPlayerButton(context, 0.74, 0.15, "RW", strikers[2]['name']!,
              strikers[2]['image']!),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerButton(BuildContext context, double dx, double dy,
      String position, String playerName, String playerImage) {
    return Positioned(
      left: MediaQuery.of(context).size.width * dx,
      top: MediaQuery.of(context).size.height * dy,
      child: GestureDetector(
        onTap: () {
          // เปิดหน้าประวัตินักเตะ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerDetailPage(
                name: playerName,
                image: playerImage,
                position: position,
              ),
            ),
          );
        },
        child: Column(
          children: [
            // แสดงชื่อตำแหน่งด้านบน
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // ใส่พื้นหลังสีขาว
                borderRadius: BorderRadius.circular(10), // มุมโค้ง
              ),
              padding: EdgeInsets.all(10), // ระยะห่างภายใน
              child: Text(
                position,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // ขนาดตัวอักษรที่เหมาะสม
                  decoration: TextDecoration.none, // ไม่มีเส้นขีดทับ
                ),
              ),
            ),
            SizedBox(height: 5), // เพิ่มระยะห่างระหว่างตำแหน่งกับรูปภาพ
            // กล่องปุ่มวงกลมที่มีรูปภาพนักเตะ
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Color.fromRGBO(3, 70, 148, 1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // สีของเงา
                    spreadRadius: 2, // ขยายเงา
                    blurRadius: 10, // ความเบลอของเงา
                    offset: Offset(0, 3), // ตำแหน่งของเงา
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(playerImage),
                  fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับวงกลม
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
