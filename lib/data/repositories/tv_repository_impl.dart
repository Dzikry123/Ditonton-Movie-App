import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../common/exception.dart';
import '../../common/failure.dart';
import '../../domain/entities/tv/tv.dart';
import '../../domain/entities/tv/tv_detail.dart';
import '../../domain/repositories/tv_repository.dart';
import '../datasources/tv_local_data_source.dart';
import '../datasources/tv_remote_data_source.dart';
import '../models/tv/tv_table.dart';

class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTv() async {
    try {
      final result = await remoteDataSource.getOnTheAirTv();

      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async {
    try {
      final result = await remoteDataSource.getPopularTv();

      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async {
    try {
      final result = await remoteDataSource.getTopRatedTv();

      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetail(id);

      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async {
    try {
      final result = await remoteDataSource.searchTv(query);

      return Right(
        result.map((model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(
      TvDetail tv,
      ) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TvTable.fromEntity(tv),
      );

      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
      TvDetail tv,
      ) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TvTable.fromEntity(tv),
      );

      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvById(id);

    return result != null;
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() async {
    final result = await localDataSource.getWatchlistTv();

    return Right(
      result.map((data) => data.toEntity()).toList(),
    );
  }
}