import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc({required WatchlistRepository repository})
      : _repository = repository,
        super(const WatchlistInitial()) {
    on<WatchlistLoaded>(_onLoaded);
    on<WatchlistStockReordered>(_onReordered);
    on<WatchlistStockRemoved>(_onRemoved);
  }

  final WatchlistRepository _repository;

  Future<void> _onLoaded(
    WatchlistLoaded event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(const WatchlistLoadInProgress());
    try {
      final stocks = _repository.getStocks();
      emit(WatchlistLoadSuccess(
        watchlistName: _repository.watchlistName,
        stocks: stocks,
      ));
    } catch (e) {
      emit(WatchlistLoadFailure(message: e.toString()));
    }
  }

  void _onReordered(
    WatchlistStockReordered event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    _repository.reorder(event.oldIndex, event.newIndex);

    emit(current.copyWith(stocks: _repository.getStocks()));
  }

  void _onRemoved(
    WatchlistStockRemoved event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    _repository.remove(event.stockId);

    emit(current.copyWith(stocks: _repository.getStocks()));
  }
}
