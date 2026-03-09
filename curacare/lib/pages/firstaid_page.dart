import 'package:curacare/pages/firstaid_data_page.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/format_card.dart';
import 'package:flutter/material.dart';
import 'package:curacare/models/firstaidmockdata.dart';

class FirstaidPage extends StatefulWidget {
  const FirstaidPage({super.key});

  @override
  State<FirstaidPage> createState() => _FirstaidPageState();
}

class _FirstaidPageState extends State<FirstaidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ปฐมพยาบาลเบื้องต้น",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              "คำแนะนำฉุกเฉินอยู่แค่ปลายนิ้วคุณ",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormatCard(
                card_title: "ภาวะฉุกเฉิน??",
                card_sup_title: "โทรแจ้ง 191 ทันที",
                icon: Icons.warning_amber,
                color: Colors.white,
                backgroundColor: const Color.fromARGB(255, 255, 96, 47),
                textcolor: Colors.white,
              ),
              const SizedBox(height: 20),

              FormatCard(
                card_title: "CPR",
                card_sup_title: "การช่วยชีวิตด้วยการปั๊มหัวใจและผายปอด",
                icon: Icons.favorite_border_outlined,
                color: Colors.red,
                toScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FirstaidDataPage(data: mockFirstaidList[0]),
                    ),
                  );
                },
              ),
              FormatCard(
                card_title: "ไฟลวก",
                card_sup_title: "การรักษาแผลไหม้จากความร้อน",
                icon: Icons.local_fire_department,
                color: Colors.orangeAccent,
                toScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FirstaidDataPage(data: mockFirstaidList[1]),
                    ),
                  );
                },
              ),
              FormatCard(
                card_title: "อาหารติดคอ",
                card_sup_title: "การช่วยชีวิตภาวะอุดตันทางเดินหายใจ",
                icon: Icons.airline_seat_flat,
                color: Colors.green,
                toScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FirstaidDataPage(data: mockFirstaidList[2]),
                    ),
                  );
                },
              ),
              FormatCard(
                card_title: "เลือดออกรุนแรง",
                card_sup_title: "การควบคุมการเสียเลือดมาก",
                icon: Icons.water_drop,
                color: Colors.red,
                toScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FirstaidDataPage(data: mockFirstaidList[3]),
                    ),
                  );
                },
              ),
              FormatCard(
                card_title: "ช็อก",
                card_sup_title: "การรับรู้และการรักษาภาวะช็อก",
                icon: Icons.bolt,
                color: Colors.blue,
                toScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FirstaidDataPage(data: mockFirstaidList[4]),
                    ),
                  );
                },
              ),
              FormatCard(
                card_title: "การโดนยาพิษ",
                card_sup_title: "การรับมือกับเหตุฉุกเฉินจากการได้รับสารพิษ",
                icon: Icons.bug_report,
                color: const Color.fromARGB(255, 199, 179, 0),
                toScreen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FirstaidDataPage(data: mockFirstaidList[5]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
    );
  }
}
