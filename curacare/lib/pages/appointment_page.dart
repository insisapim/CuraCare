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

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int userid = 1;
  final _titleController = TextEditingController();

  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final DateFormat _formatter = DateFormat('MM/dd/yyyy');
  final _dateStartController = TextEditingController();
  final _dateEndController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<AppointmentTypeData> _appTypeData = [];
  bool isEdiing = false;
  int? _editingAppointmentId;
  late Future<List<Appointmentdata>> _appointmentFuture;
  @override
  void initState() {
    super.initState();
    _loadAppointmentTypeData();

    _appointmentFuture = AppointmentsApi.fetchAppointment();
    log('_appointmentFuture : $_appointmentFuture');
  }

  void clearControll() {
    _titleController.clear();
    _locationController.clear();
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
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateStartController.text = _formatter.format(_selectedDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateEndController.text = _formatter.format(_selectedDate);
      });
    }
  }

  Future<void> _deleteAppointment(int appointmentId) async {
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

  @override
  Widget build(BuildContext context) {
    void openEditAppointment(BuildContext context) {
      isEdiing = true;
      showDialog(
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
                            'MM/dd/yyyy',
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
                        hintText: 'MM/dd/yyyy',
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
                            'MM/dd/yyyy',
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
                              final location = _locationController.text;
                              final appointmentType = _selectedAppointmentType;
                              final startTime = _dateStartController.text;
                              final endTime = _dateEndController.text;
                              final userId = userid;
                              if (appointmentType == null) return;
                              if (DateFormat('MM/dd/yyyy')
                                  .parse(endTime)
                                  .isBefore(
                                    DateFormat('MM/dd/yyyy').parse(startTime),
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
                                await AppointmentsApi.editAppointment(
                                  id: _editingAppointmentId!,
                                  title: title,
                                  userId: userId,
                                  startTime: startTime.toString(),
                                  endTime: endTime.toString(),
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
                            'MM/dd/yyyy',
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
                        hintText: 'MM/dd/yyyy',
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
                            'MM/dd/yyyy',
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
                            // if(true){
                            //   if (_formKey.currentState!.validate()){
                            //     final appointmentType = _selectedAppointmentType;
                            //     log('id: ${appointmentType!.id}, name: ${appointmentType!.name}');
                            //   }

                            //   return;
                            // }
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
                              final location = _locationController.text;
                              final appointmentType = _selectedAppointmentType;
                              final startTime = _dateStartController.text;
                              final endTime = _dateEndController.text;
                              final userId = userid;
                              if (appointmentType == null) return;
                              if (DateFormat('MM/dd/yyyy')
                                  .parse(endTime)
                                  .isBefore(
                                    DateFormat('MM/dd/yyyy').parse(startTime),
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
                                await AppointmentsApi.addAppointment(
                                  title: title,
                                  userId: userId,
                                  startTime: startTime.toString(),
                                  endTime: endTime.toString(),
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
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
            onDateChanged: (date) {
              print(date);
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text("นัดหมายที่กำลังจะถึง", style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: FutureBuilder<List<Appointmentdata>>(
              future: _appointmentFuture,
              builder: (context, snapshot) {
                log("snapshot.connectionState = ${snapshot.connectionState}");
                log("snapshot.hasData = ${snapshot.hasData}");
                log("snapshot.hasError = ${snapshot.hasError}");
                log("snapshot.error = ${snapshot.error}");
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
                return ListView.builder(
                  itemCount: appointment_data.length,
                  itemBuilder: (context, index) {
                    final appointment = appointment_data[index];
                    log("$appointment");
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
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _titleController.text = appointment.title;
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
                            child: Text("แก้ไข"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              log("appoinmentId : ${appointment.id}");
                              _deleteAppointment(appointment.id);
                            },
                            child: Text("ลบข้อมูลนัดหมาย"),
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
