import 'package:curacare/models/search_condition_model.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:flutter/material.dart';

class SearchListTile extends StatefulWidget {
  const SearchListTile({super.key, required this.searchCondition});

  final SearchConditionModel searchCondition;

  @override
  State<SearchListTile> createState() => _SearchListTileState();
}

class _SearchListTileState extends State<SearchListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.searchCondition.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      subtitle: Text(widget.searchCondition.description),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConditionDetailPage(
              conditionId: widget.searchCondition.objectID,
            ),
          ),
        );
      },
    );
  }
}
