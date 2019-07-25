import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../static_data.dart';

class SlipScreen extends StatefulWidget {
  SlipScreen() : super();

  final String title = "Laporan Slip Gaji";

  @override
  SlipScreenState createState() => SlipScreenState();
}

class SlipScreenState extends State<SlipScreen> {
  bool downloading = false;
  var progressString = "";
  var dio = new Dio();

  Future<Map> employeeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imei = await ImeiPlugin.getImei;
    String token = await prefs.getString('apiKey');
    final url = '${apiUrl}api/mobile_slip_info';
    var body = json.encode({'imei': imei});
    var res = await http.post(url, body: body, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token
    });
    var response = jsonDecode(res.body);
    return response;
  }

  Future<File> _downloadFile(Dio dio,String url, String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      File file = new File('$dir/$filename');
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget dataBody() {
    return FutureBuilder(
        future: employeeInfo(),
        builder: (BuildContext context, snapshot) {
          List<DataRow> row = [];
          if (snapshot.hasData) {
            var now = new DateTime.now();
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data["data"]["project"].length,
                itemBuilder: (context, index) {
                  var item = snapshot.data["data"]["project"][index];
                  dio.interceptors.add(LogInterceptor());
                  return Card(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  item["project_name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0),
                                ),
                                Text(
                                  "Periode: " +
                                      now.month.toString() +
                                      " - " +
                                      now.year.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                item["status"] == 0
                                    ? Text('Data Belum Tersedia')
                                    : RaisedButton(
                                  onPressed:  () => _downloadFile(dio,'http://p4tkmatematika.org/file/ARTIKEL/Artikel%20Teknologi/PEMBUATAN%20FILE%20PDF_FNH_tamim.pdf', 'test.pdf'),
                                  child: Text(
                                    'Download',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  elevation: 4.0,
                                )
                              ],
                            )
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
        body: dataBody());
  }
}
