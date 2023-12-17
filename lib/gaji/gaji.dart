import 'dart:convert';

import 'package:absenku/models/gaji.dart';
import 'package:absenku/network/network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GajiPage extends StatefulWidget {
  const GajiPage({Key? key}) : super(key: key);

  @override
  State<GajiPage> createState() => _GajiPageState();
}

class _GajiPageState extends State<GajiPage> {
  List<Data> gaji = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Data>> _fetchData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var pegawais = pref.getString("pegawais");
      var jsonResponse = await http.get(Uri.parse(BaseUrl.gaji + pegawais!));
      print(jsonResponse.body);
      if (jsonResponse.statusCode == 200) {
        var jsonItems = json
            .decode(jsonResponse.body)['result']['data']
            .cast<Map<String, dynamic>>();

        gaji = jsonItems.map<Data>((json) {
          return Data.fromJson(json);
        }).toList();
      }
    } catch (e) {
      print(e);
    }
    return gaji;
  }

  Future<Null> _refresh() {
    return _fetchData().then((_gaji) {
      setState(() => gaji = _gaji);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ListTile(
            title: Text(
          'Gaji',
          textAlign: TextAlign.end,
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
        )),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<Data>>(
              future: _fetchData(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
                if (snapshot.hasData) {
                  gaji = snapshot.data!;
                  return Container(
                    // padding: EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                        itemCount: gaji.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var _data = gaji[index];
                          return Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      _data.tgl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          height: 100,
                                          child: Image.network(
                                              _data.pegawais.foto)),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _data.pegawais.nama,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _data.pegawais.posisi,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _data.pegawais.alamat,
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    child: Text(
                                      "Rp. " + _data.total.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ));
                        }),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
              }
              // child: Column(
              //   children: [
              //     Divider(
              //       thickness: 2,
              //       color: Colors.blue,
              //     ),

              //   ],
              // ),
              ),
        ),
      ),
    );
  }
}
