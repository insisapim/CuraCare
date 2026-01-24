import 'package:curacare/models/condition.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/search_result.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final kPrimaryGreen = Color(0xFF2ECC71);
  final kSoftGreen = Color(0xFFE9FBF3);
  final textGreen = Color.fromARGB(255, 0, 153, 5);

  final List<Condition> testConditions = [
    Condition(
      id: '1',
      name: 'decease',
      description: "test",
      detail: "This will be long text",
    ),
    Condition(
      id: '2',
      name: 'Normal',
      description: "test",
      detail: "This will be long text",
    ),
    Condition(
      id: '2',
      name: 'Insi kaka',
      description: "test",
      detail: "This will be long text",
    ),
  ];

  final PreferredSizeWidget _buildAppBar = AppBar(
    title: Text(
      "ค้นหา",
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
    ),
    automaticallyImplyLeading: false,
  );

  final Widget _buildSearchBar = SearchBar(hintText: "ค้นหาอาการ");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6FFFB),
      appBar: _buildAppBar,
      body: Column(
        spacing: 20,
        children: [
          _buildSearchBar,
          Expanded(child: SearchResult(conditionList: testConditions)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
