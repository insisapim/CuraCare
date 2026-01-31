import 'package:curacare/pages/search_page.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var kPrimaryGreen = Color(0xFF2ECC71);
  var kSoftGreen = Color(0xFFE9FBF3);
  var textGreen = Color.fromARGB(255, 0, 153, 5);
  final SearchController _searchController = SearchController();

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void searchConditions(String query) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SearchPage(searchText: query)),
    );
  }

  final PreferredSizeWidget _buildAppBar = AppBar(
    titleSpacing: 20,
    actionsPadding: EdgeInsets.all(10),
    automaticallyImplyLeading: false,

    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("สวัสดีตอนบ่าย", style: TextStyle(fontSize: 20)),
        Text(
          "คุณสมศรี 👋",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    toolbarHeight: 100,
    actions: [
      Stack(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2ECC71),
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
        ],
      ),
    ],
  );

  final Widget _buildTodayStatus = Card(
    color: Colors.white,
    child: Container(
      margin: EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFE9FBF3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("สถานะวันนี้", style: TextStyle(fontSize: 18)),
                        Text(
                          "สุขภาพดี!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "ดูรายละเอียด",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 153, 5),
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color.fromARGB(255, 0, 153, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300, height: 32),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "5",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("กิจวัตรวันนี้", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "2",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("นัดหมาย", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "80%",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 153, 5),
                      ),
                    ),
                    Text("ทำสำเร็จ", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 24),
              child: SearchBar(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                controller: _searchController,
                hintText: "ค้นหาโรค อาการ...",
                onSubmitted: (value) => searchConditions(value),
              ),
            ),

            _buildTodayStatus,
            //กิจวัตร
            Container(
              margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
              child: Column(
                children: [
                  Card(
                    color: const Color.fromARGB(255, 255, 242, 225),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.notifications_on_outlined,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "กิจวัตรประจำวัน",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "แผนดูแลสุขภาพตามโรค",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 92, 92, 92),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //นัดหมายที่จะถึง
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Column(
                children: [
                  Card(
                    color: const Color.fromARGB(255, 218, 255, 219),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kPrimaryGreen,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "กิจวัตรประจำวัน",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "แผนดูแลสุขภาพตามโรค",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 92, 92, 92),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "เมนูหลัก",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE9FBF3),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.assignment_outlined,
                                  color: Color(0xFF2ECC71),
                                  size: 28,
                                ),
                              ),
                              Text(
                                "กิจวัตรประจำวัน",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "แผนดูแลสุขภาพตามโรค",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    213,
                                    236,
                                    255,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                              ),
                              Text(
                                "ปฏิทินนัดหมาย",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "จัดการการนัดพบแพทย์",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //คู่มือปฐมพยาบาล
            Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    218,
                                    219,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              ),
                              Text(
                                "คู่มือปฐมพยาบาล",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "วิธีช่วยเหลือเบื้องต้น",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
