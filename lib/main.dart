import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth.dart'; // น าเข้าไฟล์ที่ต้องการเรียกใช้จากหน้า  'auth.dart'
import 'signin_page.dart'; // น าเข้าไฟล์ที่ต้องการเรียกใช้จากหน้า  'signin_page.dart'
import 'home_page.dart'; // น าเข้าไฟล์ที่ต้องการเรียกใช้จากหน้า  'homepage_page.dart'
import 'profilesetup.dart';

//Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDUOXn2Ga_lxa3Vh2vV89FeLERJW_CmgEg",
            authDomain: "testfirebasesw.firebaseapp.com",
            databaseURL: "https://testfirebasesw-default-rtdb.firebaseio.com",
            projectId: "testfirebasesw",
            storageBucket: "testfirebasesw.appspot.com",
            messagingSenderId: "531001032330",
            appId: "1:531001032330:web:8ec67b1d834559b9fb7773",
            measurementId: "G-MNWTDY1WX0"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

// Class MyApp ส าหรับการแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  MyApp({super.key});
// ตรวจสอบ AuthService
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges, // ตรวจสอบการเชื่อมต่อ Stream
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomePage(); // ตรวจสอบว่ามี HomePage และท างานได้
          } else {
            return const SigninPage(); // ตรวจสอบว่ามี SigninPage และท างานได้
          }
        },
      ),
      routes: {
        SigninPage.routeName: (BuildContext context) => const SigninPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        ProfileSetup.routeName: (BuildContext context) => const ProfileSetup(),
      },
    );
  }
}
