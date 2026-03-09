import 'package:curacare/models/condition_model.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:flutter/material.dart';

class ConditionListTile extends StatefulWidget {
  const ConditionListTile({
    super.key,
    required this.condition,
    this.voidCallBack,
  });

  final ConditionModel condition;
  final VoidCallback? voidCallBack;

  @override
  State<ConditionListTile> createState() => _ConditionListTileState();
}

class _ConditionListTileState extends State<ConditionListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.condition.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      subtitle: Text(widget.condition.description),
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) =>
                    ConditionDetailPage(conditionId: widget.condition.id),
              ),
            )
            .then(
              (_) => {
                if (widget.voidCallBack != null) {widget.voidCallBack!.call()},
              },
            );
      },
    );
  }
}
