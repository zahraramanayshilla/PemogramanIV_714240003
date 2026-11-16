import 'package:flutter/material.dart';

import 'home_page.dart';
import 'contact_page.dart';
import 'contact_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF12BFC5)),

        // Mengatur warna tulisan Bottom Navigation
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.black,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            return const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            );
          }),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final ContactStore _store = ContactStore();

  int _index = 0;

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomePage(),
          ContactPage(store: _store),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        height: 65,
        backgroundColor: Colors.black,
        indicatorColor: Colors.transparent,
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },

        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: _index == 0 ? const Color(0xFF12BFC5) : Colors.white,
              size: 22,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.contacts,
              color: _index == 1 ? const Color(0xFF12BFC5) : Colors.white,
              size: 22,
            ),
            label: 'Contact List',
          ),
        ],
      ),
    );
  }
}
