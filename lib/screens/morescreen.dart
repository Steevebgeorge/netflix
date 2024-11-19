import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            "new & hot",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            const Icon(
              Icons.cast,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 30,
                width: 30,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
          bottom: const TabBar(tabs: [
            Tab(
              text: "coming soon",
            ),
          ]),
        ),
      ),
    );
  }
}
