import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/user_service.dart';
import 'package:flutter/material.dart';

class MedicineListTile extends StatefulWidget {
  const MedicineListTile({
    super.key,
    required this.medicine,
    required this.voidCallBack,
  });

  final MedicineModel medicine;
  final VoidCallback? voidCallBack;

  @override
  State<MedicineListTile> createState() => _MedicineListTileState();
}

class _MedicineListTileState extends State<MedicineListTile> {
  late Future<UserModel?> _userModelFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModelFuture = UserService.getByUid();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.medicine.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      subtitle: Text(widget.medicine.description),
      trailing: FutureBuilder(
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

          if (userProfile.medicines.contains(widget.medicine.id)) {
            return TextButton(
              onPressed: () async {
                await UserService.removeMedicine(widget.medicine.id);
                setState(() {
                  _userModelFuture = UserService.getByUid();
                });
                if (widget.voidCallBack != null) {
                  widget.voidCallBack!.call();
                }
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
            );
          }

          return TextButton(
            onPressed: () async {
              await UserService.addMedicine(widget.medicine.id);
              setState(() {
                _userModelFuture = UserService.getByUid();
              });
              if (widget.voidCallBack != null) {
                widget.voidCallBack!.call();
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF2ECC71),

                borderRadius: BorderRadius.circular(
                  15.0,
                ), // Apply border radius
              ),
              child: Text(
                "บันทึก",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
