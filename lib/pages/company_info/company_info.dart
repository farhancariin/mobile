import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../static_data.dart';
import 'package:imei_plugin/imei_plugin.dart';

class CompanyInfoScreen extends StatefulWidget {
  @override
  _CompanyInfoScreenState createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Perushaan'),
        centerTitle: true,
      ),
      body: Center(child: CompanyInfo()),
    );
  }
}

class CompanyInfo extends StatelessWidget {
  List<Widget> child = [];

  Future<Map> companyInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imei = await ImeiPlugin.getImei;
    String token = await prefs.getString('apiKey');
    final url = '${apiUrl}api/mobile_company_info';
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: FutureBuilder(
          future: companyInfo(),
          builder: (BuildContext context, snapshot){
            if(snapshot.hasData){
              print(snapshot.data);

              snapshot.data["data"].forEach((key, value) {
                child.add(Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        key.replaceAll(new RegExp(r'_'), ' '),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        value.toString(),
                        style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ));
              });

              return Container(
                child: Column(
                  children: child,
                ),
              );
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
    );
  }
}

const Map<String, dynamic> dummyData = {
  "Nama Perushaan": "Asco ",
  "Alamat Perusahaan": "Jl raya pasar minggu",
  "Telephone": "(021) 8955520",
  "No Fax": "(021) 85955520",
  "Email Terdaftar": "test@gmail.com",
  "NPWP": "0000000000000",
  "Jumlah Karyawan": "99/100"
};
