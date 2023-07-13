import 'package:driver_app/screens/tab_pages/earning_tab_page.dart';
import 'package:driver_app/screens/tab_pages/home_tab_page.dart';
import 'package:driver_app/screens/tab_pages/profile_tab_page.dart';
import 'package:driver_app/screens/tab_pages/rating_tab_page.dart';
import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget {
  static const String idScreen = 'driverHomeScreen';
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int  selectedIndex = 0;

  void onItemTap(int index){
    setState(() {
      selectedIndex = index;
      _tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeTabPage(),
            EarningTabPage(),
            RatingTabPage(),
            ProfileTabPage()
          ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
              label: 'Earning'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.star),
              label: 'Rating'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
              label: 'Profile'
            ),
          ],
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: onItemTap,
        currentIndex: selectedIndex,
      ),
    );
  }
}
