//โครงสร้างของหน้าจอที่ต้องแสดงผลจากการรับค่ามาจากอีกหน้าหนึ่ง ต้องใช้StatefulWidget
// Class StatefulWidget สําหรับแสดงผลหน้ารายละเอียดแบบรับค่ามาจากอีกหน้าหนึ่ง
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
      appBar: AppBar(title: Text("...")),
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
                    decoration: const InputDecoration(
                      hintText: "แสดงความคิดเห็น...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text("ส่ง"),
                ),
              ],
            ),
          ],
        ),
      ), //column
    );
  }
}
