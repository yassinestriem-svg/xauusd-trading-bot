import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const XauUsdBotApp());
}

class XauUsdBotApp extends StatelessWidget {
  const XauUsdBotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XAUUSD Live Exness Bot',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: const TradingDashboard(),
    );
  }
}

class TradingDashboard extends StatefulWidget {
  const TradingDashboard({Key? key}) : super(key: key);

  @override
  _TradingDashboardState createState() => _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  String _connectionStatus = 'Disconnected';
  bool _isTradingActive = false;
  double _goldPrice = 0.0;

  // إعدادات MetaApi وحساب Exness الحقيقي
  final String metaApiToken = "YOUR_METAAPI_TOKEN";
  final String accountId = "YOUR_EXNESS_ACCOUNT_ID";

  // دالة لجلب السعر الحقيقي للذهب (XAUUSD) عبر MetaApi
  Future<void> fetchGoldPrice() async {
    try {
      final response = await http.get(
        Uri.parse('https://mt-client-api-v1.agiliumtrade.ai/users/current/accounts/$accountId/symbols/XAUUSD/price'),
        headers: {'auth-token': metaApiToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _goldPrice = data['bid'] ?? 0.0;
          _connectionStatus = 'Connected & Active (Exness)';
        });
      } else {
        setState(() {
          _connectionStatus = 'Auth/API Error (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection Failed';
      });
    }
  }

  // دالة حقيقية لإرسال أمر صفقة (شراء/بيع) عبر MetaApi إلى Exness
  Future<void> executeTrade(String action) async {
    setState(() {
      _connectionStatus = 'Executing $action Order...';
    });

    try {
      final response = await http.post(
        Uri.parse('https://mt-client-api-v1.agiliumtrade.ai/users/current/accounts/$accountId/orders'),
        headers: {
          'auth-token': metaApiToken,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'symbol': 'XAUUSD',
          'action': action, // 'ORDER_TYPE_BUY' أو 'ORDER_TYPE_SELL'
          'volume': 0.01, // حجم العقد الحقيقي
          'type': '市场订单',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          _connectionStatus = 'Order Executed Successfully ($action)';
        });
      } else {
        setState(() {
          _connectionStatus = 'Trade Failed: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Trade Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XAUUSD Exness Live Trader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, size: 70, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              'Status: $_connectionStatus',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'XAUUSD Bid Price: \$$_goldPrice',
              style: const TextStyle(fontSize: 22, color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: fetchGoldPrice,
              icon: const Icon(Icons.refresh),
              label: const Text('Fetch Live Price'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => executeTrade('ORDER_TYPE_BUY'),
                  child: const Text('BUY XAUUSD', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => executeTrade('ORDER_TYPE_SELL'),
                  child: const Text('SELL XAUUSD', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
