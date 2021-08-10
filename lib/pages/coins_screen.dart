import 'package:crypto_coin/models/Coin.dart';
import 'package:crypto_coin/repositories/coin_repository.dart';
import 'package:flutter/material.dart';

class CoinsScreen extends StatelessWidget {
  const CoinsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Coin> table = CoinRepository.table;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Coins'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.asset(table[index].icon),
            title: Text(table[index].name),
            trailing: Text(table[index].price.toString()),
          );
        },
        separatorBuilder: (_, __) => Divider(),
        itemCount: table.length,
      ),
    );
  }
}
