import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

final testTv = Tv(
  adult: false,
  backdropPath: '/g88VMPtog8sl8riaIRtz4U80dMK.jpg',
  genreIds: [16, 35, 10751, 10762],
  id: 82728,
  originalName: 'Bluey',
  overview:
  'Bluey is an inexhaustible six year-old Blue Heeler dog, who loves to play and turns everyday family life into extraordinary adventures, developing her imagination as well as her mental, physical and emotional resilience.',
  popularity: 37.9496,
  posterPath: '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
  firstAirDate: '2018-10-01',
  name: 'Bluey',
  voteAverage: 8.579,
  voteCount: 692,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: '/g88VMPtog8sl8riaIRtz4U80dMK.jpg',
  genres: [
    Genre(id: 16, name: 'Animation'),
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
);

final testWatchlistTv = Tv.watchlist(
  id: 82728,
  name: 'Bluey',
  posterPath: '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
  overview:
  'Bluey is an inexhaustible six year-old Blue Heeler dog.',
);

final testTvTable = TvTable(
  id: 82728,
  name: 'Bluey',
  posterPath: '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
  overview:
  'Bluey is an inexhaustible six year-old Blue Heeler dog.',
);

final testTvMap = {
  'id': 82728,
  'name': 'Bluey',
  'posterPath': '/b9mY0X5T20ZM073hoa5n0dgmbfN.jpg',
  'overview':
  'Bluey is an inexhaustible six year-old Blue Heeler dog.',
};