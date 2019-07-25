import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:mobile_framwork/components/box_shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../static_data.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<Map> getCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imei = await ImeiPlugin.getImei;
    String token = await prefs.getString('apiKey');
    final url = '${apiUrl}api/mobile_login';
    var body = json.encode({'imei': imei});
    var res = await http.post(url, body: body, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token
    });
    var response = jsonDecode(res.body);
    return response;
  }

  renderDasboard() async {
    return FutureBuilder(
        future: getCompany(),
        builder: (BuildContext context,
            AsyncSnapshot<Map> snapshot) {
          print(snapshot);

          if(snapshot.hasData){
            return Text('data');
          }else{
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new DashboardWidget(),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.05),
      height: double.infinity,
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(color: Color(0xff395e89), width: 5.0)),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xff316fc0),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                boxShadow: <BoxShadow>[
                  new CustomBoxShadow(
                      color: Colors.grey,
                      offset: new Offset(1.0, 1.0),
                      blurRadius: 5.0,
                      blurStyle: BlurStyle.solid)
                ],
              ),
              child: Center(
                  child: Text(
                'Esa Garda Pratama',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
                textAlign: TextAlign.center,
              )),
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/company-info'),
                  icon: Image.asset('assets/images/perusahaan.png'),
                  tooltip: 'Info Perushaan',
                  iconSize: 40.0,
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/project-information'),
                  icon: Image.asset('assets/images/proyek.png'),
                  tooltip: 'Info Proyek',
                  iconSize: 40.0,
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/employee'),
                  icon:Image.asset('assets/images/karyawan.png'),
                  tooltip: 'Info Karayawan Berjalan',
                  iconSize: 40.0,
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/absence'),
                  icon: Image.asset('assets/images/absensi.png'),
                  tooltip: 'Absensi',
                  iconSize: 40.0,
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/project-visit'),
                  icon: Image.asset('assets/images/rtm.png'),
                  tooltip: 'Kunjungan Proyek',
                  iconSize: 40.0,
                ),
                IconButton(
                  onPressed: () =>  Navigator.pushNamed(context, '/report'),
                  icon: Image.asset('assets/images/laporan kerja.png'),
                  tooltip: 'Laporan Kerja',
                  iconSize: 40.0,
                ),
              ],
            )
          ],
        ),
    );
  }
}
