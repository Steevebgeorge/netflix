import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix/models/trendingmodel.dart';
import 'package:netflix/screens/moviedetailsscreen.dart';
import 'package:netflix/screens/tvdetailscreen.dart';
import 'package:netflix/utils/utils.dart';

class HomeCarousel extends StatelessWidget {
  final Trendingmodel trending;

  const HomeCarousel({super.key, required this.trending});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final carouselHeight = size.height * 0.6;

    return SizedBox(
      width: size.width,
      height: carouselHeight,
      child: CarouselSlider.builder(
        itemCount: trending.results.length,
        itemBuilder: (context, index, realIndex) {
          final url = trending.results[index].posterPath.toString();
          final movieTitle = trending.results[index].originalTitle ??
              trending.results[index].name;
          final movieRating =
              trending.results[index].voteAverage?.toStringAsFixed(1) ?? 'N/A';

          void navigate() {
            if (trending.results[index].mediaType == MediaType.MOVIE) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MovieDetailScreen(movieId: trending.results[index].id),
              ));
            } else if (trending.results[index].mediaType == MediaType.TV) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    TvDetailcreen(movieId: trending.results[index].id),
              ));
            }
          }

          return GestureDetector(
            onTap: () {
              navigate();
            },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.7 / 0.99,
                  child: CachedNetworkImage(
                    imageUrl: "$imageUrl$url",
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieTitle!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              movieRating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: carouselHeight,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOut,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.8,
        ),
      ),
    );
  }
}
