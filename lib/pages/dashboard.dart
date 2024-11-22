import 'package:emtrade/pages/construction_page.dart';
import 'package:emtrade/pages/education_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, this.index }) : super(key: key);

  final int? index;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int currentIndex = 0;

  final screens = [
    ConstructionActivity(),
    ConstructionActivity(),
    EducationActivity(),
    ConstructionActivity(),
    ConstructionActivity(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    currentIndex = widget.index??0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: screens[currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/ic_home.png"),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/ic_stock.png"),
            ),
            label: 'Stock Pick',
          ),

          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/ic_school.png"),
            ),
            label: 'Education',
          ),


          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/ic_analysis.png"),
            ),
            label: 'Analysis',
          ),

          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/ic_books.png"),
            ),
            label: 'Academy',
          ),
        ],
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        iconSize: 20,
        currentIndex: currentIndex,
        unselectedItemColor: Color(0xFF979797),
        selectedItemColor: Color(0xFFFF9441),
        onTap: _onItemTapped,
      ),
    );
  }
}