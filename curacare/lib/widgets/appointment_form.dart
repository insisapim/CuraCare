
import 'package:flutter/material.dart';

class AppointmentFormDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController titleController;
  final TextEditingController detailController;
  final TextEditingController locationController;
  final TextEditingController dateController;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final VoidCallback onPickDate;

  final String title;

  AppointmentFormDialog({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.detailController,
    required this.locationController,
    required this.dateController,
    required this.onSubmit,
    required this.onCancel,
    required this.onPickDate,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Form(
        key: formKey,

        child: Padding(
          padding: EdgeInsets.all(16),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "หัวข้อนัดหมาย",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณากรอกหัวข้อ";
                  }
                  if (value.length < 3) {
                    return "อย่างน้อย 3 ตัวอักษร";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "สถานที่",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณากรอกสถานที่";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: detailController,
                decoration: InputDecoration(
                  labelText: "รายละเอียด",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: onPickDate,
                decoration: InputDecoration(
                  labelText: "เวลานัดหมาย",
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาเลือกเวลา";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: onSubmit, child: Text("บันทึก")),

                  SizedBox(width: 10),
 
                  ElevatedButton(
                    onPressed: onCancel,

                    child: Text("ยกเลิก"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
