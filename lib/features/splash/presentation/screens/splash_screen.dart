import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/routing/routes.dart';
import '../../../auth/presentation/login/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // إزالة شاشة النيتيف فور رسم أول إطار من شاشة فلاتر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginView(),
        settings: const RouteSettings(name: Routes.login),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDEBFD), // نفس درجة النيتيف
      body: SizedBox.expand(
        child: Lottie.asset(
          'assets/animations/splash_animation.json',
          controller: _controller,
          fit: BoxFit.cover,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(_navigateToNext);
          },
        ),
      ),
    );
  }
}