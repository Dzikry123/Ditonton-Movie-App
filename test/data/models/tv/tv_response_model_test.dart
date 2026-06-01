import 'dart:convert';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    adult: false,
    backdropPath: "/6gN8DYnIEln8v7OhRy61c57w0Xy.jpg",
    genreIds: [9648, 18, 10765],
    id: 124364,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "FROM",
    overview: "Overview",
    popularity: 718.6677,
    posterPath: "/pRtJagIxpfODzzb0T0NAvZSzErC.jpg",
    firstAirDate: "2022-02-20",
    softcore: false,
    name: "FROM",
    voteAverage: 8.406,
    voteCount: 3332,
  );

  final tTvResponseModel = TvResponse(
    tvList: <TvModel>[tTvModel],
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/tv/now_playing_tv.json'));

      // act
      final result = TvResponse.fromJson(jsonMap);

      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTvResponseModel.toJson();

      // assert
      final expectedJsonMap = {
        "results": [
          {
            'adult': false,
            'backdrop_path': '/6gN8DYnIEln8v7OhRy61c57w0Xy.jpg',
            'genre_ids': [9648, 18, 10765],
            'id': 124364,
            'origin_country': ['US'],
            'original_language': 'en',
            'original_name': 'FROM',
            'overview': 'Overview',
            'popularity': 718.6677,
            'poster_path': '/pRtJagIxpfODzzb0T0NAvZSzErC.jpg',
            'first_air_date': '2022-02-20',
            'softcore': false,
            'name': 'FROM',
            'vote_average': 8.406,
            'vote_count': 3332
          }
        ],
      };

      expect(result, expectedJsonMap);
    });
  });
}