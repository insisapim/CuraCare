
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime dateTime;
  final IconData icon;
  final String? requireTask;
  final Color? color;
  final Color? backgroundColor;
  final Color? textcolor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const AppointmentCard({
    super.key,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.icon,
    this.requireTask,
    this.color,
    this.backgroundColor,
    this.textcolor,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var objectColor = color ?? const Color(0xFF2ECC71);
    var objectBackgroundColor =
        backgroundColor ?? const Color.fromARGB(255, 255, 255, 255);
    var task = requireTask ?? "เพิ่มสิ่งที่จำเป็นต้องทำก่อนไปนัดหมาย";
    var formattedDate = DateFormat("d MMMM yyyy HH:mm", "th").format(dateTime);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: objectBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: objectColor, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 6),
                      Text(location),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 6),
                      Text(formattedDate)
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$task",
                      style: TextStyle(
                        color: objectColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == "edit") {
                  onEdit?.call();
                } else if (value == "delete") {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "edit",
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text("แก้ไข"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text("ลบ"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
