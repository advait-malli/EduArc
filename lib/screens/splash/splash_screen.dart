import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../auth/login_page.dart';
import '../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));

    final isLoggedIn = await AuthService.isLoggedIn();
    final token = await AuthService.getToken();

    if (!mounted) return;

    // Require a valid token to skip login (handles old sessions without one)
    if (isLoggedIn && token != null && token.isNotEmpty) {
      final role = await AuthService.getUserRole();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen(role: role ?? 'Student')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/icon/icon.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
