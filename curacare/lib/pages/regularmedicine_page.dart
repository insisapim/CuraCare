import 'package:flutter/material.dart';

class RegularmedicinePage extends StatefulWidget {
  const RegularmedicinePage({super.key});

  @override
  State<RegularmedicinePage> createState() => _RegularmedicinePageState();
}

class _RegularmedicinePageState extends State<RegularmedicinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("บันทึกยา", style: TextStyle(fontWeight: FontWeight.bold),),
          Text("จัดการยาที่ต้องรับประทาน", style: TextStyle(color: const Color.fromARGB(255, 131, 131, 131), fontSize: 16),)
        ],
      )),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text("เพิ่มยารักษา"),
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
