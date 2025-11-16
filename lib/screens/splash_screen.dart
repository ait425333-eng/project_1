import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
    _navigateToLogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
            ],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.5),
                              blurRadius: 50,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.white,
                              child: const Icon(
                                Icons.apps_rounded,
                                size: 100,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 40),
              
              // App Name with Animation
              Text(
                'IMAM',
                style: AppTheme.headingStyle(fontSize: 42, color: Colors.white),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 12),
              
              Text(
                'Mining & Mineral',
                style: AppTheme.bodyStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 600.ms),
              
              const SizedBox(height: 80),
              
              // Modern Loading Animation
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 60,
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.5))
                  .fadeIn(duration: 600.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
