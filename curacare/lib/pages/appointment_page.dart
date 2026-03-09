import 'dart:developer';
import 'package:curacare/models/appointment_model.dart';
import 'package:curacare/pages/login_page.dart';
import 'package:curacare/services/appointment_service.dart';
import 'package:curacare/widgets/appointment_card.dart';
import 'package:curacare/widgets/appointment_form.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:table_calendar/table_calendar.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final DateFormat _formatter = DateFormat("d MMMM yyyy HH:mm", "th");
  DateTime _calendarSelectedDate = DateTime.now();

  bool _showAll = true;

  final Map<DateTime, List<dynamic>> _events = {};

  late Future<List<AppointmentModel>> appointments;

  @override
  void initState() {
    super.initState();
    appointments = AppointmentService.get();
  }

  void reload() {
    setState(() {
      appointments = AppointmentService.get();
    });
  }

  void clearController() {
    _titleController.clear();
    _locationController.clear();
    _detailController.clear();
    _dateTimeController.clear();
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    _titleController.dispose();
    _detailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(2100),
      initialDate: today,
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;
    final DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    _dateTimeController.text = DateFormat(
      "d MMMM yyyy HH:mm",
      "th",
    ).format(finalDateTime);
  }

  //เช็คว่าเป็นวันเดียวกันหรือไม่
  bool isSameDay(DateTime calendar_date, DateTime data_date) {
    return calendar_date.year == data_date.year &&
        calendar_date.month == data_date.month &&
        calendar_date.day == data_date.day;
  }

  Future<void> deleteAppointment(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ยืนยันการลบ"),
        content: const Text("ต้องการลบนัดหมายนี้หรือไม่"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ลบ"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("ยกเลิก"),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await AppointmentService.remove(id);
      reload();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ลบสำเร็จ")));
    } catch (e) {
      log("delete error $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ลบไม่สำเร็จ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    void openCreateDialog() {
      clearController();
      showDialog(
        context: context,
        builder: (_) => AppointmentFormDialog(
          formKey: _formKey,
          title: "เพิ่มนัดหมาย",
          titleController: _titleController,
          detailController: _detailController,
          locationController: _locationController,
          dateController: _dateTimeController,
          onPickDate: _selectDateTime,
          onCancel: () async {
            if (_titleController.text.isNotEmpty ||
                _locationController.text.isNotEmpty ||
                _detailController.text.isNotEmpty ||
                _dateTimeController.text.isNotEmpty) {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("ข้อมูลยังไม่ถูกบันทึก"),
                    content: Text(
                      "คุณต้องการปิดหรือไม่ ถ้าปิดข้อมูลจะไม่ถูกบันทึก",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "ตกลง",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("ยกเลิก"),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) return;
            } else {
              Navigator.pop(context);
            }
          },
          onSubmit: () async {
            if (!_formKey.currentState!.validate()) return;
            final date = _formatter.parse(_dateTimeController.text);
            await AppointmentService.add(
              _titleController.text,
              _locationController.text,
              date,
              _detailController.text,
            );
            reload();
            Navigator.pop(context);
          },
        ),
      );
    }

    void openEditDialog(AppointmentModel ap) {
      _titleController.text = ap.title;
      _locationController.text = ap.location;
      _detailController.text = ap.detail;
      _dateTimeController.text = _formatter.format(ap.dateTime);

      showDialog(
        context: context,
        builder: (_) => AppointmentFormDialog(
          formKey: _formKey,
          title: "แก้ไขนัดหมาย",

          titleController: _titleController,
          detailController: _detailController,
          locationController: _locationController,
          dateController: _dateTimeController,
          onPickDate: _selectDateTime,
          onCancel: () => Navigator.pop(context),
          onSubmit: () async {
            if (!_formKey.currentState!.validate()) return;

            final date = _formatter.parse(_dateTimeController.text);

            await AppointmentService.update(
              ap.id,
              _titleController.text,
              _locationController.text,
              date,
              _detailController.text,
            );

            reload();

            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ปฏิทินนัดหมาย",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text("จัดการการนัดพบแพทย์", style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF2ECC71)),
              iconColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => LoginPage()));
                return;
              }
              clearController();
              openCreateDialog();
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _calendarSelectedDate,

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _calendarSelectedDate = selectedDay;
                _showAll = false;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_calendarSelectedDate, day);
            },
            eventLoader: (day) {
              final normalized = DateTime(day.year, day.month, day.day);
              final events = _events[normalized];

              if (events != null && events.isNotEmpty) {
                return [events.first];
              }

              return [];
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false, // ซ่อนปุ่ม 2 weeks
            ),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(112, 83, 83, 83),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 67, 168, 0),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "นัดหมายที่กำลังจะถึง",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAll = true;
                  });
                },
                child: Text("ดูทั้งหมด"),
              ),
            ],
          ),

          Expanded(
            child: FutureBuilder<List<AppointmentModel>>(
              future: appointments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  final error = snapshot.error;

                  if (error is TimeoutException) {
                    return Center(
                      child: Column(
                        children: [
                          Text("โหลดข้อมูลช้าเกินไป กรุณาลองใหม่"),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {
                                appointments = AppointmentService.get();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Text('Hey!!! Error ==>>> ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('ไม่พบข้อมูลนัดหมาย'));
                }
                final appointmentData = snapshot.data!;
                if (appointmentData.isEmpty) {
                  return Center(child: Text("ไม่พบข้อมูลนัดหมาย"));
                }
                _events.clear();

                for (var ap in appointmentData) {
                  final normalized = DateTime(
                    ap.dateTime.year,
                    ap.dateTime.month,
                    ap.dateTime.day,
                  );

                  if (_events[normalized] == null) {
                    _events[normalized] = [];
                  }

                  _events[normalized]!.add(ap);
                }
                final filteredAppointments = _showAll
                    ? appointmentData
                    : appointmentData.where((ap) {
                        return isSameDay(_calendarSelectedDate, ap.dateTime);
                      }).toList();

                if (filteredAppointments.isEmpty) {
                  return Center(
                    child: Text(
                      _showAll ? "ไม่มีนัดหมาย" : "ไม่มีนัดหมายในวันที่เลือก",
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = filteredAppointments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          AppointmentCard(
                            title: appointment.title,
                            location: appointment.location,
                            dateTime: appointment.dateTime,
                            icon: Icons.local_hospital_outlined,
                            requireTask: appointment.detail,
                            onEdit: () => openEditDialog(appointment),
                            onDelete: () => deleteAppointment(appointment.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
