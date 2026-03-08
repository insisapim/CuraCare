import 'dart:convert';
import 'package:curacare/models/routine_model.dart';
import 'package:curacare/services/routine_service.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> with WidgetsBindingObserver {
  final Color kPrimaryGreen = const Color(0xFF2ECC71);
  final Color kSoftGreen = const Color(0xFFE9FBF3);

  bool isNotificationEnabled = true;

  late Future<List<RoutineModel>> _routines;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _categoryController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _checkAndResetDailyProgress();
    _routines = RoutineService.get();
  }

  Future<void> _checkAndResetDailyProgress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? lastDateStr = pref.getString('last_reset_date');
    DateTime now = DateTime.now();
    String todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    if (lastDateStr != todayStr) {
      await RoutineService.resetStatus();
      await pref.setString('last_reset_date', todayStr);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndResetDailyProgress();
    }
  }

  Widget _buildScaffoldNotEmpty(
    BuildContext context,
    List<RoutineModel> routines,
  ) => Scaffold(
    backgroundColor: Colors.white,
    appBar: _buildAppBar(context),
    body: Column(
      children: [
        _buildProgressBlock(routines),
        Expanded(child: _buildRoutineList(routines)),
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

  Widget _buildScaffoldEmpty(
    BuildContext context,
    List<RoutineModel> routines,
  ) => Scaffold(
    backgroundColor: Colors.white,
    appBar: _buildAppBar(context),
    body: _buildEmptyState,
    bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
  );

  Widget _buildPage(BuildContext context) => FutureBuilder(
    future: _routines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("ขออภัย เกิดข้อผิดพลาดระหว่างดึงข้อมูล"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("โหลดข้อมูล"));
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return Center(child: Text("ขออภัย เกิดข้อผิดพลาดระหว่างดึงข้อมูล"));
      }

      final data = snapshot.data!;
      if (data.isEmpty) {
        return _buildScaffoldEmpty(context, data);
      }

      return _buildScaffoldNotEmpty(context, data);
    },
  );

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    title: const Text('กิจวัตร', style: TextStyle(fontWeight: FontWeight.bold)),
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
              content: Text(
                isNotificationEnabled
                    ? "เปิดการแจ้งเตือนแล้ว"
                    : "ปิดการแจ้งเตือนแล้ว",
              ),
              duration: const Duration(milliseconds: 800),
            ),
          );
        },
      ),
      const SizedBox(width: 10),
    ],
  );

  Widget _buildRoutineCard(RoutineModel item) {
    return Opacity(
      opacity: item.isCompleted ? 0.5 : 1,
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
                onTap: () async {
                  await RoutineService.update(
                    item.id,
                    item.title,
                    item.detail,
                    item.time,
                    !item.isCompleted,
                  );
                  setState(() {
                    _routines = RoutineService.get();
                  });
                },
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
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ปุ่มแก้ไข
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blue,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showRoutineFormDialog(itemToEdit: item),
              ),
              const SizedBox(width: 8),

              // ปุ่มลบ
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _confirmDelete(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(RoutineModel item) {
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await RoutineService.remove(item.id);
                setState(() {
                  _routines = RoutineService.get();
                });

                Navigator.of(ctx).pop();
              },
              child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showRoutineFormDialog({RoutineModel? itemToEdit}) {
    bool isEditing = itemToEdit != null;

    if (isEditing) {
      _titleController.text = itemToEdit.title;
      _detailController.text = itemToEdit.detail;
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
                        decoration: const InputDecoration(
                          labelText: 'ชื่อกิจวัตร',
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'รายละเอียด (ไม่บังคับ)',
                        ),
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
                                fontSize: 16,
                                color: kPrimaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (isEditing) {
                        await RoutineService.update(
                          itemToEdit.id,
                          _titleController.text.trim(),
                          _detailController.text.trim(),
                          _selectedTime,
                          itemToEdit.isCompleted,
                        );
                      } else {
                        RoutineService.add(
                          _titleController.text.trim(),
                          _detailController.text.trim(),
                          _selectedTime,
                        );
                      }
                      setState(() {
                        _routines = RoutineService.get();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "บันทึก",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget get _buildEmptyState => Center(
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
            Icon(
              Icons.add_circle_outline,
              size: 60,
              color: Colors.grey.shade400,
            ),
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

  Widget _buildRoutineList(List<RoutineModel> routines) {
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        final routine = routines[index];
        return _buildRoutineCard(routine);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Widget _buildProgressBlock(List<RoutineModel> routines) {
    int completes = 0;
    for (var routine in routines) {
      if (routine.isCompleted) {
        completes += 1;
      }
    }

    final double progress = completes / routines.length;

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
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryGreen),
            ),
          ),
        ],
      ),
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
}
