import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  });

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationTvState = RequestState.Empty;
  RequestState get recommendationTvState => _recommendationTvState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlistTv = false;
  bool get isAddedToWatchlistTv => _isAddedtoWatchlistTv;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationTvState = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationTvState = RequestState.Error;
            _message = failure.message;
          },
          (tv) {
            _recommendationTvState = RequestState.Loaded;
            _tvRecommendations = tv;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessageTv = '';
  String get watchlistMessageTv => _watchlistMessageTv;

  Future<void> addWatchlistTv(TvDetail tv) async {
    final result = await saveWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessageTv = failure.message;
      },
      (successMessage) async {
        _watchlistMessageTv = successMessage;
      },
    );

    await loadWatchlistStatusTv(tv.id);
  }

  Future<void> removeFromWatchlistTv(TvDetail tv) async {
    final result = await removeWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessageTv = failure.message;
      },
      (successMessage) async {
        _watchlistMessageTv = successMessage;
      },
    );

    await loadWatchlistStatusTv(tv.id);
  }

  Future<void> loadWatchlistStatusTv(int id) async {
    final result = await getWatchListStatusTv.execute(id);
    _isAddedtoWatchlistTv = result;
    notifyListeners();
  }
}
