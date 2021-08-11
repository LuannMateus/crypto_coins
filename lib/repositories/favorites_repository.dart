import 'dart:collection';

import 'package:crypto_coin/models/Coin.dart';
import 'package:flutter/widgets.dart';

class FavoritesRepository extends ChangeNotifier {
  List<Coin> _list = [];

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_list.contains(coin)) _list.add(coin);
    });
    notifyListeners();
  }

  remove(Coin coin) {
    _list.remove(coin);
    notifyListeners();
  }
}
