import 'package:curacare/models/condition.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:curacare/services/condition.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.searchText});

  final String? searchText;

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
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Set initial search text from navigation parameter
    if (widget.searchText != null && widget.searchText!.isNotEmpty) {
      _searchController.text = widget.searchText!;
    }

    searchConditions(_searchController.value.text);

    // Listen for scroll to load more
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        fetchConditions(_searchController.value.text);
      }
    });
  }

  final PreferredSizeWidget _buildAppBar = AppBar(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ค้นหาโรค",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Text(
          "ค้นหาโรคจากชื่อหรืออาการที่คุณพบ",
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
    automaticallyImplyLeading: false,
    toolbarHeight: 80,
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
    final conditions = await getConditions(0, query);

    setState(() {
      _conditions.clear();
      _conditions.addAll(conditions);
      _page = 1;
      _isLoading = false;
    });
  }

  Widget _buildListTileCard(ListTile listTile) {
    return Card(
      color: Colors.white,
      child: listTile,
      shadowColor: Colors.black,
    );
  }

  Widget _buildResult(List<Condition> conditionList) {
    if (_conditions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Text(
            "ขออภัย ไม่พบโรคหรืออาการที่คุณต้องการ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: conditionList.length,
      itemBuilder: (context, index) {
        final condition = conditionList[index];
        String description = "";
        if (condition.description != null) {
          description = condition.description!;
        }
        ListTile listTile = ListTile(
          title: Text(
            condition.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          subtitle: Text(description),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ConditionDetailPage(conditionId: condition.id),
              ),
            );
          },
        );

        return _buildListTileCard(listTile);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: Column(
        spacing: 20,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, right: 5),
            child: SearchBar(
              controller: _searchController,
              hintText: "ค้นหาโรค อาการ...",
              onChanged: (value) => searchConditions(value),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
          ),

          Expanded(child: _buildResult(_conditions)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
