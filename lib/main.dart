import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';

import 'router/router.dart';
import 'utils/tools.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late double widthScreen;
late double heightScreen;

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Tools.changeStatusbarIconColor();
    final router = ref.watch(routerProvider);

    return OKToast(
      textPadding: const EdgeInsets.all(12),
      position: ToastPosition.bottom,
      child: MaterialApp.router(
        title: 'Jira Counter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
