import 'dart:convert';

import 'package:absenku/bottom_nav.dart';
import 'package:absenku/home/home.dart';
import 'package:absenku/network/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool secureText = true;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("idUser");
    if (val != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNav(selectLayer: 0)),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Container(
                child: Text(
                  "LOGIN USER",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 10),
              Container(
                child: TextField(
                  readOnly: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.mail_solid),
                  ),
                ),
              ),
              Container(
                child: TextField(
                  obscureText: secureText,
                  readOnly: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            !secureText
                                ? secureText = true
                                : secureText = false;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye)),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  // color: Colors.blue,
                  onPressed: () {
                    login();
                  },
                  child: Text("Masuk"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Form login harus diisi!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      var response = await http.post(Uri.parse(BaseUrl.login), body: {
        "email": emailController.text,
        "password": passwordController.text
      });

      print(response);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body)['result']['data'];
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("idUser", body['_id']);
        await pref.setString("pegawais", body['pegawais']['_id']);
        await pref.setString("namaUser", body['pegawais']['nama']);
        await pref.setString("emailUser", body['email']);
        await pref.setString("fotoUser", body['pegawais']['foto']);
        await pref.setString("posisiUser", body['pegawais']['posisi']);

        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Berhasil Login!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNav(selectLayer: 0)),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        var body = jsonDecode(response.body)['message'];
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(body.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
