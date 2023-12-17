import 'package:absenku/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController posisiController = TextEditingController();
  String foto = "";

  @override
  void initState() {
    cekLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  width: double.infinity,
                  color: foto != "" ? Colors.transparent : Colors.grey.shade200,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: foto != "" ? Image.network(foto) : Container(),
                ),
                Container(
                  child: TextField(
                    readOnly: true,
                    controller: namaController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.person_alt),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    readOnly: true,
                    controller: emailController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.person_alt),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    readOnly: true,
                    controller: posisiController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(CupertinoIcons.person_alt),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  // color: Colors.red,
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text("LOGOUT"),
                )
              ],
            )));
  }

  cekLogin() async {
    print("cek login");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var idUser = pref.getString("idUser");
    var namaUser = pref.getString("namaUser");
    var emailUser = pref.getString("emailUser");
    var fotoUser = pref.getString("fotoUser");
    var posisiUser = pref.getString("posisiUser");
    if (idUser != null) {
      setState(() {
        namaController.text = namaUser!;
        emailController.text = emailUser!;
        foto = fotoUser!;
        posisiController.text = posisiUser!;
      });
    } else {
      return false;
    }
  }
}
