import 'package:curacare/pages/homepage.dart';
import 'package:curacare/pages/login_page.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/format_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            const FormatCard(
              card_title: "Sarah Johnson",
              card_sup_title: "sarah.johnson@email.com",
              icon: Icons.person_outlined,
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
                  MaterialPageRoute(builder: (_) => HomePage()),
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
            Container(
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
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
