import 'package:flutter/material.dart';
import 'views/beranda_page.dart';
import 'views/favorit_page.dart';
import 'views/peta_page.dart';
import 'views/profil_page.dart';
import 'views/detail_kos_page.dart';
import 'models/kos_model.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poli Kos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final kos = settings.arguments as KosModel;
          return MaterialPageRoute(
            builder: (context) => DetailKosPage(kos: kos),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const BerandaPage(),
    const FavoritPage(),
    const PetaPage(),
    const ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}