import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/condition_model.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:curacare/services/condition_service.dart';
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

  final List<ConditionModel> _conditions = [];
  DocumentSnapshot? _lastDoc;
  bool _isLoading = false;
  bool _hasMore = true;

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
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final query = await ConditionService.get(8, _lastDoc, null);

    if (query.isEmpty) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    final conditions = query.map((condition) {
      final map = condition.data();
      map["id"] = condition.id;
      return ConditionModel.fromJson(map);
    }).toList();

    setState(() {
      _conditions.addAll(conditions);
      _lastDoc = query.last;
      _isLoading = false;
    });
  }

  Future<void> searchConditions(String search) async {
    final query = await ConditionService.get(8, null, search);

    final conditions = query.map((condition) {
      final map = condition.data();
      map["id"] = condition.id;
      return ConditionModel.fromJson(map);
    }).toList();

    setState(() {
      _hasMore = true;
      _conditions.clear();
      if (conditions.isNotEmpty) _conditions.addAll(conditions);
      _lastDoc = query.lastOrNull;

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

  Widget _buildResult(List<ConditionModel> conditionList) {
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
        ListTile listTile = ListTile(
          title: Text(
            condition.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          subtitle: Text(condition.description),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ConditionDetailPage(conditionId: condition.id),
              ),
            );
          },

          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
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
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
