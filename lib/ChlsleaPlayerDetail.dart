import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final String position;

  // ข้อมูลนักเตะ - ในโปรเจ็คจริงควรใช้ฐานข้อมูลหรือ API
  final Map<String, Map<String, dynamic>> playerData = {
    'Petr Čech': {
      'fullName': 'Petr Čech',
      'dateOfBirth': '20 พฤษภาคม 1982',
      'nationality': 'เช็ก',
      'yearsAtChelsea': '2004-2015',
      'appearances': 494,
      'cleanSheets': 228,
      'trophies': [
        'พรีเมียร์ลีก x4 (2004/05, 2005/06, 2009/10, 2014/15)',
        'เอฟเอคัพ x4 (2007, 2009, 2010, 2012)',
        'ลีกคัพ x3 (2005, 2007, 2015)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
        'ยูโรป้าลีก x1 (2013)',
      ],
      'records': 'สถิติการเก็บคลีนชีตมากที่สุดในพรีเมียร์ลีก (202 ครั้ง)',
      'achievements': 'ได้รับรางวัลถุงมือทองคำพรีเมียร์ลีก 4 ครั้ง',
      'description':
          'หนึ่งในผู้รักษาประตูที่ดีที่สุดในประวัติศาสตร์พรีเมียร์ลีก เป็นกำลังสำคัญในการพาเชลซีคว้าแชมป์แชมเปี้ยนส์ลีก 2012 ด้วยการเซฟลูกโทษในรอบชิงชนะเลิศ',
      'stats': {
        'คลีนชีต': '228 ครั้ง',
        'เซฟจุดโทษ': '17 ครั้ง',
        'อัตราการเซฟ': '76%',
        'ถ้วยรางวัลรวม': '13 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=f-vbRES3ZH4'
      }
    },
    'Ashley Cole': {
      'fullName': 'Ashley Cole',
      'dateOfBirth': '20 ธันวาคม 1980',
      'nationality': 'อังกฤษ',
      'yearsAtChelsea': '2006-2014',
      'appearances': 338,
      'goals': 7,
      'assists': 38,
      'trophies': [
        'พรีเมียร์ลีก x1 (2009/10)',
        'เอฟเอคัพ x4 (2007, 2009, 2010, 2012)',
        'ลีกคัพ x1 (2007)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
        'ยูโรป้าลีก x1 (2013)',
      ],
      'records': 'แบ็คซ้ายที่ประสบความสำเร็จที่สุดในประวัติศาสตร์พรีเมียร์ลีก',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 4 ครั้ง',
      'description':
          'แบ็คซ้ายชั้นยอดที่ผสมผสานทักษะการป้องกันและการบุกได้อย่างลงตัว เป็นหนึ่งในผู้เล่นตำแหน่งแบ็คซ้ายที่ดีที่สุดในประวัติศาสตร์',
      'stats': {
        'แท็คเกิ้ลเฉลี่ย': '2.5 ครั้ง/เกม',
        'สกัดบอลเฉลี่ย': '1.8 ครั้ง/เกม',
        'สร้างโอกาสทำประตู': '253 ครั้ง',
        'ถ้วยรางวัลรวม': '9 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=La2dwYSLz1w'
      }
    },
    'John Terry': {
      'fullName': 'John Terry',
      'dateOfBirth': '7 ธันวาคม 1980',
      'nationality': 'อังกฤษ',
      'yearsAtChelsea': '1998-2017',
      'appearances': 717,
      'goals': 67,
      'trophies': [
        'พรีเมียร์ลีก x5 (2004/05, 2005/06, 2009/10, 2014/15, 2016/17)',
        'เอฟเอคัพ x5 (2000, 2007, 2009, 2010, 2012)',
        'ลีกคัพ x3 (2005, 2007, 2015)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
        'ยูโรป้าลีก x1 (2013)',
      ],
      'records': 'กัปตันทีมที่ประสบความสำเร็จที่สุดในประวัติศาสตร์เชลซี',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 5 ครั้ง',
      'description':
          'กัปตันที่ยิ่งใหญ่ที่สุดของเชลซี เป็นผู้นำที่แข็งแกร่งและเป็นต้นแบบของนักเตะเยาวชน เป็นเสาหลักในแนวรับที่พาทีมประสบความสำเร็จมากมาย',
      'stats': {
        'ประตู': '67 ลูก',
        'แท็คเกิ้ลเฉลี่ย': '1.7 ครั้ง/เกม',
        'สกัดบอลเฉลี่ย': '2.2 ครั้ง/เกม',
        'ถ้วยรางวัลรวม': '17 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=78GVlZY9lzs'
      }
    },
    'Marcel Desailly': {
      'fullName': 'Marcel Desailly',
      'dateOfBirth': '7 กันยายน 1968',
      'nationality': 'ฝรั่งเศส',
      'yearsAtChelsea': '1998-2004',
      'appearances': 327,
      'goals': 10,
      'trophies': [
        'พรีเมียร์ลีก x1 (2004/05)',
        'เอฟเอคัพ x1 (2000)',
        'ลีกคัพ x1 (2005)',
        'แชมเปี้ยนส์ลีก x1 (1993)',
        'ยูโรป้าลีก x1 (1994)',
      ],
      'records': 'เป็นหนึ่งในกองหลังที่ดีที่สุดในประวัติศาสตร์',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 2 ครั้ง',
      'description': 'กองหลังที่มีความแข็งแกร่งและทักษะการอ่านเกมที่ยอดเยี่ยม',
      'stats': {
        'ประตู': '10 ลูก',
        'แท็คเกิ้ลเฉลี่ย': '1.5 ครั้ง/เกม',
        'สกัดบอลเฉลี่ย': '2.0 ครั้ง/เกม',
        'ถ้วยรางวัลรวม': '4 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=FzrS6rpcmGQ'
      }
    },
    'Cesar Azpilicueta': {
      'fullName': 'Cesar Azpilicueta',
      'dateOfBirth': '28 สิงหาคม 1989',
      'nationality': 'สเปน',
      'yearsAtChelsea': '2012-2023',
      'appearances': 400,
      'goals': 15,
      'trophies': [
        'พรีเมียร์ลีก x2 (2014/15, 2016/17)',
        'เอฟเอคัพ x1 (2018)',
        'ลีกคัพ x1 (2015)',
        'แชมเปี้ยนส์ลีก x1 (2021)',
        'ยูโรป้าลีก x2 (2013, 2019)',
      ],
      'records': 'เป็นกัปตันทีมที่ประสบความสำเร็จ',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 1 ครั้ง',
      'description': 'แบ็คขวาที่มีความสามารถในการป้องกันและการโจมตี',
      'stats': {
        'ประตู': '15 ลูก',
        'แท็คเกิ้ลเฉลี่ย': '2.0 ครั้ง/เกม',
        'สกัดบอลเฉลี่ย': '1.5 ครั้ง/เกม',
        'ถ้วยรางวัลรวม': '6 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=SIlpedA0sYQ'
      }
    },
    'Frank Lampard': {
      'fullName': 'Frank Lampard',
      'dateOfBirth': '20 มิถุนายน 1978',
      'nationality': 'อังกฤษ',
      'yearsAtChelsea': '2001-2014',
      'appearances': 648,
      'goals': 211,
      'trophies': [
        'พรีเมียร์ลีก x3 (2004/05, 2005/06, 2009/10)',
        'เอฟเอคัพ x4 (2007, 2009, 2010, 2012)',
        'ลีกคัพ x2 (2005, 2007)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
        'ยูโรป้าลีก x1 (2013)',
      ],
      'records': 'เป็นผู้ทำประตูสูงสุดตลอดกาลของเชลซี',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 3 ครั้ง',
      'description':
          'กองกลางที่มีทักษะการทำประตูและการสร้างสรรค์เกมที่ยอดเยี่ยม',
      'stats': {
        'ประตู': '211 ลูก',
        'แอสซิสต์': '145 ครั้ง',
        'ถ้วยรางวัลรวม': '10 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=NJlmq-z8XGw&t=771s'
      }
    },
    'Claude Makélélé': {
      'fullName': 'Claude Makélélé',
      'dateOfBirth': '18 กุมภาพันธ์ 1973',
      'nationality': 'ฝรั่งเศส',
      'yearsAtChelsea': '2003-2012',
      'appearances': 217,
      'goals': 30,
      'trophies': [
        'พรีเมียร์ลีก x2 (2004/05, 2005/06)',
        'เอฟเอคัพ x1 (2007)',
        'ลีกคัพ x2 (2005, 2007)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
      ],
      'records': 'เป็นหนึ่งในกองกลางที่ดีที่สุดในประวัติศาสตร์',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 2 ครั้ง',
      'description': 'กองกลางที่มีความสามารถในการป้องกันและการควบคุมเกม',
      'stats': {
        'ประตู': '30 ลูก',
        'แท็คเกิ้ลเฉลี่ย': '3.0 ครั้ง/เกม',
        'สกัดบอลเฉลี่ย': '2.5 ครั้ง/เกม',
        'ถ้วยรางวัลรวม': '6 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=xl4e1IVET5s'
      }
    },
    'Michael Ballack': {
      'fullName': 'Michael Ballack',
      'dateOfBirth': '26 กันยายน 1976',
      'nationality': 'เยอรมัน',
      'yearsAtChelsea': '2006-2010',
      'appearances': 167,
      'goals': 58,
      'trophies': [
        'พรีเมียร์ลีก x1 (2009/10)',
        'เอฟเอคัพ x1 (2007)',
        'ลีกคัพ x1 (2007)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
      ],
      'records': 'เป็นกองกลางที่มีความสามารถในการทำประตู',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 1 ครั้ง',
      'description': 'กองกลางที่มีทักษะการทำประตูและการสร้างสรรค์เกม',
      'stats': {
        'ประตู': '58 ลูก',
        'แอสซิสต์': '40 ครั้ง',
        'ถ้วยรางวัลรวม': '4 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=qy_1jheuHAk'
      }
    },
    'Eden Hazard': {
      'fullName': 'Eden Hazard',
      'dateOfBirth': '7 มกราคม 1991',
      'nationality': 'เบลเยียม',
      'yearsAtChelsea': '2012-2019',
      'appearances': 352,
      'goals': 110,
      'trophies': [
        'พรีเมียร์ลีก x2 (2014/15, 2016/17)',
        'เอฟเอคัพ x1 (2018)',
        'ลีกคัพ x1 (2015)',
        'แชมเปี้ยนส์ลีก x1 (2021)',
        'ยูโรป้าลีก x2 (2013, 2019)',
      ],
      'records': 'เป็นหนึ่งในผู้เล่นที่ดีที่สุดในประวัติศาสตร์เชลซี',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 2 ครั้ง',
      'description': 'ปีกที่มีความสามารถในการทำประตูและการสร้างสรรค์เกม',
      'stats': {
        'ประตู': '110 ลูก',
        'แอสซิสต์': '92 ครั้ง',
        'ถ้วยรางวัลรวม': '6 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=Hu5ojmaSWks&t=84s'
      }
    },
    'Didier Drogba': {
      'fullName': 'Didier Drogba',
      'dateOfBirth': '11 มีนาคม 1978',
      'nationality': 'ไอวอรีโคสต์',
      'yearsAtChelsea': '2004-2012, 2014',
      'appearances': 381,
      'goals': 164,
      'trophies': [
        'พรีเมียร์ลีก x4 (2004/05, 2005/06, 2009/10, 2014/15)',
        'เอฟเอคัพ x4 (2007, 2009, 2010, 2012)',
        'ลีกคัพ x3 (2005, 2007, 2015)',
        'แชมเปี้ยนส์ลีก x1 (2012)',
        'ยูโรป้าลีก x1 (2013)',
      ],
      'records': 'เป็นผู้ทำประตูสูงสุดในประวัติศาสตร์ของเชลซี',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 2 ครั้ง',
      'description': 'กองหน้าที่มีความสามารถในการทำประตูและการสร้างสรรค์เกม',
      'stats': {
        'ประตู': '164 ลูก',
        'แอสซิสต์': '86 ครั้ง',
        'ถ้วยรางวัลรวม': '10 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=PFKnPyxicuc'
      }
    },
    'Gianfranco Zola': {
      'fullName': 'Gianfranco Zola',
      'dateOfBirth': '5 กรกฎาคม 1966',
      'nationality': 'อิตาลี',
      'yearsAtChelsea': '1996-2003',
      'appearances': 312,
      'goals': 80,
      'trophies': [
        'พรีเมียร์ลีก x1 (1996/97)',
        'เอฟเอคัพ x1 (1997)',
        'ลีกคัพ x1 (1998)',
        'ยูโรป้าลีก x1 (2013)',
      ],
      'records': 'เป็นหนึ่งในผู้เล่นที่ดีที่สุดในประวัติศาสตร์เชลซี',
      'achievements': 'ติดทีมยอดเยี่ยมแห่งปีพรีเมียร์ลีก 2 ครั้ง',
      'description': 'กองหน้าที่มีทักษะการทำประตูและการสร้างสรรค์เกม',
      'stats': {
        'ประตู': '80 ลูก',
        'แอสซิสต์': '40 ครั้ง',
        'ถ้วยรางวัลรวม': '4 รายการ',
      },
      'biography': {
        'ลิงค์ประวิติ': 'https://www.youtube.com/watch?v=_kmgoFxadjA'
      }
    },
  };

  PlayerDetailPage({
    required this.name,
    required this.image,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final player = playerData[name] ??
        {
          'fullName': name,
          'position': position,
          'yearsAtChelsea': 'ไม่มีข้อมูล',
          'description': 'ไม่มีข้อมูลเพิ่มเติมสำหรับนักเตะนี้',
          'stats': {'การลงเล่น': 'ไม่มีข้อมูล'}
        };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: Color.fromRGBO(3, 70, 148, 1),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('ข้อมูลส่วนตัว'),
                    _buildInfoRow('ตำแหน่ง', position),
                    _buildInfoRow('ชื่อเต็ม', player['fullName']),
                    if (player['dateOfBirth'] != null)
                      _buildInfoRow('วันเกิด', player['dateOfBirth']),
                    if (player['nationality'] != null)
                      _buildInfoRow('สัญชาติ', player['nationality']),
                    _buildInfoRow('ช่วงเวลาที่เชลซี', player['yearsAtChelsea']),
                    SizedBox(height: 10),
                    Text(
                      player['description'],
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (player['biography'] != null &&
                        player['biography']['ลิงค์ประวิติ'] != null)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final url = player['biography']['ลิงค์ประวิติ'];
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          icon: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: Text(
                            'ดูประวัติที่ YouTube',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(3, 70, 148, 1),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                color: Color.fromRGBO(245, 245, 245, 1),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('สถิติการเล่น'),
                    SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount:
                          (player['stats'] as Map<String, dynamic>).length,
                      itemBuilder: (context, index) {
                        final statKey =
                            (player['stats'] as Map<String, dynamic>)
                                .keys
                                .elementAt(index);
                        final statValue =
                            (player['stats'] as Map<String, dynamic>)[statKey];

                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                statValue,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromRGBO(3, 70, 148, 1),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                statKey,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (player['trophies'] != null)
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('ถ้วยรางวัลกับเชลซี'),
                      SizedBox(height: 10),
                      ...(player['trophies'] as List<String>).map((trophy) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Color.fromARGB(255, 218, 165, 32),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  trophy,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              if (player['achievements'] != null)
                Container(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('ความสำเร็จ'),
                      SizedBox(height: 10),
                      Text(
                        player['achievements'],
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      if (player['records'] != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            player['records'],
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(3, 70, 148, 1),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
