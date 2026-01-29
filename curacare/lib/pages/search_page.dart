import 'package:curacare/models/condition.dart';
import 'package:curacare/pages/condition_detail_page.dart';
import 'package:curacare/services/condition.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
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

  Widget _buildListTileCard(ListTile listTile) {
    return Card(child: listTile);
  }

  Widget _buildResult(List<Condition> conditionList) {
    return ListView.builder(
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
          SearchBar(
            controller: _searchController,
            hintText: "ค้นหาอาการ",
            onSubmitted: (value) => searchConditions(value),
          ),
          Expanded(child: _buildResult(_conditions)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
