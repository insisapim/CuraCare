import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/format_card.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var kPrimaryGreen = Color(0xFF2ECC71);
  var kSoftGreen = Color(0xFFE9FBF3);
  var textGreen = Color.fromARGB(255, 0, 153, 5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
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
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.favorite, color: Colors.white, size: 22),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormatCard(
                card_title: "Sarah Johnson",
                card_sup_title: "sarah.johnson@email.com",
                icon: Icons.person_outlined,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                child: Text("ข้อมูลการรักษา" ,style: TextStyle(fontSize: 20)),
              ),
              FormatCard(
                card_title: "บันทึกโรค",
                card_sup_title: "จัดการบันทึกเปลี่ยนแปลงการบันทึกโรค",
                icon: Icons.favorite_border_outlined,
              ),
              FormatCard(
                card_title: "บันทึกยา",
                card_sup_title: "จัดการบันทึกเปลี่ยนแปลงการบันทึกยา",
                icon: Icons.article_outlined,
                color: Colors.blue,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: FormatCard(
                card_title: "Sign Out",
                card_sup_title: "",
                icon: Icons.logout,
                color: Colors.red,
              ),
              )
            ],
          ),
      
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
