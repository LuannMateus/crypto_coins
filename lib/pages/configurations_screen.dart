import 'package:crypto_coin/configs/app_settings.dart';
import 'package:crypto_coin/pages/documents_screen.dart';
import 'package:crypto_coin/repositories/account_repository.dart';
import 'package:crypto_coin/services/auth_service.dart';
import 'package:crypto_coin/utils/priceFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfigurationsScreen extends StatefulWidget {
  ConfigurationsScreen({Key? key}) : super(key: key);

  @override
  _ConfigurationsScreenState createState() => _ConfigurationsScreenState();
}

class _ConfigurationsScreenState extends State<ConfigurationsScreen> {
  late Map<String, String> loc;
  late PriceFormat priceFormat;

  readNumberFormat() {
    loc = Provider.of<AppSettings>(context).locale;

    priceFormat =
        PriceFormat(locale: loc['locale'] ?? '', name: loc['name'] ?? '');
  }

  void updateAmount() async {
    final form = GlobalKey<FormState>();
    final value = TextEditingController();
    final account = context.read<AccountRepository>();

    value.text = account.amount.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Update Amount'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) return 'Enter with the amount';

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                account.setAmount(double.parse(value.text));
                Navigator.pop(context);
              }
            },
            child: Text('SAVE')),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountRepository>();

    readNumberFormat();

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurations'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Amount'),
              subtitle: Text(
                priceFormat.format(account.amount),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white70,
                ),
              ),
              trailing: IconButton(
                onPressed: updateAmount,
                icon: Icon(Icons.edit),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Scan CNH or RG'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentsScreen(),
                  fullscreenDialog: true,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: OutlinedButton(
                    onPressed: () => context.read<AuthService>().logout(),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Logout',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
