import 'package:equatable/equatable.dart';

enum StockType { equity, option, indexFund }

extension StockTypeExtension on StockType {
  String get label {
    switch (this) {
      case StockType.equity:
        return 'EQ';
      case StockType.option:
        return 'OPT';
      case StockType.indexFund:
        return 'IDX';
    }
  }
}

class StockModel extends Equatable {
  const StockModel({
    required this.id,
    required this.symbol,
    required this.type,
    this.optionDetails,
  });

  final String id;
  final String symbol;
  final StockType type;

  final String? optionDetails;

  String get displayName =>
      optionDetails != null ? '$symbol $optionDetails' : symbol;

  StockModel copyWith({
    String? id,
    String? symbol,
    StockType? type,
    String? optionDetails,
  }) {
    return StockModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      optionDetails: optionDetails ?? this.optionDetails,
    );
  }

  @override
  List<Object?> get props => [id, symbol, type, optionDetails];
}
