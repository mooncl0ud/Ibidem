import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
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

class IbidemApp extends ConsumerStatefulWidget {
  const IbidemApp({super.key});

  @override
  ConsumerState<IbidemApp> createState() => _IbidemAppState();
}

class _IbidemAppState extends ConsumerState<IbidemApp> {
  @override
  void initState() {
    super.initState();
    _setHighRefreshRate();
  }

  Future<void> _setHighRefreshRate() async {
    if (Platform.isAndroid) {
      try {
        await FlutterDisplayMode.setHighRefreshRate();
      } catch (e) {
        debugPrint('Error setting high refresh rate: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

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
