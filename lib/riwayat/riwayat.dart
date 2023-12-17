import 'dart:convert';

import 'package:absenku/models/history.dart';
import 'package:absenku/network/network.dart';
import 'package:absenku/riwayat/riwayat_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Data> history = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Data>> _fetchData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var pegawais = pref.getString("pegawais");
      var jsonResponse = await http.get(Uri.parse(BaseUrl.history + pegawais!));
      if (jsonResponse.statusCode == 200) {
        var jsonItems = json
            .decode(jsonResponse.body)['result']['data']
            .cast<Map<String, dynamic>>();

        history = jsonItems.map<Data>((json) {
          return Data.fromJson(json);
        }).toList();
      }
    } catch (e) {
      print(e);
    }
    return history;
  }

  Future<Null> _refresh() {
    return _fetchData().then((_history) {
      setState(() => history = _history);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ListTile(
            title: Text(
          'History',
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
                  history = snapshot.data!;
                  return Container(
                    // padding: EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                        itemCount: history.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var _data = history[index];
                          return InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                      color: _data.status == "IN"
                                          ? Colors.green.shade500
                                          : Colors.red,
                                      width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    color: Colors.redAccent,
                                    child: Image.network(_data.foto),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(_data.tgl),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(_data.jam),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        _data.status,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RiwayatDetail(history: _data)));
                            },
                          );
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
