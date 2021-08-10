import 'package:crypto_coin/models/Coin.dart';
import 'package:crypto_coin/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinsScreen extends StatefulWidget {
  CoinsScreen({Key? key}) : super(key: key);

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
  final List<Coin> table = CoinRepository.table;

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'eua', name: '\$');

  List<Coin> selecteds = [];

  AppBar dynamicAppBar() {
    if (selecteds.isEmpty) {
      return AppBar(
        title: Text('Crypto Coins'),
        centerTitle: true,
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecteds = [];
            });
          },
        ),
        title: Text('${selecteds.length} selecteds'),
        centerTitle: true,
        backgroundColor: Colors.white70,
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dynamicAppBar(),
      body: ListView.separated(
        padding: const EdgeInsets.all(15),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: selecteds.contains(table[index])
                ? CircleAvatar(child: Icon(Icons.check))
                : SizedBox(
                    child: Image.asset(table[index].icon),
                    width: 40,
                  ),
            title: Text(
              table[index].name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(currencyFormat.format(table[index].price)),
            selected: selecteds.contains(table[index]),
            selectedTileColor: Colors.white10,
            onLongPress: () {
              setState(() {
                selecteds.contains(table[index])
                    ? selecteds.remove(table[index])
                    : selecteds.add(table[index]);
              });
            },
          );
        },
        separatorBuilder: (_, __) => Divider(),
        itemCount: table.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecteds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.star),
              label: Text(
                'FAVORITE',
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
