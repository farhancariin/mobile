import 'package:flutter/material.dart';
import 'package:mobile_framwork/components/Carousel/Carousel.dart';

import 'package:mobile_framwork/routes.dart' as routes;

void main() => runApp(AppStart());

class AppStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: routes.main,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Carousel(
          landingItem: <Widget>[
            Container(
              color: Colors.red,
              child: Center(child: Text('Letakan konten anda di sini'),),
            ),
            Container(
              color: Colors.blue,
              child: Center(child: Text('Letakan konten anda di sini'),),
            ),
            Container(
              color: Colors.green,
              child: Center(child: RaisedButton(onPressed: () => Navigator.pushNamed(context, '/login'),child: Text('Login'),)),
            ),
          ],
        ),
      ),
    );
  }
}
