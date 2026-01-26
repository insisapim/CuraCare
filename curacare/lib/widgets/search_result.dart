import 'package:curacare/models/condition.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, required this.conditionList});

  final List<Condition> conditionList;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.conditionList.length,
      itemBuilder: (context, index) {
        final condition = widget.conditionList[index];
        String description = "";
        if (condition.description != null) {
          description = condition.description!;
        }
        return ListTile(
          title: Text(
            condition.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(description),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ConditionDetailPage(conditionId: condition.id),
              ),
            );
          },
        );
      },
    );
  }
}
