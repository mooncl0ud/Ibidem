import 'package:go_router/go_router.dart';
import '../features/authentication/splash_screen.dart';
import '../features/authentication/login_screen.dart';
import '../features/library/library_screen.dart';
import '../features/reader/text_reader_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/reader/:bookId',
      builder: (context, state) {
        final bookId = state.pathParameters['bookId']!;
        return TextReaderScreen(bookId: bookId);
      },
    ),
  ],
);
