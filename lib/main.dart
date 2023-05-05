import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_utility/models/app_user.dart';
import 'package:dialog_utility/pages/project_page.dart';
import 'package:dialog_utility/pages/projects_page.dart';
import 'package:dialog_utility/pages/view_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  if (kIsWeb) {
    MetaSEO().config();
  }
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
        path: '/projects/:projectId',
        builder: (context, state) {
          var projectId = state.pathParameters['projectId'];
          return ProjectPage(projectId!);
        },
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
      ),
      GoRoute(
        path: '/view',
        builder: (context, state) => ViewPage(state.queryParameters['p']!, state.queryParameters['c']!),
      ),
    ],
    redirect: (context, state) {
      if (state.matchedLocation == '/view') {
        return null;
      }
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
