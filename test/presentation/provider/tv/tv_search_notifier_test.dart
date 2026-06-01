import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;

    mockSearchTv = MockSearchTv();

    provider = TvSearchNotifier(
      searchTv: mockSearchTv,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

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

  final tTvList = <Tv>[tTv];
  final tQuery = 'Bluey';

  group('search tv', () {
    test('should change state to loading when usecase is called',
            () async {
          // arrange
          when(mockSearchTv.execute(tQuery))
              .thenAnswer((_) async => Right(tTvList));

          // act
          provider.fetchTvSearch(tQuery);

          // assert
          expect(provider.state, RequestState.Loading);
        });

    test('should change search result data when data is gotten successfully',
            () async {
          // arrange
          when(mockSearchTv.execute(tQuery))
              .thenAnswer((_) async => Right(tTvList));

          // act
          await provider.fetchTvSearch(tQuery);

          // assert
          expect(provider.state, RequestState.Loaded);
          expect(provider.searchResult, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTv.execute(tQuery)).thenAnswer(
            (_) async => Left(ServerFailure('Server Failure')),
      );

      // act
      await provider.fetchTvSearch(tQuery);

      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}