import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class FirstaidPage extends StatefulWidget {
  const FirstaidPage({super.key});

  @override
  State<FirstaidPage> createState() => _FirstaidPageState();
}

class _FirstaidPageState extends State<FirstaidPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("ปฐมพยาบาลเบื้องต้น", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),), Text("คำแนะนำฉุกเฉินอยู่แค่ปลายนิ้วคุณ", style: TextStyle(fontSize: 18))],
        ),
      ),
      body: Column(
        children: [
          Text("this is body")
          ]
        ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
    );;
  }
}