
import 'package:flutter/material.dart';
import 'package:mobile_framwork/pages/Login/form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
          child: FormLogin()),
      resizeToAvoidBottomPadding: false,
    );
  }
}
