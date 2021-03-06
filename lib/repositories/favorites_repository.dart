import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin/database/db_firestore.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:crypto_coin/repositories/coin_repository.dart';
import 'package:crypto_coin/services/auth_service.dart';
import 'package:flutter/widgets.dart';

class FavoritesRepository extends ChangeNotifier {
  List<Coin> _list = [];
  late FirebaseFirestore db;
  late AuthService auth;
  CoinRepository coins;

  FavoritesRepository({required this.auth, required this.coins}) {
    _startRepository();
  }

  Future<void> _startRepository() async {
    await _startFirestore();
    await _readFavorites();
  }

  Future<void> _startFirestore() async {
    db = DBFirestore.get();
  }

  Future<void> _readFavorites() async {
    if (auth.user != null && _list.isEmpty) {
      final snapshot =
          await db.collection('users/${auth.user!.uid}/favorites').get();

      snapshot.docs.forEach((doc) {
        Coin coin = coins.table
            .firstWhere((coin) => coin.initials == doc.get('initials'));
        _list.add(coin);

        notifyListeners();
      });
    }
  }

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  void saveAll(List<Coin> coins) {
    coins.forEach((coin) async {
      if (!_list.any((actual) => actual.initials == coin.initials)) {
        _list.add(coin);

        await db
            .collection('users/${auth.user!.uid}/favorites')
            .doc(coin.initials)
            .set({
          'coin': coin.name,
          'initials': coin.initials,
          'price': coin.price
        });
      }
    });

    notifyListeners();
  }

  Future<void> remove(Coin coin) async {
    await db
        .collection('users/${auth.user!.uid}/favorites')
        .doc(coin.initials)
        .delete();

    _list.remove(coin);

    notifyListeners();
  }
}
