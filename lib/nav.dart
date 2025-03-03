import 'package:flutter/material.dart';
import 'home_page.dart'; // หน้าหลัก
import 'share_page.dart'; // หน้าแชร์ข้อมูล
import 'howto_page.dart'; // หน้าคู่มือ

import 'package:firebase_database/firebase_database.dart';
import 'profilesetup.dart';
import 'auth.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final AuthService _auth = AuthService();
  late DatabaseReference _userRef;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      _userRef =
          FirebaseDatabase.instance.ref().child('usersAttachai/${user.uid}');
      _fetchUserData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final snapshot = await _userRef.get();
      if (snapshot.exists) {
        setState(() {
          _userData = Map<String, dynamic>.from(snapshot.value as Map);
        });
      } else {
        setState(() {
          _userData = null;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _userData = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProfileSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => profilesetup(
          userData: _userData,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _fetchUserData();
      }
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    SharePage(),
    HowToPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 70, 148, 1),
        title: Text(
          _selectedIndex == 0
              ? 'หน้าแรก: Home Page'
              : _selectedIndex == 1
                  ? 'Share'
                  : 'How To',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(3, 70, 148, 1),
              ),
              accountName: Text(
                _userData?['prefix'] != null
                    ? '${_userData!['prefix']} ${_userData!['firstName']} ${_userData!['lastName']}'
                    : 'ผู้ใช้: User',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                _auth.currentUser?.email ?? 'อีเมล: Email',
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _userData?['profileImage'] != null
                    ? NetworkImage(_userData!['profileImage'])
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                child: _userData?['profileImage'] == null
                    ? Icon(Icons.camera_alt)
                    : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue[900]),
              title: Text(
                'แกไขโปรไฟล์: Edit Profile',
                style: TextStyle(color: Colors.blue[900]),
              ),
              onTap: _navigateToProfileSetup,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue[900]),
              title: Text(
                'ออกจากระบบ: Logout',
                style: TextStyle(color: Colors.blue[900]),
              ),
              onTap: () async {
                await _auth.signOut(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Share',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'How to',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(3, 70, 148, 1),
        unselectedItemColor: Color.fromRGBO(3, 71, 148, 0.757),
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
