import 'dart:convert';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineItem {
  String title;
  String detail;
  String category;
  TimeOfDay time;
  String period;
  bool isCompleted;
  bool isActive;

  RoutineItem({
    required this.title,
    required this.detail,
    required this.category,
    required this.time,
    required this.period,
    this.isCompleted = false,
    this.isActive = true,
  });

  //แปลงเป็น JSON เซฟลงเครื่อง
  Map<String, dynamic> toJson() => {
        'title': title,
        'detail': detail,
        'category': category,
        'hour': time.hour,
        'minute': time.minute,
        'period': period,
        'isCompleted': isCompleted,
        'isActive': isActive,
      };

  //แปลงจาก JSON กลับเป็น Object
  factory RoutineItem.fromJson(Map<String, dynamic> json) => RoutineItem(
        title: json['title'],
        detail: json['detail'],
        category: json['category'],
        time: TimeOfDay(hour: json['hour'], minute: json['minute']),
        period: json['period'],
        isCompleted: json['isCompleted'],
        isActive: json['isActive'],
      );
}

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> with WidgetsBindingObserver {
  final Color kPrimaryGreen = const Color(0xFF2ECC71);
  final Color kSoftGreen = const Color(0xFFE9FBF3);

  bool isNotificationEnabled = true;

  List<RoutineItem> routines = [];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _categoryController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadRoutines();
  }

  //โหลดข้อมูลจาก SharedPreferences
  Future<void> _loadRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? routinesString = prefs.getString('saved_routines');
    if (routinesString != null) {
      Iterable decoded = jsonDecode(routinesString);
      setState(() {
        routines = decoded.map((e) => RoutineItem.fromJson(e)).toList();
      });
    }
    _checkAndResetDailyProgress();
  }

  //บันทึกข้อมูลลง SharedPreferences
  Future<void> _saveRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(routines.map((r) => r.toJson()).toList());
    await prefs.setString('saved_routines', encoded);
  }

  // ฟังก์ชันตรวจสอบและรีเซ็ตค่าเมื่อขึ้นวันใหม่
  Future<void> _checkAndResetDailyProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDateStr = prefs.getString('last_reset_date');
    DateTime now = DateTime.now();
    String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // ถ้าข้ามวันหรือเปิดแอปครั้งแรก
    if (lastDateStr != todayStr) {
      setState(() {
        for (var item in routines) {
          item.isCompleted = false;
        }
      });
      await prefs.setString('last_reset_date', todayStr);
      _saveRoutines();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    _detailController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  double get _progress {
    if (routines.isEmpty) return 0.0;
    int totalActive = routines.where((r) => r.isActive).length;
    if (totalActive == 0) return 0.0;

    int completed = routines.where((r) => r.isActive && r.isCompleted).length;
    return completed / totalActive;
  }

  // ฟังก์ชันคำนวณช่วงเวลาจาก TimeOfDay
  String _getPeriodFromTime(TimeOfDay time) {
    int hour = time.hour;
    // 05.00 - 11.59 -> เช้า
    if (hour >= 5 && hour < 12) {
      return 'เช้า';
    }
    // 12.00 - 16.59 -> บ่าย
    else if (hour >= 12 && hour < 17) {
      return 'บ่าย';
    }
    // 17.00 - 04.59 -> เย็น
    else {
      return 'เย็น';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndResetDailyProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'กิจวัตร',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isNotificationEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: isNotificationEnabled ? kPrimaryGreen : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isNotificationEnabled = !isNotificationEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isNotificationEnabled
                      ? "เปิดการแจ้งเตือนแล้ว"
                      : "ปิดการแจ้งเตือนแล้ว"),
                  duration: const Duration(milliseconds: 800),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildProgressBlock(),
          Expanded(
            child: routines.isEmpty ? _buildEmptyState() : _buildRoutineList(),
          ),
        ],
      ),
      floatingActionButton: routines.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: kPrimaryGreen,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showRoutineFormDialog(),
            )
          : null,
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildProgressBlock() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSoftGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ความคืบหน้าประจำวัน",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${(_progress * 100).toInt()}%",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: GestureDetector(
        onTap: () => _showRoutineFormDialog(),
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline,
                  size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 10),
              Text(
                "เพิ่มกิจวัตรใหม่",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineList() {
    List<RoutineItem> morningList =
        routines.where((r) => r.period == 'เช้า').toList();
    List<RoutineItem> afternoonList =
        routines.where((r) => r.period == 'บ่าย').toList();
    List<RoutineItem> eveningList =
        routines.where((r) => r.period == 'เย็น').toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        if (morningList.isNotEmpty) ...[
          _buildSectionHeader("ช่วงเช้า", Icons.wb_sunny_outlined),
          ...morningList.map((item) => _buildRoutineCard(item)),
        ],
        if (afternoonList.isNotEmpty) ...[
          _buildSectionHeader("ช่วงบ่าย", Icons.wb_sunny),
          ...afternoonList.map((item) => _buildRoutineCard(item)),
        ],
        if (eveningList.isNotEmpty) ...[
          _buildSectionHeader("ช่วงเย็น", Icons.nights_stay_outlined),
          ...eveningList.map((item) => _buildRoutineCard(item)),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(RoutineItem item) {
    return Opacity(
      opacity: item.isActive ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: item.isCompleted ? kPrimaryGreen : Colors.grey.shade200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: item.isActive
                    ? () {
                        setState(() {
                          item.isCompleted = !item.isCompleted;
                        });
                        _saveRoutines();
                      }
                    : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: item.isCompleted ? kPrimaryGreen : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.isCompleted
                          ? kPrimaryGreen
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: item.isCompleted
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: item.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "${item.time.format(context)} น.",
                          style: TextStyle(fontSize: 12, color: kPrimaryGreen),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ปุ่มแก้ไข
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: Colors.blue, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showRoutineFormDialog(itemToEdit: item),
              ),
              const SizedBox(width: 8),

              // ปุ่มลบ
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _confirmDelete(item),
              ),
              const SizedBox(width: 8),

              // Switch เปิด/ปิด
              Switch(
                value: item.isActive,
                activeColor: kPrimaryGreen,
                onChanged: (val) {
                  setState(() {
                    item.isActive = val;
                  });
                  _saveRoutines();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ป๊อปอัพ confirmDelete
  void _confirmDelete(RoutineItem item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("ยืนยันการลบ"),
          content: const Text("คุณต้องการลบกิจวัตรนี้ใช่หรือไม่?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  routines.remove(item);
                });
                _saveRoutines();
                Navigator.of(ctx).pop();
              },
              child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // เพิ่มและการแก้ไข
  void _showRoutineFormDialog({RoutineItem? itemToEdit}) {
    bool isEditing = itemToEdit != null;

    if (isEditing) {
      _titleController.text = itemToEdit.title;
      _detailController.text = itemToEdit.detail;
      _categoryController.text = itemToEdit.category;
      _selectedTime = itemToEdit.time;
    } else {
      _titleController.clear();
      _detailController.clear();
      _categoryController.clear();
      _selectedTime = const TimeOfDay(hour: 8, minute: 0);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEditing ? "แก้ไขกิจวัตร" : "เพิ่มกิจวัตรใหม่"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(labelText: 'ชื่อกิจวัตร'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอกชื่อกิจวัตร';
                          }
                          if (value.characters.length < 2 ||
                              value.characters.length > 30) {
                            return 'ต้องมีความยาว 2-30 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _detailController,
                        decoration:
                            const InputDecoration(labelText: 'รายละเอียด (ไม่บังคับ)'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (value.characters.length < 2 ||
                              value.characters.length > 100) {
                            return 'ต้องมีความยาว 2-100 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (time != null) {
                                setStateDialog(() {
                                  _selectedTime = time;
                                });
                              }
                            },
                            child: Text(
                              "เวลา: ${_selectedTime.format(context)}",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryGreen),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                            labelText: 'หมวดหมู่ (ไม่บังคับ)'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (value.characters.length < 2 ||
                              value.characters.length > 30) {
                            return 'ต้องมีความยาว 2-30 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ยกเลิก",
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        String detailText = _detailController.text.trim();
                        String categoryText = _categoryController.text.trim();
                        
                        if (categoryText.isEmpty) {
                          categoryText = 'ทั่วไป';
                        }

                        String autoPeriod = _getPeriodFromTime(_selectedTime);

                        if (isEditing) {
                          itemToEdit!.title = _titleController.text.trim();
                          itemToEdit.detail = detailText;
                          itemToEdit.category = categoryText;
                          itemToEdit.time = _selectedTime;
                          itemToEdit.period = autoPeriod;
                        } else {
                          routines.add(RoutineItem(
                            title: _titleController.text.trim(),
                            detail: detailText,
                            category: categoryText,
                            time: _selectedTime,
                            period: autoPeriod,
                          ));
                        }
                      });
                      _saveRoutines();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("บันทึก",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}