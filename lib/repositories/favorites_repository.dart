import 'dart:collection';

import 'package:crypto_coin/adapters/CoinHiveAdapter.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

class FavoritesRepository extends ChangeNotifier {
  List<Coin> _list = [];
  late LazyBox box;

  FavoritesRepository() {
    _startRepository();
  }

  Future<void> _startRepository() async {
    await _openBox();
    await _readFavorites();
  }

  Future<void> _openBox() async {
    Hive.registerAdapter(CoinHiveAdapter());
    box = await Hive.openLazyBox<Coin>('favorites_coins');
  }

  Future<void> _readFavorites() async {
    box.keys.forEach((coin) async {
      Coin coinItem = await box.get(coin);

      _list.add(coinItem);
      notifyListeners();
    });
  }

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_list.any((actual) => actual.initials == coin.initials)) {
        _list.add(coin);
        box.put(coin.initials, coin);
      }
    });
    notifyListeners();
  }

  remove(Coin coin) {
    _list.remove(coin);
    box.delete(coin.initials);
    notifyListeners();
  }
}
