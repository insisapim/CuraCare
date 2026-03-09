import 'package:curacare/models/condition_model.dart';
import 'package:curacare/pages/search_page.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:curacare/widgets/condition_card.dart';
import 'package:curacare/widgets/condition_list_tile.dart';
import 'package:flutter/material.dart';

class UserConditionPage extends StatefulWidget {
  const UserConditionPage({super.key});

  @override
  State<UserConditionPage> createState() => _UserConditionPageState();
}

class _UserConditionPageState extends State<UserConditionPage> {
  late Future<List<ConditionModel>> _conditions;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _conditions = ConditionService.getFromUser();
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
              .push(MaterialPageRoute(builder: (context) => SearchPage()))
              .then(
                (_) => setState(() {
                  _conditions = ConditionService.getFromUser();
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
          "เพิ่มโรค",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );

  Widget _buildConditionList(BuildContext context) => Expanded(
    child: FutureBuilder(
      future: _conditions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("บันทึกโรคแรกของคุณกัน!"));
        }

        final data = snapshot.data!;

        if (data.isEmpty) {
          return Center(child: Text("บันทึกโรคแรกของคุณกัน!"));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final condition = data[index];
            return ConditionCard(
              listTile: ConditionListTile(
                condition: condition,
                voidCallBack: () => setState(() {
                  _conditions = ConditionService.getFromUser();
                }),
              ),
              cardIcon: Icon(
                Icons.medical_services_outlined,
                color: Colors.blue,
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
        children: [_buildAddButton(context), _buildConditionList(context)],
      ),
    );
  }
}
