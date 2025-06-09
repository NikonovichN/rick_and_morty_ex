import 'package:flutter/material.dart';
import 'package:rick_and_morty_ex/src/features/rick_and_morty/ui.dart';

import '../ui_kit/ui_kit.dart';

class BottomNavigationBarWithScaffold extends StatefulWidget {
  const BottomNavigationBarWithScaffold({super.key});

  @override
  State<BottomNavigationBarWithScaffold> createState() => _BottomNavigationBarWithScaffoldState();
}

class _BottomNavigationBarWithScaffoldState extends State<BottomNavigationBarWithScaffold> {
  static const _rickAndMortyPageTitle = 'Rick And Morty Fun';
  static const _favoritesPageTitle = 'Favorites';
  static const List<Widget> _widgetOptions = <Widget>[
    RickAndMortyScreen(),
    Text('Index 1: Favorites'),
  ];
  static const _pageTitles = [_rickAndMortyPageTitle, _favoritesPageTitle];

  int _selectedIndex = 0;
  String _pageTitle = _pageTitles[0];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageTitle = _pageTitles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppRickMortyBar(title: Text(_pageTitle)),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: NamedColors.selectedAccent,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'API'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Favorites'),
        ],
      ),
    );
  }
}
