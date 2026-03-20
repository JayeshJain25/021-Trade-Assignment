import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/watchlist/presentation/pages/watchlist_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '021 Trade',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WatchlistPage(),
    );
  }
}
