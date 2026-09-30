import 'package:flutter/material.dart';

void main() {
  runApp(const XauUsdBotApp());
}

class XauUsdBotApp extends StatelessWidget {
  const XauUsdBotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XAUUSD Auto Trader',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: const TradingDashboard(),
    );
  }
}

class TradingDashboard extends StatelessWidget {
  const TradingDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XAUUSD Exness Bot'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              'Bot Status: Initializing...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Connected via MetaApi (Exness)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
