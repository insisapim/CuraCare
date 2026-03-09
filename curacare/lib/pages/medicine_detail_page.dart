import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:curacare/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicineDetailPage extends StatefulWidget {
  const MedicineDetailPage({super.key, required this.medicineId});

  final String medicineId;

  @override
  State<MedicineDetailPage> createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  late Future<MedicineModel?> _medicine;
  late Future<UserModel?> _userModelFuture;

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _medicine = MedicineService.getById(widget.medicineId);
    _userModelFuture = UserService.getByUid();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    backgroundColor: Colors.white,
    actions: (user == null)
        ? null
        : [
            FutureBuilder(
              future: _userModelFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData) {
                  return Container();
                }

                final userProfile = snapshot.data!;

                if (userProfile.medicines.contains(widget.medicineId)) {
                  return TextButton(
                    onPressed: () async {
                      await UserService.removeMedicine(widget.medicineId);
                      setState(() {
                        _userModelFuture = UserService.getByUid();
                      });
                    },
                    child: Text("ลบบันทึก"),
                  );
                }

                return TextButton(
                  onPressed: () async {
                    await UserService.addMedicine(widget.medicineId);
                  },
                  child: Text("บันทึก"),
                );
              },
            ),
          ],
  );

  Widget _buildBody() => FutureBuilder(
    future: _medicine,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("ขออภัย เกิดข้อผิดพลาดในการดึงข้อมูลยา"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData) {
        return Center(child: Text("ขออภัย ไม่พบข้อมูลโรคนี้"));
      }

      final medicine = snapshot.data!;

      return Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Text(
                medicine.name,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(medicine.description, style: const TextStyle(fontSize: 17)),
            ],
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,appBar: _buildAppBar(context), body: _buildBody());
  }
}
