import 'package:curacare/models/condition_model.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:curacare/pages/search_page.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:flutter/material.dart';

class UserConditionPage extends StatefulWidget {
  const UserConditionPage({super.key});

  @override
  State<UserConditionPage> createState() => _UserConditionPageState();
}

class _UserConditionPageState extends State<UserConditionPage> {
  late Future<List<ConditionModel>> conditions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conditions = ConditionService.getFromUser();
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
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => SearchPage()));
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
                  "เพิ่มโรค",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: conditions,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("กำลังโหลดข้อมูล"));
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("บันทึกโรคแรกของคุณกัน!"));
                }

                final data = snapshot.data!;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final condition = data[index];
                    return ListTile(
                      title: Text(
                        condition.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      subtitle: Text(condition.description),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ConditionDetailPage(conditionId: condition.id),
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
