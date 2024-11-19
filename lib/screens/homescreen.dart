import 'package:flutter/material.dart';
import 'package:netflix/apicalls/apicalls.dart';
import 'package:netflix/models/popular.dart';
import 'package:netflix/models/trendingmodel.dart';
import 'package:netflix/models/upcoming.dart';
import 'package:netflix/screens/searchscreen.dart';
import 'package:netflix/widgets/carousel.dart';
import 'package:netflix/widgets/moviecard.dart';
import 'package:netflix/widgets/popularmoviecard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovieModel> upcomingFuture;
  late Future<UpcomingMovieModel> nowplayingFuture;
  late Future<PopularMovieModel> popularFuture;
  late Future<Trendingmodel> trendingFuture;
  final Apiservices apiservices = Apiservices();

  @override
  void initState() {
    super.initState();
    upcomingFuture = apiservices.getUpcomingMovies();
    nowplayingFuture = apiservices.getNowPlayingMovies();
    popularFuture = apiservices.getPopularMovies();
    trendingFuture = apiservices.gettrending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Image.asset(
          'assets/netflix.png',
          height: 90,
          width: 50,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ));
            },
            icon: const Icon(Icons.search, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 30,
              width: 30,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 18),
            FutureBuilder(
              future: trendingFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                } else {
                  return HomeCarousel(trending: snapshot.data!);
                }
              },
            ),
            SizedBox(
              height: 250,
              child: MovieCard(
                future: nowplayingFuture,
                headLineText: "Now Playing",
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              height: 250,
              child: MovieCard(
                future: upcomingFuture,
                headLineText: 'Upcoming Movies',
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 250,
              child: Popularmoviecard(
                future: popularFuture,
                headLineText: "Popular Movies",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
