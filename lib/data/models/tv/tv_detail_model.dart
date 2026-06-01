import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv/tv_detail.dart';
import '../genre_model.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String firstAirDate;
  final String lastAirDate;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        adult: json['adult'],
        backdropPath: json['backdrop_path'],
        genres: List<GenreModel>.from(
          json['genres'].map((x) => GenreModel.fromJson(x)),
        ),
        homepage: json['homepage'] ?? '',
        id: json['id'],
        inProduction: json['in_production'] ?? false,
        languages: List<String>.from(json['languages'] ?? []),
        name: json['name'] ?? '',
        numberOfEpisodes: json['number_of_episodes'] ?? 0,
        numberOfSeasons: json['number_of_seasons'] ?? 0,
        originCountry: List<String>.from(json['origin_country'] ?? []),
        originalLanguage: json['original_language'] ?? '',
        originalName: json['original_name'] ?? '',
        overview: json['overview'] ?? '',
        popularity: (json['popularity'] ?? 0).toDouble(),
        posterPath: json['poster_path'],
        firstAirDate: json['first_air_date'] ?? '',
        lastAirDate: json['last_air_date'] ?? '',
        status: json['status'] ?? '',
        tagline: json['tagline'] ?? '',
        type: json['type'] ?? '',
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        voteCount: json['vote_count'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'homepage': homepage,
    'id': id,
    'in_production': inProduction,
    'languages': List<dynamic>.from(languages),
    'name': name,
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'origin_country': List<dynamic>.from(originCountry),
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'first_air_date': firstAirDate,
    'last_air_date': lastAirDate,
    'status': status,
    'tagline': tagline,
    'type': type,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  TvDetail toEntity() {
    return TvDetail(
      adult: adult,
      backdropPath: backdropPath,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      numberOfEpisodes: numberOfEpisodes,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    firstAirDate,
    lastAirDate,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}