import 'package:crypto_coin/configs/app_settings.dart';
import 'package:crypto_coin/repositories/account_repository.dart';
import 'package:crypto_coin/utils/priceFormat.dart';
import 'package:crypto_coin/widgets/graphic_history.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

class CoinsDetailsScreen extends StatefulWidget {
  final Coin coin;

  CoinsDetailsScreen({Key? key, required this.coin}) : super(key: key);

  @override
  _CoinsDetailsScreenState createState() => _CoinsDetailsScreenState();
}

class _CoinsDetailsScreenState extends State<CoinsDetailsScreen> {
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double quantity = 0;
  late AccountRepository account;
  Widget graphic = Container();
  bool graphicLoaded = false;

  late Map<String, String> loc;
  late PriceFormat priceFormat;

  readNumberFormat() {
    loc = Provider.of<AppSettings>(context).locale;
    priceFormat =
        PriceFormat(locale: loc['locale'] ?? '', name: loc['name'] ?? '');
  }

  getGraphic() {
    if (!graphicLoaded) {
      graphic = GraphicHistory(coin: widget.coin);
      graphicLoaded = true;
    }

    return graphic;
  }

  Future<void> handlePurchase() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    await account.purchase(widget.coin, double.parse(_value.text));

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase with success!'),
      ),
    );
  }

  void sharePrice() {
    final coin = widget.coin;

    SocialShare.shareOptions(
      'Check ${coin.name} price now: ${priceFormat.format(coin.price)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    account = Provider.of<AccountRepository>(context, listen: false);

    readNumberFormat();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: sharePrice,
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.network(widget.coin.icon, scale: 2.5),
                    Container(
                      width: 10,
                    ),
                    Text(
                      priceFormat.format(widget.coin.price),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              getGraphic(),
              quantity > 0
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Text(
                          '${quantity.toStringAsFixed(4)} ${widget.coin.initials}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.05),
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 24),
                    ),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _value,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Value',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                    suffix: Text(
                      'reais',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter the purchase amount';
                    } else if (double.parse(value) < 50) {
                      return 'The minimium value accepted is R\$ 50,00';
                    } else if (double.parse(value) > account.amount) {
                      return 'You cannot buy coins. Money is not enough';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      quantity = (value.isEmpty)
                          ? 0
                          : double.parse(value) / widget.coin.price;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Buy',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                  onPressed: handlePurchase,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
