import 'dart:developer';
import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/pages/medicine_page.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:flutter/material.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/user_service.dart';

class UserMedicinePage extends StatefulWidget {
  const UserMedicinePage({super.key});

  @override
  State<UserMedicinePage> createState() => _UserMedicinePageState();
}

class _UserMedicinePageState extends State<UserMedicinePage> {
  late Future<List<MedicineModel>> _medicines;
  late Future<UserModel?> _userModelFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModelFuture = UserService.getByUid();
    _medicines = MedicineService.getFromUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildListTileCard(ListTile listTile) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: EdgeInsets.only(left: 10, top: 12, right: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Icon(Icons.medical_services_outlined, color: Colors.blue),
            SizedBox(width: 10),
            // แก้ตรงนี้: ใช้ Expanded หุ้ม item ไว้
            Expanded(child: listTile),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(8),

            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(builder: (context) => MedicinePage()),
                      )
                      .then(
                        (_) => setState(() {
                          _medicines = MedicineService.getFromUser();
                          _userModelFuture = UserService.getByUid();
                        }),
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
                    ListTile listTile = ListTile(
                      title: Text(
                        medicine.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      subtitle: Text(medicine.description),
                      trailing: TextButton(
                        onPressed: () async {
                          await UserService.removeMedicine(medicine.id);
                          setState(() {
                            _userModelFuture = UserService.getByUid();
                            _medicines = MedicineService.getFromUser();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 0, 0),

                            borderRadius: BorderRadius.circular(
                              15.0,
                            ), // Apply border radius
                          ),
                          child: Text(
                            "ลบบันทึก",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                    return _buildListTileCard(listTile);
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
