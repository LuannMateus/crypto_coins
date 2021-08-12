import 'package:crypto_coin/configs/app_settings.dart';
import 'package:crypto_coin/models/Position.dart';
import 'package:crypto_coin/repositories/account_repository.dart';
import 'package:crypto_coin/utils/priceFormat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int index = 0;
  double walletAmount = 0;
  double amount = 0;
  late AccountRepository account;

  String graphicLabel = '';
  double graphicValue = 0;
  List<Position> wallet = [];

  late Map<String, String> loc;
  late PriceFormat priceFormat;
  readNumberFormat() {
    loc = Provider.of<AppSettings>(context).locale;
    priceFormat =
        PriceFormat(locale: loc['locale'] ?? '', name: loc['name'] ?? '');
  }

  setGraphicData(index) {
    if (index < 0) return;

    if (index == wallet.length) {
      graphicLabel = 'Amount';
      graphicValue = account.amount;
    } else {
      graphicLabel = wallet[index].coin.name;
      graphicValue = wallet[index].coin.price * wallet[index].quantity;
    }
  }

  List<PieChartSectionData> loadWallet() {
    setGraphicData(index);

    wallet = account.wallet;

    final sizeList = wallet.length + 1;

    return List.generate(sizeList, (i) {
      final isTouched = i == index;
      final isAmount = i == sizeList - 1;

      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double percentage = 0;

      if (!isAmount) {
        percentage = wallet[i].coin.price * wallet[i].quantity / walletAmount;
      } else {
        percentage = (account.amount > 0) ? account.amount / walletAmount : 0;
      }

      percentage *= 100;

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.green[900],
        ),
      );
    });
  }

  Widget loadGraphic() {
    return (account.amount <= 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 130,
                    sections: loadWallet(),
                    pieTouchData: PieTouchData(
                      touchCallback: (touch) => setState(() {
                        index = touch.touchedSection!.touchedSectionIndex;

                        setGraphicData(index);
                      }),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    graphicLabel,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    priceFormat.format(graphicValue),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          );
  }

  void setWalletAmount() {
    final walletList = account.wallet;

    setState(() {
      walletAmount = account.amount;

      for (var position in walletList) {
        walletAmount += position.coin.price * position.quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();

    account = context.watch<AccountRepository>();
    amount = account.amount;

    setWalletAmount();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Amount in Wallet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              priceFormat.format(walletAmount),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            loadGraphic(),
          ],
        ),
      ),
    );
  }
}
