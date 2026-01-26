import 'dart:convert';

import 'package:curacare/models/condition.dart';
import 'package:curacare/services/condition.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/search_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final kPrimaryGreen = Color(0xFF2ECC71);
  final kSoftGreen = Color(0xFFE9FBF3);
  final textGreen = Color.fromARGB(255, 0, 153, 5);

  final ScrollController _scrollController = ScrollController();

  final List<Condition> _conditions = [];
  bool _isLoading = false;
  int _page = 0;

  Future<void> fetchConditions() async {
    if (_isLoading) return;
    _isLoading = true;
    final conditions = await getConditions(_page);

    setState(() {
      _conditions.addAll(conditions);
      _page++;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchConditions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        fetchConditions();
      }
    });
  }

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
          Expanded(child: SearchResult(conditionList: _conditions)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
