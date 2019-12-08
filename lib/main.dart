import 'package:flutter/material.dart';
import 'package:mobile_framwork/pages/Login/login.dart';
import 'package:mobile_framwork/pages/dashboard/dashboard.dart';

import 'package:mobile_framwork/routes.dart' as routes;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.get('apiKey');
  }

  Widget pageRender() {
    return new FutureBuilder<SharedPreferences>(
      future: getApiKey(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if ( snapshot.data != null) {
          return DashboardScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageRender()
    );
  }
}
