import 'dart:developer';

import 'package:curacare/models/user_model.dart';
import 'package:curacare/pages/appointment_page.dart';
import 'package:curacare/pages/firstaid_page.dart';
import 'package:curacare/pages/routine_page.dart';
import 'package:curacare/pages/search_page.dart';
import 'package:curacare/services/appointment_service.dart';
import 'package:curacare/services/routine_service.dart';
import 'package:curacare/services/user_service.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/homepage_navigate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  late Future<UserModel?> userProfile;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //loadAppointments();
    // TODO: implement initState
    super.initState();
    userProfile = UserService.getByUid();
  }

  void searchConditions(String query) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SearchPage(searchText: query)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext) => AppBar(
    backgroundColor: Colors.white,
    titleSpacing: 20,
    actionsPadding: EdgeInsets.all(10),
    automaticallyImplyLeading: false,

    title: FutureBuilder(
      future: userProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("โหลดข้อมูล", style: TextStyle(fontSize: 20))],
          );
        }
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ไม่สามารถหาผู้ใช้ได้", style: TextStyle(fontSize: 20)),
            ],
          );
        }

        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ยินดีต้อนรับ!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }

        final userData = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("สวัสดีตอนบ่าย", style: TextStyle(fontSize: 20)),
            Text(
              "${userData!.username} 👋",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    ),
    toolbarHeight: 100,
  );

  Widget _buildTodayStatus() {
    return Card(
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
                          FutureBuilder(
                            future: RoutineService.getPercent(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                log("Error : ${snapshot.error.toString()}");
                                return Text("เกิดข้อผิดพลาดระหว่างโหลด");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (!snapshot.hasData) {
                                return Text("เกิดข้อผิดพลาดระหว่างโหลด");
                              }
                              final percent = snapshot.data!;
                              if (percent >= 50) {
                                return Text(
                                  "สุขภาพดี!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                );
                              } else if (percent < 50 && percent >= 25) {
                                return Text(
                                  "สุขภาพปกติ",
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                );
                              } else {
                                return Text(
                                  "อย่าลืมทำกิจวัตร!!",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Spacer(),
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
                      FutureBuilder(
                        future: RoutineService.get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("error");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("โหลดข้อมูล");
                          }

                          if (!snapshot.hasData) {
                            return Text("ไม่พบข้อมูล");
                          }

                          final data = snapshot.data!.length;
                          return Text(
                            data.toString(),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),

                      Text("กิจวัตรวันนี้", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      FutureBuilder(
                        future: AppointmentService.get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("error");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("โหลดข้อมูล");
                          }

                          if (!snapshot.hasData) {
                            return Text("ไม่พบข้อมูล");
                          }

                          final data = snapshot.data!.length;
                          return Text(
                            data.toString(),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Text("นัดหมาย", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      FutureBuilder(
                        future: RoutineService.getPercent(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("error");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("โหลดข้อมูล");
                          }

                          if (!snapshot.hasData) {
                            return Text("ไม่พบข้อมูล");
                          }
                          final percent = snapshot.data!;
                          return Text(
                            "${percent.toString()}%",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 153, 5),
                            ),
                          );
                        },
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
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

            _buildTodayStatus(),
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RoutinePage(),
                          ),
                        );
                      },
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
                            FutureBuilder(
                              future: RoutineService.getNext(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  log(snapshot.error.toString());
                                  return Text("error");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (!snapshot.hasData) {
                                  return Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ไม่มีกิจวัตรต่อไป",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(height: 6),
                                      ],
                                    ),
                                  );
                                }

                                final routine = snapshot.data!;
                                return Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "กิจวัตร : ${routine.title}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        DateFormat("HH:mm", "th").format(
                                          DateTime(
                                            2000,
                                            0,
                                            0,
                                            routine.time.hour,
                                            routine.time.minute,
                                          ),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentPage(),
                          ),
                        );
                      },
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
                            FutureBuilder(
                              future: AppointmentService.get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }

                                final data = snapshot.data!;

                                if (data.isEmpty) {
                                  return Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "เพิ่มนัดหมายแรกกันเถอะ!",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(height: 6),
                                      ],
                                    ),
                                  );
                                }

                                final appointment = data.first;

                                return Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "นัดหมาย : ${appointment.title}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        DateFormat(
                                          "d MMMM yyyy HH:mm",
                                          "th",
                                        ).format(appointment.dateTime),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
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

            HomepageNavigate(
              card_title: "กิจวัตรประจำวัน",
              card_sup_title: "แผนดูแลสุขภาพตามโรค",
              icon: Icons.assignment_outlined,
              toScreen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RoutinePage()),
                );
              },
              color: Colors.green,
              backgroundColor: Colors.green.withOpacity(0.15),
            ),
            HomepageNavigate(
              card_title: "ปฏิทินนัดหมาย",
              card_sup_title: "จัดการการนัดหมายแพทย์",
              icon: Icons.calendar_month_outlined,
              toScreen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AppointmentPage()),
                );
              },
              color: Colors.blue,
              backgroundColor: Colors.blue.withOpacity(0.15),
            ),
            HomepageNavigate(
              card_title: "คู่มือปฐมพยาบาล",
              card_sup_title: "วิธีช่วยเหลือเบื้องต้น",
              icon: Icons.warning_amber,
              toScreen: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FirstaidPage()),
                );
              },
              color: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.15),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
