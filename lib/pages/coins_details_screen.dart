import 'package:flutter/material.dart';
import 'package:crypto_coin/models/Coin.dart';

class CoinsDetailsScreen extends StatefulWidget {
  final Coin coin;

  CoinsDetailsScreen({Key? key, required this.coin}) : super(key: key);

  @override
  _CoinsDetailsScreenState createState() => _CoinsDetailsScreenState();
}

class _CoinsDetailsScreenState extends State<CoinsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                child: Image.asset(widget.coin.icon),
                width: 50,
              )
            ],
          )
        ],
      ),
    );
  }
}
