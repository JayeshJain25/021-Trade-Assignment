import 'package:uuid/uuid.dart';
import '../models/stock_model.dart';

class WatchlistRepository {
  WatchlistRepository() : _stocks = _seedStocks();

  final List<StockModel> _stocks;

  String get watchlistName => 'Watchlist 1';

  List<StockModel> getStocks() => List.unmodifiable(_stocks);

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex--;
    final item = _stocks.removeAt(oldIndex);
    _stocks.insert(newIndex, item);
  }

  void remove(String stockId) {
    _stocks.removeWhere((s) => s.id == stockId);
  }

  static const _uuid = Uuid();

  static List<StockModel> _seedStocks() => [
        StockModel(
          id: _uuid.v4(),
          symbol: 'HDFCBANK',
          type: StockType.equity,
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'ASIANPAINT',
          type: StockType.equity,
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'RELIANCE',
          type: StockType.option,
          optionDetails: 'SEP 1880 CE',
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'RELIANCE',
          type: StockType.equity,
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'NIFTY IT',
          type: StockType.indexFund,
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'RELIANCE',
          type: StockType.option,
          optionDetails: 'SEP 1370 PE',
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'MRF',
          type: StockType.equity,
        ),
        StockModel(
          id: _uuid.v4(),
          symbol: 'MRF',
          type: StockType.equity,
        ),
      ];
}
