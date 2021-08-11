import 'package:intl/intl.dart';

class PriceFormat {
  String locale;
  String name;

  PriceFormat({required this.locale, required this.name});

  String format(double price) {
    NumberFormat _currencyFormat =
        NumberFormat.currency(locale: locale, name: name);

    return _currencyFormat.format(price);
  }
}
