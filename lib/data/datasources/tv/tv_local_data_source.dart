import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper_tvs.dart';
import 'package:ditonton/data/models/tv/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlistTv(TvTable tv);
  Future<String> removeWatchlistTv(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTv();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelperTvs databaseHelpertv;

  TvLocalDataSourceImpl({required this.databaseHelpertv});

  @override
  Future<String> insertWatchlistTv(TvTable tv) async {
    try {
      await databaseHelpertv.insertWatchlistTv(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTv(TvTable tv) async {
    try {
      await databaseHelpertv.removeWatchlistTv(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelpertv.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTv() async {
    final result = await databaseHelpertv.getWatchlistTv();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
