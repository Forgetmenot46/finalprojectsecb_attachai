import 'package:finalprojectsecb_attachai/showdetail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => _SharePageState();
}

//ประกาศตัวแปร _ratingsRef เพื่ออ้างอิงตาราง ratings
final DatabaseReference _ratingsRef =
    FirebaseDatabase.instance.ref().child("ratingAttachai");

// ฟังก์ชันดึงค่าเฉลี่ยคะแนนของแต่ละรายการ
Future<double> _fetchAverageRating(String itemId) async {
// ดึงข้อมูลจาก Firebase Realtime Database ของแต่ละรายการ "ratingsนักศึกษา/{itemId}"
  final snapshot = await _ratingsRef.child(itemId).get();
  // ตรวจสอบว่าข้อมูลมีอยู่จริงหรือไม่
  if (snapshot.exists) {
    // แปลงข้อมูลที่ดึงมาเป็น Map (Key-Value)
    final data = snapshot.value as Map<dynamic, dynamic>?;
    // ถ้าข้อมูลไม่เป็นค่าว่างให้ทำการคำนวณค่าเฉลี่ย
    if (data != null) {
      double totalRating = 0.0; // ตัวแปรเก็บผลรวมของคะแนนทั้งหมด
      int count = 0; // ตัวแปรเก็บจำนวนผู้ใช้ที่ให้คะแนน
      // วนลูปผ่านรายการทั้งหมดใน Firebase และรวมคะแนน
      data.forEach((userId, ratingData) {
        totalRating +=
            (ratingData['rating'] as num).toDouble(); // เพิ่มค่าคะแนน
        count++; // เพิ่มจำนวนผู้ให้คะแนน
      });

      // คำนวณค่าเฉลี่ย (totalRating / count) และคืนค่ากลับไป
      return count > 0 ? totalRating / count : 0.0;
    }
  }
  // หากไม่มีข้อมูลคะแนน ให้คืนค่า 0.0 (ไม่มีการให้คะแนน)
  return 0.0;
}

class _SharePageState extends State<SharePage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _energyImage;
  List<Map<String, dynamic>> _energyList = [];
  bool _isLoading = false;

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedType;

  // Energy types
  final List<String> _energyTypes = [
    'พลังงานแสงอาทิตย์',
    'พลังงานลม',
    'พลังงานน้ำ',
    'พลังงานชีวมวล',
    'อื่นๆ'
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  double averageRating = 0.0; // ตัวแปรเก็บค่าเฉลี่ยคะแนน

  void _fetchData() {
    _dbRef.child('CleanenergyAttachai').onValue.listen((event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<String, dynamic>> tempList = [];

        for (var key in data.keys) {
          var value = data[key];
          String imageUrl = value['imageUrl'] ?? "";

          // ถ้ารันบนเว็บ ให้แปลง URL ให้สามารถใช้ได้
          if (kIsWeb && imageUrl.isNotEmpty) {
            try {
              imageUrl = await FirebaseStorage.instance
                  .refFromURL(imageUrl)
                  .getDownloadURL();
            } catch (e) {
              print("Error loading image: $e");
            }
          }

          // โหลดคะแนนเฉลี่ยของแต่ละรายการ
          double averageRating = await _fetchAverageRating(key);

          tempList.add({
            'key': key,
            'title': value['name'],
            'description': value['description'],
            'type': value['type'],
            'imageUrl': imageUrl,
            'averageRating': averageRating,
          });
        }

        // เพิ่มการเรียงลำดับตาม `averageRating` จากมากไปน้อย
        tempList
            .sort((a, b) => b['averageRating'].compareTo(a['averageRating']));

        setState(() {
          _energyList = tempList;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _energyImage = image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String?> _uploadImage(String energyId) async {
    if (_energyImage == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('cleanenergyimagesAttachai/$energyId.jpg');

      if (kIsWeb) {
        await ref.putData(await _energyImage!.readAsBytes());
      } else {
        await ref.putFile(File(_energyImage!.path));
      }

      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  void _showAddForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'ชื่อพลังงานสะอาด'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'กรุณากรอกชื่อพลังงานสะอาด'
                      : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(labelText: 'ประเภท'),
                  items: _energyTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value),
                  validator: (value) =>
                      value == null ? 'กรุณาเลือกประเภทพลังงาน' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'คำอธิบาย'),
                  maxLines: 2,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'กรุณากรอกคำอธิบาย' : null,
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('เลือกรูปภาพ'),
                  onPressed: _pickImage,
                ),
                if (_energyImage != null)
                  Text('Selected image: ${_energyImage!.name}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('บันทึก'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_energyImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาเลือกรูปภาพ')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final newEnergyRef = _dbRef.child('CleanenergyAttachai').push();
      final imageUrl = await _uploadImage(newEnergyRef.key!);

      await newEnergyRef.set({
        'name': _nameController.text,
        'type': _selectedType,
        'description': _descriptionController.text,
        'imageUrl': imageUrl,
      });

      _clearForm();
      Navigator.pop(context);
      _fetchData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedType = null;
      _energyImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _energyList.length,
              itemBuilder: (context, index) {
                final item = _energyList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: item['imageUrl'] != null && item['imageUrl'] != ''
                        ? Image.network(
                            item['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 50, color: Colors.red),
                          )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                    title: Text(item['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item['type']} - ${item['description']}'),
                        Text(
                          "⭐ คะแนนความพึงพอใจเฉลี่ย: ${item['averageRating'].toStringAsFixed(1)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(3, 70, 148, 1)),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowDetail(
                            uid: item['key'],
                            title: item['title'],
                            description: item['description'],
                            type: item['type'],
                            imageUrl: item['imageUrl'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(3, 70, 148, 1),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
