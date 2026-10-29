import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/language_provider.dart';
import 'features/home/home_screen.dart';

/// Root application widget for Jhora Mobile.
class JhoraApp extends StatelessWidget {
  const JhoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, _) {
          return MaterialApp(
            title: langProvider.l('app_name'),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
