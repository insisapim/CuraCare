import 'dart:developer';
import 'package:curacare/models/chronicdiseasedata.dart';
import 'package:curacare/services/chronicdiseasebyid_api.dart';
import 'package:curacare/services/chronicdisease_api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ChronicdiseasePage extends StatefulWidget {
  const ChronicdiseasePage({super.key});

  @override
  State<ChronicdiseasePage> createState() => _ChronicdiseasePageState();
}

class _ChronicdiseasePageState extends State<ChronicdiseasePage> {
  late Future<List<Chronicdiseasedata>> _chronicdiseaseFuture;

  @override
  void initState() {
    super.initState();
    _chronicdiseaseFuture = ChronicdiseaseByIdApi.fetchDisease();
    _loadDiseaseData();
    log('$_chronicdiseaseFuture');
  }

  List<Chronicdiseasedata> _diseases = [];
  bool _isLoading = true;
  Chronicdiseasedata? _selectedDisease;
  int userid = 1;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadDiseaseData() async {
    try {
      final disease_data = await ChronicdiseaseApi.fetchDisease();
      setState(() {
        _diseases = disease_data;
        if (_diseases.isNotEmpty) {
          _selectedDisease = _diseases.first;
        }
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteDisease(int diseaseId) async {
    try {
      await ChronicdiseaseApi.deleteDisease(
        diseaseId: diseaseId,
        userId: userid,
      );

      setState(() {
        _chronicdiseaseFuture = ChronicdiseaseByIdApi.fetchDisease();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ลบสำเร็จ")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ลบไม่สำเร็จ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    void openRecord(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'เพิ่มโรค',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      DropdownSearch<Chronicdiseasedata>(
                        items: _diseases,
                        selectedItem: _selectedDisease,
                        itemAsString: (d) => d.name,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "ค้นหาโรค",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedDisease = value;
                          });
                        },
                      ),

                      SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_selectedDisease == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("กรุณาเลือกโรค")),
                              );
                              return;
                            }
                            try {
                              await ChronicdiseaseApi.addDiseaseToUser(
                                diseaseId: _selectedDisease!.id,
                                userId: userid,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("บันทึกสำเร็จ")),
                              );
                              setState(() {
                                _chronicdiseaseFuture =
                                    ChronicdiseaseByIdApi.fetchDisease();
                              });

                              Navigator.pop(context);
                            } catch (err) {
                              log('Exception ===> : ${err}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("บันทึกไม่สำเร็จ")),
                              );
                            }
                          },
                          child: Text('บันทึก', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "บันทึกโรคประจำตัว",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "จัดการโรคประจำตัว",
              style: TextStyle(
                color: const Color.fromARGB(255, 131, 131, 131),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => openRecord(context),
                icon: Icon(Icons.add),
                label: Text("เพิ่มโรคประจำตัว"),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _chronicdiseaseFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    final error = snapshot.error;

                    if (error is TimeoutException) {
                      return Center(
                        child: Column(
                          children: [
                            Text("โหลดข้อมูลช้าเกินไป กรุณาลองใหม่"),
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  _chronicdiseaseFuture =
                                      ChronicdiseaseByIdApi.fetchDisease();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Text('Hey!!! Error ==>>> ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final diseases = snapshot.data!;
                    if (diseases.isEmpty) {
                      return Center(child: Text("ไม่มีข้อมูลโรคประจำตัว"));
                    }
                    log("dis : $diseases");
                    return ListView.builder(
                      itemCount: diseases.length,
                      itemBuilder: (context, index) {
                        final disease = diseases[index];
                        return Dismissible(
                          key: Key(disease.id.toString()),
                          direction: DismissDirection.endToStart,

                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("ยืนยันการลบ"),
                                  content: Text("คุณต้องการลบโรคนี้หรือไม่?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("ยกเลิก"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        "ลบ",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            await _deleteDisease(disease.id);
                          },

                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  disease.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  disease.detail,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "การรักษา: ${disease.treatment}",
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("ไม่มีข้อมูลโรคประจำตัว");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
