import 'dart:convert';

class TvcreditsModel {
  List<Cast> cast;
  List<Cast> crew;
  int id;

  TvcreditsModel({
    required this.cast,
    required this.crew,
    required this.id,
  });

  TvcreditsModel copyWith({
    List<Cast>? cast,
    List<Cast>? crew,
    int? id,
  }) =>
      TvcreditsModel(
        cast: cast ?? this.cast,
        crew: crew ?? this.crew,
        id: id ?? this.id,
      );

  factory TvcreditsModel.fromRawJson(String str) =>
      TvcreditsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvcreditsModel.fromJson(Map<String, dynamic> json) => TvcreditsModel(
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
        "id": id,
      };
}

class Cast {
  bool adult;
  int gender;
  int id;
  Department knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  List<Role>? roles;
  int totalEpisodeCount;
  int? order;
  List<Job>? jobs;
  Department? department;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    this.roles,
    required this.totalEpisodeCount,
    this.order,
    this.jobs,
    this.department,
  });

  Cast copyWith({
    bool? adult,
    int? gender,
    int? id,
    Department? knownForDepartment,
    String? name,
    String? originalName,
    double? popularity,
    String? profilePath,
    List<Role>? roles,
    int? totalEpisodeCount,
    int? order,
    List<Job>? jobs,
    Department? department,
  }) =>
      Cast(
        adult: adult ?? this.adult,
        gender: gender ?? this.gender,
        id: id ?? this.id,
        knownForDepartment: knownForDepartment ?? this.knownForDepartment,
        name: name ?? this.name,
        originalName: originalName ?? this.originalName,
        popularity: popularity ?? this.popularity,
        profilePath: profilePath ?? this.profilePath,
        roles: roles ?? this.roles,
        totalEpisodeCount: totalEpisodeCount ?? this.totalEpisodeCount,
        order: order ?? this.order,
        jobs: jobs ?? this.jobs,
        department: department ?? this.department,
      );

  factory Cast.fromRawJson(String str) => Cast.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: departmentValues.map[json["known_for_department"]]!,
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        totalEpisodeCount: json["total_episode_count"],
        order: json["order"],
        jobs: json["jobs"] == null
            ? []
            : List<Job>.from(json["jobs"]!.map((x) => Job.fromJson(x))),
        department: departmentValues.map[json["department"]]!,
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": departmentValues.reverse[knownForDepartment],
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "total_episode_count": totalEpisodeCount,
        "order": order,
        "jobs": jobs == null
            ? []
            : List<dynamic>.from(jobs!.map((x) => x.toJson())),
        "department": departmentValues.reverse[department],
      };
}

enum Department { ACTING, DIRECTING, LIGHTING, PRODUCTION, WRITING }

final departmentValues = EnumValues({
  "Acting": Department.ACTING,
  "Directing": Department.DIRECTING,
  "Lighting": Department.LIGHTING,
  "Production": Department.PRODUCTION,
  "Writing": Department.WRITING
});

class Job {
  String creditId;
  String job;
  int episodeCount;

  Job({
    required this.creditId,
    required this.job,
    required this.episodeCount,
  });

  Job copyWith({
    String? creditId,
    String? job,
    int? episodeCount,
  }) =>
      Job(
        creditId: creditId ?? this.creditId,
        job: job ?? this.job,
        episodeCount: episodeCount ?? this.episodeCount,
      );

  factory Job.fromRawJson(String str) => Job.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        creditId: json["credit_id"],
        job: json["job"],
        episodeCount: json["episode_count"],
      );

  Map<String, dynamic> toJson() => {
        "credit_id": creditId,
        "job": job,
        "episode_count": episodeCount,
      };
}

class Role {
  String creditId;
  String character;
  int episodeCount;

  Role({
    required this.creditId,
    required this.character,
    required this.episodeCount,
  });

  Role copyWith({
    String? creditId,
    String? character,
    int? episodeCount,
  }) =>
      Role(
        creditId: creditId ?? this.creditId,
        character: character ?? this.character,
        episodeCount: episodeCount ?? this.episodeCount,
      );

  factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        creditId: json["credit_id"],
        character: json["character"],
        episodeCount: json["episode_count"],
      );

  Map<String, dynamic> toJson() => {
        "credit_id": creditId,
        "character": character,
        "episode_count": episodeCount,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
