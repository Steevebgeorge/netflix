import 'package:flutter/material.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("You don't have any downloads"),
          ),
          SizedBox(
            height: 20,
          ),
          Icon(
            Icons.download_rounded,
            color: Colors.white,
            size: 70,
          )
        ],
      ),
    );
  }
}
