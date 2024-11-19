import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/apicalls/apicalls.dart';
import 'package:netflix/models/similarmoviesmodel.dart';
import 'package:netflix/screens/moviedetailsscreen.dart';
import 'package:netflix/utils/utils.dart';

class SimilarMoviesWidget extends StatefulWidget {
  final int movidId;

  const SimilarMoviesWidget({
    super.key,
    required this.movidId,
  });

  @override
  State<SimilarMoviesWidget> createState() => _SimilarMoviesWidgetState();
}

class _SimilarMoviesWidgetState extends State<SimilarMoviesWidget> {
  late Future<SimilarMovies> similarfuture;
  final Apiservices apiservices = Apiservices();

  @override
  void initState() {
    super.initState();
    similarfuture = apiservices.getSimilarMovies(widget.movidId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SimilarMovies>(
      future: similarfuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error fetching data: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          final details = snapshot.data!.results;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "similar movies",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.2 / 3,
                  ),
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    if (index >= details.length) return const SizedBox.shrink();

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movieId: details[index].id),
                        ));
                      },
                      child: SizedBox(
                        height: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: CachedNetworkImage(
                                  imageUrl: details[index].posterPath != null &&
                                          details[index].posterPath!.isNotEmpty
                                      ? "$imageUrl${details[index].posterPath}"
                                      : details[index].backdropPath != null &&
                                              details[index]
                                                  .backdropPath!
                                                  .isNotEmpty
                                          ? "$imageUrl${details[index].backdropPath}"
                                          : "https://via.placeholder.com/200x300.png?text=No+Image",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    (details[index].title.isNotEmpty)
                                        ? details[index].title
                                        : (details[index]
                                                .originalTitle
                                                .isNotEmpty)
                                            ? details[index].originalTitle
                                            : "unknown",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    getYearFromReleaseDate(
                                        details[index].releaseDate),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String getYearFromReleaseDate(String? releaseDate) {
    if (releaseDate != null && releaseDate.isNotEmpty) {
      DateTime date = DateTime.parse(releaseDate);
      return date.year.toString();
    } else {
      return "N/A";
    }
  }
}
