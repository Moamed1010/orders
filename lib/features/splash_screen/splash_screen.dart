import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/core/routing/app_routes.dart';
import 'package:orders/core/styling/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    waitAnimationAndNavigate();
    super.initState();
  }

  Future<void> waitAnimationAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    // ignore: use_build_context_synchronously
    context.pushReplacementNamed(AppRoutes.loginScreen);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(AppAssets.logo, width: 200.w, height: 200.w),
        ),
      ),
    );
  }
}
