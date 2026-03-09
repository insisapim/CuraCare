import 'dart:developer';

import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/pages/medicine_detail_page.dart';
import 'package:curacare/pages/medicine_page.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:flutter/material.dart';

class UserMedicinePage extends StatefulWidget {
  const UserMedicinePage({super.key});

  @override
  State<UserMedicinePage> createState() => _UserMedicinePageState();
}

class _UserMedicinePageState extends State<UserMedicinePage> {
  late Future<List<MedicineModel>> _medicines;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _medicines = MedicineService.getFromUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(8),

            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MedicinePage()),
                  );
                },

                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.green.shade600,
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  elevation: WidgetStatePropertyAll(2),
                ),
                child: Text(
                  "เพิ่มยา",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _medicines,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("บันทึกยาแรกของคุณกัน!"));
                }

                final data = snapshot.data!;

                if (data.isEmpty) {
                  return Center(child: Text("บันทึกยาแรกของคุณกัน!"));
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final medicine = data[index];
                    return ListTile(
                      title: Text(
                        medicine.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      subtitle: Text(medicine.description),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MedicineDetailPage(medicineId: medicine.id),
                          ),
                        );
                      },

                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
