import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix/apicalls/apicalls.dart';
import 'package:netflix/models/popular.dart';
import 'package:netflix/models/searchmodel.dart';
import 'package:netflix/screens/moviedetailsscreen.dart';
import 'package:netflix/screens/tvdetailscreen.dart';
import 'package:netflix/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final Apiservices apiservices = Apiservices();
  late Future<PopularMovieModel> populerfuture;
  SearchModel? _searchModel;
  bool isLoading = false;
  Timer? debounce;

  void search(String queryText) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoading = true;
      });
      try {
        final results = await apiservices.getsearchfiles(queryText);
        setState(() {
          _searchModel = results;
        });
      } catch (e) {
        // Handle errors gracefully
        print("Error fetching search results: $e");
        setState(() {
          _searchModel = null;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    populerfuture = apiservices.getPopularMovies();
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CupertinoSearchTextField(
                  itemColor: Colors.white,
                  itemSize: 25,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  autocorrect: false,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 200, 190, 190),
                    size: 25,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 69, 64, 63),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: searchController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      search(value.toLowerCase().trim());
                    } else {
                      setState(() {
                        _searchModel = null;
                      });
                    }
                  },
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (searchController.text.isEmpty)
                FutureBuilder(
                  future: populerfuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
                      var data = snapshot.data!.results;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Popular Movies",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                        movieId: data[index].id),
                                  ));
                                },
                                child: Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Image.network(
                                          '$imageUrl${data[index].posterPath}',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              data[index].title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Text(
                                            data[index]
                                                .releaseDate
                                                .year
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              else if (_searchModel == null || _searchModel!.results.isEmpty)
                const Center(child: Text("No results found."))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchModel!.results.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.2 / 2,
                  ),
                  itemBuilder: (context, index) {
                    final result = _searchModel!.results[index];

                    void navigate() {
                      if (result.mediaType == MediaType.MOVIE) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movieId: result.id),
                        ));
                      } else if (result.mediaType == MediaType.TV) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              TvDetailcreen(movieId: result.id),
                        ));
                      }
                    }

                    String imageUrlToUse = result.backdropPath != null &&
                            result.backdropPath!.isNotEmpty
                        ? "$imageUrl${result.backdropPath!}"
                        : result.posterPath.isNotEmpty
                            ? "$imageUrl${result.posterPath}"
                            : "https://via.placeholder.com/200x300.png?text=No+Image";

                    return InkWell(
                      onTap: () {
                        navigate();
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
                                  imageUrl: imageUrlToUse,
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
                                    result.originalName ??
                                        result.title ??
                                        result.name ??
                                        "unknown",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    result.releaseDate != null
                                        ? result.releaseDate!.year.toString()
                                        : result.firstAirDate != null
                                            ? result.firstAirDate!.year
                                                .toString()
                                            : "N/A",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  )
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
        ),
      ),
    );
  }
}
