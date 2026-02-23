import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:curacare/models/medicinedata.dart';
import 'package:curacare/services/medicinebyid_api.dart';
import 'package:curacare/services/medicine_api.dart';
import 'dart:developer';
import 'dart:async';
class RegularmedicinePage extends StatefulWidget {
  const RegularmedicinePage({super.key});

  @override
  State<RegularmedicinePage> createState() => _RegularmedicinePageState();
}

class _RegularmedicinePageState extends State<RegularmedicinePage> {
  late Future<List<Medicinedata>> _MedicineFuture;

  @override
  void initState() {
    super.initState();
    _MedicineFuture = MedicinebyidApi.fetchMedicine();
    _loadMedicineData();
    log('$_MedicineFuture');
  }

  List<Medicinedata> _allMedicines = [];
  bool _isLoading = true;
  Medicinedata? _selectedMedicinedata;
  int userid = 1;

  Future<void> _loadMedicineData() async {
    try {
      final medicine_data = await MedicineApi.fetchMedicine();
      setState(() {
        _allMedicines = medicine_data;
        if (_allMedicines.isNotEmpty) {
          _selectedMedicinedata = _allMedicines.first;
        }
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteMedicine(int medicineId) async {
    try {
      await MedicineApi.deleteMedicine(
        medicineId: medicineId,
        userId: userid,
      );

      setState(() {
        _MedicineFuture = MedicinebyidApi.fetchMedicine();
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
                      DropdownSearch<Medicinedata>(
                        items: _allMedicines,
                        selectedItem: _selectedMedicinedata,
                        itemAsString: (d) => d.name,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "ค้นหายา",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedMedicinedata = value;
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
                            if (_selectedMedicinedata == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("กรุณาเลือกยา")),
                              );
                              return;
                            }
                            try {
                              await MedicineApi.addMedicineToUser(
                                medicineId: _selectedMedicinedata!.id,
                                userId: userid,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("บันทึกสำเร็จ")),
                              );
                              setState(() {
                                _MedicineFuture = MedicinebyidApi.fetchMedicine();
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
              "บันทึกยาประจำตัว",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "จัดการยาประจำตัว",
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
                label: Text("เพิ่มยาประจำตัว"),
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
                future: _MedicineFuture,
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
                                 _MedicineFuture =
                                      MedicinebyidApi.fetchMedicine();
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
                    final medicines = snapshot.data!;
                    if (medicines.isEmpty) {
                      return Center(child: Text("ไม่มีข้อมูลยาตัว"));
                    }
                    log("dis : $medicines");
                    return ListView.builder(
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = medicines[index];
                        return Dismissible(
                          key: Key(medicine.id.toString()),
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
                                  content: Text("คุณต้องการลบยานี้หรือไม่?"),
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
                            await _deleteMedicine(medicine.id);
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
                                  medicine.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  medicine.detail,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),                       
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("ไม่มีข้อมูลยาประจำตัว");
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
