import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _zipController = TextEditingController();
  Future<String?>? _cityFuture;

  Future<String?> getCityFromZip(String zip) async {
    // Simuliere eine Netzwerkverzögerung
    await Future.delayed(const Duration(seconds: 2));

    // Dummy-Daten: Mapping von Postleitzahlen zu Städten
    Map<String, String> zipToCity = {
      '10115': 'Berlin',
      '20095': 'Hamburg',
      '80331': 'München',
      '50667': 'Köln',
      '60549': 'Frankfurt am Main'
    };

    return zipToCity[zip];
  }

  void _searchCity() {
    setState(() {
      _cityFuture = getCityFromZip(_zipController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Postleitzahl zu Stadt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _zipController,
              decoration: const InputDecoration(
                labelText: 'Postleitzahl eingeben',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchCity,
              child: const Text('Stadt suchen'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<String?>(
              future: _cityFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Fehler bei der Suche');
                } else if (snapshot.hasData) {
                  return Text('Stadt: ${snapshot.data}');
                } else {
                  return const Text('Keine Stadt gefunden');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
