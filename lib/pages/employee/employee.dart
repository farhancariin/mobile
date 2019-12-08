import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';

import '../../static_data.dart';

class EmployeeScreen extends StatefulWidget {
  EmployeeScreen() : super();

  final String title = "Karyawan";

  @override
  EmployeeScreenState createState() => EmployeeScreenState();
}

class EmployeeScreenState extends State<EmployeeScreen> {
  List<Employees> users;
  List<Employees> selectedUsers;
  bool sort;

  Future<Map> employeeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imei = await ImeiPlugin
        .getImei( shouldShowRequestPermissionRationale: false );
    String token = await prefs.get('apiKey');
    final url = '${apiUrl}api/mobile_employee_info';
    var body = json.encode({'imei': imei});
    var res = await http.post(url, body: body, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token
    });
    var response = jsonDecode(res.body);
    return response;
  }

  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    users = Employees.getUsers();
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.projectName.compareTo(b.projectName));
      } else {
        users.sort((a, b) => b.projectName.compareTo(a.projectName));
      }
    }
  }

  onSelectedRow(bool selected, Employees user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Employees> temp = [];
        temp.addAll(selectedUsers);
        for (Employees user in temp) {
          users.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }

  Widget dataBody() {
    return FutureBuilder(
            future: employeeInfo(),
            builder: (BuildContext context, snapshot) {
              List<DataRow> row = [];
              if (snapshot.hasData) {
                return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data["data"].length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data["data"][index];
                        return Card(
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(item["employee_name"], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),),
                                      Text(item["id_card_number"], style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0),),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(item["division_name"], style: TextStyle(fontWeight: FontWeight.w300),),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text(item["company_name"], style: TextStyle(fontWeight: FontWeight.w300),),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(item["project_name"], style: TextStyle(fontWeight: FontWeight.w300),)
                                    ],
                                  ),
                                ],
                              )),
                        );
                      });
              } else {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator()));
              }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: dataBody()
    );
  }
}

class Employees {
  String projectName;
  String data;
  int index;

  Employees({this.projectName, this.data, this.index});

  static List<Employees> getUsers() {
    return <Employees>[
      Employees(projectName: "Jakarta", data: "17/20", index: 1),
      Employees(projectName: "Bandung", data: "17/20", index: 2),
      Employees(projectName: "Bekasi", data: "17/20", index: 3),
    ];
  }
}
