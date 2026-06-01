import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/dummy_tv_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetWatchListTvStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;

    mockGetTvDetail = MockGetTvDetail();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();

    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getWatchListTvStatus: mockGetWatchListTvStatus,
      saveTvWatchlist: mockSaveTvWatchlist,
      removeTvWatchlist: mockRemoveTvWatchlist,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  const tId = 82728;

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

  group('Get TV Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));

      // act
      await provider.fetchTvDetail(tId);

      // assert
      verify(mockGetTvDetail.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));

      // act
      provider.fetchTvDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv detail when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvDetail));

          // act
          await provider.fetchTvDetail(tId);

          // assert
          expect(provider.tvState, RequestState.Loaded);
          expect(provider.tv, testTvDetail);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchTvDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchListTvStatus.execute(1))
          .thenAnswer((_) async => true);

      // act
      await provider.loadWatchlistStatus(1);

      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Success'));

      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);

      // act
      await provider.addWatchlist(testTvDetail);

      // assert
      verify(mockSaveTvWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed'));

      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      // act
      await provider.removeFromWatchlist(testTvDetail);

      // assert
      verify(mockRemoveTvWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success',
            () async {
          // arrange
          when(mockSaveTvWatchlist.execute(testTvDetail))
              .thenAnswer((_) async => Right('Added to Watchlist'));

          when(mockGetWatchListTvStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => true);

          // act
          await provider.addWatchlist(testTvDetail);

          // assert
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));

          expect(provider.isAddedToWatchlist, true);
          expect(provider.watchlistMessage, 'Added to Watchlist');
          expect(listenerCallCount, 1);
        });

    test('should update watchlist message when add watchlist failed',
            () async {
          // arrange
          when(mockSaveTvWatchlist.execute(testTvDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));

          when(mockGetWatchListTvStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);

          // act
          await provider.addWatchlist(testTvDetail);

          // assert
          expect(provider.watchlistMessage, 'Failed');
          expect(listenerCallCount, 1);
        });
  });
}