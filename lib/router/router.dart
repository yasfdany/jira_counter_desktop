import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jira_counter/ui/screens/splashscreen/splash_screen.dart';

import '../ui/screens/home/home_screen.dart';
import '../ui/screens/login/login_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ], // All the routes can be found there
  );
});
