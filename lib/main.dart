import 'package:crypto_coin/configs/app_settings.dart';
import 'package:crypto_coin/configs/hive_config.dart';
import 'package:crypto_coin/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';

import 'package:crypto_coin/pages/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppSettings(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesRepository(),
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
      home: HomeScreen(),
    );
  }
}
