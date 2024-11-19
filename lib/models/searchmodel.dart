import 'dart:convert';

class SearchModel {
  final int page;
  final List<Result> results;
  final int totalPages;
  final int totalResults;

  SearchModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  SearchModel copyWith({
    int? page,
    List<Result>? results,
    int? totalPages,
    int? totalResults,
  }) =>
      SearchModel(
        page: page ?? this.page,
        results: results ?? this.results,
        totalPages: totalPages ?? this.totalPages,
        totalResults: totalResults ?? this.totalResults,
      );

  factory SearchModel.fromRawJson(String str) =>
      SearchModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result {
  final String? backdropPath;
  final int id;
  final String? name;
  final String? originalName;
  final String overview;
  final String posterPath;
  final MediaType mediaType;
  late bool adult; // Using late since it will be set later
  final String originalLanguage;
  final List<int> genreIds;
  final double popularity;
  DateTime? firstAirDate; // Nullable
  final double voteAverage;
  final int voteCount;
  List<String>? originCountry; // Nullable
  final String? title;
  final String? originalTitle;
  DateTime? releaseDate; // Nullable
  bool? video; // Nullable

  Result({
    this.backdropPath,
    required this.id,
    this.name,
    this.originalName,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.adult, // Ensure adult is initialized
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    this.originCountry,
    this.title,
    this.originalTitle,
    this.releaseDate,
    this.video,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        backdropPath: json["backdrop_path"] as String?,
        id: json["id"],
        name: json["name"] as String?,
        originalName: json["original_name"] as String?,
        overview: json["overview"] as String? ?? "", // Default to empty string
        posterPath:
            json["poster_path"] as String? ?? "", // Default to empty string
        mediaType: mediaTypeValues.map[json["media_type"]]!,
        adult: json["adult"] ?? false, // Default to false if not present
        originalLanguage: json["original_language"] as String? ??
            "", // Default to empty string
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        popularity: (json["popularity"]?.toDouble() ?? 0.0), // Default to zero
        firstAirDate: _parseDate(json["first_air_date"]),
        voteAverage:
            (json["vote_average"]?.toDouble() ?? 0.0), // Default to zero
        voteCount: json["vote_count"] ?? 0, // Default to zero
        originCountry: json["origin_country"] == null
            ? []
            : List<String>.from(json["origin_country"].map((x) => x)),
        title: json["title"] as String?,
        originalTitle: json["original_title"] as String?,
        releaseDate: _parseDate(json["release_date"]),
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "name": name,
        "original_name": originalName,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaTypeValues.reverse[mediaType],
        "adult": adult, // Ensure adult is included in JSON output
        "original_language": originalLanguage,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "popularity": popularity,
        "first_air_date": firstAirDate?.toIso8601String(),
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "origin_country": originCountry ?? [],
        "title": title,
        "original_title": originalTitle,
        "release_date": releaseDate?.toIso8601String(),
        "video": video,
      };

  static DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null; // Return null if the string is null or empty
    }

    try {
      return DateTime.parse(dateString); // Attempt to parse the date
    } catch (e) {
      print('Error parsing date: $dateString'); // Log the error
      return null; // Return null or handle as needed
    }
  }
}

enum MediaType { MOVIE, TV }

final mediaTypeValues =
    EnumValues({"movie": MediaType.MOVIE, "tv": MediaType.TV});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
