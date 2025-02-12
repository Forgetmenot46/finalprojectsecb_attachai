import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'auth.dart';

class SharePage extends StatefulWidget {
  @override
  _SharePageState createState() => _SharePageState();
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
    _loadEnergyData();
  }

  Future<void> _loadEnergyData() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _dbRef.child('CleanenergyAttachai').once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map;
        _energyList = data.entries
            .map((e) =>
                {'id': e.key, ...Map<String, dynamic>.from(e.value as Map)})
            .toList();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
    setState(() => _isLoading = false);
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
      _loadEnergyData();

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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _energyList.length,
              itemBuilder: (context, index) {
                final energy = _energyList[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: energy['imageUrl'] != null
                        ? Image.network(
                            energy['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.energy_savings_leaf),
                    title: Text(energy['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${energy['type']}'),
                        Text('${energy['description']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
