import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/medicine_card.dart';
import 'package:curacare/widgets/medicine_list_tile.dart';
import 'package:flutter/material.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  late Future<List<MedicineModel>> _medicines;

  final SearchController _searchController = SearchController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _medicines = MedicineService.get(null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
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
    toolbarHeight: 80,
  );

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

          return MedicineCard(
            listTile: MedicineListTile(medicine: medicine, voidCallBack: null),
          );
        },
      );
    },
  );

  Widget _buildSearchBar(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: 4, right: 5),
    child: SearchBar(
      controller: _searchController,
      hintText: "ค้นหาโรค อาการ...",
      onSubmitted: (value) => setState(() {
        _medicines = MedicineService.get(value);
      }),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        spacing: 20,
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildResult(context)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
