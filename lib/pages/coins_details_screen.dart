import 'package:crypto_coin/utils/priceFormat.dart';
import 'package:flutter/material.dart';
import 'package:crypto_coin/models/Coin.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

  void handlePurchase() {
    if (!_form.currentState!.validate()) {
      return;
    }

    // Save in the database

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase with success!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Image.asset(widget.coin.icon),
                    width: 50,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    PriceFormat.format(widget.coin.price),
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
    );
  }
}
