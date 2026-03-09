import 'package:flutter/material.dart';

class MedicineCard extends StatefulWidget {
  const MedicineCard({super.key, required this.listTile});

  final Widget listTile;

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 255, 255, 255),
      margin: EdgeInsets.only(left: 10, top: 12, right: 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Icon(Icons.medical_services_outlined, color: Colors.blue),
            SizedBox(width: 10),
            // แก้ตรงนี้: ใช้ Expanded หุ้ม item ไว้
            Expanded(child: widget.listTile),
          ],
        ),
      ),
    );
  }
}
