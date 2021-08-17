import 'package:crypto_coin/configs/app_settings.dart';
import 'package:crypto_coin/configs/hive_config.dart';
import 'package:crypto_coin/repositories/account_repository.dart';
import 'package:crypto_coin/repositories/favorites_repository.dart';
import 'package:crypto_coin/services/auth_service.dart';
import 'package:crypto_coin/widgets/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppSettings(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              FavoritesRepository(auth: context.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountRepository(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Coins',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
    );
  }
}
