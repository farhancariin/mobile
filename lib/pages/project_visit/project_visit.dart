import 'package:flutter/material.dart';

class ProjectVisitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('Kunjungan Project'),),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/rtm.png'),
            title: Text('Rapat Tinjauan Project'),
            onTap: () => Navigator.pushNamed(context, '/audit'),
          ),
          ListTile(
            leading: Image.asset('assets/images/patroli area.png'),
            title: Text('Patroli Lapangan'),
            onTap: () => Navigator.pushNamed(context, '/field-patrol'),
          ),
        ],
      ),
    );
  }
}

