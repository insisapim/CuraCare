import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/user_service.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  late Future<List<MedicineModel>> _medicines;
  late Future<UserModel?> _userModelFuture;

  final SearchController _searchController = SearchController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModelFuture = UserService.getByUid();
    _medicines = MedicineService.get(null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  final PreferredSizeWidget _buildAppBar = AppBar(
    backgroundColor: Colors.white,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ค้นหายา",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    automaticallyImplyLeading: false,
    toolbarHeight: 80,
  );

  Widget _buildListTileCard(ListTile listTile) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: EdgeInsets.only(left: 10, top: 12, right: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Icon(
              Icons.medication_rounded,
              color: const Color.fromARGB(255, 255, 109, 90),
            ),
            SizedBox(width: 10),
            // แก้ตรงนี้: ใช้ Expanded หุ้ม item ไว้
            Expanded(child: listTile),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context) => FutureBuilder(
    future: _medicines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text(snapshot.error.toString()));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData) {
        return Center(child: Text("ไม่พบข้อมูลยา"));
      }

      if (snapshot.data!.isEmpty) {
        return Center(child: Text("ไม่พบข้อมูลยา"));
      }

      final medicines = snapshot.data!;

      return ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          ListTile listTile = ListTile(
            title: Text(
              medicine.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
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

                if (userProfile.medicines.contains(medicine.id)) {
                  return TextButton(
                    onPressed: () async {
                      await UserService.removeMedicine(medicine.id);
                      setState(() {
                        _userModelFuture = UserService.getByUid();
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
                  );
                }

                return TextButton(
                  onPressed: () async {
                    await UserService.addMedicine(medicine.id);
                    setState(() {
                      _userModelFuture = UserService.getByUid();
                    });
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

          return _buildListTileCard(listTile);
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar,
      body: Column(
        spacing: 20,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, right: 5),
            child: SearchBar(
              controller: _searchController,
              hintText: "ค้นหาโรค อาการ...",
              onSubmitted: (value) => setState(() {
                _medicines = MedicineService.get(value);
              }),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
          ),

          Expanded(child: _buildResult(context)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
