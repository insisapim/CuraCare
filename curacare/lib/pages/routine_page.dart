import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

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
}

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final Color kPrimaryGreen = const Color(0xFF2ECC71);
  final Color kSoftGreen = const Color(0xFFE9FBF3);

  bool isNotificationEnabled = true;

  List<RoutineItem> routines = [];

  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _categoryController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  String _selectedPeriod = 'เช้า';

  @override
  void dispose() {
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
            child: routines.isEmpty
                ? _buildEmptyState()
                : _buildRoutineList(),
          ),
        ],
      ),
      floatingActionButton: routines.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: kPrimaryGreen,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showAddRoutineDialog(),
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
        onTap: () => _showAddRoutineDialog(),
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
              Icon(Icons.add_circle_outline, size: 60, color: Colors.grey.shade400),
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
                      }
                    : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: item.isCompleted ? kPrimaryGreen : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.isCompleted ? kPrimaryGreen : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: item.isCompleted
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 15),
              
              // รายละเอียด
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // ขีดฆ่าข้อความถ้าทำเสร็จแล้ว
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

              // Switch เปิด/ปิด
              Switch(
                value: item.isActive,
                activeColor: kPrimaryGreen,
                onChanged: (val) {
                  setState(() {
                    item.isActive = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddRoutineDialog() {
    _titleController.clear();
    _detailController.clear();
    _categoryController.clear();
    _selectedTime = const TimeOfDay(hour: 8, minute: 0);
    _selectedPeriod = 'เช้า';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("เพิ่มกิจวัตรใหม่"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'ชื่อกิจวัตร'),
                    ),
                    TextField(
                      controller: _detailController,
                      decoration: const InputDecoration(labelText: 'รายละเอียด'),
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
                            style: TextStyle(fontSize: 16, color: kPrimaryGreen),
                          ),
                        ),
                      ],
                    ),
                    
                    DropdownButtonFormField<String>(
                      value: _selectedPeriod,
                      decoration: const InputDecoration(labelText: 'ช่วงเวลา'),
                      items: ['เช้า', 'บ่าย', 'เย็น'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setStateDialog(() {
                          _selectedPeriod = newValue!;
                        });
                      },
                    ),

                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                          labelText: 'หมวดหมู่ (เช่น เบาหวาน)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                  ),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      setState(() {
                        routines.add(RoutineItem(
                          title: _titleController.text,
                          detail: _detailController.text,
                          category: _categoryController.text.isEmpty
                              ? 'ทั่วไป'
                              : _categoryController.text,
                          time: _selectedTime,
                          period: _selectedPeriod,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("บันทึก", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}