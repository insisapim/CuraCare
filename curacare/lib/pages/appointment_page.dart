import 'dart:developer';
import 'package:curacare/models/appointment_type_data.dart';
import 'package:curacare/models/appointmentdata.dart';
import 'package:curacare/services/appointment_type_api.dart';
import 'package:curacare/services/appointments_api.dart';
import 'package:curacare/widgets/appointment_card.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:table_calendar/table_calendar.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int userid = 1;
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final DateFormat _formatter = DateFormat("d MMMM yyyy HH:mm", "th");
  final _dateStartController = TextEditingController();
  final _dateEndController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<AppointmentTypeData> _appTypeData = [];
  bool isEdiing = false;
  int? _editingAppointmentId;
  Map<DateTime, List<dynamic>> _events = {};
  DateTime _calendarSelectedDate = DateTime.now();

  late Future<List<Appointmentdata>> _appointmentFuture;
  @override
  void initState() {
    super.initState();
    _loadAppointmentTypeData();

    _appointmentFuture = AppointmentsApi.fetchAppointment();
    // log('_appointmentFuture : $_appointmentFuture');
  }

  void clearControll() {
    _titleController.clear();
    _locationController.clear();
    _detailController.clear();
    _dateEndController.clear();
    _dateStartController.clear();
    setState(() {
      _selectedAppointmentType = null;
    });
  }

  AppointmentTypeData? _selectedAppointmentType;
  @override
  void dispose() {
    _dateStartController.dispose();
    _titleController.dispose();
    _detailController.dispose();
    _locationController.dispose();
    _dateEndController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointmentTypeData() async {
    try {
      final apppointmenttype_data =
          await AppointmentTypeApi.fetchAppointmenttype();
      setState(() {
        _appTypeData = apppointmenttype_data;
        if (_appTypeData.isNotEmpty) {
          _selectedAppointmentType = _appTypeData.first;
        }
      });
    } catch (err) {
      log("Fetch AppointmentType fail Error : ${err}");
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
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

    _dateStartController.text = DateFormat(
      "d MMMM yyyy HH:mm",
      "th",
    ).format(finalDateTime);
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(2100),
      initialDate: today,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateEndController.text = _formatter.format(_selectedDate);
      });
    }
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedDate == null) return;

    if (pickedTime == null) return;
    final DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    _dateEndController.text = DateFormat(
      "d MMMM yyyy HH:mm",
      "th",
    ).format(finalDateTime);
  }

  Future<void> _deleteAppointment(int appointmentId) async {
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
      await AppointmentsApi.deleteAppointment(
        userId: userid,
        appointmentId: appointmentId,
      );
      setState(() {
        _appointmentFuture = AppointmentsApi.fetchAppointment();
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
      isEdiing = true;
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
                      controller: _dateStartController,
                      onTap: () {
                        _selectStartDate(context);
                      },

                      decoration: const InputDecoration(
                        labelText: 'แก้ไขเวลาเริ่มการนัดหมาย',
                        hintText: "เช่น 1 มีนาคม 2026 14:30",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Add validation
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเวลาเริ่มการนัดหมาย';
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
                    TextFormField(
                      controller: _dateEndController,
                      onTap: () {
                        _selectEndDate(context);
                      },

                      decoration: const InputDecoration(
                        labelText: 'เวลาสิ้นสุดการนัดหมาย',
                        hintText: "เช่น 1 มีนาคม 2026 15:30",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Add validation
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเวลาสิ้นสุดการนัดหมาย';
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
                    // DropdownSearch<AppointmentTypeData>(
                    //   items: _appTypeData,
                    //   selectedItem: _selectedAppointmentType,
                    //   itemAsString: (d) => d.name,
                    //   popupProps: PopupProps.menu(
                    //     showSearchBox: true,
                    //     searchFieldProps: TextFieldProps(
                    //       decoration: InputDecoration(
                    //         labelText: "ค้นหาประเภทนัดหมาย",
                    //         border: OutlineInputBorder(),
                    //       ),
                    //     ),
                    //   ),
                    //   onChanged: (value) {
                    //     log('drodow valuew : ${value}');
                    //     setState(() {
                    //       _selectedAppointmentType = value;
                    //     });
                    //   },
                    // ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_selectedAppointmentType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("กรุณาเลือกประเภทนัดหมาย"),
                                ),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              final title = _titleController.text;
                              final detail = _detailController.text;
                              final location = _locationController.text;
                              final appointmentType = _selectedAppointmentType;
                              final startTime = _dateStartController.text;
                              final endTime = _dateEndController.text;
                              final userId = userid;
                              if (appointmentType == null) return;
                              final start = _formatter.parse(startTime);
                              final end = _formatter.parse(endTime);

                              if (end.isBefore(start)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'วันสิ้นสุดต้องมากกว่าวันเริ่มต้น',
                                    ),
                                  ),
                                );
                                return;
                              }
                              try {
                                final start = _formatter.parse(startTime);
                                final end = _formatter.parse(endTime);
                                await AppointmentsApi.editAppointment(
                                  id: _editingAppointmentId!,
                                  title: title,
                                  detail: detail,
                                  userId: userId,
                                  startTime: start.toIso8601String(),
                                  endTime: end.toIso8601String(),
                                  location: location,
                                  appointmentType: appointmentType!.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("แก้ไขข้อมูลสำเร็จ")),
                                );
                                setState(() {
                                  _appointmentFuture =
                                      AppointmentsApi.fetchAppointment();
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
                            isEdiing = false;

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
                      controller: _dateStartController,
                      onTap: () {
                        _selectStartDate(context);
                      },

                      decoration: const InputDecoration(
                        labelText: 'เวลาเริ่มการนัดหมาย',
                        hintText: 'MM/dd/yyyy',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Add validation
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเวลาเริ่มการนัดหมาย';
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
                    TextFormField(
                      controller: _dateEndController,
                      onTap: () {
                        _selectEndDate(context);
                      },

                      decoration: const InputDecoration(
                        labelText: 'เวลาสิ้นสุดการนัดหมาย',
                        hintText: "เช่น 1 มีนาคม 2026 14:30",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Add validation
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกเวลาสิ้นสุดการนัดหมาย';
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
                    // DropdownSearch<AppointmentTypeData>(
                    //   items: _appTypeData,
                    //   selectedItem: _selectedAppointmentType,
                    //   itemAsString: (d) => d.name,
                    //   popupProps: PopupProps.menu(
                    //     showSearchBox: true,
                    //     searchFieldProps: TextFieldProps(
                    //       decoration: InputDecoration(
                    //         labelText: "ค้นหาประเภทนัดหมาย",
                    //         border: OutlineInputBorder(),
                    //       ),
                    //     ),
                    //   ),
                    //   onChanged: (value) {
                    //     log('drodow valuew : ${value}');
                    //     setState(() {
                    //       _selectedAppointmentType = value;
                    //     });
                    //   },
                    // ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_selectedAppointmentType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("กรุณาเลือกประเภทนัดหมาย"),
                                ),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              final title = _titleController.text;
                              final detail = _detailController.text;
                              final location = _locationController.text;
                              final appointmentType = _selectedAppointmentType;
                              final startTime = _dateStartController.text;
                              final endTime = _dateEndController.text;
                              final userId = userid;
                              if (appointmentType == null) return;
                              if (DateFormat("d MMMM yyyy HH:mm", "th")
                                  .parse(endTime)
                                  .isBefore(
                                    DateFormat(
                                      "d MMMM yyyy HH:mm",
                                      "th",
                                    ).parse(startTime),
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'วันสิ้นสุดต้องมากกว่าวันเริ่มต้น',
                                    ),
                                  ),
                                );
                                return;
                              }
                              try {
                                final start = _formatter.parse(startTime);
                                final end = _formatter.parse(endTime);
                                await AppointmentsApi.addAppointment(
                                  title: title,
                                  detail: detail,
                                  userId: userId,
                                  startTime: start.toIso8601String(),
                                  endTime: end.toIso8601String(),
                                  location: location,
                                  appointmentType: appointmentType!.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("บันทึกสำเร็จ")),
                                );
                                setState(() {
                                  _appointmentFuture =
                                      AppointmentsApi.fetchAppointment();
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
                                _dateStartController.text.isNotEmpty ||
                                _dateEndController.text.isNotEmpty) {
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
              clearControll();
              await _loadAppointmentTypeData();
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
            child: FutureBuilder<List<Appointmentdata>>(
              future: _appointmentFuture,
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
                                _appointmentFuture =
                                    AppointmentsApi.fetchAppointment();
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
                final appointment_data = snapshot.data!;
                if (appointment_data.isEmpty) {
                  return Center(child: Text("ไม่พบข้อมูลนัดหมาย"));
                }
                final appointmentData = snapshot.data!;
                _events.clear();

                for (var ap in appointmentData) {
                  final date = DateTime.parse(ap.startTime);
                  final normalized = DateTime(date.year, date.month, date.day);

                  if (_events[normalized] == null) {
                    _events[normalized] = [];
                  }

                  _events[normalized]!.add(ap);
                }
                final filteredAppointments = _showAll
                    ? appointmentData
                    : appointmentData.where((ap) {
                        final apDate = DateTime.parse(ap.startTime);
                        return isSameDay(_calendarSelectedDate, apDate);
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
                            dateTime: DateTime.parse(appointment.startTime),
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
                              _dateStartController.text = _formatter.format(
                                DateTime.parse(appointment.startTime),
                              );

                              _dateEndController.text = _formatter.format(
                                DateTime.parse(appointment.endTime),
                              );
                              setState(() {
                                _selectedAppointmentType = appointment.app_type;
                              });
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
