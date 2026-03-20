import 'package:equatable/equatable.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

final class WatchlistLoaded extends WatchlistEvent {
  const WatchlistLoaded();
}

final class WatchlistStockReordered extends WatchlistEvent {
  const WatchlistStockReordered({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

final class WatchlistStockRemoved extends WatchlistEvent {
  const WatchlistStockRemoved({required this.stockId});

  final String stockId;

  @override
  List<Object?> get props => [stockId];
}
