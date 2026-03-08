import 'dart:developer';

import 'package:curacare/models/user_model.dart';
import 'package:curacare/pages/homepage.dart';
import 'package:curacare/pages/login_page.dart';
import 'package:curacare/pages/user_condition_page.dart';
import 'package:curacare/services/authentication_service.dart';
import 'package:curacare/services/user_service.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/format_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var kPrimaryGreen = const Color(0xFF2ECC71);
  var kSoftGreen = const Color(0xFFE9FBF3);
  var textGreen = const Color.fromARGB(255, 0, 153, 5);

  User? get user => FirebaseAuth.instance.currentUser;
  late Future<UserModel?> userProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfile = UserService.getByUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "โปรไฟล์",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text("การกำหนดและการตั้งค่า", style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UserModel?>(
              future: userProfile,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return FormatCard(
                    card_title: "โปรดเข้าสู่ระบบ",
                    card_sup_title: "",
                    icon: Icons.person_outlined,
                    toScreen: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    ),
                  );
                }
                final userData = snapshot.data;
                return FormatCard(
                  card_title: userData!.username,
                  card_sup_title: user?.email ?? "",
                  icon: Icons.person_outlined,
                );
              },
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: const Text(
                "ข้อมูลการรักษา",
                style: TextStyle(fontSize: 20),
              ),
            ),
            FormatCard(
              card_title: "บันทึกโรค",
              card_sup_title: "จัดการบันทึกเปลี่ยนแปลงการบันทึกโรค",
              icon: Icons.favorite_border_outlined,
              toScreen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserConditionPage()),
                );
              },
            ),
            FormatCard(
              card_title: "บันทึกยา",
              card_sup_title: "จัดการบันทึกเปลี่ยนแปลงการบันทึกยา",
              icon: Icons.article_outlined,
              color: Colors.blue,
              toScreen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
            FutureBuilder<UserModel?>(
              future: userProfile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("โหลดข้อมูล", style: TextStyle(fontSize: 20)),
                    ],
                  );
                }
                if (!snapshot.hasData) {
                  return Container();
                }
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Stack(
                    children: [
                      const FormatCard(
                        card_title: "Sign Out",
                        card_sup_title: "",
                        icon: Icons.logout,
                        color: Colors.red,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              log("sign");
                              await AuthenticationService.signOut();
                              log("out");
                              setState(() {});
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false, // ลบทุกหน้าออกจาก stack
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
