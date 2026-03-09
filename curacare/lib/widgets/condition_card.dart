import 'package:flutter/material.dart';

class ConditionCard extends StatefulWidget {
  const ConditionCard({
    super.key,
    required this.listTile,
    required this.cardIcon,
  });

  final Widget listTile;
  final Icon cardIcon;

  @override
  State<ConditionCard> createState() => _ConditionCardState();
}

class _ConditionCardState extends State<ConditionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: EdgeInsets.only(left: 10, top: 12, right: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            widget.cardIcon,

            SizedBox(width: 10),
            Expanded(child: widget.listTile),
          ],
        ),
      ),
    );
  }
}
