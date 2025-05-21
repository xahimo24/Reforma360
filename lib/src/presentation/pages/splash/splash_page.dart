import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reforma360/src/core/routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Arranca la animación
    _controller.repeat(reverse: true);

    // Tras 2 segundos, navegamos a la home
    Future.delayed(const Duration(seconds: 2), () {
      _controller.stop();
      context.go(RouteNames.home);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Image.asset(
            'assets/launcher_icons/logo_negro.png',
            width: 120,
            height: 120,
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
