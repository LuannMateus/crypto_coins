import 'package:crypto_coin/models/Coin.dart';

class CoinRepository {
  static List<Coin> table = [
    Coin(
      icon: 'images/bitcoin.png',
      name: 'Bitcoin',
      initials: 'BTC',
      price: 164603.00,
    ),
    Coin(
      icon: 'images/ethereum.png',
      name: 'Ethereum',
      initials: 'ETH',
      price: 9716.00,
    ),
    Coin(
      icon: 'images/xrp.png',
      name: 'XRP',
      initials: 'XRP',
      price: 3.34,
    ),
    Coin(
      icon: 'images/cardano.png',
      name: 'Cardano',
      initials: 'ADA',
      price: 6.32,
    ),
    Coin(
      icon: 'images/usdcoin.png',
      name: 'USD Coin',
      initials: 'USDC',
      price: 5.02,
    ),
    Coin(
      icon: 'images/litecoin.png',
      name: 'Litecoin',
      initials: 'LTC',
      price: 669.93,
    ),
  ];
}
