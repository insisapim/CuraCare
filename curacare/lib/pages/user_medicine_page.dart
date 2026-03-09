import 'dart:developer';
import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/pages/medicine_page.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:curacare/widgets/medicine_card.dart';
import 'package:curacare/widgets/medicine_list_tile.dart';
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

  Widget _buildAddButton(BuildContext context) => Padding(
    padding: EdgeInsetsGeometry.all(8),

    child: SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MedicinePage()))
              .then(
                (_) => setState(() {
                  _medicines = MedicineService.getFromUser();
                }),
              );
        },

        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.green.shade600),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevation: WidgetStatePropertyAll(2),
        ),
        child: Text(
          "เพิ่มยา",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );

  Widget _buildMedicineList(BuildContext context) => Expanded(
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

            return MedicineCard(
              listTile: MedicineListTile(
                medicine: medicine,
                voidCallBack: () => setState(() {
                  _medicines = MedicineService.getFromUser();
                }),
              ),
            );
          },
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [_buildAddButton(context), _buildMedicineList(context)],
      ),
    );
  }
}
