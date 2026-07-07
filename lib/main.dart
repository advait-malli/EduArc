import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme_controller.dart';
import 'core/services/title_service.dart';
import 'core/repositories/repository_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme controller to load saved settings
  final themeController = AppThemeController();

  runApp(
    ChangeNotifierProvider.value(value: themeController, child: const ERPApp()),
  );
}

class ERPApp extends StatelessWidget {
  const ERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeController>(
      builder: (context, themeController, _) {
        final colorScheme = ColorScheme.fromSeed(
          seedColor: themeController.seedColor,
          brightness: themeController.mode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light,
        );

        return ValueListenableBuilder(
          valueListenable: TitleService.titleNotifier,
          builder: (context, _, __) {
            return RepositoryProvider.wrap(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                title: TitleService.getCurrentTitle(),
                themeMode: themeController.mode,
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: colorScheme,
                  cardTheme: CardThemeData(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: themeController.seedColor,
                    brightness: Brightness.dark,
                  ),
                  cardTheme: CardThemeData(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
                home: const SplashScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
