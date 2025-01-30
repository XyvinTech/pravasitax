import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/mainpage.dart';
import 'package:pravasitax_flutter/mainPage_consultant.dart';
import 'package:pravasitax_flutter/src/core/theme/app_theme.dart';
import '../../../data/providers/auth_provider.dart';
import 'login_front.dart';
import '../../../data/services/secure_storage_service.dart';
import 'dart:developer' as developer;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final isLoggedIn = await SecureStorageService.isLoggedIn();

    if (isLoggedIn) {
          final token = await SecureStorageService.getAuthToken();
    final userId = await SecureStorageService.getUserId();
   developer. log('userId : $userId');
  developer.  log('token : $token');
      // Get both stored values and auth state
      final storedUserType = await SecureStorageService.getUserType();
      final authState = ref.read(authProvider);

      developer.log(
          'Stored user type: $storedUserType, Auth state user type: ${authState.userType}',
          name: 'SplashScreen');

      // Use stored value if auth state is not yet initialized
      final effectiveUserType = storedUserType ?? authState.userType;

      if (effectiveUserType == 'staff') {
        developer.log('Navigating to consultant page', name: 'SplashScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPageConsultantPage()),
        );
      } else {
        developer.log('Navigating to main page', name: 'SplashScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    } else {
      developer.log('Not logged in, navigating to login page',
          name: 'SplashScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginFrontPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/pravasi_logo.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
