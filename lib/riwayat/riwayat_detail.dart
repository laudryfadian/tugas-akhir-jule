import 'package:absenku/models/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maps_launcher/maps_launcher.dart';

class RiwayatDetail extends StatelessWidget {
  const RiwayatDetail({Key? key, required this.history}) : super(key: key);
  final Data history;

  @override
  Widget build(BuildContext context) {
    print(double.parse(history.lat));
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Riwayat"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Image.network(
                  history.foto,
                  fit: BoxFit.contain,
                )),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tanggal",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        history.tgl,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Jam",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        history.jam,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Alamat",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        history.loc,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        history.status,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      // color: Colors.blue,
                      onPressed: () {
                        MapsLauncher.launchCoordinates(
                            double.parse(history.lat),
                            double.parse(history.long));
                      },
                      child: Text(
                        "Lihat maps",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
