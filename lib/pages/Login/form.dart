import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:mobile_framwork/static_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  bool _obsecureText = true, isLoading = false;
  LoginData data = new LoginData();

//  StaticData _staticData = new StaticData();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

//  LocalStorage localStorage = new LocalStorage();


  String validatePassword(String value) {
    if (value == '')
      return 'Minimal karakter adalah 6';
    else
      return null;
  }

  Widget emailForm() {
    return new TextFormField(
      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value.isEmpty){
          return 'Username tidak boleh kosong';
        }else{
          return null;
        }
      },
      decoration: InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        hintText: "Masukan Username Anda",
        labelText: "Username",
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black26),
      ),
      onSaved: (String value) => data.username = value,
    );
  }

  Widget passFrom() {
    return new TextFormField(
      style: TextStyle(color: Colors.black),
      obscureText: _obsecureText,
      decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: "Masukan Password Anda",
          labelText: "Password",
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black26),
          suffixIcon: GestureDetector(onTap: showPass, child: secureIcon())),
      onSaved: (String value) => data.password = value,
      validator: validatePassword,
    );
  }

  void showPass() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  Widget secureIcon() {
    return Icon(!_obsecureText ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey);
  }

  Widget descText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
//        Text(
//          "Lupa Pasword ?",
//          textAlign: TextAlign.end,
//          style: TextStyle(color: Colors.black, fontSize: 15.0),
//        )
      ],
    );
  }

  void submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      String imei = await ImeiPlugin
          .getImei( shouldShowRequestPermissionRationale: false );
      final url = '${apiUrl}api/mobile_login';
      formKey.currentState.save(); // Save our form now.
      var body = json.encode({
        'password': data.password,
        'id_number': data.username,
        'imei': imei
      });
      var res = await http.post(url, body: body, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });
      setState(() {
        isLoading = false;
      });

      var response = jsonDecode(res.body);
      if (response["error"] != null) {
        return showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Terjadi Kesalahan"),
              content: Text(response["message"]),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Oke"))
              ],
            ));
      }
      prefs.setString("apiKey", response["token"]);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Widget submitButton() {
    return InkWell(
        onTap: submit,
        child: new Container(
          height: 50.0,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
          ),
          child: !isLoading
              ? new Text(
                  "Masuk",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                  ),
                )
              : new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
        ));
  }

  Widget register() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Belum punya akun ?"),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/register'),
            child: Text(
              "Daftar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    Widget imageTop(){
//      return  Container(
//        height: 200,
//        child: Stack(
//          children: <Widget>[
//            Positioned(
//                child: Align(
//                  alignment: Alignment.topCenter,
//                  child: SvgPicture.asset(
//                    'assets/vector/social.svg',
//                    width: MediaQuery.of(context).size.width * 0.5,
//                    height: 165,
//                  ),
//                )),
//          ],
//        ),
//      );
//    }
    return Stack(children: <Widget>[
//      Positioned(
//        child: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ),
      Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        child: Center(
          child: ListView(
            children : <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('egp_logo.png', height: 150.0,),
                  Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
//               imageTop(),
                          Container(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat'
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          emailForm(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          passFrom(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          descText(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          submitButton(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
//                register(),
                        ],
                      )),
                ],
              ),
            ]
          ),
        ),
      ),
    ]);
  }
}

class LoginData {
  String username;
  String password;
}
