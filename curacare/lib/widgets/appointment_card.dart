import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 227, 184),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.medication_liquid_outlined, color: Colors.orange, size: 28),
              ),
              SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "เจาะเลือดตรวจ HbA1c",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Row(
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 6),
                    Text("ห้องแล็บ โรงพยาบาลกรุงเทพ"),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: const [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 6),
                    Text("12 ม.ค. • 07:00 น."),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "งดอาหาร 8–12 ชม.",
                    style: TextStyle(color: Colors.orange),
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
