import 'package:equatable/equatable.dart';
import '../data/models/stock_model.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

final class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

final class WatchlistLoadInProgress extends WatchlistState {
  const WatchlistLoadInProgress();
}

final class WatchlistLoadSuccess extends WatchlistState {
  const WatchlistLoadSuccess({
    required this.watchlistName,
    required this.stocks,
  });

  final String watchlistName;
  final List<StockModel> stocks;

  WatchlistLoadSuccess copyWith({
    String? watchlistName,
    List<StockModel>? stocks,
  }) {
    return WatchlistLoadSuccess(
      watchlistName: watchlistName ?? this.watchlistName,
      stocks: stocks ?? this.stocks,
    );
  }

  @override
  List<Object?> get props => [watchlistName, stocks];
}

final class WatchlistLoadFailure extends WatchlistState {
  const WatchlistLoadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
