import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';
import '../../../json_reader.dart';


void main() {
  const apiKey = 'api_key=6a4b6ebe523580487ceb3e22628e250b';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  group('get On The Air TV', () {
    final tTvList = TvResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv/now_playing_tv.json'),
      ),
    ).tvList;

    test(
      'should return list of Tv Model when response code is 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/on_the_air?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response(
            readJson('dummy_data/tv/now_playing_tv.json'),
            200,
          ),
        );

        // act
        final result = await dataSource.getOnTheAirTv();

        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/on_the_air?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response('Not Found', 404),
        );

        // act
        final call = dataSource.getOnTheAirTv();

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV', () {
    final tTvList = TvResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv/popular_tv.json'),
      ),
    ).tvList;

    test(
      'should return list of tv when response code is 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/popular?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response(
            readJson('dummy_data/tv/popular_tv.json'),
            200,
          ),
        );

        // act
        final result = await dataSource.getPopularTv();

        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw ServerException when response code is not 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/popular?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response('Not Found', 404),
        );

        // act
        final call = dataSource.getPopularTv();

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV', () {
    final tTvList = TvResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv/top_rated_tv.json'),
      ),
    ).tvList;

    test(
      'should return list of tv when response code is 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/top_rated?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response(
            readJson('dummy_data/tv/top_rated_tv.json'),
            200,
          ),
        );

        // act
        final result = await dataSource.getTopRatedTv();

        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw ServerException when response code is not 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/top_rated?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response('Not Found', 404),
        );

        // act
        final call = dataSource.getTopRatedTv();

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    const tId = 82728;

    final tTvDetail = TvDetailResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv/tv_detail.json'),
      ),
    );

    test(
      'should return tv detail when response code is 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response(
            readJson('dummy_data/tv/tv_detail.json'),
            200,
          ),
        );

        // act
        final result = await dataSource.getTvDetail(tId);

        // assert
        expect(result, equals(tTvDetail));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId?$apiKey'),
          ),
        ).thenAnswer(
              (_) async => http.Response('Not Found', 404),
        );

        // act
        final call = dataSource.getTvDetail(tId);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv/search_bluey_tv.json'),
      ),
    ).tvList;

    const tQuery = 'Bluey';

    test(
      'should return list of tv when response code is 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse(
              '$baseUrl/search/tv?$apiKey&query=$tQuery',
            ),
          ),
        ).thenAnswer(
              (_) async => http.Response(
            readJson('dummy_data/tv/search_bluey_tv.json'),
            200,
          ),
        );

        // act
        final result = await dataSource.searchTv(tQuery);

        // assert
        expect(result, tSearchResult);
      },
    );

    test(
      'should throw ServerException when response code is not 200',
          () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse(
              '$baseUrl/search/tv?$apiKey&query=$tQuery',
            ),
          ),
        ).thenAnswer(
              (_) async => http.Response('Not Found', 404),
        );

        // act
        final call = dataSource.searchTv(tQuery);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}