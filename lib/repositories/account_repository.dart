import 'package:crypto_coin/database/db.dart';
import 'package:crypto_coin/models/Position.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;

  List<Position> _wallet = [];
  double _amount = 0;

  get amount => _amount;
  List<Position> get wallet => _wallet;

  AccountRepository() {
    _initRepository();
  }

  void _initRepository() async {
    await _getAmount();
  }

  Future<void> _getAmount() async {
    db = await DB.instance.database;
    List account = await db.query('account', limit: 1);

    _amount = account.first['amount'];

    notifyListeners();
  }

  Future<void> setAmount(double value) async {
    db = await DB.instance.database;

    db.update('account', {'amount': value});

    _amount = value;

    notifyListeners();
  }
}
