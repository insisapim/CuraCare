import 'package:curacare/models/condition.dart';
import 'package:flutter/material.dart';

class ConditionDetailPage extends StatefulWidget {
  const ConditionDetailPage({super.key, required this.condition});

  final Condition condition;

  @override
  State<ConditionDetailPage> createState() => _ConditionDetailPageState();
}

class _ConditionDetailPageState extends State<ConditionDetailPage> {
  PreferredSizeWidget _buildAppBar(Condition condition) {
    return AppBar(title: Text(condition.name));
  }

  Widget _buildBody(Condition condition) {
    return Column(
      children: [
        Text(condition.name),
        Text(condition.description),
        Text(condition.detail),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.condition),
      body: _buildBody(widget.condition),
    );
  }
}
