import 'package:flutter/material.dart';

class AbsenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        '08:00',
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '08:00',
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 45.0),
                        child: Text(
                          'Masuk',
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () => print('masuk'),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 45.0),
                        child: Text(
                          'Keluar',
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () => print('masuk'),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 55.0),
                        child: Text(
                          'Ijin',
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () => print('masuk'),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        child: Text(
                          'Sakit',
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () => print('masuk'),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 55.0),
                        child: Text(
                          'Dinas',
                        ),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () => Navigator.pushNamed(context, '/dinas'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
