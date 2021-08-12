import 'package:crypto_coin/models/Coin.dart';

class History {
  DateTime operationDate;
  String operationType;
  Coin coin;
  double value;
  double quantity;

  History({
    required this.operationDate,
    required this.operationType,
    required this.coin,
    required this.value,
    required this.quantity,
  });
}
