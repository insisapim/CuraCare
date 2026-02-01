import 'package:flutter/material.dart';

class ChronicdiseasePage extends StatefulWidget {
  const ChronicdiseasePage({super.key});

  @override
  State<ChronicdiseasePage> createState() => _ChronicdiseasePageState();
}

class _ChronicdiseasePageState extends State<ChronicdiseasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("บันทึกโรคประจำตัว", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "จัดการโรคประจำตัว",
              style: TextStyle(
                color: const Color.fromARGB(255, 131, 131, 131),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text("เพิ่มโรคประจำตัว"),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
