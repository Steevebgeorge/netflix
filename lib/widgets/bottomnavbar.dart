import 'package:flutter/material.dart';
import 'package:netflix/screens/downloadscreen.dart';
import 'package:netflix/screens/homescreen.dart';
import 'package:netflix/screens/morescreen.dart';
import 'package:netflix/screens/searchscreen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: const TabBar(
            indicatorColor: Colors.transparent,
            unselectedLabelStyle:
                TextStyle(color: Color.fromARGB(255, 112, 110, 110)),
            labelColor: Colors.white,
            dividerColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.search),
                text: 'Search',
              ),
              Tab(
                icon: Icon(Icons.photo_library_rounded),
                text: 'Hot & New',
              ),
              Tab(
                icon: Icon(Icons.download_rounded),
                text: 'Downloads',
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          HomeScreen(),
          SearchScreen(),
          MoreScreen(),
          DownloadScreen()
        ]),
      ),
    );
  }
}
