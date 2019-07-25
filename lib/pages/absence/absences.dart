import 'package:flutter/material.dart';

class AbsenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi'),centerTitle: true,),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('under_con.png'),
        ),
      ),
    );
  }
}
