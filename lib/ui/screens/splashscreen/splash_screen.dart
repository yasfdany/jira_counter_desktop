import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jira_counter/config/themes.dart';

import '../../../main.dart';
import '../../../router/router.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import '../login/provider/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routeName => '/';
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = ref.read(routerProvider);
      final authProviderNotifier = ref.read(authProvider);

      authProviderNotifier.checkSession();
      Future.delayed(const Duration(seconds: 1), () {
        router.replace(
          authProviderNotifier.isLogged
              ? HomeScreen.routeName
              : LoginScreen.routeName,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return const Scaffold(
      backgroundColor: Themes.primary,
    );
  }
}
