import 'dart:developer';
import 'package:curacare/models/appointment_model.dart';
import 'package:curacare/services/appointment_service.dart';
import 'package:curacare/widgets/appointment_card.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
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
  final DateFormat _formatter = DateFormat("d MMMM yyyy HH:mm", "th");
  final _dateTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEdit = false;
  String? _editingAppointmentId;
  final Map<DateTime, List<dynamic>> _events = {};
  DateTime _calendarSelectedDate = DateTime.now();

  late Future<List<AppointmentModel>> _appointments;
  @override
  void initState() {
    super.initState();

    _appointments = AppointmentService.get();
    // log('_appointmentFuture : $_appointmentFuture');
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

  Future<void> _selectDateTime(BuildContext context) async {
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

  Future<void> _deleteAppointment(String appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณต้องการลบนัดหมายนี้ใช่หรือไม่"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              onPressed: () => Navigator.pop(context, false),
              child: Text("ยกเลิก"),
            ),
          ],
        );
      },
    );

    // ถ้ากด ยกเลิก หรือปิด dialog
    if (confirm != true) return;
    try {
      await AppointmentService.remove(appointmentId);
      setState(() {
        _appointments = AppointmentService.get();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ลบสำเร็จ")));
    } catch (e) {
      log("Error : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ลบไม่สำเร็จ")));
    }
  }

  bool isSameDay(DateTime calendar_date, DateTime data_date) {
    return calendar_date.year == data_date.year &&
        calendar_date.month == data_date.month &&
        calendar_date.day == data_date.day;
  }

  bool _showAll = true;

  @override
  Widget build(BuildContext context) {
    void openEditAppointment(BuildContext context) {
      isEdit = true;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Text('แก้ไขข้อมูลนัดหมาย')),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "แก้ไขหัวข้อนัดหมาย",
                        hintText: "เช่น ตรวจเลือด",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อนัดหมาย';
                        }
                        if (value.length < 3) {
                          return 'ต้องมีอย่างน้อย 3 ตัวอักษร';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _detailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "รายละเอียดนัดหมาย",
                        hintText: "เช่น งดข้าวก่อนไปตรวจ 8 ชม.",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "แก้ไขสถานที่นัดหมาย",
                        hintText: "เช่น โรงพยาบาลกรุงเทพ",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกสถานที่นัดหมาย';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _dateTimeController,
                      onTap: () {
                        _selectDateTime(context);
                      },

                      decoration: const InputDecoration(
                        labelText: 'แก้ไขเวลานัดหมาย',
                        hintText: "เช่น 1 มีนาคม 2026 14:30",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Add validation
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเวลานัดหมาย';
                        }
                        try {
                          final selectDate = DateFormat(
                            "d MMMM yyyy HH:mm",
                            "th",
                          ).parse(value);

                          if (selectDate.isBefore(
                            DateTime.now().subtract(Duration(days: 1)),
                          )) {
                            return 'ไม่สามารถเลือกวันที่ย้อนหลังได้';
                          }
                        } catch (err) {
                          log("Error : $err");
                          return 'รูปแบบวันที่ไม่ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final title = _titleController.text;
                              final detail = _detailController.text;
                              final location = _locationController.text;
                              final dateTime = _dateTimeController.text;
                              final date = _formatter.parse(dateTime);
                              try {
                                await AppointmentService.update(
                                  _editingAppointmentId!,
                                  title,
                                  location,
                                  date,
                                  detail,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("แก้ไขข้อมูลสำเร็จ")),
                                );
                                setState(() {
                                  _appointments = AppointmentService.get();
                                });
                                Navigator.pop(context);
                              } catch (err) {
                                log('Exception ===> : ${err}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("แก้ไขข้อมูลไม่สำเร็จ"),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text("บันทึก"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            isEdit = false;

                            Navigator.pop(context);
                          },
                          child: Text("ยกเลิก"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    void openAppointmentInput(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Text("กรอกข้อมูลนัดหมาย")),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "หัวข้อนัดหมาย",
                        hintText: "เช่น ตรวจเลือด",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อนัดหมาย';
                        }
                        if (value.length < 3) {
                          return 'ต้องมีอย่างน้อย 3 ตัวอักษร';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _detailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "รายละเอียดนัดหมาย",
                        hintText: "เช่น งดข้าวก่อนไปตรวจ 8 ชม.",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "สถานที่",
                        hintText: 'เช่น โรงพยาบาลกรุงเทพ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกสถานที่';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _dateTimeController,
                      onTap: () {
                        _selectDateTime(context);
                      },

                      decoration: const InputDecoration(
                        labelText: 'เวลานัดหมาย',
                        hintText: 'MM/dd/yyyy',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Add validation
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเวลานัดหมาย';
                        }
                        try {
                          final selectDate = DateFormat(
                            "d MMMM yyyy HH:mm",
                            "th",
                          ).parse(value);

                          if (selectDate.isBefore(
                            DateTime.now().subtract(Duration(days: 1)),
                          )) {
                            return 'ไม่สามารถเลือกวันที่ย้อนหลังได้';
                          }
                        } catch (err) {
                          log("Error : $err");
                          return 'รูปแบบวันที่ไม่ถูกต้อง';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final title = _titleController.text;
                              final detail = _detailController.text;
                              final location = _locationController.text;
                              final dateTime = _dateTimeController.text;

                              try {
                                final date = _formatter.parse(dateTime);
                                await AppointmentService.add(
                                  title,
                                  location,
                                  date,
                                  detail,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("บันทึกสำเร็จ")),
                                );
                                setState(() {
                                  _appointments = AppointmentService.get();
                                });
                                Navigator.pop(context);
                              } catch (err) {
                                log('Exception ===> : ${err}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("บันทึกไม่สำเร็จ")),
                                );
                              }
                            }
                          },
                          child: Text("บันทึก"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_titleController.text.isNotEmpty ||
                                _locationController.text.isNotEmpty ||
                                _detailController.text.isNotEmpty ||
                                _dateTimeController.text.isNotEmpty) {
                              final confirm = showDialog<bool>(
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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

                              // ถ้ากด ยกเลิก หรือปิด dialog
                              if (confirm != true) return;
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text("ยกเลิก"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
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
            onPressed: () async {
              clearController();
              openAppointmentInput(context);
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
            eventLoader: (day) {
              final normalized = DateTime(day.year, day.month, day.day);
              final events = _events[normalized];

              if (events != null && events.isNotEmpty) {
                return [events.first];
              }

              return [];
            },
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
              future: _appointments,
              builder: (context, snapshot) {
                // log("snapshot.connectionState = ${snapshot.connectionState}");
                // log("snapshot.hasData = ${snapshot.hasData}");
                // log("snapshot.hasError = ${snapshot.hasError}");
                // log("snapshot.error = ${snapshot.error}");
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
                                _appointments = AppointmentService.get();
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
                            onDelete: () {
                              log("appoinmentId : ${appointment.id}");
                              _deleteAppointment(appointment.id);
                            },
                            onEdit: () {
                              _titleController.text = appointment.title;
                              _detailController.text = appointment.detail;
                              _locationController.text = appointment.location;
                              _dateTimeController.text = _formatter.format(
                                appointment.dateTime,
                              );
                              _editingAppointmentId = appointment.id;
                              openEditAppointment(context);
                            },
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
