
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/isar_service.dart';
import 'providers/note_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isarService = IsarService();
  await isarService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoteProvider(isarService.db)
            ..loadNotes(),
        ),
      ],
      child: const NotatoApp(),
    ),
  );
}

class NotatoApp extends StatelessWidget {
  const NotatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notato',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            const Color(0xFFFFFBF5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF333333),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
