import 'package:flutter/material.dart';
import 'package:netflix/apicalls/apicalls.dart';
import 'package:netflix/models/tvcreditsmodel.dart';

class TvCreditsWidget extends StatefulWidget {
  final int id;

  const TvCreditsWidget({
    super.key,
    required this.id,
  });

  @override
  State<TvCreditsWidget> createState() => _TvCreditsWidgetState();
}

class _TvCreditsWidgetState extends State<TvCreditsWidget> {
  late Future<TvcreditsModel> tvcreditfuture;
  final Apiservices apiservices = Apiservices();

  @override
  void initState() {
    super.initState();
    _initialData();
  }

  void _initialData() {
    tvcreditfuture = apiservices.gettvcredits(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 120,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Credits",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              FutureBuilder<TvcreditsModel>(
                future: tvcreditfuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error fetching data: ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data != null && data.cast.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.cast.length,
                        itemBuilder: (context, index) {
                          final credit = data.cast[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                // Display actor's image (if available)
                                credit.profilePath != null
                                    ? ClipOval(
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w500${credit.profilePath}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Colors.grey, // Placeholder color
                                      ),
                                const SizedBox(height: 5),
                                Text(
                                  credit.name,
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No credits available."));
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
