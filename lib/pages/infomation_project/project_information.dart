import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';

import '../../static_data.dart';


class ProjectInformationScreen extends StatefulWidget {
  ProjectInformationScreen() : super();

  final String title = "Informasi Projek";

  @override
  ProjectInformationScreenState createState() => ProjectInformationScreenState();
}

class ProjectInformationScreenState extends State<ProjectInformationScreen> {
  bool sort;

  Future<Map> employeeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imei = await ImeiPlugin.getImei;
    String token = await prefs.getString('apiKey');
    final url = '${apiUrl}api/mobile_project_info';
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
                                Text(item["project_name"], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),),
                                Text(item["employee_capacity"] +"/"+ item["qty"], style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0),),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(item["project_phone"], style: TextStyle(fontWeight: FontWeight.w300),),
                              ],
                            ),
                            SizedBox(height: 10.0,),
                            Row(
                              children: <Widget>[
                                Text(item["active_date"], style: TextStyle(fontWeight: FontWeight.w300),),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container( width: 250.0,child: Text(item["project_address"], style: TextStyle(fontWeight: FontWeight.w300),overflow: TextOverflow.clip,))
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


class Projects {
  String projectName;
  String data;
  int index;

  Projects({this.projectName, this.data, this.index});

  static List<Projects> getUsers() {
    return <Projects>[
      Projects(projectName: "Jakarta", data: "17/20", index: 1),
      Projects(projectName: "Bandung", data: "17/20", index: 2),
      Projects(projectName: "Bekasi", data: "17/20", index: 3),
    ];
  }
}
