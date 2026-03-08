import 'dart:developer';

import 'package:curacare/models/condition_model.dart';
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

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _conditionFuture = _loadCondition();
  }

  Future<ConditionModel?> _loadCondition() async {
    final condition = await ConditionService.getById(widget.conditionId);
    if (condition == null) return null;
    ConditionService.increaseView(condition.id);
    return condition;
  }

  Future<Image> _loadImage(String url) async {
    return Image.network(url);
  }

  PreferredSizeWidget _buildAppBar(ConditionModel condition) {
    log(user.toString());
    if (user != null) {
      return AppBar(
        title: Text(condition.name),
        actions: [
          TextButton(
            onPressed: () async {
              await UserService.addCondition(conditionId: condition.id);
            },
            child: Text("บันทึก"),
          ),
        ],
      );
    }
    return AppBar(title: Text(condition.name));
  }

  Widget _buildBody(ConditionModel condition) {
    return Column(
      spacing: 10,
      children: [
        Text(condition.name, style: const TextStyle(fontSize: 20)),
        Text("อาการ: ${condition.description}"),
        Text(condition.detail),
        FutureBuilder<Image>(
          future: _loadImage(condition.imageUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Icon(Icons.error, color: Colors.red);
            } else if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildScaffold(ConditionModel condition) {
    return Scaffold(
      appBar: _buildAppBar(condition),
      body: _buildBody(condition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConditionModel?>(
      future: _conditionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          if (snapshot.data == null) {
            Navigator.of(context).pop();
          }
          return _buildScaffold(snapshot.data!);
        } else {
          return const Center(child: Text("No data found"));
        }
      },
    );
  }
}
