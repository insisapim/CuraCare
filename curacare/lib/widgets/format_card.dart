import 'package:flutter/material.dart';

class FormatCard extends StatelessWidget {
  final String card_title;
  final String card_sup_title;
  final IconData icon;
  const FormatCard({
    super.key,
    required this.card_title,
    required this.card_sup_title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFE9FBF3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Color(0xFF2ECC71), size: 28),
              ),
              SizedBox(width: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card_title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    card_sup_title,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
