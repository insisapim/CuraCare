import 'package:curacare/models/condition.dart';
import 'package:curacare/services/condition.dart';
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

  final ScrollController _scrollController = ScrollController();

  final SearchController _searchController = SearchController();

  final List<Condition> _conditions = [];
  bool _isLoading = false;
  int _page = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchConditions(_searchController.value.text);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        fetchConditions(_searchController.value.text);
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

  Future<void> fetchConditions(String query) async {
    if (_isLoading) return;
    _isLoading = true;
    final conditions = await getConditions(_page, query);

    setState(() {
      _conditions.addAll(conditions);
      _page++;
      _isLoading = false;
    });
  }

  Future<void> searchConditions(String query) async {
    final conditions = await getConditions(_page, query);

    setState(() {
      _conditions.clear();
      _conditions.addAll(conditions);
      _page = 1;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6FFFB),
      appBar: _buildAppBar,
      body: Column(
        spacing: 20,
        children: [
          SearchBar(
            controller: _searchController,
            hintText: "ค้นหาอาการ",
            onSubmitted: (value) => searchConditions(value),
          ),
          Expanded(child: SearchResult(conditionList: _conditions)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
