import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/paths.dart';
import '../../core/utils/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    context.go(AppPaths.courses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text("Rebuni",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold))),
    );
  }
}
