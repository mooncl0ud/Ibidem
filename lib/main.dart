import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/data/local/local_database.dart';
import 'src/data/local/local_database_provider.dart';
import 'src/shared/router.dart';
import 'src/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Local Database
  final localDb = LocalDatabase();
  await localDb.init();

  runApp(
    ProviderScope(
      overrides: [localDatabaseProvider.overrideWithValue(localDb)],
      child: const IbidemApp(),
    ),
  );
}

class IbidemApp extends StatelessWidget {
  const IbidemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IBIDEM',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
