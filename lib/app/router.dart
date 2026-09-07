import 'package:go_router/go_router.dart';

import 'home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage(title: 'Everstride')),
  ],
);
