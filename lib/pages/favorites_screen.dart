import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:crypto_coin/repositories/favorites_repository.dart';
import 'package:crypto_coin/widgets/card_coin.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Coins'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12.0),
        child: Consumer<FavoritesRepository>(
          builder: (context, favorites, child) {
            return favorites.list.isEmpty
                ? ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Has no one coins favorites'))
                : ListView.builder(
                    itemCount: favorites.list.length,
                    itemBuilder: (_, index) {
                      return CardCoin(coin: favorites.list[index]);
                    },
                  );
          },
        ),
      ),
    );
  }
}
