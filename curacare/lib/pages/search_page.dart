import 'package:curacare/models/search_condition_model.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:curacare/widgets/condition_card.dart';
import 'package:curacare/widgets/custom_bottom_navigation_bar.dart';
import 'package:curacare/widgets/search_list_tile.dart';
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

  final SearchController _searchController = SearchController();
  late Future<List<SearchConditionModel>> _conditions;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.searchText != null && widget.searchText!.isNotEmpty) {
      _searchController.text = widget.searchText!;
    }
    _conditions = ConditionService.search(_searchController.text);
  }

  final PreferredSizeWidget _buildAppBar = AppBar(
    backgroundColor: Colors.white,
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

  Widget _buildSearchBar(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: 4, right: 5),
    child: SearchBar(
      controller: _searchController,
      hintText: "ค้นหาโรค อาการ...",
      onSubmitted: (value) => setState(() {
        _conditions = ConditionService.search(value);
      }),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
    ),
  );

  Widget _buildResult(BuildContext context) => FutureBuilder(
    future: _conditions,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text(snapshot.error.toString()));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData) {
        return Center(child: Text("ไม่พบข้อมูลโรค"));
      }

      if (snapshot.data!.isEmpty) {
        return Center(child: Text("ไม่พบข้อมูลโรค"));
      }

      final conditions = snapshot.data!;

      return ListView.builder(
        itemCount: conditions.length,
        itemBuilder: (context, index) {
          final condition = conditions[index];

          return ConditionCard(
            listTile: SearchListTile(searchCondition: condition),
            cardIcon: Icon(
              Icons.my_library_books_rounded,
              color: const Color.fromARGB(255, 255, 109, 90),
            ),
          );
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar,
      body: Column(
        spacing: 20,
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildResult(context)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
