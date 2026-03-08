import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vocabvault/config/injection/injection_container.dart';
import 'package:vocabvault/presentation/bloc/vocabulary_bloc.dart';
import 'package:vocabvault/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // ⚠️ DEBUG ONLY: Uncomment เพื่อ reset database (ข้อมูลจะหาย!)
  // await DatabaseHelper.instance.resetDatabase();

  setupDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<VocabularyBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'VocabVault',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6366F1),
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}


