import 'package:flutter/material.dart';

class ChronicdiseasePage extends StatefulWidget {
  const ChronicdiseasePage({super.key});

  @override
  State<ChronicdiseasePage> createState() => _ChronicdiseasePageState();
}

class _ChronicdiseasePageState extends State<ChronicdiseasePage> {
  @override
  Widget build(BuildContext context) {
    void openRecord(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'เพิ่มโรค',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'ชื่อโรค',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'หมายเหตุ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('บันทึก', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
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
              "บันทึกโรคประจำตัว",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                onPressed: () => openRecord(context),
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
