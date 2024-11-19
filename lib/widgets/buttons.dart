import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            toolbaricons(icon: Icons.bookmark, text: "Bookmark"),
            toolbaricons(icon: Icons.share_rounded, text: "share"),
            toolbaricons(icon: Icons.download_rounded, text: "download")
          ],
        ),
      ),
    );
  }

  Widget toolbaricons({IconData? icon, String? text}) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            hoverColor: const Color.fromARGB(255, 215, 27, 27),
            onPressed: () {},
            icon: Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
          ),
          Text(
            text!,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
