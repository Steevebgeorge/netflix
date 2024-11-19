import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/apicalls/apicalls.dart';
import 'package:netflix/models/tvdetailsmodel.dart';
import 'package:netflix/utils/utils.dart';
import 'package:netflix/widgets/buttons.dart';
import 'package:netflix/widgets/similartvwidget.dart';

class TvDetailcreen extends StatefulWidget {
  final int movieId;

  const TvDetailcreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<TvDetailcreen> createState() => TvDetailcreenState();
}

class TvDetailcreenState extends State<TvDetailcreen> {
  late Future<TvDetailsmodel> tvdetailsfuture;
  Apiservices apiservices = Apiservices();

  @override
  void initState() {
    super.initState();
    initialdata();
  }

  void initialdata() async {
    try {
      tvdetailsfuture = apiservices.getTvDetails(widget.movieId);
      print(widget.movieId);

      // Log the response to check its structure
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: tvdetailsfuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            final movie = snapshot.data;
            final imagePath = movie?.posterPath ??
                movie?.backdropPath ??
                "https://via.placeholder.com/200x300.png?text=No+Image";

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  "$imageUrl$imagePath"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        backbutton()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie!.name,
                            style: const TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Text(
                                  movie.firstAirDate.year.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            maxLines: 2,
                            movie.genres.map((e) => e.name).join(', '),
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Rating: ${movie.voteAverage.toStringAsFixed(1)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 19,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: SingleChildScrollView(
                              child: Text(movie.overview,
                                  style: const TextStyle(color: Colors.grey)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Buttons(),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SimilarTvWidget(movidId: movie.id)
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget backbutton() {
    return Positioned(
      top: 25,
      left: 15,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.15,
        decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 30,
        ),
      ),
    );
  }
}
