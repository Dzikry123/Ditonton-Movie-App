import 'dart:io';
import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();

    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/g88VMPtog8sl8riaIRtz4U80dMK.jpg',
    genreIds: [16, 35, 10751, 10762],
    id: 82728,
    originCountry: ['AU'],
    originalLanguage: 'en',
    originalName: 'Bluey',
    overview:
    'Bluey is an inexhaustible six year-old Blue Heeler dog.',
    popularity: 37.9496,
    posterPath: '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
    firstAirDate: '2018-10-01',
    softcore: false,
    name: 'Bluey',
    voteAverage: 8.579,
    voteCount: 692,
  );

  final tTv = Tv(
    adult: false,
    backdropPath: '/g88VMPtog8sl8riaIRtz4U80dMK.jpg',
    genreIds: [16, 35, 10751, 10762],
    id: 82728,
    originalName: 'Bluey',
    overview:
    'Bluey is an inexhaustible six year-old Blue Heeler dog.',
    popularity: 37.9496,
    posterPath: '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
    firstAirDate: '2018-10-01',
    name: 'Bluey',
    voteAverage: 8.579,
    voteCount: 692,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('On The Air TV', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirTv())
              .thenAnswer((_) async => tTvModelList);

          // act
          final result = await repository.getOnTheAirTv();

          // assert
          verify(mockRemoteDataSource.getOnTheAirTv());

          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirTv())
              .thenThrow(ServerException());

          // act
          final result = await repository.getOnTheAirTv();

          // assert
          verify(mockRemoteDataSource.getOnTheAirTv());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getOnTheAirTv()).thenThrow(
            SocketException('Failed to connect to the network'),
          );

          // act
          final result = await repository.getOnTheAirTv();

          // assert
          verify(mockRemoteDataSource.getOnTheAirTv());

          expect(
            result,
            equals(
              Left(ConnectionFailure('Failed to connect to the network')),
            ),
          );
        });
  });

  group('Popular TV', () {
    test('should return tv list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTv())
              .thenAnswer((_) async => tTvModelList);

          // act
          final result = await repository.getPopularTv();

          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test('should return ServerFailure when call is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(ServerException());

      // act
      final result = await repository.getPopularTv();

      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTv()).thenThrow(
            SocketException('Failed to connect to the network'),
          );

          // act
          final result = await repository.getPopularTv();

          // assert
          expect(
            result,
            Left(ConnectionFailure('Failed to connect to the network')),
          );
        });
  });

  group('Top Rated TV', () {
    test('should return tv list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTv())
              .thenAnswer((_) async => tTvModelList);

          // act
          final result = await repository.getTopRatedTv();

          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test('should return ServerFailure when call is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(ServerException());

      // act
      final result = await repository.getTopRatedTv();

      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTv()).thenThrow(
            SocketException('Failed to connect to the network'),
          );

          // act
          final result = await repository.getTopRatedTv();

          // assert
          expect(
            result,
            Left(ConnectionFailure('Failed to connect to the network')),
          );
        });
  });

  group('Get TV Detail', () {
    final tId = 82728;

    final tTvDetailResponse = TvDetailResponse(
      adult: false,
      backdropPath: '/g88VMPtog8sl8riaIRtz4U80dMK.jpg',
      genres: [
        GenreModel(
          id: 16,
          name: 'Animation',
        ),
      ],
      id: 82728,
      originalName: 'Bluey',
      overview:
      'Bluey is an inexhaustible six year-old Blue Heeler dog.',
      posterPath: '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
      firstAirDate: '2018-10-01',
      numberOfEpisodes: 154,
      name: 'Bluey',
      voteAverage: 8.579,
      voteCount: 692,
      homepage: 'http://www.abc.net.au/tv/programs/bluey/',
      inProduction: true,
      languages: ["en"],
      numberOfSeasons: 3,
      originCountry: ["AU"],
      originalLanguage: '',
      popularity: 38.1084,
      lastAirDate: '2024-04-21',
      status: 'Returning Series',
      tagline: 'For real life?!',
      type: 'Scripted',
    );

    test(
        'should return TV detail when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvDetail(tId))
              .thenAnswer((_) async => tTvDetailResponse);

          // act
          final result = await repository.getTvDetail(tId);

          // assert
          verify(mockRemoteDataSource.getTvDetail(tId));

          expect(result, equals(Right(testTvDetail)));
        });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvDetail(tId))
              .thenThrow(ServerException());

          // act
          final result = await repository.getTvDetail(tId);

          // assert
          verify(mockRemoteDataSource.getTvDetail(tId));

          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return ConnectionFailure when device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(
            SocketException('Failed to connect to the network'),
          );

          // act
          final result = await repository.getTvDetail(tId);

          // assert
          verify(mockRemoteDataSource.getTvDetail(tId));

          expect(
            result,
            equals(
              Left(ConnectionFailure('Failed to connect to the network')),
            ),
          );
        });
  });

  group('Search TV', () {
    final tQuery = 'Bluey';

    test('should return tv list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTv(tQuery))
              .thenAnswer((_) async => tTvModelList);

          // act
          final result = await repository.searchTv(tQuery);

          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvList);
        });

    test('should return ServerFailure when call is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.searchTv(tQuery))
          .thenThrow(ServerException());

      // act
      final result = await repository.searchTv(tQuery);

      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTv(tQuery)).thenThrow(
            SocketException('Failed to connect to the network'),
          );

          // act
          final result = await repository.searchTv(tQuery);

          // assert
          expect(
            result,
            Left(ConnectionFailure('Failed to connect to the network')),
          );
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      // act
      final result = await repository.saveWatchlist(testTvDetail);

      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      // act
      final result = await repository.saveWatchlist(testTvDetail);

      // assert
      expect(
        result,
        Left(DatabaseFailure('Failed to add watchlist')),
      );
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      // act
      final result = await repository.removeWatchlist(testTvDetail);

      // assert
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      // act
      final result = await repository.removeWatchlist(testTvDetail);

      // assert
      expect(
        result,
        Left(DatabaseFailure('Failed to remove watchlist')),
      );
    });
  });

  group('get watchlist status', () {
    test('should return watchlist status whether data is found', () async {
      // arrange
      final tId = 1;

      when(mockLocalDataSource.getTvById(tId))
          .thenAnswer((_) async => null);

      // act
      final result = await repository.isAddedToWatchlist(tId);

      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv', () {
    test('should return list of TV', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);

      // act
      final result = await repository.getWatchlistTv();

      // assert
      final resultList = result.getOrElse(() => []);

      expect(resultList, [testWatchlistTv]);
    });
  });
}