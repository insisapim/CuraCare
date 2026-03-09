import 'package:flutter/material.dart';

class HomepageNavigate extends StatelessWidget {
  final String card_title;
  final String card_sup_title;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final Color? textcolor;
  final Widget? screen;
  final VoidCallback? toScreen;
  const HomepageNavigate({
    super.key,
    required this.card_title,
    required this.card_sup_title,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.textcolor,
    this.screen,
    this.toScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: toScreen,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      Text(
                        card_title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
        ),
      ],
    );
  }
}
