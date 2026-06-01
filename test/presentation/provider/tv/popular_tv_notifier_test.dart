// tv_popular_notifier_test.dart

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';


@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;

    mockGetPopularTv = MockGetPopularTv();

    notifier = PopularTvNotifier(mockGetPopularTv)
      ..addListener(() {
        listenerCallCount++;
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

  test('should change state to loading when usecase is called',
          () async {
        // arrange
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tTvList));

        // act
        notifier.fetchPopularTv();

        // assert
        expect(notifier.state, RequestState.Loading);
        expect(listenerCallCount, 1);
      });

  test('should change tv data when data is gotten successfully',
          () async {
        // arrange
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tTvList));

        // act
        await notifier.fetchPopularTv();

        // assert
        expect(notifier.state, RequestState.Loaded);
        expect(notifier.tv, tTvList);
        expect(listenerCallCount, 2);
      });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
    );

    // act
    await notifier.fetchPopularTv();

    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}