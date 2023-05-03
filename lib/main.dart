import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/app_user.dart';
import 'package:dialog_utility/pages/characters_page.dart';
import 'package:dialog_utility/pages/conversation_viewer_page.dart';
import 'package:dialog_utility/pages/conversations_page.dart';
import 'package:dialog_utility/pages/projects_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // GoRouter configuration
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProjectsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
              leading: BackButton(onPressed: () => Navigator.pop(context)),
            ),
            body: ProfileScreen(
              actions: [
                SignedOutAction(
                  (context) => context.go('/signin'),
                )
              ],
            )),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => SignInScreen(
          providers: [
            GoogleProvider(clientId: "69535469589-m78ugjf8kh9v6a1onvgpo4rndf1d7njo.apps.googleusercontent.com")
          ],
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) async {
              var userRef = FirebaseFirestore.instance.collection('users').doc(state.user!.uid);
              var userSnapshot = await userRef.get();
              AppUser user;
              if (userSnapshot.exists) {
                user = AppUser.fromJson(userSnapshot.data() as dynamic);
                user.name = state.user!.displayName ?? '';
              } else {
                user = AppUser(id: state.user!.uid, name: state.user!.displayName ?? '');
              }
              var result = await userRef.set(user.toJson());

              context.go('/');
            })
          ],
        ),
      )
    ],
    redirect: (context, state) {
      if (FirebaseAuth.instance.currentUser == null) {
        return '/signin';
      }
      return null;
    },
  );

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
      builder: (theme, darkTheme) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dialog Manager',
        theme: theme,
        darkTheme: darkTheme,
        routerConfig: _router,
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
          IconButton(onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(), icon: const Icon(Icons.light_mode)),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
              onDestinationSelected: (value) => setState(() => _selectedIndex = value),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.people), label: Text("Characters")),
                NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Conversations")),
                NavigationRailDestination(icon: Icon(Icons.play_arrow), label: Text("Preview")),
                // NavigationRailDestination(icon: Icon(Icons.import_export), label: Text("Export"))
              ],
              selectedIndex: _selectedIndex),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          if (_selectedIndex == 0) const Expanded(child: CharactersPage()),
          if (_selectedIndex == 1) const Expanded(child: ConversationsPage()),
          if (_selectedIndex == 2) const Expanded(child: ConversationViewerPage()),
          // if (_selectedIndex == 3) const Expanded(child: ExportPage()),
        ],
      ),
    );
  }
}
