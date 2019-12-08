import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'dart:math';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:mobile_framwork/static_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:path_provider/path_provider.dart';

class DinasForm extends StatefulWidget {
  @override
  _DinasFormState createState() => _DinasFormState();
}

class _DinasFormState extends State<DinasForm> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  DinasData data = new DinasData();
  bool isLoading = false, fileProccess = true;
  File file;
  String compressedFile;
  var project;

  Future<File> compressImage(File imageFile) async {
    if (imageFile == null) return null;
    final tempDir = await getTemporaryDirectory();

    CompressObject compressObject = CompressObject(
      imageFile: imageFile, //image
      path: tempDir.path, //compress to path
      quality: 85, //first compress quality, default 80
      step:
          9, //compress quality step, The bigger the fast, Smaller is more accurate, default 6
//      mode: CompressMode.LARGE2SMALL,//default AUTO
    );
    Luban.compressImage(compressObject).then((_path) {
      setState(() {
        compressedFile = base64Encode(File(_path).readAsBytesSync());
      });
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    void submit() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = await prefs.get("apiKey");

      if (formKey.currentState.validate()) {
        setState(() {
          isLoading = true;
        });
        String imei = await ImeiPlugin
            .getImei( shouldShowRequestPermissionRationale: false );

        final uri = '${apiUrl}api/mobile_incident_add';
        formKey.currentState.save(); // Save our form now.
        if (file != null) {
          List<int> imageBytes = await file.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          var body = json.encode({
            'description': data.description,
            'detail': data.detail,
            'officer': data.officer,
            'witneses': data.witneses,
            'imei': imei,
            'base64Img': base64Image,
            'project_id': project["data"]["project_id"]
          });

          // get file length
          var headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': token
          };

          return http
              .post(uri, body: body, headers: headers)
              .then((http.Response response) {
            final int statusCode = response.statusCode;

            print(statusCode);
            if (statusCode < 200 || statusCode > 400 || json == null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text("Terjadi Kesalahan"),
                        content: Text(
                            "Terjadi kesalahan saat mengupload gambar silakan hubungi developer"),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Oke"))
                        ],
                      ));
            }

            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      content: Text("Berhasil menambah kejadian baru"),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              data = new DinasData();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text("Oke"))
                      ],
                    ));
          });
        }

        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  content: Text("Anda belum memasukan foto"),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          data = new DinasData();
                          Navigator.of(context).pop();
                        },
                        child: Text("Oke"))
                  ],
                ));
      }
      setState(() {
        isLoading = false;
      });
    }

    void _choose() async {
      setState(() async {
        file = await ImagePicker.pickImage(source: ImageSource.camera);
      });
    }

    Future projectInfo() async {
      var location = new Location();
      var userLocation = await location.getLocation();
      var lat = userLocation.latitude;
      var long = userLocation.longitude;
      print({lat: lat, long:long});
      return {lat: lat, long:long};
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Dinas Luar Kantor'),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05,
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    file == null
                        ? Container(
                            height: 150.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/image.png'),
                                    fit: BoxFit.contain)),
                          )
                        : Container(
                            height: 150.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(file), fit: BoxFit.contain)),
                          ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: _choose,
                      child: Text(
                        'Upload Gambar',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FutureBuilder(
                        future: projectInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data;
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text('Anda Berada di :'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('${data.long} - ${data.lat}'),
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Kejadian harus id isi ';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Masukan nama kejadian",
                        labelText: "Kejadian",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                      onSaved: (String value) => data.description = value,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: TextStyle(),
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Masukan detail cerita",
                        labelText: "Detail",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                      onSaved: (String value) => data.detail = value,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Nama petugas tidak boleh kosong ';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Masukan nama petugas",
                        labelText: "Petugas",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                      onSaved: (String value) => data.officer = value,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Masukan nama saksi",
                        labelText: "Saksi",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                      onSaved: (String value) => data.witneses = value,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                        onTap: submit,
                        child: new Container(
                          height: 50.0,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius:
                                new BorderRadius.all(const Radius.circular(10.0)),
                          ),
                          child: !isLoading
                              ? new Text(
                                  "Kirim",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                  ),
                                )
                              : new CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                        ))
                  ],
                ),
              )),
        ));
  }
}

class DinasData {
  String description;
  String detail;
  String status = "Selesai";
  String officer;
  String reporter;
  String witneses;
  File image;
}
