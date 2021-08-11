import 'package:intl/intl.dart';

abstract class PriceFormat {
  static NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt-BR', name: 'R\$');

  static String format(double price) {
    return _currencyFormat.format(price);
  }
}
