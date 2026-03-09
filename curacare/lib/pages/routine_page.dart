import 'package:curacare/models/routine_model.dart';
import 'package:curacare/pages/login_page.dart';
import 'package:curacare/services/routine_service.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/routine_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    setState(() {
      _routines = RoutineService.get();
    });
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

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    title: const Text('กิจวัตร', style: TextStyle(fontWeight: FontWeight.bold)),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
  );

  void _showRoutineFormDialog(RoutineModel? itemToEdit) {
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
      onTap: () {
        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => LoginPage()));
          return;
        }
        _showRoutineFormDialog(null);
      },
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
        return RoutineCard(
          routine: routine,
          voidCallback: () => setState(() {
            _routines = RoutineService.get();
          }),
          openDialog: _showRoutineFormDialog,
        );
      },
    );
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

  Widget _buildResult(List<RoutineModel> routines) => Column(
    children: [
      _buildProgressBlock(routines),
      Expanded(child: _buildRoutineList(routines)),
    ],
  );

  Widget _buildBody(BuildContext context) => FutureBuilder(
    future: _routines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("ขออภัย เกิดข้อผิดพลาดระหว่างดึงข้อมูล"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return Center(child: Text("ขออภัย เกิดข้อผิดพลาดระหว่างดึงข้อมูล"));
      }

      final data = snapshot.data!;
      if (data.isEmpty) {
        return _buildEmptyState;
      }

      return _buildResult(data);
    },
  );

  Widget _buildFloatingActionButton(BuildContext context) => FutureBuilder(
    future: _routines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      if (!snapshot.hasData) {
        return Text("Error");
      }

      final routines = snapshot.data!;

      if (routines.isEmpty) {
        return Container();
      }

      return FloatingActionButton(
        backgroundColor: kPrimaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showRoutineFormDialog(null),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
