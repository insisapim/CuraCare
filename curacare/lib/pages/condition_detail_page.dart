import 'package:curacare/models/condition_model.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:curacare/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConditionDetailPage extends StatefulWidget {
  const ConditionDetailPage({super.key, required this.conditionId});

  final String conditionId;

  @override
  State<ConditionDetailPage> createState() => _ConditionDetailPageState();
}

class _ConditionDetailPageState extends State<ConditionDetailPage> {
  late Future<ConditionModel?> _conditionFuture;
  late Future<UserModel?> _userModelFuture;

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _conditionFuture = ConditionService.getById(widget.conditionId);
    _userModelFuture = UserService.getByUid();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
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

                if (userProfile.conditions.contains(widget.conditionId)) {
                  return TextButton(
                    onPressed: () async {
                      await UserService.removeCondition(
                        conditionId: widget.conditionId,
                      );
                      setState(() {
                        _userModelFuture = UserService.getByUid();
                      });
                    },
                    child: Text("ลบบันทึก"),
                  );
                }

                return TextButton(
                  onPressed: () async {
                    await UserService.addCondition(
                      conditionId: widget.conditionId,
                    );
                  },
                  child: Text("บันทึก"),
                );
              },
            ),
          ],
  );

  Widget _buildBody() => FutureBuilder(
    future: _conditionFuture,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("ขออภัย เกิดข้อผิดพลาดในการดึงข้อมูลโรค"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData) {
        return Center(child: Text("ขออภัย ไม่พบข้อมูลโรคนี้"));
      }

      final condition = snapshot.data!;

      return Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Text(
                condition.name,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(condition.description, style: const TextStyle(fontSize: 20)),
              Text(condition.detail, style: const TextStyle(fontSize: 17)),
              Image.network(
                condition.imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody());
  }
}
