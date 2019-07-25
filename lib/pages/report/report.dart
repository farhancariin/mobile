import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('Laporan'),),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/laporan bulanan.png'),
            title: Text('Laporan Bulanan'),
            onTap: () => Navigator.pushNamed(context, '/monthly-report'),
          ),
          ListTile(
            leading: Image.asset('assets/images/slip gaji.png'),
            title: Text('Slip Gaji Karyawan'),
            onTap: () => Navigator.pushNamed(context, '/slip'),
          ),
          ListTile(
            leading: Image.asset('assets/images/laporan kegiatan.png'),
            title: Text('Kegiatan'),
            onTap: () => Navigator.pushNamed(context, '/event'),
          ),
          ListTile(
            leading: Image.asset('assets/images/laporan kejadian.png'),
            title: Text('Kejadian'),
            onTap: () => Navigator.pushNamed(context, '/incident'),
          ),
        ],
      ),
    );
  }
}

