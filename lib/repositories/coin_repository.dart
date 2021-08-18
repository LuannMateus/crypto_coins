import 'dart:async';
import 'dart:convert';

import 'package:crypto_coin/database/db.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class CoinRepository extends ChangeNotifier {
  List<Coin> _table = [];
  late Timer interval;

  List<Coin> get table => _table;

  CoinRepository() {
    _setupCoinsTable();
    _setupCoinsTableData();
    _readCoinsTable();
    _refreshPrices();
  }

  _refreshPrices() {
    interval =
        Timer.periodic(Duration(minutes: 5), (timer) => checkAndUpdatePrices());
  }

  Future<void> checkAndUpdatePrices() async {
    String uri = 'https://api.coinbase.com/v2/assets/prices?base=BRL';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List<dynamic> coins = json['data'];

      Database db = await DB.instance.database;
      Batch batch = db.batch();

      _table.forEach((actual) {
        coins.forEach((newCoin) {
          if (actual.baseId == newCoin['base_id']) {
            final coin = newCoin['prices'];
            final price = coin['latest_price'];
            final timestamp = DateTime.parse(price['timestamp']);

            batch.update(
              'coins',
              {
                "price": coin['latest'],
                "timestamp": timestamp.millisecondsSinceEpoch,
                "hourChange": price['percent_change']['hour'].toString(),
                "dayChange": price['percent_change']['day'].toString(),
                "weekChange": price['percent_change']['week'].toString(),
                "monthChange": price['percent_change']['month'].toString(),
                "yearChange": price['percent_change']['year'].toString(),
                "totalPeriodChange": price['percent_change']['all'].toString(),
              },
              where: 'baseId = ?',
              whereArgs: [actual.baseId],
            );
          }
        });
      });

      batch.commit(noResult: true);
      await _readCoinsTable();
    }
  }

  _readCoinsTable() async {
    Database db = await DB.instance.database;

    List results = await db.query('coins');

    _table = results.map((row) {
      return Coin(
        baseId: row['baseId'],
        icon: row['icon'],
        name: row['name'],
        initials: row['initials'],
        price: double.parse(row['price']),
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp']),
        hourChange: double.parse(row['hourChange']),
        dayChange: double.parse(row['dayChange']),
        weekChange: double.parse(row['weekChange']),
        monthChange: double.parse(row['monthChange']),
        yearChange: double.parse(row['yearChange']),
        totalPeriodChange: double.parse(row['totalPeriodChange']),
      );
    }).toList();

    print('UPDATEEEE');

    notifyListeners();
  }

  Future<bool> _coinsTableIsEmpty() async {
    Database db = await DB.instance.database;

    List results = await db.query('coins');

    return results.isEmpty;
  }

  Future<void> _setupCoinsTableData() async {
    if (await _coinsTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final List<dynamic> coins = json['data'];

        Database db = await DB.instance.database;

        Batch batch = db.batch();

        coins.forEach((coin) {
          final price = coin['latest_price'];
          final timestamp = DateTime.parse(price['timestamp']);

          batch.insert('coins', {
            "baseId": coin['id'],
            "icon": coin['image_url'],
            "name": coin['name'],
            "initials": coin['symbol'],
            "price": coin['latest'],
            "timestamp": timestamp.millisecondsSinceEpoch,
            "hourChange": price['percent_change']['hour'].toString(),
            "dayChange": price['percent_change']['day'].toString(),
            "weekChange": price['percent_change']['week'].toString(),
            "monthChange": price['percent_change']['month'].toString(),
            "yearChange": price['percent_change']['year'].toString(),
            "totalPeriodChange": price['percent_change']['all'].toString(),
          });
        });
        await batch.commit(noResult: true);
      }
    }
  }

  Future<void> _setupCoinsTable() async {
    final String table = ''' 
     CREATE TABLE IF NOT EXISTS coins (
        baseId TEXT PRIMARY KEY,
        initials TEXT,
        name TEXT,
        icon TEXT,
        price TEXT,
        timestamp INTEGER,
        hourChange TEXT,
        dayChange TEXT,
        weekChange TEXT,
        monthChange TEXT,
        yearChange TEXT,
        totalPeriodChange TEXT
      );
    ''';

    Database db = await DB.instance.database;

    await db.execute(table);
  }
}
