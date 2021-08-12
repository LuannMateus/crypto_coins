import 'package:crypto_coin/database/db.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:crypto_coin/models/History.dart';
import 'package:crypto_coin/models/Position.dart';
import 'package:crypto_coin/repositories/coin_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;

  List<Position> _wallet = [];
  List<History> _history = [];

  double _amount = 0;

  get amount => _amount;

  List<Position> get wallet => _wallet;
  List<History> get history => _history;

  AccountRepository() {
    _initRepository();
  }

  Future<void> _initRepository() async {
    await _getAmount();
    await _getWallet();
    await _getHistory();
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

  Future<void> purchase(Coin coin, double value) async {
    db = await DB.instance.database;

    await db.transaction(
      (txn) async {
        final positionWallet = await txn.query(
          'wallet',
          where: 'initials = ?',
          whereArgs: [coin.initials],
        );

        if (positionWallet.isEmpty) {
          await txn.insert('wallet', {
            'initials': coin.initials,
            'coin': coin.name,
            'quantity': (value / coin.price).toString(),
          });
        } else {
          final actualWallet =
              double.parse(positionWallet.first['quantity'].toString());

          await txn.update(
            'wallet',
            {
              'quantity': (actualWallet + (value / coin.price)).toString(),
            },
            where: 'initials = ?',
            whereArgs: [coin.initials],
          );
        }

        await txn.insert('history', {
          'initials': coin.initials,
          'coin': coin.name,
          'quantity': (value / coin.price).toString(),
          'value': value,
          'operation_type': 'purchase',
          'operation_date': DateTime.now().millisecondsSinceEpoch,
        });

        await txn.update('account', {
          'amount': amount - value,
        });
      },
    );

    await _initRepository();
    notifyListeners();
  }

  Future<void> _getWallet() async {
    _wallet = [];

    List positions = await db.query('wallet');

    positions.forEach((position) {
      Coin coin = CoinRepository.table.firstWhere(
        (coin) => coin.initials == position['initials'],
      );

      _wallet.add(
        Position(
          coin: coin,
          quantity: double.parse(
            position['quantity'],
          ),
        ),
      );
    });

    notifyListeners();
  }

  Future<void> _getHistory() async {
    _history = [];

    List operations = await db.query('history');

    operations.forEach((operation) {
      Coin coin = CoinRepository.table.firstWhere(
        (coin) => coin.initials == operation['initials'],
      );

      _history.add(
        History(
          operationDate:
              DateTime.fromMillisecondsSinceEpoch(operation['operation_date']),
          operationType: operation['operation_type'],
          coin: coin,
          value: operation['value'],
          quantity: double.parse(
            operation['quantity'],
          ),
        ),
      );
    });

    notifyListeners();
  }
}
