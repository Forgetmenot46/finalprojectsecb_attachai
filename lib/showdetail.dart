//โครงสร้างของหน้าจอที่ต้องแสดงผลจากการรับค่ามาจากอีกหน้าหนึ่ง ต้องใช้StatefulWidget
// Class StatefulWidget สําหรับแสดงผลหน้ารายละเอียดแบบรับค่ามาจากอีกหน้าหนึ่ง
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart'; // ใช้แปลงวันที่ให้เป็ นรูปแบบที่อ่านง่าย

class ShowDetail extends StatefulWidget {
  static const String routeName = '/showdetail';
//ส่วนสําหรับรับค่ามาจากอีกหน้าหนึ่ง
  final String uid;
  final String title;
  final String description;
  final String type;
  final String? imageUrl;
// รับค่าจากหน้า shart.dart มาหน้า showdetail โดยต้องเรียกใช้ผาน่ Widget
  const ShowDetail({
    required this.uid,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<ShowDetail> createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
//เขียนcode ภาษาdart
//ส่วนสําหรับการออกแบบหน้าจอ

  final DatabaseReference _commentRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
//ประกาศตัวแปรเก็บคาcomment
  List<Map<String, dynamic>> _comments = [];
  Map<String, dynamic> _userProfiles = {};
//ประกาศตัวแปรcommentcontrollerใหเปน TextEditingรับคาการแสดงความคิดเห็น
  final TextEditingController _commentController = TextEditingController();

  void _fetchUserProfiles() {
    _commentRef.child("usersAttachai").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _userProfiles.clear();
        data.forEach((userId, profile) {
          _userProfiles[userId] = {
            'firstName': profile['firstName'],
            'lastName': profile['lastName'],
            'profileImage': profile['profileImage'],
          };
        });
      }
      setState(() {});
    });
  }

// สร้างฟังกชันบันทึกความคิดเห็น ์
  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("กรุณาเข้าสู่ระบบก่อนแสดงความคิดเห็น")));
      return;
    }
    String userId = user.uid;
    String comment = _commentController.text.trim();
    String timestamp = DateTime.now().toIso8601String();
    await _commentRef.child("commentsAttachai/${widget.uid}").push().set({
      'userId': userId,
      'comment': comment,
      'timestamp': timestamp,
    });
    _commentController.clear();
  }

  void initState() {
    super.initState();
    _fetchComments();
    _fetchUserProfiles();
    _fetchAverageRating();
  }

//2.1 ประกาศตัวแปรเพื่อเก็บค่าดาว คะแนนความพึงพอใจและจํานวนคนที่ให้ดาว
  double _userRating = 0.0; //ประกาศตัวแปรเพื่อเก็บค่าดาวเริ ่มต้น
  double _averageRating = 0.0; //ประกาศตัวแปรเพื่อเก็บค่าคะแนนความพึงพอใจเฉลี่ย
  int _ratingCount = 0; //ประกาศตัวแปรเพื่อนับจํานวนคนที่ให้ดาว

//2.2 สร้างฟังกชันเพื่อเกบคาคะแนนความพึงพอใจที่ผู ้ใช้แตละคนให้ในแตละรายการลงในตาราง rating
//บันทึกคะแนนความพึงพอใจลง Realtime Databaseในตารางชื่อ ratingชื่อนักศึกษา
  Future<void> _submitRating(double rating) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("กรุณาเข้าสู ่ระบบก่อนให้คะแนน")));
      return;
    }

    String userId = user.uid;
    //เกบคะแนนความพึงพอใจกบวันเวลาให้คะแนน
    await _commentRef.child("ratingAttachai/${widget.uid}/$userId").set({
      'rating': rating,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _fetchAverageRating(); // อัปเดตค่าเฉลี่ยหลังจากให้คะแนน
  }

//2.3 สร้างฟังกชันเพื่อคํานวณคาคะแนนเฉลี่ยความพึงพอใจจากการให้คะแนนทั ้งหมดของผู ้ใช้
  //คํานวณคาเฉลี่ยคะแนน
  void _fetchAverageRating() {
    _commentRef.child("ratingAttachai/${widget.uid}").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        double totalRating =
            0.0; //ประกาศตัวแปรคะแนนทังหมดให้มีคาเริมต้นเป็นศุนย์
        int count = 0; //ประกาศตัวแปรสําหรับนับจํานวนผู ้ใช้ที่เข้ามาให้คะแนน
        //วนรอบเพื่ออานคาคะแนนทังหมดมาบวกรวมกนไว้
        data.forEach((userId, ratingData) {
          totalRating += (ratingData['rating'] as num).toDouble();
          count++;
        });
        //ตรวจสอบวามีคนมาให้คะแนนกคนถ้ามีมากกว่า0ให้เอาคะแนนทังหมดหารด้วยจํานวนคนที่มาให้คะแนนเกบในตัวแปรaverage
        _averageRating = count > 0 ? totalRating / count : 0.0;
        _ratingCount = count;
      } else {
        _averageRating = 0.0;
        _ratingCount = 0;
      }

      setState(() {});
    });
  }

// สร้างฟังกชัน์ ดึงความคิดเห็นจาก Firebaseมาแสดงผล
  void _fetchComments() {
    _commentRef.child("commentsAttachai/${widget.uid}").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _comments.clear();
        data.forEach((key, value) {
          _comments.add({
            'id': key,
            'userId': value['userId'],
            'comment': value['comment'],
            'timestamp': value['timestamp'],
          });
        });
        _comments.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียด"),
        backgroundColor: Color.fromRGBO(3, 70, 148, 1), // เปลี่ยนสี AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              Center(
                child: Image.network(widget.imageUrl!,
                    height: 200, fit: BoxFit.cover),
              )
            else
              const Center(
                child: Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            // Text("UID: ${widget.uid}",
            //     style:
            //         const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("ชื่อ: ${widget.title}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("ประเภท: ${widget.type}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("รายละเอียด: ${widget.description}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _userRating, // คาคะแนนเริ่มตน
              minRating: 1, // คาคะแนนต่ำสุดที่เลือกได
              direction: Axis.horizontal, // การจัดเรียงดาว (แนวนอน)
              allowHalfRating: true, // อนุญาตใหเลือกครึ่งคะแนน
              itemCount: 5, // จำนวนดาวทั้งหมด
              itemPadding:
                  EdgeInsets.symmetric(horizontal: 4.0), // ระยะหางระหวางดาว
              itemBuilder: (context, _) => Icon(
                Icons
                    .local_fire_department, //กำหนดรูปแบบของดาว (เชน ใช Icons.star)
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _submitRating(rating);
              },
            ),
            const SizedBox(height: 8),
            Text(
                "คะแนนเฉลี่ย: ${_averageRating.toStringAsFixed(1)} 🔥 ($_ratingCount รีวิว)",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        Color.fromRGBO(3, 70, 148, 1))), // เปลี่ยนสีคะแนนเฉลี่ย
//เพิ่มส่วนแสดงความคิดเห็น
// ส่วนการแสดงความคิดเห็น
            SizedBox(
              height: 20,
            ),
            const Text("ความคิดเห็น",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: _comments.isEmpty
                  ? const Center(child: Text("ยังไม่มีความคิดเห็น"))
                  : ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        final userId = comment['userId'];
                        final profile = _userProfiles[userId] ?? {};
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  profile['profileImage'] != null &&
                                          profile['profileImage'].isNotEmpty
                                      ? NetworkImage(profile['profileImage'])
                                      : const AssetImage(
                                              'assets/default_profile.png')
                                          as ImageProvider,
                            ),
                            title: Text(
                              "${profile['firstName'] ?? 'ไม่ทราบชื่อ'}${profile['lastName'] ?? ''}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(comment['comment']),
                            trailing: Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(DateTime.parse(comment['timestamp'])),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
// 🔹🔹 ฟอร์มเพิ่มความคิดเห็น
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "แสดงความคิดเห็น...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text("ส่ง"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(3, 70, 148, 1), // เปลี่ยนสีปุ่ม
                  ),
                ),
              ],
            ),
          ],
        ),
      ), //column
    );
  }
}
