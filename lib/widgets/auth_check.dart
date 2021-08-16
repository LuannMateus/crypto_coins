import 'package:crypto_coin/pages/home_screen.dart';
import 'package:crypto_coin/pages/login_screen.dart';
import 'package:crypto_coin/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    Widget loading() {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (auth.isLoading)
      return loading();
    else if (auth.user == null)
      return LoginScreen();
    else
      return HomeScreen();
  }
}
