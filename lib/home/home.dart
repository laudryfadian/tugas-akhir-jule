import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:absenku/models/cek.dart';
import 'package:absenku/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uploadcare_client/uploadcare_client.dart' as upc;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Cek> cek;
  late bool isAbsen;
  late String route;
  bool isLoading = false;
  File? imageFile;

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  late String imageUrl;

  String namaUser = "";

  @override
  void initState() {
    cek = fetch();
    checkGps();
    super.initState();
  }

  Future<Cek> fetch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var idUser = pref.getString("idUser");
    namaUser = pref.getString("namaUser")!;

    final response = await http.get(Uri.parse(BaseUrl.cek + idUser!));

    print(response.body);

    if (response.statusCode == 200) {
      return Cek.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang,",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    Text(
                      namaUser + " !",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )),
            SizedBox(height: 5),
            Divider(
              thickness: 2,
              color: Colors.blue,
            ),
            SizedBox(height: 5),
            Container(
                alignment: Alignment.topRight,
                child: FutureBuilder<Cek>(
                    future: cek,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!;
                        isAbsen = data.result.data.jam1;
                        route = data.result.data.route;
                        return Text(
                          data.message,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Container();
                      }
                    })),
            SizedBox(height: 10),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                height: MediaQuery.of(context).size.height * 0.35,
                child: imageFile == null
                    ? Center(
                        child: Icon(
                        CupertinoIcons.camera,
                        size: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.grey.shade700,
                      ))
                    : Image.file(imageFile!),
              ),
              onTap: () {
                print("klik");
                imageSelector(context);
              },
            ),
            SizedBox(height: 10),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                  // color: Colors.blue,
                  onPressed: () {
                    if (imageFile != null) {
                      setState(() {
                        isLoading = true;
                      });
                      uploadcare(imageFile);
                    } else {
                      print("kosong gambarnya");
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.red,
                        )
                      : Text(
                          "Absen",
                          style: TextStyle(color: Colors.white),
                        ),
                )),
            // Container(
            //     alignment: Alignment.center,
            //     padding: EdgeInsets.all(50),
            //     child: Column(children: [
            //       Text(servicestatus ? "GPS is Enabled" : "GPS is disabled."),
            //       Text(haspermission ? "GPS is Enabled" : "GPS is disabled."),
            //       Text("Longitude: $long", style: TextStyle(fontSize: 20)),
            //       Text(
            //         "Latitude: $lat",
            //         style: TextStyle(fontSize: 20),
            //       )
            //     ]))
          ],
        ),
      ),
    );
  }

  Future imageSelector(BuildContext context) async {
    var jepret = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    if (jepret != null) {
      print("You selected  image : " + jepret.path);
      setState(() {
        imageFile = File(jepret.path);
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        // setState(() {
        //   //refresh the UI
        // });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    // setState(() {
    //   //refresh the UI
    // });
  }

  getLocation() async {
    print("oke");
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("Masuk getLocation()");
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    setState(() {
      long = position.longitude.toString();
      lat = position.latitude.toString();
    });

    // setState(() {
    //   //refresh UI
    // });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
      print("hee");

      setState(() {
        long = position.longitude.toString();
        lat = position.latitude.toString();
      });

      // setState(() {
      //   //refresh UI on update
      // });
    });
  }

  uploadcare(file) async {
    try {
      final options = upc.ClientOptions(
          authorizationScheme: upc.AuthSchemeRegular(
        apiVersion: 'v0.5',
        publicKey: '13d6296f5980c22e9805',
        privateKey: '2b8f7318d600f9233a94',
      ));

      final upload = upc.ApiUpload(options: options);
      final fileId = await upload.base(upc.UCFile(file));

      setState(() {
        imageFile = null;
        imageUrl = "https://ucarecdn.com/" + fileId.toString() + "/";
      });

      absen();
    } catch (e) {
      print(e);
    }
  }

  absen() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var pegawais = pref.getString("pegawais");
      var idUser = pref.getString("idUser");
      if (route == "tidak ada") {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Belum saatnya absen'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        var response = await http
            .post(Uri.parse("${BaseUrl.domain}absen/$route/${idUser!}"), body: {
          "pegawais": pegawais,
          "loc": lat + ", " + long,
          "lat": lat,
          "long": long,
          "foto": imageUrl
        });

        if (response.statusCode == 200) {
          print("success");
          setState(() {
            cek = fetch();
          });

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Berhasil absen!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          var body = jsonDecode(response.body);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(body['message'].toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }
}
