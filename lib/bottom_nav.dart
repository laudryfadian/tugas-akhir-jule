import 'package:absenku/akun/akun.dart';
import 'package:absenku/gaji/gaji.dart';
import 'package:absenku/home/home.dart';
import 'package:absenku/riwayat/riwayat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, required this.selectLayer}) : super(key: key);
  final int selectLayer;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.selectLayer;
    super.initState();
  }

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    RiwayatPage(),
    GajiPage(),
    AkunPage()
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Absen ku'.toUpperCase()),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => PageProfil()));
        //       },
        //       icon: Icon(CupertinoIcons.person_alt))
        // ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 40),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  iconSize: _selectedIndex == 0 ? 35 : 20,
                  color:
                      _selectedIndex == 0 ? Colors.blue.shade900 : Colors.white,
                  onPressed: () {
                    _onItemTap(0);
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.doc_chart_fill),
                  iconSize: _selectedIndex == 1 ? 35 : 20,
                  color:
                      _selectedIndex == 1 ? Colors.blue.shade900 : Colors.white,
                  onPressed: () {
                    _onItemTap(1);
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.money_dollar_circle_fill),
                  iconSize: _selectedIndex == 2 ? 35 : 20,
                  color:
                      _selectedIndex == 2 ? Colors.blue.shade900 : Colors.white,
                  onPressed: () {
                    _onItemTap(2);
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.person_circle_fill),
                  iconSize: _selectedIndex == 3 ? 35 : 20,
                  color:
                      _selectedIndex == 3 ? Colors.blue.shade900 : Colors.white,
                  onPressed: () {
                    _onItemTap(3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
