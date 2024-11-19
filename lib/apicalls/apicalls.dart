import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:netflix/models/moviedetailmodel.dart';
import 'package:netflix/models/popular.dart';
import 'package:netflix/models/searchmodel.dart';
import 'package:netflix/models/similarmoviesmodel.dart';
import 'package:netflix/models/similartvmodel.dart';
import 'package:netflix/models/trendingmodel.dart';
import 'package:netflix/models/tvcreditsmodel.dart';
import 'package:netflix/models/tvdetailsmodel.dart';
import 'package:netflix/models/upcoming.dart';
import 'package:netflix/utils/utils.dart';

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
var key2 = "api_key=$apiKey";
late String endpoint;
late String searchQuery;

class Apiservices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endpoint = "movie/upcoming";
    final url = "$baseUrl$endpoint$key";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success fetching upcoming movies');
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to fetch upcoming movies: ${response.statusCode} - ${response.body}');
      throw Exception("Error fetching upcoming movies");
    }
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endpoint = "movie/now_playing";
    final url = "$baseUrl$endpoint$key";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success fetching now playing movies");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    } else {
      log("Failed getting Now playing movies: ${response.statusCode} - ${response.body}");
      throw Exception("error fetching now playing movies");
    }
  }

  Future<PopularMovieModel> getPopularMovies() async {
    endpoint = "movie/popular";
    final url = "$baseUrl$endpoint$key";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success fetching popular movies");
      return PopularMovieModel.fromJson(jsonDecode(response.body));
    } else {
      log("Failed getting popular movies: ${response.statusCode} - ${response.body}");
      throw Exception("error fetching popular movies");
    }
  }

  Future<Trendingmodel> gettrending() async {
    endpoint = "trending/all/day?language=en-US&";
    final url = "$baseUrl$endpoint$key2";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success fetching trending List");
      return Trendingmodel.fromJson(jsonDecode(response.body));
    } else {
      log("Failed getting trending List: ${response.statusCode} - ${response.body}");
      throw Exception("error fetching trending List");
    }
  }

  Future<SearchModel> getsearchfiles(String query) async {
    endpoint = "search/multi";
    searchQuery = "&query=$query";
    final url = "$baseUrl$endpoint$key$searchQuery";
    final response = await http.get(Uri.parse(url));
    print(response.request);

    if (response.statusCode == 200) {
      log("Success fetching searched items");
      return SearchModel.fromJson(jsonDecode(response.body));
    } else {
      log("Failed getting searched items: ${response.statusCode} - ${response.body}");
      throw Exception("error fetching search List");
    }
  }

  Future<MovieDetailModel> getmovieDetail(int movieId) async {
    endpoint = "movie/";
    final response = await http.get(Uri.parse('$baseUrl$endpoint$movieId$key'));
    print("hey hey ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic>? jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return MovieDetailModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load movie detail: Response is null');
      }
    } else {
      throw Exception('Failed to load movie detail: ${response.reasonPhrase}');
    }
  }

  Future<TvDetailsmodel> getTvDetails(int tvId) async {
    endpoint = "tv/";
    final response = await http.get(Uri.parse('$baseUrl$endpoint$tvId$key'));
    print("hey hey ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic>? jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return TvDetailsmodel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load tv detail: Response is null');
      }
    } else {
      throw Exception('Failed to load tv detail: ${response.reasonPhrase}');
    }
  }

  Future<SimilarMovies> getSimilarMovies(int tvId) async {
    endpoint = "movie/$tvId/similar";
    final response = await http.get(Uri.parse('$baseUrl$endpoint$key'));
    print("hey hey ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic>? jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return SimilarMovies.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load similar detail: Response is null');
      }
    } else {
      throw Exception(
          'Failed to load similar detail: ${response.reasonPhrase}');
    }
  }

  Future<Similartv> getSimilarTV(int tvId) async {
    endpoint = "tv/$tvId/similar";
    final response = await http.get(Uri.parse('$baseUrl$endpoint$key'));
    print("hey hey ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic>? jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return Similartv.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load similar detail: Response is null');
      }
    } else {
      throw Exception(
          'Failed to load similar detail: ${response.reasonPhrase}');
    }
  }

  Future<TvcreditsModel> gettvcredits(int tvId) async {
    endpoint = "tv/$tvId/aggregate_credits";
    final response = await http.get(Uri.parse('$baseUrl$endpoint$key'));
    print("hey hey ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic>? jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return TvcreditsModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load credits detail: Response is null');
      }
    } else {
      throw Exception(
          'Failed to load credits detail: ${response.reasonPhrase}');
    }
  }
}
