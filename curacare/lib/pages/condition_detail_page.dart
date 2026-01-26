import 'package:curacare/models/condition.dart';
import 'package:curacare/services/condition.dart';
import 'package:flutter/material.dart';

class ConditionDetailPage extends StatefulWidget {
  const ConditionDetailPage({super.key, required this.conditionId});

  final String conditionId;

  @override
  State<ConditionDetailPage> createState() => _ConditionDetailPageState();
}

class _ConditionDetailPageState extends State<ConditionDetailPage> {
  late Future<Condition> condition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    condition = getConditionById(widget.conditionId);
  }

  PreferredSizeWidget _buildAppBar(Condition condition) {
    return AppBar(title: Text(condition.name));
  }

  Widget _buildBody(Condition condition) {
    String description = "";
    if (condition.description != null) {
      description = condition.description!;
    }
    String detail = "";
    if (condition.detail != null) {
      detail = condition.detail!;
    }
    return Center(
      child: Column(
        children: [Text(condition.name), Text(description), Text(detail)],
      ),
    );
  }

  Widget _buildScaffold(Condition condition) {
    return Scaffold(
      appBar: _buildAppBar(condition),
      body: _buildBody(condition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: condition,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildScaffold(snapshot.data!);
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
