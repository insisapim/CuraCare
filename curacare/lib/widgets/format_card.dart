import 'package:flutter/material.dart';

class FormatCard extends StatelessWidget {
  final String card_title;
  final String card_sup_title;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final Color? textcolor;
  final Widget? screen;
  final VoidCallback? toScreen;
  const FormatCard({
    super.key,
    required this.card_title,
    required this.card_sup_title,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.textcolor,
    this.screen,
    this.toScreen
  });

  @override
  Widget build(BuildContext context) {
    var objectColor = color ?? const Color(0xFF2ECC71);
    var objectBackgroundColor =
        backgroundColor ?? const Color.fromARGB(255, 255, 255, 255);
    var objectTextColor = textcolor ?? const Color.fromARGB(255, 0, 0, 0);
    return Card(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: objectBackgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: toScreen,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: objectColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: objectColor, size: 28),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card_title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: objectTextColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    card_sup_title,
                    style: TextStyle(fontSize: 14, color: objectTextColor),
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
