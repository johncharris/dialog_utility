import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dialog_utility/pages/characters_page.dart';
import 'package:dialog_utility/pages/conversation_viewer_page.dart';
import 'package:dialog_utility/pages/conversations_page.dart';
import 'package:dialog_utility/pages/export_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          // primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light)),
      dark: ThemeData(
          brightness: Brightness.dark,
          // primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
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
                NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Conversations")),
                // NavigationRailDestination(icon: Icon(Icons.play_arrow), label: Text("Preview")),
                // NavigationRailDestination(icon: Icon(Icons.import_export), label: Text("Export"))
              ],
              selectedIndex: _selectedIndex),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          if (_selectedIndex == 0) const Expanded(child: CharactersPage()),
          if (_selectedIndex == 1) const Expanded(child: ConversationsPage()),
          // if (_selectedIndex == 2) const Expanded(child: ConversationViewerPage()),
          // if (_selectedIndex == 3) const Expanded(child: ExportPage()),
        ],
      ),
    );
  }
}
