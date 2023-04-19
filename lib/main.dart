import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dialog_utility/db_manager.dart';
import 'package:dialog_utility/pages/characters_page.dart';
import 'package:dialog_utility/pages/conversations_page.dart';
import 'package:flutter/material.dart';

void main() async {
  await DbManager.instance.init();
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dialog Manager"),
        actions: [
          IconButton(onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(), icon: const Icon(Icons.light_mode))
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
              onDestinationSelected: (value) => setState(() => _selectedIndex = value),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.people), label: Text("Characters")),
                NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Conversations"))
              ],
              selectedIndex: _selectedIndex),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          if (_selectedIndex == 0) const Expanded(child: CharactersPage()),
          if (_selectedIndex == 1) const Expanded(child: ConversationsPage())
        ],
      ),
    );
  }
}
