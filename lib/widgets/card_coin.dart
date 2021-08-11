import 'package:crypto_coin/models/Coin.dart';
import 'package:crypto_coin/pages/coins_details_screen.dart';
import 'package:crypto_coin/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardCoin extends StatefulWidget {
  final Coin coin;

  const CardCoin({Key? key, required this.coin}) : super(key: key);

  @override
  _CardCoinState createState() => _CardCoinState();
}

class _CardCoinState extends State<CardCoin> {
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt-BR', name: 'R\$');

  static Map<String, Color> priceColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.white70,
  };

  void showCoinDetails(Coin coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinsDetailsScreen(coin: coin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesRepository>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => showCoinDetails(widget.coin),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: <Widget>[
              Image.asset(
                widget.coin.icon,
                height: 40,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.coin.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.coin.initials,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: priceColor['down']!.withOpacity(0.05),
                    border: Border.all(
                      color: priceColor['down']!.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  currencyFormat.format(widget.coin.price),
                  style: TextStyle(
                    fontSize: 16,
                    color: priceColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text('Remove from favorites'),
                      onTap: () {
                        Navigator.pop(context);
                        favorites.remove(widget.coin);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
